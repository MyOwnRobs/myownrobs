test_that("set_initial_project - no project", {
  local_mocked_bindings(
    getActiveProject = function() NULL,
    .package = "myownrobs"
  )
  expect_null(set_initial_project())
  expect_null(set_initial_project(TRUE))
})
