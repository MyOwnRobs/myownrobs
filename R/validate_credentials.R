#' Validate MyOwnHadley Credentials
#' @importFrom httr2 req_headers req_method req_perform req_url_path_append request resp_body_json
#' @importFrom httr2 resp_status
#' @importFrom gargle token_fetch
#' @param api_url The API URL to use for requests.
#' @param force Force validation altough there's an existing key.
validate_credentials <- function(api_url, force = FALSE) {
  if (nchar(get_api_key()) == 0 || force) {
    tryCatch(
      {
        token <- token_fetch("https://www.googleapis.com/auth/userinfo.email")
        req <- request(api_url)
        req <- req_url_path_append(req, "authenticate")
        req <- req_method(req, "POST")
        req <- req_headers(req, Authorization = paste("Bearer", token$credentials$access_token))
        resp <- req_perform(req)
        if (resp_status(resp) != 200) {
          stop("Authentication failed with status: ", resp_status(resp))
        }
        # Extract and validate API key
        response_data <- resp_body_json(resp)
        api_key <- response_data$api_key
        if (is.null(api_key) || nchar(api_key) == 0) {
          stop("No valid API key received from server")
        }
        save_api_key(api_key)
        # Return the API key
        return(api_key)
      },
      error = function(e) {
        stop("Please login to MyOwnHadley. Error: ", e$message)
      }
    )
  } else {
    # API key already exists, return it
    return(get_api_key())
  }
}

#' Save MyOwnHadley Credentials Locally
#' @param api_key The MyOwnHadley API key to save locally.
save_api_key <- function(api_key) {
  assign("api_key", api_key, envir = .state)
  renviron_path <- file.path(Sys.getenv("HOME"), ".Renviron")
  # Read existing .Renviron if it exists
  if (file.exists(renviron_path)) {
    lines <- readLines(renviron_path)
    # Remove any existing MYOWNHADLEY_API_KEY line
    lines <- lines[!grepl("^MYOWNHADLEY_API_KEY=", lines)]
  } else {
    lines <- character(0)
  }
  # Add the new API key
  lines <- c(lines, paste0("MYOWNHADLEY_API_KEY=", api_key))
  # Write back to .Renviron
  writeLines(lines, renviron_path)
  message("API key stored in ~/.Renviron - restart R session to load automatically")
}
