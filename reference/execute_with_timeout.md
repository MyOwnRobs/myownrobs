# Execute With Timeout

Evaluate an R expression and interrupts it if it takes too long.

## Usage

``` r
execute_with_timeout(expr, max_tool_run_time)
```

## Arguments

- expr:

  The R expression to evaluate.

- max_tool_run_time:

  Maximum seconds an AI tool can run before getting killed.
