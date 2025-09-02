#' @importFrom rstudioapi getSourceEditorContext
read_currently_open_file <- function(args) {
  if (!validate_command_args(ai_tool_read_currently_open_file, args)) {
    stop("Invalid arguments for ReadCurrentlyOpenFile")
  }
  context <- getSourceEditorContext()
  if (is.null(context)) {
    return(list(filepath = "NO CURRENT FILE", content = "There are no files currently open."))
  }
  filepath <- context$path
  if (nchar(filepath) == 0) {
    filepath <- "ACTIVE_R_DOCUMENT"
  }
  list(filepath = filepath, content = paste(context$contents, collapse = "\n"))
}

ai_tool_read_currently_open_file <- list(
  name = "ReadCurrentlyOpenFile",
  parameters = list(),
  display_title = "Read Currently Open File",
  would_like_to = "Read the current file",
  is_currently = "Reading the current file",
  has_already = "Read the current file",
  readonly = TRUE,
  execute = read_currently_open_file
)
