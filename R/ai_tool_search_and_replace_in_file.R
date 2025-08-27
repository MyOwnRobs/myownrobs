#' @importFrom rstudioapi documentOpen
search_and_replace_in_file <- function(args) {
  if (!validate_command_args(ai_tool_search_and_replace_in_file, args)) {
    stop("Invalid arguments for SearchAndReplaceInFile")
  }
  file_content <- paste(readLines(args$filepath), collapse = "\n")
  for (diff in args$diffs) {
    file_content <- sub(diff$SEARCH, diff$REPLACE, file_content, fixed = TRUE)
  }
  writeLines(file_content, args$filepath)
  documentOpen(args$filepath)
  return(list(new_content = file_content))
}

ai_tool_search_and_replace_in_file <- list(
  name = "SearchAndReplaceInFile",
  parameters = list(
    list(name = "filepath"),
    list(name = "diffs")
  ),
  display_title = "Edit File",
  would_like_to = "edit {filepath}",
  is_currently = "editing {filepath}",
  has_already = "edited {filepath}",
  readonly = FALSE,
  execute = search_and_replace_in_file
)
