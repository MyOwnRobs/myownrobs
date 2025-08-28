#' Send Prompt to the LLM
#' @param chat_id The ID of the chat session.
#' @param prompt The prompt to send.
#' @param role The role of the entity sending the prompt, one of "user" or "tool_runner".
#' @param mode The mode of operation, one of "agent" or "ask".
#' @param model The ID of the model to use.
#' @param project_context The context of the session executing the addin, obtained with
#'   `get_project_context()`.
#' @param api_url The API URL to use for requests.
#' @param api_key The API key for MyOwnHadley, obtained with `get_api_key()`.
#'
#' @importFrom httr2 req_body_json req_headers req_perform req_url_path_append request
#' @importFrom httr2 resp_body_string
#' @importFrom jsonlite toJSON
send_prompt <- function(chat_id, prompt, role, mode, model, project_context, api_url, api_key) {
  req <- request(api_url)
  req <- req_url_path_append(req, "send_prompt")
  req <- req_headers(req, Authorization = paste("Bearer", api_key))
  req <- req_body_json(req, list(
    chat_id = chat_id,
    prompt = prompt,
    project_context = project_context,
    role = role,
    mode = mode,
    model = model
  ))
  resp <- req_perform(req)
  return(resp_body_string(resp))
}

#' @importFrom mirai mirai
send_prompt_async <- function(chat_id, prompt, role, mode, model, project_context, api_url,
                              api_key) {
  mirai(
    send_prompt(chat_id, prompt, role, mode, model, project_context, api_url, api_key),
    send_prompt = send_prompt,
    chat_id = chat_id,
    prompt = prompt,
    role = role,
    mode = mode,
    model = model,
    project_context = project_context,
    api_url = api_url,
    api_key = api_key
  )
}
