#' Execute LLM tools
#'
#' @param tools A list of tools to execute
#' @param mode The mode of operation, one of "agent" or "ask".
#'
#' @importFrom glue glue
#'
#' @keywords internal
#'
execute_llm_tools <- function(tools, mode) {
  execution <- lapply(tools, function(tool) {
    # Retrieve the command definition from the global 'llm_commands' list using the tool's name.
    command <- llm_commands[[tool$name]]
    # Check if the mode is 'ask' (read-only) and the command is not marked as read-only.
    # If an editing command is attempted in 'ask' mode, stop execution with an error.
    if (mode == "ask" && !command$readonly) {
      stop("AI trying to perform edits on Ask mode.")
    }
    # Execute the command's designated function with its arguments.
    # The execution is wrapped in a try-catch block to handle potential errors silently,
    # and the result (or error) is stored in the tool's 'output' slot.
    tool$output <- try(command$execute(tool$args), silent = TRUE)
    list(execution = tool, ui = glue(command$has_already, .envir = as.environment(tool$args)))
  })
  ai <- list(tools = lapply(execution, function(x) x$execution))
  ui <- lapply(execution, function(x) x$ui)
  list(ai = ai, ui = ui)
}
