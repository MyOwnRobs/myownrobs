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
            selectInput("ai_mode", NULL, c("Agent", "Ask"), selectize = FALSE, width = "auto")
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

#' @importFrom shiny div h3 markdown observeEvent p reactiveVal renderUI stopApp tags
#' @importFrom shiny updateTextAreaInput
#' @importFrom uuid UUIDgenerate
myownhadley_server <- function(api_url) {
  function(input, output, session) {
    # App reactive values.
    r_chat_id <- reactiveVal(UUIDgenerate())
    r_is_working <- reactiveVal(FALSE)
    r_messages <- reactiveVal(list())

    observeEvent(input$close_addin, stopApp())
    observeEvent(input$reset_session, {
      if (length(r_messages()) == 0) {
        return()
      }
      r_chat_id(UUIDgenerate())
      r_is_working(FALSE)
      r_messages(list())
    })

    # Handle send message.
    send_message <- function(prompt) {
      prompt_text <- trimws(prompt)
      if (prompt_text == "" || r_is_working()) {
        return()
      }
      # Clear the input and set working state
      updateTextAreaInput(session, "prompt", value = "")
      # Immediately show user message and working state
      msgs <- r_messages()
      msgs <- c(list(list(role = "user", text = prompt_text)), msgs)
      r_is_working(TRUE)
      llm_reply <- perform_llm_actions(
        r_chat_id(), prompt_text, tolower(input$ai_mode), input$ai_model, api_url
      )$reply
      msgs <- c(list(list(role = "assistant", text = llm_reply)), msgs)
      r_is_working(FALSE)
      r_messages(msgs)
    }
    observeEvent(input$inputPrompt, send_message(input$inputPrompt))
    observeEvent(input$send_message, send_message(input$prompt))

    working_bubble <- div(class = "message assistant", div(class = "message-content", div(
      class = "working-indicator",
      tags$i(class = "fas fa-spinner fa-spin"),
      " Working..."
    )))

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
      if (isTRUE(r_is_working())) {
        bubbles <- c(bubbles, list(working_bubble))
      }
      div(id = "chat_messages", bubbles)
    })
  }
}
