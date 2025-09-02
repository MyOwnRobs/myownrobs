#' @importFrom rstudioapi documentOpen getSourceEditorContext insertText
search_and_replace_in_file <- function(args) {
  if (!validate_command_args(ai_tool_search_and_replace_in_file, args)) {
    stop("Invalid arguments for SearchAndReplaceInFile")
  }
  if (args$filepath == "ACTIVE_R_DOCUMENT") {
    editor_context <- getSourceEditorContext()
    file_content <- paste(editor_context$contents, collapse = "\n")
  } else {
    file_content <- paste(readLines(args$filepath), collapse = "\n")
  }
  for (diff in args$diffs) {
    file_content <- sub(diff$SEARCH, diff$REPLACE, file_content, fixed = TRUE)
  }
  if (args$filepath == "ACTIVE_R_DOCUMENT") {
    insertText(c(0, 0, Inf, Inf), file_content, editor_context$id)
  } else {
    writeLines(file_content, args$filepath)
    documentOpen(args$filepath)
  }
  list(new_content = file_content)
}

ai_tool_search_and_replace_in_file <- list(
  name = "SearchAndReplaceInFile",
  parameters = list(
    list(name = "filepath"),
    list(name = "diffs")
  ),
  display_title = "Edit File",
  would_like_to = "Edit `{filepath}`",
  is_currently = "Editing `{filepath}`",
  has_already = "Edited `{filepath}`",
  readonly = FALSE,
  execute = search_and_replace_in_file
)
