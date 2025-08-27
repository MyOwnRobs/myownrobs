#' @importFrom jsonlite fromJSON
parse_agent_response <- function(response_text) {
  extracted <- gsub("(^```(json)?\\s*)|(\\s*```$)", "", response_text)
  # Safe parse using jsonlite.
  parsed <- try(fromJSON(extracted, simplifyVector = FALSE), silent = TRUE)
  if (inherits(parsed, "try-error")) {
    warning(response_text)
    return(list(error = paste0("Failed to parse JSON: ", parsed)))
  }
  # Expect parsed to be a list with keys: tools (array) and user_message (string).
  if (!is.list(parsed)) {
    return(list(error = "Parsed JSON is not an object"))
  }
  if (!is.null(parsed$error)) {
    return(list(error = parsed$error))
  }
  return(list(response = parsed))
}
