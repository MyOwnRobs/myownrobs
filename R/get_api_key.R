#' Get API Key
#'
#' Retrieves the API key for MyOwnRobs from the internal state environment.
#'
#' @keywords internal
#'
get_api_key <- function() {
  get("api_key", envir = .state) # Retrieve the 'api_key' from the '.state' environment.
}
