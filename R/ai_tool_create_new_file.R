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

#' @importFrom ellmer tool type_array type_string
ai_tool_create_new_file_ellmer <- tool(
  function(filepath, contents) create_new_file(list(filepath = filepath, contents = contents)),
  name = ai_tool_create_new_file$name,
  description = "Create a new file. Only use this when a file doesn't exist and should be created.",
  arguments = list(
    filepath = type_string(
      "The path where the new file should be created, relative to the root of the workspace."
    ),
    contents = type_array(type_string(), "The contents to write to the new file.")
  )
)
