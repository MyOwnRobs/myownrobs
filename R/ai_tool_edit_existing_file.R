#' @importFrom rstudioapi documentOpen getSourceEditorContext insertText
edit_existing_file <- function(filepath, changes) {
  if (filepath == "ACTIVE_R_DOCUMENT") {
    insertText(c(0, 0, Inf, Inf), changes, getSourceEditorContext()$id)
  } else {
    writeLines(changes, filepath)
    documentOpen(filepath)
  }
  list(output = "")
}

#' @importFrom ellmer tool type_string
ai_tool_edit_existing_file <- tool(
  edit_existing_file,
  name = "EditExistingFile",
  description = paste0(
    "Use this tool to edit an existing file. If you don't know the contents of the file, read ",
    "it first. Note this tool CANNOT be called in parallel."
  ),
  arguments = list(
    filepath = type_string("The path of the file to edit, relative to the root of the workspace."),
    changes = type_string(paste0(
      "The exact text that will replace the target file's contents. This tool WILL overwrite the ",
      "file at `filepath` with this content. Do NOT wrap the text in Markdown code fences."
    ))
  )
)
