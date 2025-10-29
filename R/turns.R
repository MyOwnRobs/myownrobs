#' Load a Turns from Disk
#'
#' @importFrom fs file_exists
#' @importFrom tools R_user_dir
#'
#' @keywords internal
#'
#'
load_turns <- function() {
  config_dir <- R_user_dir("myownrobs", "config")
  turns_file <- file.path(config_dir, "turns.rds")
  turns_value <- list()
  if (file_exists(turns_file)) {
    turns_value <- readRDS(turns_file)
  }
  turns_value
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
save_turns <- function(value) {
  config_dir <- R_user_dir("myownrobs", "config")
  if (!dir_exists(config_dir)) {
    dir_create(config_dir)
  }
  saveRDS(value, file.path(config_dir, "turns.rds"))
}

#' Convert a Turns Structure Into a User-Reading UI
#'
#' @param turns A list of Turns.
#'
#' @keywords internal
#'
turns_to_ui <- function(turns) {
  ui <- rev(lapply(turns, function(turn) {
    list(
      role = get_turn_role(turn),
      text = sapply(attr(turn, "contents"), content_to_ui)
    )
  }))
  # Remove non-UI elements.
  ui <- ui[!sapply(ui, function(x) is.null(unlist(x$text)))]
  ui
}

#' Get the MyOwnRobs Role from a Turn
#'
#' @param turns A Turn.
#'
#' @keywords internal
#'
get_turn_role <- function(turn) {
  role <- attr(turn, "role")
  content_types <- sapply(attr(turn, "contents"), function(x) class(x)[[1]])
  if (content_types == "ellmer::ContentToolRequest") role <- "tool_runner"
  role
}

#' Convert a Turn Content into a User-Reading UI
#'
#' @param content A Content.
#'
#' @importFrom methods is
#'
#' @keywords internal
#'
content_to_ui <- function(content) {
  if (is(content, "ellmer::ContentText")) {
    attr(content, "text")
  } else if (is(content, "ellmer::ContentToolRequest")) {
    arguments <- ""
    if (length(attr(content, "arguments")) > 0) {
      arguments <- paste0(
        names(attr(content, "arguments")), ' = "', attr(content, "arguments"), '"',
        collapse = ", "
      )
    }
    paste0(attr(content, "name"), "(", arguments, ")")
  } else if (is(content, "ellmer::ContentToolResult")) {
    NULL
  } else {
    browser()
  }
}
