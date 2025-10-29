#' @importFrom rstudioapi documentOpen getSourceEditorContext insertText
search_and_replace_in_file <- function(filepath, diffs) {
  if (filepath == "ACTIVE_R_DOCUMENT") {
    editor_context <- getSourceEditorContext()
    file_content <- paste(editor_context$contents, collapse = "\n")
  } else {
    file_content <- paste(readLines(filepath), collapse = "\n")
  }
  for (diff in diffs) {
    file_content <- sub(diff$SEARCH, diff$REPLACE, file_content, fixed = TRUE)
  }
  if (filepath == "ACTIVE_R_DOCUMENT") {
    insertText(c(0, 0, Inf, Inf), file_content, editor_context$id)
  } else {
    writeLines(file_content, filepath)
    documentOpen(filepath)
  }
  list(new_content = file_content)
}

#' @importFrom ellmer tool type_array type_string
ai_tool_search_and_replace_in_file <- tool(
  search_and_replace_in_file,
  name = "SearchAndReplaceInFile",
  description = paste0(
    "Request to replace sections of content in an existing file using multiple SEARCH/REPLACE ",
    "blocks that define exact changes to specific parts of the file. This tool should be used ",
    "when you need to make targeted changes to specific parts of a file. Note this tool CANNOT ",
    "be called in parallel."
  ),
  arguments = list(
    filepath = type_string(
      "The path of the file to modify, relative to the root of the workspace."
    ),
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
