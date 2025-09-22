test_that("edit_existing_file - invalid args", {
  expect_error(edit_existing_file(list()), "Invalid arguments for EditExistingFile")
})

test_that("edit_existing_file - ACTIVE_R_DOCUMENT", {
  local_mocked_bindings(
    getSourceEditorContext = function(...) list(id = "id"),
    insertText = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    edit_existing_file(list(filepath = "ACTIVE_R_DOCUMENT", changes = "CHANGES")),
    list(output = "")
  )
})

test_that("edit_existing_file - editing some file", {
  editing_file <- tempfile()
  local_mocked_bindings(
    documentOpen = function(...) NULL,
    .package = "myownrobs"
  )
  result <- edit_existing_file(list(filepath = editing_file, changes = "CHANGES"))
  expect_equal(result, list(output = ""))
  expect_equal(readLines(editing_file), "CHANGES")
})
