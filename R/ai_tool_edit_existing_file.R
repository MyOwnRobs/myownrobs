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

#' @importFrom ellmer tool type_array type_string
ai_tool_edit_existing_file_ellmer <- tool(
  function(filepath, changes) edit_existing_file(list(filepath = filepath, changes = changes)),
  name = ai_tool_edit_existing_file$name,
  description = paste0(
    "Use this tool to edit an existing file. If you don't know the contents of the file, read ",
    "it first. Note this tool CANNOT be called in parallel."
  ),
  arguments = list(
    filepath = type_string("The path of the file to edit, relative to the root of the workspace."),
    changes = type_array(type_string(), paste0(
      "The exact text that will replace the target file's contents. This tool WILL overwrite the ",
      "file at `filepath` with these contents. Do NOT wrap the text in Markdown code fences."
    ))
  )
)
