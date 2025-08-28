get_api_key <- function() {
  return(get("api_key", envir = .state))
}
