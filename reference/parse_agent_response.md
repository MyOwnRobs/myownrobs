# Parse Agent Response

This function parses the raw text response from an AI agent, expecting a
JSON string potentially wrapped in markdown code fences. It extracts the
JSON part and attempts to parse it.

## Usage

``` r
parse_agent_response(response_text)
```

## Arguments

- response_text:

  The raw text response received from the AI agent.
