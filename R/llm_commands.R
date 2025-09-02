# This file defines a list of AI agent commands, categorizing them by the mode
# in which they are available (Plan Mode for read-only, Agent Mode for all tools).

# TODO: Add `continue/core/tools/definitions/`
# - CreateRuleBlock
# - RequestRule
# - ViewDiff

# llm_commands: A list containing definitions of tools that the AI agent can use.
llm_commands <- list(
  # Tools Available in Plan Mode (Read-Only): These tools allow the AI to inspect the project and
  # gather information without making any modifications.
  ai_tool_read_file,
  ai_tool_read_currently_open_file,
  ai_tool_ls_tool,
  ai_tool_file_glob_search,
  ai_tool_grep_search,
  ai_tool_fetch_url_content,
  ai_tool_search_web,
  # Tools Available in Agent Mode (All Tools): These tools enable the AI to perform actions that
  # modify the project, create new files, or run R commands, in addition to all read-only
  # capabilities.
  ai_tool_create_new_file,
  ai_tool_edit_existing_file,
  ai_tool_search_and_replace_in_file,
  ai_tool_run_r_command
)
# Assign names to the elements of the 'llm_commands' list based on their 'name' property.
# This allows for easy lookup of commands by their function name.
llm_commands <- setNames(llm_commands, sapply(llm_commands, function(x) x$name))

#' Validate Command Arguments
#'
#' Checks if all required parameters for a given command are present in the provided arguments.
#' This function ensures that the AI agent has supplied all necessary arguments before executing a
#' command.
#'
#' @param command A list representing the command definition, expected to contain a 'parameters'
#'   element.
#' @param args A list of arguments provided to the command.
#'
#' @keywords internal
#'
validate_command_args <- function(command, args) {
  all(sapply(command$parameters, function(x) x$name) %in% names(args))
}
