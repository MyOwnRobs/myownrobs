#' @importFrom rstudioapi documentOpen
create_new_file <- function(args) {
  if (!validate_command_args(ai_tool_create_new_file, args)) {
    stop("Invalid arguments for CreateNewFile")
  }
  dir.create(dirname(args$filepath), recursive = TRUE, showWarnings = FALSE)
  writeLines(args$contents, args$filepath)
  documentOpen(args$filepath)
  list(output = "")
}

ai_tool_create_new_file <- list(
  name = "CreateNewFile",
  parameters = list(
    list(name = "filepath"),
    list(name = "contents")
  ),
  display_title = "Create New File",
  would_like_to = "Create a new file at `{filepath}`",
  is_currently = "Creating a new file at `{filepath}`",
  has_already = "Created a new file at `{filepath}`",
  readonly = FALSE,
  execute = create_new_file
)
