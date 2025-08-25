#' Execute LLM tools
#' @param tools A list of tools to execute
execute_llm_tools <- function(tools) {
  debug_print(tools)
  return(list(tools = execute_llm_tools_iteration(tools)))
}

execute_llm_tools_iteration <- function(tools) {
  lapply(tools, function(tool) {
    tool$output <- try(llm_commands[[tool$name]]$execute(tool$args), silent = TRUE)
    return(tool)
  })
}
