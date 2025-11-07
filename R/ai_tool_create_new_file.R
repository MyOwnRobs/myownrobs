#' @importFrom rstudioapi documentOpen
create_new_file <- function(filepath, content) {
  dir.create(dirname(filepath), recursive = TRUE, showWarnings = FALSE)
  writeLines(content, filepath)
  documentOpen(filepath)
  list(output = "")
}

#' @importFrom ellmer tool type_string
ai_tool_create_new_file <- tool(
  create_new_file,
  name = "CreateNewFile",
  description = "Create a new file. Only use this when a file doesn't exist and should be created.",
  arguments = list(
    filepath = type_string(
      "The path where the new file should be created, relative to the root of the workspace."
    ),
    content = type_string("The content to write to the new file.")
  )
)
