test_that("ls_tool - invalid args", {
  expect_error(ls_tool(list()), "Invalid arguments for LSTool")
})

test_that("ls_tool", {
  mock_file <- tempfile()
  # Make sure there's at least one file.
  writeLines("FILE_CONTENT", mock_file)
  expect_true(grepl(
    basename(mock_file),
    ls_tool(list(dirPath = tempdir()))$output
  ))
})
