test_that("search_and_replace_in_file - invalid args", {
  expect_error(search_and_replace_in_file(list()), "Invalid arguments for SearchAndReplaceInFile")
})

test_that("search_and_replace_in_file - no edits", {
  mock_file <- tempfile()
  writeLines("FILE_CONTENT1\nFILE_CONTENT2", mock_file)
  local_mocked_bindings(
    documentOpen = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    search_and_replace_in_file(list(filepath = mock_file, diffs = list())),
    list(new_content = "FILE_CONTENT1\nFILE_CONTENT2")
  )
})

test_that("search_and_replace_in_file - one edit", {
  mock_file <- tempfile()
  writeLines("FILE_CONTENT1\nFILE_CONTENT2", mock_file)
  local_mocked_bindings(
    documentOpen = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    search_and_replace_in_file(
      list(
        filepath = mock_file,
        diffs = list(list(SEARCH = "FILE_CONTENT2", REPLACE = "NEW_CONTENT2"))
      )
    ),
    list(new_content = "FILE_CONTENT1\nNEW_CONTENT2")
  )
})

test_that("search_and_replace_in_file - two edits", {
  mock_file <- tempfile()
  writeLines("FILE_CONTENT1\nFILE_CONTENT2", mock_file)
  local_mocked_bindings(
    documentOpen = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    search_and_replace_in_file(
      list(
        filepath = mock_file,
        diffs = list(
          list(SEARCH = "FILE_CONTENT2", REPLACE = "NEW_CONTENT2"),
          list(SEARCH = "FILE_CONTENT1", REPLACE = "NEW_CONTENT1")
        )
      )
    ),
    list(new_content = "NEW_CONTENT1\nNEW_CONTENT2")
  )
})

test_that("search_and_replace_in_file - no edits ACTIVE_R_DOCUMENT", {
  local_mocked_bindings(
    getSourceEditorContext = function(...) list(contents = "FILE_CONTENT1\nFILE_CONTENT2"),
    insertText = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    search_and_replace_in_file(list(filepath = "ACTIVE_R_DOCUMENT", diffs = list())),
    list(new_content = "FILE_CONTENT1\nFILE_CONTENT2")
  )
})

test_that("search_and_replace_in_file - one edit ACTIVE_R_DOCUMENT", {
  local_mocked_bindings(
    getSourceEditorContext = function(...) list(contents = "FILE_CONTENT1\nFILE_CONTENT2"),
    insertText = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    search_and_replace_in_file(
      list(
        filepath = "ACTIVE_R_DOCUMENT",
        diffs = list(list(SEARCH = "FILE_CONTENT2", REPLACE = "NEW_CONTENT2"))
      )
    ),
    list(new_content = "FILE_CONTENT1\nNEW_CONTENT2")
  )
})

test_that("search_and_replace_in_file - two edits ACTIVE_R_DOCUMENT", {
  local_mocked_bindings(
    getSourceEditorContext = function(...) list(contents = "FILE_CONTENT1\nFILE_CONTENT2"),
    insertText = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    search_and_replace_in_file(
      list(
        filepath = "ACTIVE_R_DOCUMENT",
        diffs = list(
          list(SEARCH = "FILE_CONTENT2", REPLACE = "NEW_CONTENT2"),
          list(SEARCH = "FILE_CONTENT1", REPLACE = "NEW_CONTENT1")
        )
      )
    ),
    list(new_content = "NEW_CONTENT1\nNEW_CONTENT2")
  )
})
