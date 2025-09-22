test_that("get_project_context", {
  local_mocked_bindings(
    getActiveProject = function() "PROJECT",
    getSourceEditorContext = function(...) list(path = "PATH"),
    .package = "myownrobs"
  )
  result <- get_project_context()
  expect_named(result, c(
    "r_terminal_working_directory", "rstudio_active_project", "rstudio_source_editor_context",
    "os_type", "architecture"
  ))
})
