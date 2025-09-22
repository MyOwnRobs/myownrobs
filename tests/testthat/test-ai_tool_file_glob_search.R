test_that("file_glob_search - invalid args", {
  expect_error(file_glob_search(list()), "Invalid arguments for FileGlobSearch")
})

test_that("file_glob_search - valid args", {
  local_mocked_bindings(
    getActiveProject = function(...) tempdir(),
    .package = "myownrobs"
  )
  writeLines("FILE_CONTENT", tempfile(fileext = ".R"))
  expect_true(nchar(file_glob_search(list(pattern = "*.R"))$output) > 0)
})
