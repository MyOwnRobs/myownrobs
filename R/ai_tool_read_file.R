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
