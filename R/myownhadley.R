#' Launch MyOwnHadley
#'
#' Open a Shiny app addin with the chat interface.
#'
#' @param api_url The API URL to use for requests.
#'
#' @importFrom shiny runGadget
#' @importFrom utils packageVersion
#' @export
myownhadley <- function(api_url = paste0(
                          "https://myownhadley.com/api/v", packageVersion("myownhadley")$major
                        )) {
  runGadget(myownhadley_ui(), myownhadley_server(api_url))
}

#' @importFrom rstudioapi getThemeInfo
#' @importFrom shiny actionButton div icon includeCSS selectInput span tagList tags textAreaInput
#' @importFrom shiny uiOutput
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
          Shiny.setInputValue("inputPrompt", $("#prompt").val());
        }
      });
    '
    ),
    div(
      class = "chat-container",
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
      div(class = "main-content", uiOutput("messages_container")),
      div(
        class = "footer",
        div(
          class = "input-container",
          div(
            class = "prompt-input-container",
            textAreaInput("prompt", "", placeholder = "Build a Shiny app that...")
          )
        ),
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

#' @importFrom mirai mirai unresolved
#' @importFrom shiny div h3 markdown observeEvent p reactiveTimer reactiveVal renderUI stopApp tags
#' @importFrom shiny updateTextAreaInput
#' @importFrom uuid UUIDgenerate
myownhadley_server <- function(api_url) {
  function(input, output, session) {
    # App reactive values.
    r_chat_id <- reactiveVal(UUIDgenerate())
    r_messages <- reactiveVal(list())
    r_running_prompt <- reactiveVal(NULL)
    # TODO: Replace it with a better alternative instead of polling every second.
    r_check_prompt_execution <- reactiveTimer()
    project_context <- get_project_context()

    # Just to pass CMD check.
    chat_id <- role <- model <- NULL

    observeEvent(input$close_addin, stopApp())
    observeEvent(input$reset_session, {
      if (length(r_messages()) == 0) {
        return()
      }
      r_chat_id(UUIDgenerate())
      r_running_prompt(NULL)
      r_messages(list())
    })

    # Handle send message.
    send_message <- function(prompt) {
      prompt_text <- trimws(prompt)
      if (prompt_text == "" || !is.null(r_running_prompt())) {
        return()
      }
      # Clear the input and set working state
      updateTextAreaInput(session, "prompt", value = "")
      # Immediately show user message and working state
      r_messages(c(list(list(role = "user", text = prompt_text)), r_messages()))
      r_running_prompt(mirai(
        send_prompt(chat_id, prompt, role, mode, model, project_context, api_url),
        send_prompt = send_prompt,
        chat_id = r_chat_id(),
        prompt = prompt_text,
        role = "user",
        mode = input$ai_mode,
        model = input$ai_model,
        project_context = project_context,
        api_url = api_url
      ))
    }
    observeEvent(input$inputPrompt, send_message(input$inputPrompt))
    observeEvent(input$send_message, send_message(input$prompt))

    observeEvent(r_check_prompt_execution(), {
      if (is.null(r_running_prompt()) || unresolved(r_running_prompt())) {
        return()
      }
      response_text <- r_running_prompt()$data
      r_running_prompt(NULL)
      debug_print(list(running_prompt = list(
        mode = input$ai_mode, model = input$ai_model, reply = response_text
      )))
      parsed <- parse_agent_response(response_text)
      if (!is.null(parsed$error)) {
        warning(parsed$error, call. = FALSE)
        r_messages(c(list(list(role = "assistant", text = parsed$error)), r_messages()))
        return()
      }
      if (isTRUE(nchar(parsed$response$user_message) == 0 && length(parsed$response$tools) == 0)) {
        r_messages(c(list(list(role = "assistant", text = "\U0001f44b")), r_messages()))
        return()
      }
      if (isTRUE(nchar(parsed$response$user_message) > 0)) {
        r_messages(
          c(list(list(role = "assistant", text = parsed$response$user_message)), r_messages())
        )
      }
      if (isTRUE(length(parsed$response$tools) > 0)) {
        prompt <- execute_llm_tools(parsed$response$tools, input$ai_mode)
        debug_print(list(running_prompt = list(
          mode = input$ai_mode, model = input$ai_model, sent_prompt = prompt
        )))
        r_running_prompt(mirai(
          send_prompt(chat_id, prompt, role, mode, model, project_context, api_url),
          send_prompt = send_prompt,
          chat_id = r_chat_id(),
          prompt = prompt,
          role = "tool_runner",
          mode = input$ai_mode,
          model = input$ai_model,
          project_context = project_context,
          api_url = api_url
        ))
      }
    })

    working_bubble <- div(class = "message assistant", div(
      class = "working-indicator",
      tags$i(class = "fas fa-spinner fa-spin"),
      " Working..."
    ))

    output$messages_container <- renderUI({
      msgs <- r_messages()
      if (length(msgs) == 0) {
        return(div(
          class = "agent-mode",
          tags$i(class = "fas fa-magic"),
          h3("Build with agent mode."),
          p("AI responses may be inaccurate.")
        ))
      }
      bubbles <- lapply(msgs, function(m) {
        role_class <- if (identical(m$role, "user")) "message user" else "message assistant"
        div(class = role_class, div(class = "message-content", markdown(m$text)))
      })
      # Add working indicator if needed
      if (!is.null(r_running_prompt())) {
        bubbles <- c(list(working_bubble), bubbles)
      }
      div(id = "chat_messages", bubbles)
    })
  }
}
