get_api_key <- function() {
  api_key <- Sys.getenv("MYOWNHADLEY_API_KEY")
  return(api_key)
}
