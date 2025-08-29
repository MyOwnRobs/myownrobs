#' @importFrom jsonlite fromJSON
parse_agent_response <- function(response_text) {
  extracted <- gsub("(^```(json)?\\s*)|(\\s*```$)", "", response_text)
  # Safe parse using jsonlite.
  parsed <- try(fromJSON(extracted, simplifyVector = FALSE), silent = TRUE)
  if (inherits(parsed, "try-error") || !is.list(parsed)) {
    warning(response_text)
    return(list(error = "Invalid JSON response from AI model", error_code = "invalid_ai_response"))
  }
  return(parsed)
}
