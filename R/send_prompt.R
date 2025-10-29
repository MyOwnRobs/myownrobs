#' Send Prompt to the LLM
#'
#' @param prompt The prompt to send.
#' @param mode The mode of operation, one of "agent" or "ask".
#' @param model The ID of the model to use (E.g., "gemini-2.5-pro").
#' @param project_context The context of the session executing the addin, obtained with
#'   `get_project_context()`.
#' @param api_key The API key for MyOwnRobs, obtained with `get_api_key()`.
#' @param available_models List of available models to use.
#'
#' @keywords internal
#'
send_prompt <- function(prompt, mode, model, project_context, api_key, available_models) {
  provider <- names(available_models)[sapply(available_models, function(models) model %in% models)]
  api_key <- api_key[[provider]]
  chat_instance <- get_chat_instance(provider, model, api_key, mode, project_context)
  chat_instance$chat(prompt)
  turns <- chat_instance$get_turns()
  save_turns(turns)
  turns
}

#' Asynchronously Send Prompt to the LLM
#'
#' @param prompt The prompt to send.
#' @param mode The mode of operation, one of "agent" or "ask".
#' @param model The ID of the model to use (E.g., "gemini-2.5-pro").
#' @param project_context The context of the session executing the addin, obtained with
#'   `get_project_context()`.
#' @param api_key The API key for MyOwnRobs, obtained with `get_api_key()`.
#' @param available_models List of available models to use.
#'
#' @importFrom mirai mirai
#'
#' @keywords internal
#'
send_prompt_async <- function(prompt, mode, model, project_context, api_key, available_models) {
  # Use the mirai package to run send_prompt asynchronously.
  mirai(
    # Call the synchronous send_prompt function with all its arguments
    send_prompt(prompt, mode, model, project_context, api_key, available_models),
    # Explicitly pass all necessary objects to the mirai environment.
    send_prompt = send_prompt,
    prompt = prompt,
    mode = mode,
    model = model,
    project_context = project_context,
    api_key = api_key,
    available_models = available_models
  )
}
