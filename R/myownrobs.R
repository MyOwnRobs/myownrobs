#' Launch MyOwnRobs
#'
#' Open the RStudio addin with the chat interface.
#'
#' @param api_url The API URL to use for requests. This parameter is for advanced users who want to
#'   specify an alternative backend URL and is rarely needed.
#'
#' @return No return value. Called for its side effects to launch the MyOwnRobs RStudio addin.
#'
#' @examples
#' if (interactive()) {
#'   myownrobs()
#'   # Specify the API URL.
#'   myownrobs("https://myownrobs.com/api/v0")
#' }
#'
#' @importFrom shiny runGadget
#' @importFrom utils packageVersion
#'
#' @export
#'
myownrobs <- function(api_url =
                        paste0("https://myownrobs.com/api/v", packageVersion("myownrobs")$major)) {
  if (!validate_policy_acceptance()) {
    return("Accept MyOwnRobs terms of use in order to run it")
  }
  validate_credentials(api_url)
  available_models <- get_available_models()
  project_context <- get_project_context()
  runGadget(
    myownrobs_ui(available_models),
    myownrobs_server(api_url, available_models, project_context)
  )
  invisible()
}

# nocov start

#' MyOwnRobs Shiny UI
#'
#' @param available_models List of available models to use.
#'
#' @importFrom rstudioapi getThemeInfo
#' @importFrom shiny actionButton div icon includeCSS selectInput span tagList tags textAreaInput
#' @importFrom shiny uiOutput
#'
#' @keywords internal
#'
myownrobs_ui <- function(available_models) {
  tagList(
    tags$link(
      rel = "stylesheet",
      href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
    ),
    # Include a single stylesheet that contains both light and dark variables.
    includeCSS(system.file("app", "style.css", package = "myownrobs")),
    tags$script(paste0(
      "document.documentElement.classList.toggle('dark', ",
      tolower(isTRUE(getThemeInfo()$dark)),
      ");"
    )),
    # On focus in prompt input and Enter hit, send the message.
    tags$script(
      '
      $(document).on("keydown", "#prompt", function(e) {
        // Check if the key pressed is "Enter".
        if (e.shiftKey) return;
        if (e.key === "Enter") {
          // Prevent the default action (like a new line in the text area).
          e.preventDefault();
          // Send a message to Shiny to trigger the event.
          Shiny.setInputValue(
            "inputPrompt",
            $("#prompt").val() + " ".repeat(Math.floor(Math.random() * 100) + 1)
          );
        }
      });
    '
    ),
    # Main chat container holds all UI elements.
    div(
      class = "chat-container",
      # Chat header: title and control buttons.
      div(
        class = "header",
        span("CHAT", class = "chat-title"),
        div(
          class = "header-icons",
          actionButton(
            "reset_session", NULL,
            icon = icon("plus"), class = "top-button", title = "New Chat Session"
          ),
          actionButton(
            "undo_changes", NULL,
            icon = icon("undo"), class = "top-button", title = "Undo All Changes"
          ),
          actionButton(
            "open_settings", NULL,
            icon = icon("cog"), class = "top-button", title = "Open Settings"
          ),
          actionButton(
            "close_addin", NULL,
            icon = icon("close"), class = "top-button", title = "Close Chat"
          )
        )
      ),
      # Main content area for displaying chat messages.
      div(class = "main-content", uiOutput("messages_container")),
      # Chat footer: prompt input and mode/model selectors.
      div(
        class = "footer",
        div(
          class = "input-container",
          div(
            class = "prompt-input-container",
            textAreaInput("prompt", "", placeholder = "Build a Shiny app that...")
          )
        ),
        # Controls for AI mode and model selection, and send button.
        div(
          class = "footer-controls",
          div(
            class = "input-selector",
            selectInput(
              "ai_mode", NULL, list("Agent" = "agent", "Ask" = "ask"),
              selectize = FALSE, width = "auto"
            )
          ),
          div(
            class = "input-selector",
            selectInput(
              "ai_model", NULL, available_models,
              selected = get_config("last_used_model"), selectize = FALSE, width = "auto"
            )
          ),
          actionButton(
            "send_message", NULL,
            icon = icon("paper-plane"), class = "send-message-button"
          )
        )
      )
    )
  )
}

