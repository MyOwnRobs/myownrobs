#' Get API Key
#'
#' Retrieves the API key for MyOwnRobs from the internal state environment.
#'
#' @importFrom jsonlite fromJSON
#'
#' @keywords internal
#'
get_api_key <- function() {
  api_keys <- get_config("api_keys")
  if (!is.null(api_keys)) {
    api_keys <- fromJSON(api_keys)
  }
  # Retrieve the 'api_key' from the '.state' environment.
  api_keys$myownrobs <- get("api_key", envir = .state)
  api_keys
}
