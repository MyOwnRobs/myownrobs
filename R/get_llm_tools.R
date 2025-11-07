# This file defines a list of AI agent commands, categorizing them by the mode
# in which they are available (Plan Mode for read-only, Agent Mode for all tools).

# TODO: Add `continue/core/tools/definitions/`
# - CreateRuleBlock
# - RequestRule
# - ViewDiff

#' Get LLM Tools
#'
#' Get the LLM tools for ellmer chat interface.
#'
#' @param mode The mode of operation, one of "agent" or "ask".
#'
#' @keywords internal
#'
get_llm_tools <- function(mode) {
  tools <- list(
    ai_tool_read_file,
    ai_tool_read_currently_open_file,
    ai_tool_ls_tool,
    ai_tool_file_glob_search,
    ai_tool_grep_search,
    ai_tool_fetch_url_content,
    ai_tool_search_web
  )
  if (mode == "agent") {
    # Tools Available in Agent Mode (All Tools): These tools enable the AI to perform actions that
    # modify the project, create new files, or run R commands, in addition to all read-only
    # capabilities.
    tools <- append(tools, list(
      ai_tool_create_new_file,
      ai_tool_edit_existing_file,
      ai_tool_search_and_replace_in_file,
      ai_tool_run_r_command
    ))
  }
  tools
}