#' MyOwnRobs Shiny Server
#'
#' @param api_url The API URL to use for requests.
#' @param available_models List of available models to use, obtained with `get_available_models()`.
#' @param project_context The context of the session executing the addin, obtained with
#'   `get_project_context()`.
#'
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom promises `%...>%`
#' @importFrom shiny div h3 markdown observeEvent p reactive reactiveTimer reactiveVal renderUI req
#' @importFrom shiny stopApp tags updateTextAreaInput
#' @importFrom uuid UUIDgenerate
#'
#' @keywords internal
#'
myownrobs_server <- function(api_url, available_models, project_context) {
  function(input, output, session) {
    # App reactive values to manage chat state.
    # Stores the list of chat messages (user and assistant).
    r_messages <- reactiveVal(turns_to_ui(load_turns()))
    # Informs when the prompt got calculated. If `NULL`, no prompt is running.
    r_finished_prompt <- reactiveVal(NULL)
    r_chat_instance <- reactiveVal() # The last used chat instance.
    set_initial_project()

    # Reset the chat session when the reset button is clicked.
    # Generates a new chat ID and clears messages and running prompt.
    observeEvent(input$reset_session, {
      if (length(r_messages()) == 0) {
        return()
      }
      r_messages(save_turns(list()))
      r_finished_prompt(NULL)
      r_chat_instance(NULL)
      set_initial_project()
    })
    observeEvent(input$undo_changes, set_initial_project(restore = TRUE))
    # Settings module handles showing the modal and persisting options.
    settings_module("settings", reactive(input$open_settings))
    # Stop the Shiny app when the close addin button is clicked.
    observeEvent(input$close_addin, stopApp())

    # Helper function to send a message to the AI.
    # Clears the input, shows user message, and initiates an asynchronous AI prompt.
    send_message <- function(prompt) {
      prompt_text <- trimws(prompt)
      if (prompt_text == "" || !is.null(r_finished_prompt())) {
        return()
      }
      set_config("last_used_model", input$ai_model)
      # Clear the input and set working state.
      updateTextAreaInput(session, "prompt", value = "")
      # Immediately show user message and working state.
      r_messages(c(list(list(role = "user", text = prompt_text)), r_messages()))
      chat_instance <- get_chat_instance(
        input$ai_mode, input$ai_model, project_context, get_api_key(), available_models
      )
      r_finished_prompt(FALSE) # Mark that a prompt is running.
      chat_instance$chat_async(prompt_text) %...>% r_finished_prompt()
      r_chat_instance(chat_instance)
    }
    observeEvent(input$inputPrompt, send_message(input$inputPrompt))
    observeEvent(input$send_message, send_message(input$prompt))

    # Observer that periodically checks the status of the asynchronous AI prompt execution.
    # This is the core logic for handling AI responses, parsing tools, and managing chat flow.
    observeEvent(r_finished_prompt(), {
      # Only run if the prompt finished.
      req(isTRUE(r_finished_prompt()))
      # Retrieve the response from the running prompt.
      response <- r_chat_instance()$get_turns()
      save_turns(response)
      turns_ui <- turns_to_ui(response)
      debug_print(list(running_prompt = list(
        mode = input$ai_mode, model = input$ai_model, reply = turns_ui[[1]]$text
      )))
      r_messages(turns_ui)
      # Mark that no prompt is currently running.
      r_finished_prompt(NULL)
    })

    # Render the chat messages in the UI.
    output$messages_container <- renderUI({
      msgs <- r_messages()
      # If there are no messages, show an initial welcome/instruction message.
      if (length(msgs) == 0) {
        return(div(
          class = "agent-mode",
          tags$i(class = "fas fa-magic"),
          h3(ifelse(input$ai_mode == "agent", "Build with agent mode.", "Ask about your code.")),
          p("AI responses may be inaccurate.")
        ))
      }
      # Generate UI bubbles for each message in the chat history.
      bubbles <- lapply(msgs, function(m) {
        div(class = paste("message", m$role), div(class = "message-content", markdown(m$text)))
      })
      # Prepend the "Working..." indicator if an AI prompt is currently running.
      if (isFALSE(r_finished_prompt())) {
        bubbles <- c(list(div(
          class = "message assistant",
          div(class = "working-indicator", tags$i(class = "fas fa-spinner fa-spin"), " Working...")
        )), bubbles)
      }
      div(id = "chat_messages", bubbles)
    })
  }
}

# nocov end
