#' @importFrom jsonlite fromJSON toJSON
#' @importFrom utils URLencode
search_web <- function(args) {
  if (!validate_command_args(ai_tool_search_web, args)) {
    stop("Invalid arguments for SearchWeb")
  }
  search_url <- paste0(
    "https://api.duckduckgo.com/?q=",
    URLencode(args$query, reserved = TRUE),
    "&no_redirect=0&no_html=0&format=json&skip_disambig=0&t=myownrobs"
  )
  search_res <- fromJSON(search_url)
  result <- search_res[c("AbstractText", "AbstractURL", "Infobox", "RelatedTopics", "Results")]
  list(output = toJSON(result, auto_unbox = TRUE))
}

ai_tool_search_web <- list(
  name = "SearchWeb",
  parameters = list(
    list(name = "query")
  ),
  display_title = "Search Web",
  would_like_to = 'Search the web for "{query}"',
  is_currently = 'Searching the web for "{query}"',
  has_already = 'Searched the web for "{query}"',
  readonly = TRUE,
  execute = search_web
)
