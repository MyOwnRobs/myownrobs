#' @importFrom utils capture.output
run_r_command <- function(command) {
  output <- paste(
    capture.output(eval(parse(text = command), envir = new.env(parent = .GlobalEnv))),
    collapse = "\n"
  )
  list(output = output)
}

#' @importFrom ellmer tool type_string
ai_tool_run_r_command <- tool(
  run_r_command,
  name = "RunRCommand",
  description = paste0(
    "Run an R command in the current directory. The R terminal is not stateful and will not ",
    "remember any previous commands. When suggesting subsequent R commands ALWAYS format them in ",
    "R command blocks. Do NOT perform actions requiring special/admin privileges."
  ),
  arguments = list(
    command = type_string(
      "The command to run. This will be passed directly into the R interpreter."
    )
  )
)
