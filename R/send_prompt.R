#' Send Prompt to the LLM
#' @param chat_id The ID of the chat session.
#' @param prompt The prompt to send.
#' @param role The role of the entity sending the prompt, one of "user" or "tool_runner".
#' @param mode The mode of operation, one of "agent" or "ask".
#' @param model The ID of the model to use.
#' @param api_url The API URL to use for requests.
#'
#' @importFrom httr content POST
send_prompt <- function(chat_id, prompt, role, mode, model, api_url) {
  post_res <- POST(
    paste0(api_url, "/send_prompt"),
    body = list(
      chat_id = chat_id,
      prompt = prompt,
      project_context = get_project_context(),
      role = role,
      mode = mode,
      model = model
    ),
    encode = "json"
  )
  reply <- content(post_res, as = "parsed")
  return(reply)
}
