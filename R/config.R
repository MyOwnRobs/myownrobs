#' Get a Configuration Value
#'
#' @param config The name of the configuration value to obtain.
#'
#' @importFrom fs file_exists
#' @importFrom tools R_user_dir
#'
#' @keywords internal
#'
get_config <- function(config) {
  config_dir <- R_user_dir("myownrobs", "config")
  config_file <- file.path(config_dir, config)
  config_value <- NULL
  if (file_exists(config_file)) {
    config_value <- readLines(config_file)
  }
  config_value
}

#' Set a Configuration Value
#'
#' @param config The name of the configuration value to set.
#' @param value The value to assign to assign to the configuration.
#'
#' @importFrom fs dir_create dir_exists
#' @importFrom tools R_user_dir
#'
#' @keywords internal
#'
set_config <- function(config, value) {
  config_dir <- R_user_dir("myownrobs", "config")
  if (!dir_exists(config_dir)) {
    dir_create(config_dir)
  }
  writeLines(value, file.path(config_dir, config))
}
