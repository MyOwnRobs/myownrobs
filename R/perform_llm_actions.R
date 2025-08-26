#' Perform LLM actions given one user prompt
#'
#' @param chat_id The ID of the chat session.
#' @param user_prompt The user prompt text.
#' @param mode The mode of operation, one of "agent" or "ask".
#' @param model The ID of the model to use.
#' @param api_url The API URL to use for requests.
#' @param max_iterations The maximum number of iterations the model can execute.
perform_llm_actions <- function(chat_id, user_prompt, mode, model, api_url, max_iterations = 7) {
  role <- "user"
  prompt <- user_prompt
  iteration_count <- 0
  while (iteration_count < max_iterations) {
    iteration_count <- iteration_count + 1
    # Ask the model and parse its (agent-mode) reply which should be a JSON object.
    response_text <- send_prompt(chat_id, prompt, role, mode, model, api_url)
    parsed <- parse_agent_response(response_text)
    if (!is.null(parsed$error)) {
      warning(parsed$error, call. = FALSE)
      return(list(
        status = "error", reply = paste("An error occurred, please try again later.", parsed$error)
      ))
    }
    if (isTRUE(nchar(parsed$response$user_message) > 0)) {
      return(list(status = "finished", reply = parsed$response$user_message))
    }
    if (isTRUE(length(parsed$response$tools) > 0)) {
      role <- "tool_runner"
      prompt <- execute_llm_tools(parsed$response$tools)
    } else {
      return(list(status = "finished", reply = "👋"))
    }
  }
  return(list(
    status = "limit_reached",
    reply = "The model has been iterating for too long, do you want to continue?"
  ))
}

#' @importFrom jsonlite fromJSON
parse_agent_response <- function(response_text) {
  extracted <- gsub("(^```(json)?\\s*)|(\\s*```$)", "", response_text)
  # Safe parse using jsonlite.
  parsed <- try(fromJSON(extracted, simplifyVector = FALSE), silent = TRUE)
  if (inherits(parsed, "try-error")) {
    warning(response_text)
    return(list(error = paste0("Failed to parse JSON: ", parsed)))
  }
  # Expect parsed to be a list with keys: tools (array) and user_message (string).
  if (!is.list(parsed)) {
    return(list(error = "Parsed JSON is not an object"))
  }
  if (!is.null(parsed$error)) {
    return(list(error = parsed$error))
  }
  if (is.null(parsed$user_message) && length(parsed$tools) == 0) {
    return(list(error = "Erroneous AI reply"))
  }
  # Enforce mutual exclusivity: agent must choose either tools (and empty user_message)
  # OR a non-empty user_message (and empty tools). Return error when violated.
  if (isTRUE(nchar(parsed$user_message) > 0) && length(parsed$tools) > 0) {
    debug_print(parsed)
    return(list(error = "Agent returned both 'tools' and a non-empty 'user_message'."))
  }
  return(list(response = parsed))
}
