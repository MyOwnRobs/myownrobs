#' @importFrom stats setNames
#' @importFrom rstudioapi getActiveProject
grep_search <- function(args) {
  if (!validate_command_args(ai_tool_grep_search, args)) {
    stop("Invalid arguments for GrepSearch")
  }
  all_files <- list.files(getActiveProject(), recursive = TRUE, full.names = TRUE)
  matches <- setNames(lapply(all_files, function(file) {
    read_file <- readLines(file)
    matching_lines <- grep(args$query, read_file, perl = TRUE)
    matched_text <- read_file[matching_lines]
    paste(matching_lines, matched_text, sep = ":", collapse = "\n")
  }), all_files)
  matches <- matches[sapply(matches, function(x) nchar(x)) > 0]
  matches <- paste(names(matches), matches, sep = "\n", collapse = "\n\n")
  return(list(output = matches))
}

ai_tool_grep_search <- list(
  name = "GrepSearch",
  parameters = list(
    list(name = "query")
  ),
  display_title = "Grep Search",
  would_like_to = 'search for "{query}" in the repository',
  is_currently = 'getting search results for "{query}"',
  has_already = 'retrieved search results for "{query}"',
  readonly = TRUE,
  execute = grep_search
)
