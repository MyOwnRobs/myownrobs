test_that("grep_search - invalid args", {
  expect_error(grep_search(list()), "Invalid arguments for GrepSearch")
})

test_that("grep_search - found file", {
  local_mocked_bindings(
    getActiveProject = function(...) tempdir(),
    .package = "myownrobs"
  )
  mock_file <- tempfile(fileext = ".R")
  writeLines("FILE_CONTENT", mock_file)
  expect_true(grepl("1:FILE_CONTENT", grep_search(list(query = "CONTENT"))$output))
})

test_that("grep_search - not found file", {
  local_mocked_bindings(
    getActiveProject = function(...) tempdir(),
    .package = "myownrobs"
  )
  writeLines("FILE_CONTENT", tempfile(fileext = ".R"))
  expect_equal(grep_search(list(query = "OTHER_STUFF"))$output, "")
})
