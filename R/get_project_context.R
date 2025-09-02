#' Get Project Context Information
#'
#' Gathers various pieces of context information about the current R session and project. It
#' includes details about the working directory, RStudio project, source editor context, and
#' operating system.
#'
#' @importFrom rstudioapi getActiveProject getSourceEditorContext
#'
#' @keywords internal
#'
get_project_context <- function() {
  list(
    r_terminal_working_directory = getwd(), # The current working directory of the R terminal.
    rstudio_active_project = getActiveProject(), # The path to the currently active RStudio project.
    # The path of the file currently open in the RStudio source editor.
    rstudio_source_editor_context = getSourceEditorContext()$path,
    os_type = paste(.Platform$OS.type, Sys.info()[["sysname"]]), # The OS type and name.
    architecture = Sys.info()[["machine"]] # The machine architecture.
  )
}
