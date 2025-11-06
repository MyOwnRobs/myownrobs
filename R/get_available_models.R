#' Return the Available Models
#'
#' @importFrom jsonlite fromJSON
#'
#' @keywords internal
#'
get_available_models <- function() {
  available_models <- get_config("available_models")
  if (is.null(available_models)) {
    available_models <- list("Gemini 2.5 Flash" = "gemini-2.5-flash")
  } else {
    available_models <- fromJSON(available_models)
  }
  available_models
}
