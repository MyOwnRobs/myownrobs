debug_print <- function(value) {
  if (nchar(Sys.getenv("DEBUG")) > 0) {
    print(value)
  }
}
