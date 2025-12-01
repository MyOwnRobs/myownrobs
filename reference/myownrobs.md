# Launch MyOwnRobs

Open the RStudio addin with the chat interface.

## Usage

``` r
myownrobs(
  api_url = paste0("https://myownhadley.com/api/v", packageVersion("myownrobs")$major)
)
```

## Arguments

- api_url:

  The API URL to use for requests. This parameter is for advanced users
  who want to specify an alternative backend URL and is rarely needed.

## Value

No return value. Called for its side effects to launch the MyOwnRobs
RStudio addin.

## Examples

``` r
if (interactive()) {
  myownrobs()
  # Specify the API URL.
  myownrobs("https://myownhadley.com/api/v0")
}
```
