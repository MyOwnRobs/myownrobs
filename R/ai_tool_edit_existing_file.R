#' @importFrom rstudioapi documentOpen
edit_existing_file <- function(args) {
  if (!validate_command_args(ai_tool_edit_existing_file, args)) {
    stop("Invalid arguments for EditExistingFile")
  }
  writeLines(args$changes, args$filepath)
  documentOpen(args$filepath)
  return(list(output = ""))
}

ai_tool_edit_existing_file <- list(
  name = "EditExistingFile",
  parameters = list(
    list(name = "filepath"),
    list(name = "changes")
  ),
  display_title = "Edit File",
  would_like_to = "edit {filepath}",
  is_currently = "editing {filepath}",
  has_already = "edited {filepath}",
  readonly = FALSE,
  execute = edit_existing_file
)
