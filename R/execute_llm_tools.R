#' Execute LLM tools
#' @param tools A list of tools to execute
#' @param mode The mode of operation, one of "agent" or "ask".
execute_llm_tools <- function(tools, mode) {
  return(list(tools = execute_llm_tools_iteration(tools, mode)))
}

execute_llm_tools_iteration <- function(tools, mode) {
  lapply(tools, function(tool) {
    command <- llm_commands[[tool$name]]
    if (mode == "ask" && !command$readonly) {
      stop("AI trying to perform edits on Ask mode.")
    }
    tool$output <- try(command$execute(tool$args), silent = TRUE)
    return(tool)
  })
}
