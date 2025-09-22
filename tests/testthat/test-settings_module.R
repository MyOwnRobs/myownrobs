### save_run_at_startup

test_that("save_run_at_startup - save run at startup with empty Rprofile", {
  home_dir <- Sys.getenv("HOME")
  mock_config_dir <- tempfile("test", fileext = "/")
  dir.create(mock_config_dir, recursive = TRUE)
  Sys.setenv(HOME = mock_config_dir)
  # Test that it is written only once to the Rprofile.
  suppressMessages(save_run_at_startup())
  suppressMessages(save_run_at_startup())
  suppressMessages(save_run_at_startup())
  Sys.setenv(HOME = home_dir)
  result <- readLines(paste0(mock_config_dir, ".Rprofile"))
  expected <- paste0(
    'setHook("rstudio.sessionInit", function(...) ',
    'requireNamespace("myownrobs", quietly = TRUE) && ',
    'isTRUE(myownrobs:::get_config("open_at_startup") == "TRUE") && ',
    "myownrobs::myownrobs()",
    ', action = "append")'
  )
  expect_equal(result, expected)
})

test_that("save_run_at_startup - save run at startup with Rprofile", {
  home_dir <- Sys.getenv("HOME")
  mock_config_dir <- tempfile("test", fileext = "/")
  dir.create(mock_config_dir, recursive = TRUE)
  Sys.setenv(HOME = mock_config_dir)
  writeLines("SOME_CODE_IN_RPROFILE", paste0(mock_config_dir, ".Rprofile"))
  # Test that it is written only once to the Rprofile.
  suppressMessages(save_run_at_startup())
  suppressMessages(save_run_at_startup())
  suppressMessages(save_run_at_startup())
  Sys.setenv(HOME = home_dir)
  result <- readLines(paste0(mock_config_dir, ".Rprofile"))
  expected <- c("SOME_CODE_IN_RPROFILE", paste0(
    'setHook("rstudio.sessionInit", function(...) ',
    'requireNamespace("myownrobs", quietly = TRUE) && ',
    'isTRUE(myownrobs:::get_config("open_at_startup") == "TRUE") && ',
    "myownrobs::myownrobs()",
    ', action = "append")'
  ))
  expect_equal(result, expected)
})
