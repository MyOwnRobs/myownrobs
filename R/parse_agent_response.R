#' Parse Agent Response
#'
#' This function parses the raw text response from an AI agent, expecting a JSON string potentially
#' wrapped in markdown code fences. It extracts the JSON part and attempts to parse it.
#'
#' @param response_text The raw text response received from the AI agent.
#'
#' @importFrom jsonlite fromJSON
#'
#' @keywords internal
#'
parse_agent_response <- function(response_text) {
  # Remove markdown code fences (```json or ```) from the response text.
  extracted <- gsub("(^```(json)?\\s*)|(\\s*```$)", "", response_text)
  # Attempt to safely parse the extracted string as JSON.
  # `simplifyVector = FALSE` ensures that single-element arrays are not simplified to vectors.
  parsed <- try(fromJSON(extracted, simplifyVector = FALSE), silent = TRUE)
  # Check if parsing failed or if the result is not a list (indicating invalid JSON structure).
  if (inherits(parsed, "try-error") || !is.list(parsed)) {
    warning(response_text) # Log the problematic response for debugging.
    # Return an error object if parsing was unsuccessful.
    return(list(error = "Invalid JSON response from AI model", error_code = "invalid_ai_response"))
  }
  # Return the successfully parsed JSON object.
  parsed
}
