read_file <- function(filepath) {
  list(filepath = filepath, content = paste(readLines(filepath), collapse = "\n"))
}

#' @importFrom ellmer tool type_string
ai_tool_read_file <- tool(
  read_file,
  name = "ReadFile",
  description = paste0(
    "Use this tool if you need to view the contents of an existing file."
  ),
  arguments = list(
    filepath = type_string(paste0(
      "The path of the file to read, relative to the root of the workspace (NOT uri or absolute",
      " path)."
    ))
  )
)
