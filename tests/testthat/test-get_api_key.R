test_that("get_api_key - valid API key", {
  api_key <- get("api_key", envir = .state)
  assign("api_key", "SOME_API_KEY", envir = .state)
  expect_equal(get_api_key()$myownrobs, "SOME_API_KEY")
  assign("api_key", api_key, envir = .state)
})

test_that("get_api_key - valid API key", {
  api_key <- get("api_key", envir = .state)
  assign("api_key", NULL, envir = .state)
  expect_null(get_api_key()$myownrobs)
  assign("api_key", api_key, envir = .state)
})
