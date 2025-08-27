#' Send Prompt to the LLM
#' @param chat_id The ID of the chat session.
#' @param prompt The prompt to send.
#' @param role The role of the entity sending the prompt, one of "user" or "tool_runner".
#' @param mode The mode of operation, one of "agent" or "ask".
#' @param model The ID of the model to use.
#' @param project_context The context of the session executing the addin, obtained with
#'   `get_project_context()`.
#' @param api_url The API URL to use for requests.
#'
#' @importFrom httr add_headers content POST
#' @importFrom jsonlite toJSON
send_prompt <- function(chat_id, prompt, role, mode, model, project_context, api_url) {
  post_res <- POST(
    paste0(api_url, "/send_prompt"),
    body = list(
      chat_id = chat_id,
      prompt = toJSON(prompt, auto_unbox = TRUE),
      project_context = toJSON(project_context, auto_unbox = TRUE),
      role = role,
      mode = mode,
      model = model
    ),
    encode = "json",
    add_headers(Authorization = paste("Bearer", get_api_key()))
  )
  reply <- content(post_res, as = "text", encoding = "UTF-8")
  return(reply)
}
