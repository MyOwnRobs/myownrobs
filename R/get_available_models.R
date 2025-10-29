#' Return the Available Models
#'
#' @importFrom ellmer models_anthropic models_google_gemini
#' @importFrom jsonlite fromJSON
#' @importFrom stats setNames
#'
#' @keywords internal
#'
get_available_models <- function() {
  api_keys <- get_config("api_keys")
  if (is.null(api_keys)) {
    available_models <- get_config("available_models")
    if (is.null(available_models)) {
      available_models <- list(Gemini = list("Gemini 2.5 Flash" = "gemini-2.5-flash"))
    } else {
      available_models <- fromJSON(available_models)
    }
  } else {
    api_keys <- fromJSON(api_keys)
    available_models <- lapply(names(api_keys), function(provider) {
      if (provider == "anthropic") {
        models_anthropic(api_key = api_keys[[provider]])$id
      } else if (provider == "google_gemini") {
        models_google_gemini(api_key = api_keys[[provider]])$id
      }
    }) |> setNames(names(api_keys))
  }
  available_models
}
