#' Return the Available Models
#'
#' @param api_url The API URL to use for requests.
#'
#' @importFrom ellmer models_anthropic models_google_gemini
#' @importFrom jsonlite fromJSON
#' @importFrom stats setNames
#'
#' @keywords internal
#'
get_available_models <- function(api_url) {
  api_keys <- get_config("api_keys")
  if (is.null(api_keys)) {
    available_models <- get_myownrobs_models(api_url)
  } else {
    api_keys <- fromJSON(api_keys)
    available_models <- lapply(names(api_keys), function(provider) {
      get_ellmer_models(provider, api_keys[[provider]])
    }) |> setNames(names(api_keys))
  }
  available_models
}

#' Get MyOwnRobs Models
#'
#' @param api_url The API URL to use for requests.
#'
#' @importFrom httr2 req_headers req_perform req_url_path_append request resp_body_json resp_status
#'
#' @keywords internal
#'
get_myownrobs_models <- function(api_url) {
  # Initialize the API request.
  req <- request(api_url)
  req <- req_url_path_append(req, "list_models") # Append 'list_models' path.
  # Add Authorization header with the bearer token.
  req <- req_headers(req, Authorization = paste("Bearer", get_api_key()$myownrobs))
  # Perform the API request.
  resp <- req_perform(req)
  # Check if the response status is not 200 (OK).
  if (resp_status(resp) != 200) {
    stop("Models listing failed with status: ", resp_status(resp))
  }
  # Extract available models from the response body.
  resp_body_json(resp)
}

#' Get Ellmer Models
#'
#' @importFrom stats setNames
#' @importFrom tools toTitleCase
#'
#' @keywords internal
#'
get_ellmer_models <- function(provider, api_key) {
  if (provider == "anthropic") {
    models <- models_anthropic(api_key = api_key)
  } else if (provider == "google_gemini") {
    models <- models_google_gemini(api_key = api_key)
  }
  if ("name" %in% colnames(models)) {
    models <- setNames(models$id, models$name)
  } else {
    models <- setNames(models$id, gsub("-", " ", toTitleCase(models$id)))
  }
  models
}
