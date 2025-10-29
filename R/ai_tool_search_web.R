#' @importFrom jsonlite fromJSON toJSON
#' @importFrom utils URLencode
search_web <- function(query) {
  search_url <- paste0(
    "https://api.duckduckgo.com/?q=",
    URLencode(query, reserved = TRUE),
    "&no_redirect=0&no_html=0&format=json&skip_disambig=0&t=myownrobs"
  )
  search_res <- fromJSON(search_url)
  result <- search_res[c("AbstractText", "AbstractURL", "Infobox", "RelatedTopics", "Results")]
  list(output = toJSON(result, auto_unbox = TRUE))
}

#' @importFrom ellmer tool type_string
ai_tool_search_web <- tool(
  search_web,
  name = "SearchWeb",
  description = paste0(
    "Performs a web search, returning top results. Use this tool sparingly - only for questions ",
    "that require specialized, external, and/or up-to-date knowledge. Common programming ",
    "questions do not require web search."
  ),
  arguments = list(
    query = type_string("The natural language search query.")
  )
)
