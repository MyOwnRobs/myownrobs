test_that("send_prompt - regular usage", {
  local_mocked_bindings(
    get_chat_instance = function(...) {
      list(
        chat = function(prompt) NULL,
        get_turns = function() "Executed"
      )
    },
    save_turns = function(turns) NULL,
    .package = "myownrobs"
  )
  result <- send_prompt(
    "prompt", "mode", "model", list(context = "CONTEXT"), list(provider = "api_key"),
    list(provider = "model")
  )
  expect_equal(result, "Executed")
})

test_that("send_prompt_async - regular usage", {
  local_mocked_bindings(
    get_chat_instance = function(...) {
      list(
        chat = function(prompt) NULL,
        get_turns = function() "Executed"
      )
    },
    save_turns = function(turns) NULL,
    mirai = function(expr, ...) {
      eval(expr, envir = list(...))
    },
    .package = "myownrobs"
  )
  result <- send_prompt_async(
    "prompt", "mode", "model", list(context = "CONTEXT"), list(provider = "api_key"),
    list(provider = "model")
  )
  expect_equal(result, "Executed")
})
