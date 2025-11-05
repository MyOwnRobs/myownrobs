test_that("get_api_key - valid API key", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    .package = "myownrobs"
  )
  api_key <- get("api_key", envir = .state)
  assign("api_key", "SOME_API_KEY", envir = .state)
  expect_equal(get_api_key()$myownrobs, "SOME_API_KEY")
  assign("api_key", api_key, envir = .state)
})

test_that("get_api_key - empty API key", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    .package = "myownrobs"
  )
  api_key <- get("api_key", envir = .state)
  assign("api_key", NULL, envir = .state)
  expect_null(get_api_key()$myownrobs)
  assign("api_key", api_key, envir = .state)
})

test_that("get_api_key - valid API keys", {
  local_mocked_bindings(
    get_config = function(...) '{"provider_a":"key_a", "provider_b":"key_b"}',
    .package = "myownrobs"
  )
  api_key <- get("api_key", envir = .state)
  assign("api_key", "SOME_API_KEY", envir = .state)
  expect_equal(
    get_api_key(), list(provider_a = "key_a", provider_b = "key_b", myownrobs = "SOME_API_KEY")
  )
  assign("api_key", api_key, envir = .state)
})

test_that("get_api_key - empty API key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider_a":"key_a", "provider_b":"key_b"}',
    .package = "myownrobs"
  )
  api_key <- get("api_key", envir = .state)
  assign("api_key", NULL, envir = .state)
  expect_equal(get_api_key(), list(provider_a = "key_a", provider_b = "key_b"))
  assign("api_key", api_key, envir = .state)
})
