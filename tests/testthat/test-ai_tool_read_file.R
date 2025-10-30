test_that("read_file", {
  mock_file <- tempfile()
  writeLines("MOCK_CONTENT", mock_file)
  expect_equal(
    read_file(mock_file),
    list(filepath = mock_file, content = "MOCK_CONTENT")
  )
})
