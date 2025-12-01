# Asynchronously Send Prompt to the LLM

Asynchronously Send Prompt to the LLM

## Usage

``` r
send_prompt_async(
  chat_id,
  prompt,
  role,
  mode,
  model,
  project_context,
  api_url,
  api_key
)
```

## Arguments

- chat_id:

  The ID of the chat session.

- prompt:

  The prompt to send.

- role:

  The role of the entity sending the prompt, one of "user" or
  "tool_runner".

- mode:

  The mode of operation, one of "agent" or "ask".

- model:

  The ID of the model to use.

- project_context:

  The context of the session executing the addin, obtained with
  \`get_project_context()\`.

- api_url:

  The API URL to use for requests.

- api_key:

  The API key for MyOwnRobs, obtained with \`get_api_key()\`.
