test_that("read_currently_open_file - invalid args", {
  local_mocked_bindings(
    validate_command_args = function(...) FALSE,
    .package = "myownrobs"
  )
  expect_error(read_currently_open_file(list()), "Invalid arguments for ReadCurrentlyOpenFile")
})

test_that("read_currently_open_file - no file open", {
  local_mocked_bindings(
    getSourceEditorContext = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    read_currently_open_file(list()),
    list(filepath = "NO CURRENT FILE", content = "There are no files currently open.")
  )
})

test_that("read_currently_open_file - file open", {
  local_mocked_bindings(
    getSourceEditorContext = function(...) list(path = "", contents = "CONTENT"),
    .package = "myownrobs"
  )
  expect_equal(
    read_currently_open_file(list()),
    list(filepath = "ACTIVE_R_DOCUMENT", content = "CONTENT")
  )
})
