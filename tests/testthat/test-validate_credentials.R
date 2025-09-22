### validate_credentials

test_that("validate_credentials - valid credentials", {
  local_mocked_bindings(
    get_api_key = function() {
      "VALID_API_KEY"
    },
    .package = "myownrobs"
  )
  result <- validate_credentials("https://MOCK_URL.com")
  expect_null(result)
})

test_that("validate_credentials - validating credentials error", {
  local_mocked_bindings(
    get_api_key = function() {
      ""
    },
    token_fetch = function(...) {
      list(credentials = list(access_token = "ACCESS_TOKEN"))
    },
    req_perform = function(...) {
      NULL
    },
    resp_status = function(...) {
      401
    },
    .package = "myownrobs"
  )
  expect_error(
    validate_credentials("https://MOCK_URL.com"), "Authentication failed with status: 401"
  )
})

test_that("validate_credentials - validating credentials empty key", {
  local_mocked_bindings(
    get_api_key = function() {
      ""
    },
    token_fetch = function(...) {
      list(credentials = list(access_token = "ACCESS_TOKEN"))
    },
    req_perform = function(...) {
      NULL
    },
    resp_status = function(...) {
      200
    },
    resp_body_json = function(...) {
      NULL
    },
    .package = "myownrobs"
  )
  expect_error(
    validate_credentials("https://MOCK_URL.com"), "No valid API key received from server"
  )
})

test_that("validate_credentials - validating credentials empty key", {
  local_mocked_bindings(
    get_api_key = function() {
      ""
    },
    token_fetch = function(...) {
      list(credentials = list(access_token = "ACCESS_TOKEN"))
    },
    req_perform = function(...) {
      NULL
    },
    resp_status = function(...) {
      200
    },
    resp_body_json = function(...) {
      list(api_key = "")
    },
    .package = "myownrobs"
  )
  expect_error(
    validate_credentials("https://MOCK_URL.com"), "No valid API key received from server"
  )
})

test_that("validate_credentials - validating credentials", {
  local_mocked_bindings(
    get_api_key = function() {
      ""
    },
    token_fetch = function(...) {
      list(credentials = list(access_token = "ACCESS_TOKEN"))
    },
    req_perform = function(...) {
      NULL
    },
    resp_status = function(...) {
      200
    },
    resp_body_json = function(...) {
      list(api_key = "VALID_API_KEY")
    },
    save_api_key = function(...) {
      NULL
    },
    .package = "myownrobs"
  )
  expect_null(validate_credentials("https://MOCK_URL.com"))
})

### save_api_key

test_that("save_api_key - save api key", {
  home_dir <- Sys.getenv("HOME")
  mock_config_dir <- tempfile("test", fileext = "/")
  dir.create(mock_config_dir, recursive = TRUE)
  Sys.setenv(HOME = mock_config_dir)
  # Test that it is written only once to the Renviron.
  suppressMessages(save_api_key("VALID_API_KEY"))
  suppressMessages(save_api_key("VALID_API_KEY"))
  suppressMessages(save_api_key("VALID_API_KEY"))
  Sys.setenv(HOME = home_dir)
  result <- readLines(paste0(mock_config_dir, ".Renviron"))
  expect_equal(result, "MYOWNROBS_API_KEY=VALID_API_KEY")
})
