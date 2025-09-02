#' @importFrom fs dir_ls
#' @importFrom rstudioapi getActiveProject
file_glob_search <- function(args) {
  if (!validate_command_args(ai_tool_file_glob_search, args)) {
    stop("Invalid arguments for FileGlobSearch")
  }
  matched_files <- dir_ls(getActiveProject(), glob = args$pattern, recurse = TRUE, type = "file")
  matches <- paste(matched_files, collapse = "\n")
  list(output = matches)
}

ai_tool_file_glob_search <- list(
  name = "FileGlobSearch",
  parameters = list(
    list(name = "pattern")
  ),
  display_title = "Glob File Search",
  would_like_to = 'Find file matches for "{pattern}"',
  is_currently = 'Finding file matches for "{pattern}"',
  has_already = 'Retrieved file matches for "{pattern}"',
  readonly = TRUE,
  execute = file_glob_search
)
