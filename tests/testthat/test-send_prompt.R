test_that("send_prompt - regular usage", {
  local_mocked_bindings(
    req_perform = function(...) NULL,
    resp_body_string = function(...) "Executed",
    .package = "myownrobs"
  )
  result <- send_prompt(
    "chat_id", "prompt", "role", "mode", "model", list(context = "CONTEXT"),
    "https://MOCK_URL.com", "api_key"
  )
  expect_equal(result, "Executed")
})

test_that("send_prompt_async - regular usage", {
  local_mocked_bindings(
    req_perform = function(...) NULL,
    resp_body_string = function(...) "Executed",
    mirai = function(expr, ...) {
      eval(expr, envir = list(...))
    },
    .package = "myownrobs"
  )
  result <- send_prompt_async(
    "chat_id", "prompt", "role", "mode", "model", list(context = "CONTEXT"),
    "https://MOCK_URL.com", "api_key"
  )
  expect_equal(result, "Executed")
})
