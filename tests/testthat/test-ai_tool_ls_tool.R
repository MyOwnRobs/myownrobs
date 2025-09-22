test_that("ls_tool - invalid args", {
  expect_error(ls_tool(list()), "Invalid arguments for LSTool")
})

test_that("ls_tool - no files", {
  expect_equal(ls_tool(list(dirPath = tempdir()))$output, "")
})

test_that("ls_tool - one file", {
  mock_file <- tempfile()
  writeLines("FILE_CONTENT", mock_file)
  expect_equal(ls_tool(list(dirPath = tempdir()))$output, basename(mock_file))
})
