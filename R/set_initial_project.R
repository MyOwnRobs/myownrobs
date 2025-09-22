#' Set the Initial State of the Project
#'
#' Whether to save the initial state or to restore it.
#'
#' @param restore If TRUE, it will restore the initial state. If FALSE, it will save the initial
#'   store in R's temp dir.
#'
#' @importFrom fs dir_create dir_delete dir_exists
#' @importFrom rstudioapi getActiveProject
#'
#' @keywords internal
#'
set_initial_project <- function(restore = FALSE) {
  active_project <- getActiveProject()
  if (is.null(active_project)) {
    return()
  }
  backup_dir <- paste0(tempdir(), "/myownrobs/")
  project_dir <- paste0(active_project, "/")
  debug_print(list(backup_dir = backup_dir))
  if (restore) {
    file.copy(list.files(backup_dir, full.names = TRUE), project_dir, recursive = TRUE)
  } else {
    if (dir_exists(backup_dir)) {
      dir_delete(backup_dir)
    }
    dir_create(backup_dir)
    file.copy(list.files(project_dir, full.names = TRUE), backup_dir, recursive = TRUE)
  }
}
