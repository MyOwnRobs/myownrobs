# Add a Provider to be Used

Set API keys for running models locally.

## Usage

``` r
configure_provider(name, api_key)
```

## Arguments

- name:

  Name of the provider (one of "anthropic", "deepseek", "google_gemini",
  "ollama", or "openai").

- api_key:

  The provider's API key to use for authentication. If \`NULL\`, the
  provider will be deleted.

## Examples

``` r
if (FALSE) { # \dontrun{
# Configure providers.
configure_provider("anthropic", Sys.getenv("ANTHROPIC_API_KEY"))
configure_provider("deepseek", Sys.getenv("DEEPSEEK_API_KEY"))
configure_provider("google_gemini", Sys.getenv("GEMINI_API_KEY"))
configure_provider("openai", Sys.getenv("OPENAI_API_KEY"))
configure_provider("ollama", Sys.getenv("OLLAMA_API_KEY"))
# Delete the provider for google_gemini.
configure_provider("google_gemini", NULL)
} # }
```
