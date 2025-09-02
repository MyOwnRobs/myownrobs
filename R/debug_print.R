#' Debug Print Function
#'
#' Prints a value to the console with a timestamp if the 'DEBUG' environment variable is set.
#' This function is useful for conditional debugging output in R projects.
#'
#' @param value The R object to be printed.
#'
#' @keywords internal
#'
debug_print <- function(value) {
  # Check if the 'DEBUG' environment variable has a non-zero length, indicating debugging is active.
  if (nchar(Sys.getenv("DEBUG")) > 0) {
    # Print a debug header with the current timestamp.
    message("--- DEBUG ", Sys.time())
    # Print the provided value.
    print(value)
  }
}
