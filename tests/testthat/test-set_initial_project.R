test_that("set_initial_project - no project", {
  local_mocked_bindings(
    getActiveProject = function() NULL,
    .package = "myownrobs"
  )
  expect_null(set_initial_project())
  expect_null(set_initial_project(TRUE))
})

test_that("set_initial_project - save project", {
  project_dir <- tempfile()
  dir.create(project_dir)
  writeLines("SOME_CONTENT", paste0(project_dir, "/SOME_FILE.R"))
  backup_dir <- paste0(tempdir(), "/myownrobs/")
  local_mocked_bindings(
    getActiveProject = function() project_dir,
    .package = "myownrobs"
  )
  set_initial_project()
  expect_equal(dir(backup_dir), "SOME_FILE.R")
  expect_equal(readLines(paste0(backup_dir, "SOME_FILE.R")), "SOME_CONTENT")
})

test_that("set_initial_project - restore project", {
  project_dir <- tempfile()
  dir.create(project_dir)
  writeLines("SOME_CONTENT", paste0(project_dir, "/SOME_FILE.R"))
  backup_dir <- paste0(tempdir(), "/myownrobs/")
  local_mocked_bindings(
    getActiveProject = function() project_dir,
    .package = "myownrobs"
  )
  set_initial_project()
  expect_equal(dir(backup_dir), "SOME_FILE.R")
  expect_equal(readLines(paste0(backup_dir, "SOME_FILE.R")), "SOME_CONTENT")
  writeLines("NO_CONTENT", paste0(project_dir, "/SOME_FILE.R"))
  expect_equal(readLines(paste0(backup_dir, "SOME_FILE.R")), "SOME_CONTENT")
  expect_equal(readLines(paste0(project_dir, "/SOME_FILE.R")), "NO_CONTENT")
  set_initial_project(restore = TRUE)
  expect_equal(readLines(paste0(project_dir, "/SOME_FILE.R")), "SOME_CONTENT")
})
