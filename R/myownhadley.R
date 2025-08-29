#' Launch MyOwnHadley
#'
#' Open the RStudio addin with the chat interface.
#'
#' @param api_url The API URL to use for requests.
#'
#' @importFrom shiny runGadget
#' @importFrom utils packageVersion
#'
#' @export
#'
myownhadley <- function(api_url = paste0(
                          "https://myownhadley.com/api/v", packageVersion("myownhadley")$major
                        )) {
  validate_credentials(api_url)
  runGadget(myownhadley_ui(), myownhadley_server(api_url))
}

#' MyOwnHadley Shiny UI
#'
#' @importFrom rstudioapi getThemeInfo
#' @importFrom shiny actionButton div icon includeCSS selectInput span tagList tags textAreaInput
#' @importFrom shiny uiOutput
#'
myownhadley_ui <- function() {
  tagList(
    tags$link(
      rel = "stylesheet",
      href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
    ),
    # Include a single stylesheet that contains both light and dark variables.
    includeCSS(system.file("app", "style.css", package = "myownhadley")),
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
          actionButton("reset_session", NULL, icon = icon("plus"), class = "top-button"),
          actionButton("open_settings", NULL, icon = icon("cog"), class = "top-button"),
          actionButton("close_addin", NULL, icon = icon("close"), class = "top-button")
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
              "ai_model", NULL, list("Gemini 2.5 Flash" = "gemini-2.5-flash"),
              selectize = FALSE, width = "auto"
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

#' MyOwnHadley Shiny Server
#'
#' @param api_url The API URL to use for requests.
#'
#' @importFrom mirai unresolved
#' @importFrom shiny div h3 markdown observeEvent p reactive reactiveTimer reactiveVal renderUI
#' @importFrom shiny stopApp tags updateTextAreaInput
#' @importFrom uuid UUIDgenerate
#'
myownhadley_server <- function(api_url) {
  function(input, output, session) {
    # App reactive values to manage chat state.
    r_chat_id <- reactiveVal(UUIDgenerate()) # Unique ID for the current chat session.
    r_messages <- reactiveVal(list()) # Stores the list of chat messages (user and assistant).
    r_running_prompt <- reactiveVal(NULL) # Stores the promise for an ongoing AI prompt execution.
    max_ai_iterations <- 15 # Maximum number of consecutive AI tool iterations.
    r_ai_iterations <- reactiveVal(0) # Current count of AI tool iterations.
    max_retries <- 3 # Maximum number of retries for parsing invalid AI responses.
    r_retries <- reactiveVal(0) # Current count of retries for the active prompt.
    # TODO: Replace it with a better alternative instead of polling every second.
    r_check_prompt_execution <- reactiveTimer() # Timer to poll for prompt execution status.
    project_context <- get_project_context()

    # Reset the chat session when the reset button is clicked.
    # Generates a new chat ID and clears messages and running prompt.
    observeEvent(input$reset_session, {
      if (length(r_messages()) == 0) {
        return()
      }
      r_chat_id(UUIDgenerate())
      r_messages(list())
      r_running_prompt(NULL)
      r_ai_iterations(0)
      r_retries(0)
    })
    # Settings module handles showing the modal and persisting options.
    settings_module("settings", reactive(input$open_settings))
    # Stop the Shiny app when the close addin button is clicked.
    observeEvent(input$close_addin, stopApp())

    # Helper function to send a message to the AI.
    # Clears the input, shows user message, and initiates an asynchronous AI prompt.
    send_message <- function(prompt) {
      prompt_text <- trimws(prompt)
      if (prompt_text == "" || !is.null(r_running_prompt())) {
        return()
      }
      # Clear the input and set working state.
      updateTextAreaInput(session, "prompt", value = "")
      # Immediately show user message and working state.
      r_messages(c(list(list(role = "user", text = prompt_text)), r_messages()))
      r_ai_iterations(0)
      r_running_prompt(send_prompt_async(
        r_chat_id(), prompt_text, "user", input$ai_mode, input$ai_model, project_context, api_url,
        get_api_key()
      ))
    }
    observeEvent(input$inputPrompt, send_message(input$inputPrompt))
    observeEvent(input$send_message, send_message(input$prompt))

    # Observer that periodically checks the status of the asynchronous AI prompt execution.
    # This is the core logic for handling AI responses, parsing tools, and managing chat flow.
    observeEvent(r_check_prompt_execution(), {
      # If no prompt is running or it's still unresolved, do nothing.
      if (is.null(r_running_prompt()) || unresolved(r_running_prompt())) {
        return()
      }
      # Retrieve the response from the running prompt.
      response_text <- r_running_prompt()
      if ("data" %in% names(response_text)) {
        # When using send_prompt_async, the result is returned in a `data` value.
        response_text <- response_text$data
      }
      debug_print(list(running_prompt = list(
        mode = input$ai_mode, model = input$ai_model, reply = response_text
      )))
      # Parse the AI agent's response into user message and tool calls.
      parsed <- parse_agent_response(response_text)
      r_running_prompt(NULL)
      # Handle cases where parsing of the AI response failed.
      if (!is.null(parsed$error)) {
        # If the AI response was invalid and retries are available, retry the prompt.
        if (parsed$error_code == "invalid_ai_response" && r_retries() < max_retries) {
          r_retries(r_retries() + 1)
          debug_print(paste0("Retry number ", r_retries()))
          r_running_prompt(send_prompt_async(
            r_chat_id(), "Your last reply couldn't be parsed, please re try it.", "tool_runner",
            input$ai_mode, input$ai_model, project_context, api_url, get_api_key()
          ))
          return()
        }
        # If no retries available, then print the error to the user.
        r_messages(c(list(list(role = "assistant", text = paste0(
          "Error: ", parsed$error, ". Retry?"
        ))), r_messages()))
        return()
      }
      # If the response was successfully parsed, reset the retry counter.
      r_retries(0)
      # If the AI provided neither a user message nor tools, send a default acknowledgement.
      if (isTRUE(nchar(parsed$user_message) == 0 && length(parsed$tools) == 0)) {
        r_messages(c(list(list(role = "assistant", text = "\U0001f44b")), r_messages()))
        return()
      }
      # If the AI provided a user-facing message, add it to the chat history.
      if (isTRUE(nchar(parsed$user_message) > 0)) {
        r_messages(c(list(list(role = "assistant", text = parsed$user_message)), r_messages()))
      }
      # If the AI requested tools to be executed, process them.
      if (isTRUE(length(parsed$tools) > 0)) {
        # If the maximum number of AI tool iterations has been reached, prompt the user.
        if (r_ai_iterations() >= max_ai_iterations) {
          r_messages(c(list(list(role = "assistant", text = paste0(
            "**MyOwnHadley** has been working on this problem for a while. It can continue to ",
            "iterate, or you can send a new message to refine your prompt. Continue to iterate?"
          ))), r_messages()))
          return()
        }
        # Execute the parsed tools and get a new prompt for the next AI iteration.
        execution <- execute_llm_tools(parsed$tools, input$ai_mode)
        prompt <- execution$ai
        # Add executed steps to the chat UI.
        lapply(execution$ui, function(step) {
          r_messages(c(list(list(role = "tool", text = step)), r_messages()))
        })
        debug_print(list(running_prompt = list(
          mode = input$ai_mode, model = input$ai_model, sent_prompt = prompt
        )))
        r_ai_iterations(r_ai_iterations() + 1)
        r_running_prompt(send_prompt_async(
          r_chat_id(), prompt, "tool_runner", input$ai_mode, input$ai_model, project_context,
          api_url, get_api_key()
        ))
        return()
      }
    })

    # UI element for the "Working..." indicator shown when the AI is processing.
    working_bubble <- div(
      class = "message assistant",
      div(class = "working-indicator", tags$i(class = "fas fa-spinner fa-spin"), " Working...")
    )

    # Render the chat messages in the UI.
    output$messages_container <- renderUI({
      msgs <- r_messages()
      # If there are no messages, show an initial welcome/instruction message.
      if (length(msgs) == 0) {
        return(div(
          class = "agent-mode",
          tags$i(class = "fas fa-magic"),
          h3("Build with agent mode."),
          p("AI responses may be inaccurate.")
        ))
      }
      # Generate UI bubbles for each message in the chat history.
      bubbles <- lapply(msgs, function(m) {
        div(class = paste("message", m$role), div(class = "message-content", markdown(m$text)))
      })
      # Prepend the "Working..." indicator if an AI prompt is currently running.
      if (!is.null(r_running_prompt())) {
        bubbles <- c(list(working_bubble), bubbles)
      }
      div(id = "chat_messages", bubbles)
    })
  }
}
