#' Load Turns from Disk
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

#' Save Turns to Disk
#'
#' @param value The turns object to save.
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
  invisible(value)
}

#' Convert a Turns Structure Into a User-Readable UI
#'
#' @param turns A list of Turns.
#'
#' @keywords internal
#'
turns_to_ui <- function(turns) {
  ui <- rev(unlist(lapply(turns, function(turn) {
    lapply(attr(turn, "contents"), function(content) content_to_ui(content, attr(turn, "role")))
  }), recursive = FALSE))
  # Remove non-UI elements.
  ui <- ui[!sapply(ui, function(x) is.null(unlist(x$text)))]
  ui
}

#' Convert a Turn Content into a User-Readable UI
#'
#' @param content A Content.
#' @param role The Turn's main role.
#'
#' @importFrom methods is
#'
#' @keywords internal
#'
content_to_ui <- function(content, role) {
  if (is(content, "ellmer::ContentText")) {
    list(role = role, text = attr(content, "text"))
  } else if (is(content, "ellmer::ContentToolRequest")) {
    arguments <- ""
    if (length(attr(content, "arguments")) > 0) {
      arguments <- paste0(
        names(attr(content, "arguments")), ' = "', attr(content, "arguments"), '"',
        collapse = ", "
      )
    }
    res <- paste0(attr(content, "name"), "(", arguments, ")")
    if (nchar(res) > 100) {
      res <- paste0(substr(res, 1, 97), "...")
    }
    list(role = "tool_runner", text = res)
  } else if (is(content, "ellmer::ContentToolResult")) {
    NULL
  }
}
