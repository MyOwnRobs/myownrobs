test_that("create_new_file - new file", {
  local_mocked_bindings(
    documentOpen = function(...) NULL,
    .package = "myownrobs"
  )
  mock_file <- tempfile()
  create_new_file(mock_file, "NEW_FILE_CONTENT")
  result <- readLines(mock_file)
  expect_equal("NEW_FILE_CONTENT", result)
})
