ls_tool <- function(dir_path) {
  list(output = paste(dir(dir_path), collapse = "\n"))
}

#' @importFrom ellmer tool type_string
ai_tool_ls_tool <- tool(
  ls_tool,
  name = "LSTool",
  description = "List files and folders in a given directory.",
  arguments = list(
    dir_path = type_string("The directory path relative to the root of the project.")
  )
)
