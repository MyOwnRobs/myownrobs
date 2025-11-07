#' @importFrom rstudioapi getSourceEditorContext
read_currently_open_file <- function() {
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

#' @importFrom ellmer tool
ai_tool_read_currently_open_file <- tool(
  read_currently_open_file,
  name = "ReadCurrentlyOpenFile",
  description = paste0(
    "Read the currently open file in the IDE. If the user seems to be referring to a file that ",
    "you can't see, try using this."
  ),
  arguments = list()
)
