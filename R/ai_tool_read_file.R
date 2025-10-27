read_file <- function(args) {
  if (!validate_command_args(ai_tool_read_file, args)) {
    stop("Invalid arguments for ReadFile")
  }
  list(filepath = args$filepath, content = paste(readLines(args$filepath), collapse = "\n"))
}

ai_tool_read_file <- list(
  name = "ReadFile",
  parameters = list(
    list(name = "filepath")
  ),
  display_title = "Read File",
  would_like_to = "Read `{filepath}`",
  is_currently = "Reading `{filepath}`",
  has_already = "Read `{filepath}`",
  readonly = TRUE,
  execute = read_file
)

#' @importFrom ellmer tool type_string
ai_tool_read_file_ellmer <- tool(
  function(filepath) read_file(list(filepath = filepath)),
  name = ai_tool_read_file$name,
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
