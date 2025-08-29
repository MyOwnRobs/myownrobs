#' Get API Key
#'
#' Retrieves the API key for MyOwnHadley from the internal state environment.
#'
get_api_key <- function() {
  return(get("api_key", envir = .state)) # Retrieve the 'api_key' from the '.state' environment.
}
