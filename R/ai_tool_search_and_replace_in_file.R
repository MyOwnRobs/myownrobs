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

#' @importFrom ellmer tool type_array type_string
ai_tool_search_and_replace_in_file_ellmer <- tool(
  function(filepath, diffs) search_and_replace_in_file(list(filepath = filepath, diffs = diffs)),
  name = ai_tool_search_and_replace_in_file$name,
  description = paste0(
    "Request to replace sections of content in an existing file using multiple SEARCH/REPLACE ",
    "blocks that define exact changes to specific parts of the file. This tool should be used ",
    "when you need to make targeted changes to specific parts of a file. Note this tool CANNOT ",
    "be called in parallel."
  ),
  arguments = list(
    filepath = type_string("The path of the file to modify, relative to the root of the workspace."),
    diffs = type_array(
      type_string(),
      paste0(
        "A JSON array of diff objects. Each object must contain the fields:\n",
        '  - "SEARCH": the exact text to find (match is character-for-character, including ',
        "whitespace).\n",
        '  - "REPLACE": the replacement text to insert for the first matching occurrence.\n\n',
        "Example:\n",
        '  [ {"SEARCH": "exact content to find", "REPLACE": "new content to replace with"} ]\n\n',
        "Rules (important):\n",
        '  * Each diff will replace only the first occurrence of the exact "SEARCH" string in the ',
        "file.\n",
        "  * Matching is exact (use literal text). Include any surrounding whitespace/newlines if ",
        "needed to uniquely match.\n",
        "  * Diffs are applied sequentially in array order (top-to-bottom semantics).\n",
        '  * To perform deletions, set "REPLACE" to an empty string."\n'
      )
    )
  )
)
