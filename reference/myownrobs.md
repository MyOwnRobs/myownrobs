# Launch MyOwnRobs

Open the RStudio addin with the chat interface.

## Usage

``` r
myownrobs()
```

## Value

No return value. Called for its side effects to launch the MyOwnRobs
RStudio addin.

## Examples

``` r
if (interactive()) {
  # Configure your API providers first.
  configure_provider("google_gemini", Sys.getenv("GEMINI_API_KEY"))
  # Then launch MyOwnRobs.
  myownrobs()
}
```
