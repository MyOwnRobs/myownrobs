# TODO: Add `continue/core/tools/definitions/`
# - CreateRuleBlock
# - RequestRule
# - ViewDiff

llm_commands <- list(
  # Tools Available in Plan Mode (Read-Only)
  ai_tool_read_file,
  ai_tool_read_currently_open_file,
  ai_tool_ls_tool,
  ai_tool_file_glob_search,
  ai_tool_grep_search,
  ai_tool_fetch_url_content,
  ai_tool_search_web,
  # Tools Available in Agent Mode (All Tools)
  ai_tool_create_new_file,
  ai_tool_edit_existing_file,
  ai_tool_search_and_replace_in_file,
  ai_tool_run_r_command
)
llm_commands <- setNames(llm_commands, sapply(llm_commands, function(x) x$name))

# When going to run a command, it checks if the AI gave every required parameter to the function.
validate_command_args <- function(command, args) {
  all(sapply(command$parameters, function(x) x$name) %in% names(args))
}
