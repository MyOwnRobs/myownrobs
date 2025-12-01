# Execute LLM tools

Execute LLM tools

## Usage

``` r
execute_llm_tools(tools, mode, max_tool_run_time = Inf)
```

## Arguments

- tools:

  A list of tools to execute

- mode:

  The mode of operation, one of "agent" or "ask".

- max_tool_run_time:

  Maximum seconds an AI tool can run before getting killed.
