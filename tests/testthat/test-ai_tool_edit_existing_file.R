test_that("edit_existing_file - ACTIVE_R_DOCUMENT", {
  local_mocked_bindings(
    getSourceEditorContext = function(...) list(id = "id"),
    insertText = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    edit_existing_file("ACTIVE_R_DOCUMENT", "CHANGES"),
    list(output = "")
  )
})

test_that("edit_existing_file - editing some file", {
  editing_file <- tempfile()
  local_mocked_bindings(
    documentOpen = function(...) NULL,
    .package = "myownrobs"
  )
  result <- edit_existing_file(editing_file, "CHANGES")
  expect_equal(result, list(output = ""))
  expect_equal(readLines(editing_file), "CHANGES")
})
