#' @importFrom stats setNames
#' @importFrom rstudioapi getActiveProject
grep_search <- function(query) {
  all_files <- list.files(getActiveProject(), recursive = TRUE, full.names = TRUE)
  matches <- setNames(lapply(all_files, function(file) {
    read_file <- suppressWarnings(readLines(file))
    matching_lines <- suppressWarnings(grep(query, read_file, perl = TRUE))
    matched_text <- read_file[matching_lines]
    paste(matching_lines, matched_text, sep = ":", collapse = "\n")
  }), all_files)
  matches <- matches[sapply(matches, function(x) nchar(x)) > 0]
  matches <- paste(names(matches), matches, sep = "\n", collapse = "\n\n")
  list(output = matches)
}

#' @importFrom ellmer tool type_string
ai_tool_grep_search <- tool(
  grep_search,
  name = "GrepSearch",
  description = paste0(
    "Perform a search over the repository using ripgrep. Output may be truncated, so use ",
    "targeted queries."
  ),
  arguments = list(
    query = type_string(
      "The search query to use. Must be a valid ripgrep regex expression, escaped where needed."
    )
  )
)
