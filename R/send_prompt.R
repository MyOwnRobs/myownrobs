#' Send Prompt to the LLM
#' @param chat_id The ID of the chat session.
#' @param prompt The prompt to send.
#' @param role The role of the entity sending the prompt, one of "user" or "tool_runner".
#' @param mode The mode of operation, one of "agent" or "ask".
#' @param model The ID of the model to use.
#' @param api_url The API URL to use for requests.
#'
#' @importFrom httr add_headers content POST
#' @importFrom jsonlite toJSON
send_prompt <- function(chat_id, prompt, role, mode, model, api_url) {
  debug_print(list(send_prompt_fun = list(mode = mode, model = model, sent_prompt = prompt)))
  post_res <- POST(
    paste0(api_url, "/send_prompt"),
    body = list(
      chat_id = chat_id,
      prompt = toJSON(prompt, auto_unbox = TRUE),
      project_context = toJSON(get_project_context(), auto_unbox = TRUE),
      role = role,
      mode = mode,
      model = model
    ),
    encode = "json",
    add_headers(Authorization = paste("Bearer", get_api_key()))
  )
  reply <- content(post_res, as = "text", encoding = "UTF-8")
  debug_print(list(send_prompt_fun = list(mode = mode, model = model, reply = reply)))
  return(reply)
}
