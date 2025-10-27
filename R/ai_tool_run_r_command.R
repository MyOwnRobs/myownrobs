#' @importFrom utils capture.output
run_r_command <- function(args) {
  if (!validate_command_args(ai_tool_run_r_command, args)) {
    stop("Invalid arguments for RunRCommand")
  }
  output <- paste(
    capture.output(eval(parse(text = args$command), envir = new.env(parent = .GlobalEnv))),
    collapse = "\n"
  )
  list(output = output)
}

ai_tool_run_r_command <- list(
  name = "RunRCommand",
  parameters = list(
    list(name = "command")
  ),
  display_title = "Run R Command",
  would_like_to = "Run the R command: `{command}`",
  is_currently = "Running the R command: `{command}`",
  has_already = "Ran the R command: `{command}`",
  readonly = FALSE,
  execute = run_r_command
)

#' @importFrom ellmer tool type_string
ai_tool_run_r_command_ellmer <- tool(
  function(command) run_r_command(list(command = command)),
  name = ai_tool_run_r_command$name,
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
