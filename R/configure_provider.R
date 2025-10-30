#' Configure Provider
#'
#' Set API keys for running models locally.
#'
#' @param name Name of the provider (one of "google_gemini" or "anthropic").
#' @param api_key The provider's API key to use for authentication. If `NULL`, the provider will be
#'   deleted.
#'
#' @examples
#' \dontrun{
#' configure_provider("google_gemini", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
#' configure_provider(
#'   "anthropic",
#'   "sk-ant-api03-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' )
#' configure_provider("google_gemini", NULL)
#' }
#'
#' @importFrom ellmer models_anthropic models_google_gemini
#' @importFrom jsonlite fromJSON toJSON
#'
#' @export
#'
configure_provider <- function(name, api_key) {
  if (!name %in% c("anthropic", "google_gemini")) {
    stop('`name` must be one of "anthropic" or "google_gemini".')
  }
  # Load the already configured providers.
  api_keys <- get_config("api_keys")
  if (!is.null(api_keys)) api_keys <- fromJSON(api_keys)
  models <- NULL
  if (is.null(api_key)) {
    # API key to be removed.
    if (name %in% names(api_keys)) {
      api_keys <- api_keys[names(api_keys) != name]
    }
  } else if (name == "anthropic") {
    # Check if the API key works.
    models <- try(models_anthropic(api_key = api_key), silent = TRUE)
    api_keys[[name]] <- api_key
  } else if (name == "google_gemini") {
    # Check if the API key works.
    models <- try(models_google_gemini(api_key = api_key), silent = TRUE)
    api_keys[[name]] <- api_key
  }
  if (inherits(models, "try-error")) stop("The provided `api_key` is not working.")
  # Set the new list of providers.
  set_config("api_keys", toJSON(api_keys, auto_unbox = TRUE))
  invisible(api_keys)
}
