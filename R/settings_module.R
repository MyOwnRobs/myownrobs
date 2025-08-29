#' Settings Module
#'
#' @param id Module id.
#' @param r_trigger A reactive expression that triggers opening the modal.
#'
#' @importFrom rstudioapi readPreference writePreference
#' @importFrom shiny actionButton checkboxInput HTML modalDialog moduleServer observeEvent showModal
#' @importFrom shiny tagList tags updateCheckboxInput
#'
settings_module <- function(id, r_trigger) {
  moduleServer(id, function(input, output, session) {
    settings_modal <- modalDialog(
      title = "Settings",
      checkboxInput(
        session$ns("open_at_startup"),
        "Open MyOwnHadley at RStudio startup"
      ),
      footer = tagList(
        actionButton(session$ns("save_settings"), "Save", class = "btn-save"),
        actionButton(session$ns("close"), "Close", class = "btn-close")
      ),
      # Custom `removeModal`, because shiny's is not working because of our own css styles.
      tags$script(HTML(
        'Shiny.addCustomMessageHandler("set-modal-display", function(display) {',
        '  var m = document.querySelector(".modal");',
        "  if (m) { m.style.display = display; }",
        "});"
      ))
    )
    # Show the settings modal when the parent sends a trigger.
    observeEvent(r_trigger(), {
      updateCheckboxInput(
        session, "open_at_startup",
        value = readPreference("myownhadley.open_at_startup", FALSE)
      )
      showModal(settings_modal)
    })
    # Persist settings and close modal when save is clicked.
    observeEvent(input$save_settings, {
      save_run_at_startup()
      writePreference("myownhadley.open_at_startup", isTRUE(input$open_at_startup))
      # Hide the modal by switching its display to none via the JS handler.
      session$sendCustomMessage("set-modal-display", "none")
    })
    # Close modal when close clicked.
    observeEvent(input$close, session$sendCustomMessage("set-modal-display", "none"))
  })
}

#' Save Run MyOwnHadley At Startup
#'
save_run_at_startup <- function() {
  # Define the path to the user's .Rprofile file
  rprofile_path <- file.path(Sys.getenv("HOME"), ".Rprofile")
  # If .Rprofile doesn't exist, start with an empty character vector.
  lines <- character(0)
  # Read existing .Rprofile file if it exists.
  if (file.exists(rprofile_path)) {
    lines <- readLines(rprofile_path)
    if (any(grepl("myownhadley.open_at_startup", lines))) {
      return()
    }
  }
  # Add the new API key to the lines.
  lines <- c(lines, paste0(
    'setHook("rstudio.sessionInit", function(...) ',
    'requireNamespace("myownhadley", quietly = TRUE) && ',
    'rstudioapi::readPreference("myownhadley.open_at_startup", FALSE) && ',
    "myownhadley::myownhadley()",
    ', action = "append")'
  ))
  # Write all lines back to the .Rprofile file.
  writeLines(lines, rprofile_path)
  # Inform the user about the update.
  message("MyOwnHadley startup script stored in ~/.Rprofile")
}
