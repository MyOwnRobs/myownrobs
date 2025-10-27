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

#' @importFrom ellmer tool type_string
ai_tool_file_glob_search_ellmer <- tool(
  function(pattern) file_glob_search(list(pattern = pattern)),
  name = ai_tool_file_glob_search$name,
  description = paste0(
    "Search for files recursively in the project using glob patterns. Supports ** for recursive ",
    "directory search. Output may be truncated; use targeted patterns."
  ),
  arguments = list(
    pattern = type_string("Glob pattern for file path matching.")
  )
)
