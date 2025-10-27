ls_tool <- function(args) {
  if (!validate_command_args(ai_tool_ls_tool, args)) {
    stop("Invalid arguments for LSTool")
  }
  list(output = paste(dir(args$dirPath), collapse = "\n"))
}

ai_tool_ls_tool <- list(
  name = "LSTool",
  parameters = list(
    list(name = "dirPath")
  ),
  display_title = "ls",
  would_like_to = "List files and folders in `{dirPath}`",
  is_currently = "Listing files and folders in `{dirPath}`",
  has_already = "Listed files and folders in `{dirPath}`",
  readonly = TRUE,
  execute = ls_tool
)

#' @importFrom ellmer tool type_string
ai_tool_ls_tool_ellmer <- tool(
  function(dirPath) ls_tool()(list(dirPath = dirPath)),
  name = ai_tool_ls_tool$name,
  description = "List files and folders in a given directory.",
  arguments = list(
    dirPath = type_string("The directory path relative to the root of the project.")
  )
)
