#' Send Prompt to the LLM
#'
#' @param chat_id The ID of the chat session.
#' @param prompt The prompt to send.
#' @param role The role of the entity sending the prompt, one of "user" or "tool_runner".
#' @param mode The mode of operation, one of "agent" or "ask".
#' @param model The ID of the model to use.
#' @param project_context The context of the session executing the addin, obtained with
#'   `get_project_context()`.
#' @param api_url The API URL to use for requests.
#' @param api_key The API key for MyOwnRobs, obtained with `get_api_key()`.
#'
#' @importFrom httr2 req_body_json req_headers req_perform req_url_path_append request
#' @importFrom httr2 resp_body_string
#' @importFrom jsonlite toJSON
#'
#' @keywords internal
#'
send_prompt <- function(chat_id, prompt, role, mode, model, project_context, api_url, api_key) {
  # Initialize an HTTP request with the base API URL.
  req <- request(api_url)
  # Append the "send_prompt" path to the request URL.
  req <- req_url_path_append(req, "send_prompt")
  # Add Authorization header with the bearer API key.
  req <- req_headers(req, Authorization = paste("Bearer", api_key))
  # Set the request body as JSON, including chat details, prompt, and context.
  req <- req_body_json(req, list(
    chat_id = chat_id,
    prompt = toJSON(prompt, auto_unbox = TRUE), # Convert prompt to JSON string.
    project_context = toJSON(project_context, auto_unbox = TRUE), # Convert to JSON string.
    role = role,
    mode = mode,
    model = model
  ))
  # Perform the HTTP request.
  resp <- req_perform(req)
  # Return the response body as a string.
  resp_body_string(resp)
}

#' Asynchronously Send Prompt to the LLM
#'
#' @param chat_id The ID of the chat session.
#' @param prompt The prompt to send.
#' @param role The role of the entity sending the prompt, one of "user" or "tool_runner".
#' @param mode The mode of operation, one of "agent" or "ask".
#' @param model The ID of the model to use.
#' @param project_context The context of the session executing the addin, obtained with
#'   `get_project_context()`.
#' @param api_url The API URL to use for requests.
#' @param api_key The API key for MyOwnRobs, obtained with `get_api_key()`.
#'
#' @importFrom mirai mirai
#'
#' @keywords internal
#'
send_prompt_async <- function(chat_id, prompt, role, mode, model, project_context, api_url,
                              api_key) {
  # Use the mirai package to run send_prompt asynchronously.
  mirai(
    # Call the synchronous send_prompt function with all its arguments
    send_prompt(chat_id, prompt, role, mode, model, project_context, api_url, api_key),
    # Explicitly pass all necessary objects to the mirai environment.
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
