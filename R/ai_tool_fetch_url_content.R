fetch_url_content <- function(args) {
  if (!validate_command_args(ai_tool_fetch_url_content, args)) {
    stop("Invalid arguments for FetchUrlContent")
  }
  if (!grepl("^https?://", args$url, ignore.case = TRUE)) {
    stop("Only http/https URLs are supported")
  }
  # Safety limits to avoid huge downloads.
  max_lines <- 2000L
  max_chars <- 200000L
  con <- url(args$url, open = "rb")
  on.exit(close(con), add = TRUE)
  lines <- readLines(con, warn = FALSE, n = max_lines, encoding = "UTF-8")
  content <- paste(lines, collapse = "\n")
  if (nchar(content, type = "bytes") > max_chars) {
    content <- paste0(substr(content, 1, max_chars), "\n\n...[truncated]...\n")
  }
  list(output = content)
}

ai_tool_fetch_url_content <- list(
  name = "FetchUrlContent",
  parameters = list(
    list(name = "url")
  ),
  display_title = "Read URL",
  would_like_to = "Fetch {url}",
  is_currently = "Fetching {url}",
  has_already = "Fetched {url}",
  readonly = TRUE,
  execute = fetch_url_content
)
