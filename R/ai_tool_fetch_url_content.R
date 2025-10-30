fetch_url_content <- function(url) {
  if (!grepl("^https?://", url, ignore.case = TRUE)) {
    stop("Only http/https URLs are supported")
  }
  # Safety limits to avoid huge downloads.
  max_lines <- 2000L
  max_chars <- 200000L
  con <- url(url, open = "rb")
  on.exit(close(con), add = TRUE)
  lines <- readLines(con, warn = FALSE, n = max_lines, encoding = "UTF-8")
  content <- paste(lines, collapse = "\n")
  if (nchar(content, type = "bytes") > max_chars) {
    content <- paste0(substr(content, 1, max_chars), "\n\n...[truncated]...\n")
  }
  list(output = content)
}

#' @importFrom ellmer tool type_string
ai_tool_fetch_url_content <- tool(
  fetch_url_content,
  name = "FetchUrlContent",
  description = paste0(
    "Can be used to view the contents of a website using a URL. Do NOT use this for files."
  ),
  arguments = list(
    url = type_string("The URL to read.")
  )
)
