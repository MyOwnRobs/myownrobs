#' @importFrom utils capture.output
run_r_command <- function(args) {
  if (!validate_command_args(ai_tool_run_r_command, args)) {
    stop("Invalid arguments for RunRCommand")
  }
  output <- paste(
    capture.output(eval(parse(text = args$command), envir = .GlobalEnv)),
    collapse = "\n"
  )
  return(list(output = output))
}

ai_tool_run_r_command <- list(
  name = "RunRCommand",
  parameters = list(
    list(name = "command")
  ),
  display_title = "Run R Command",
  would_like_to = "run the following R command:",
  is_currently = "running the following R command:",
  has_already = "ran the following R command:",
  readonly = FALSE,
  execute = run_r_command
)
