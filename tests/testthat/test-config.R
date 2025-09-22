test_that("get_config - inexistent config", {
  mock_config_dir <- tempfile("test", fileext = "/")
  local_mocked_bindings(
    R_user_dir = function(package, which) mock_config_dir,
    .package = "myownrobs"
  )
  result <- get_config("test_config")
  expect_null(result)
})

test_that("set_config - write a common config", {
  mock_config_dir <- tempfile("test", fileext = "/")
  local_mocked_bindings(
    R_user_dir = function(package, which) mock_config_dir,
    .package = "myownrobs"
  )
  result <- set_config("test_config", "TRUE")
  expected <- readLines(paste0(mock_config_dir, "/test_config"))
  expect_equal("TRUE", expected)
})

test_that("set_config & get_config - write and read a common config", {
  mock_config_dir <- tempfile("test", fileext = "/")
  local_mocked_bindings(
    R_user_dir = function(package, which) mock_config_dir,
    .package = "myownrobs"
  )
  set_config("test_config", "FALSE")
  expected <- get_config("test_config")
  expect_equal("FALSE", expected)
})
