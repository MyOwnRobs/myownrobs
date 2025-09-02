#' @importFrom rstudioapi documentOpen getSourceEditorContext insertText
edit_existing_file <- function(args) {
  if (!validate_command_args(ai_tool_edit_existing_file, args)) {
    stop("Invalid arguments for EditExistingFile")
  }
  if (args$filepath == "ACTIVE_R_DOCUMENT") {
    insertText(c(0, 0, Inf, Inf), args$changes, getSourceEditorContext()$id)
  } else {
    writeLines(args$changes, args$filepath)
    documentOpen(args$filepath)
  }
  list(output = "")
}

ai_tool_edit_existing_file <- list(
  name = "EditExistingFile",
  parameters = list(
    list(name = "filepath"),
    list(name = "changes")
  ),
  display_title = "Edit File",
  would_like_to = "Edit `{filepath}`",
  is_currently = "Editing `{filepath}`",
  has_already = "Edited `{filepath}`",
  readonly = FALSE,
  execute = edit_existing_file
)
