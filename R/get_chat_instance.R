#' Get the ellmer Chat Instance
#'
#' @param mode The mode of operation, one of "agent" or "ask".
#' @param model The ID of the model to use (E.g., "gemini-2.5-pro").
#' @param project_context The context of the session executing the addin, obtained with
#'   `get_project_context()`.
#' @param api_key The API key for MyOwnRobs, obtained with `get_api_key()`.
#' @param available_models List of available models to use.
#'
#' @importFrom ellmer chat
#'
#' @keywords internal
#'
get_chat_instance <- function(mode, model, project_context, api_key, available_models) {
  provider <- names(available_models)[sapply(available_models, function(models) model %in% models)]
  api_key <- api_key[[provider]]
  initial_prompt <- paste0(
    "You are a helpful coding assistant that excels at understanding user requests and selecting ",
    "the appropriate tools to help them. Be concise but thorough in your responses. Always ",
    "prioritize accuracy and helpfulness.\n",
    "Given the following project context, analyze the user's request and determine the best ",
    "course of action:\n",
    "<project_context>\n",
    toJSON(project_context, auto_unbox = TRUE),
    "\n</project_context>\n"
  )
  chat_instance <- chat(
    paste0(provider, "/", model),
    api_key = api_key, system_prompt = initial_prompt
  )
  chat_instance$register_tools(get_llm_tools(mode))
  chat_instance$set_turns(load_turns())
  chat_instance
}
