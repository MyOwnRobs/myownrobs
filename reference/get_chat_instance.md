# Get the ellmer Chat Instance

Get the ellmer Chat Instance

## Usage

``` r
get_chat_instance(mode, model, project_context, api_key, available_models)
```

## Arguments

- mode:

  The mode of operation, one of "agent" or "ask".

- model:

  The ID of the model to use (E.g., "gemini-2.5-pro").

- project_context:

  The context of the session executing the addin, obtained with
  \`get_project_context()\`.

- api_key:

  The API key for MyOwnRobs, obtained with \`get_api_key()\`.

- available_models:

  List of available models to use.
