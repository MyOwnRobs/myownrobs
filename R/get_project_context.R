#' @importFrom rstudioapi getActiveProject getSourceEditorContext
get_project_context <- function() {
  list(
    r_terminal_working_directory = getwd(),
    rstudio_active_project = getActiveProject(),
    rstudio_source_editor_context = getSourceEditorContext()$path,
    os_type = paste(.Platform$OS.type, Sys.info()[["sysname"]]),
    architecture = Sys.info()[["machine"]]
  )
}
