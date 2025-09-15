#' Validate MyOwnRobs Credentials
#'
#' @param api_url The API URL to use for requests.
#' @param force Force validation altough there's an existing key.
#'
#' @importFrom httr2 req_headers req_method req_perform req_url_path_append request resp_body_json
#' @importFrom httr2 resp_status
#' @importFrom gargle token_fetch
#'
#' @keywords internal
#'
validate_credentials <- function(api_url, force = FALSE) {
  # Check if an API key is not set or if validation is forced.
  if (nchar(get_api_key()) == 0 || force) {
    tryCatch(
      {
        # Fetch authentication token from Google.
        token <- token_fetch("https://www.googleapis.com/auth/userinfo.email")
        # Initialize the API request
        req <- request(api_url)
        req <- req_url_path_append(req, "authenticate") # Append 'authenticate' path.
        req <- req_method(req, "POST") # Set request method to POST.
        # Add Authorization header with the bearer token.
        req <- req_headers(req, Authorization = paste("Bearer", token$credentials$access_token))
        # Perform the API request.
        resp <- req_perform(req)
        # Check if the response status is not 200 (OK).
        if (resp_status(resp) != 200) {
          stop("Authentication failed with status: ", resp_status(resp))
        }
        # Extract and validate API key from the response body.
        response_data <- resp_body_json(resp)
        api_key <- response_data$api_key
        if (is.null(api_key) || nchar(api_key) == 0) {
          stop("No valid API key received from server")
        }
        # Save the received API key locally.
        save_api_key(api_key)
      },
      error = function(e) {
        # Handle any errors during the authentication process
        stop("Please login to MyOwnRobs. Error: ", e$message)
      }
    )
  }
  return()
}

#' Save MyOwnRobs Credentials Locally
#'
#' @param api_key The MyOwnRobs API key to save locally.
#'
#' @keywords internal
#'
save_api_key <- function(api_key) {
  # Assign the API key to a local environment variable (for current session).
  assign("api_key", api_key, envir = .state)
  # Define the path to the user's .Renviron file
  renviron_path <- file.path(Sys.getenv("HOME"), ".Renviron")
  # Read existing .Renviron file if it exists.
  if (file.exists(renviron_path)) {
    lines <- readLines(renviron_path)
    # Remove any existing MYOWNROBS_API_KEY line to prevent duplicates.
    lines <- lines[!grepl("^MYOWNROBS_API_KEY=", lines)]
  } else {
    # If .Renviron doesn't exist, start with an empty character vector.
    lines <- character(0)
  }
  # Add the new API key to the lines.
  lines <- c(lines, paste0("MYOWNROBS_API_KEY=", api_key))
  # Write all lines back to the .Renviron file.
  writeLines(lines, renviron_path)
  # Inform the user about the update.
  message("API key stored in ~/.Renviron - restart R session to load automatically")
}
