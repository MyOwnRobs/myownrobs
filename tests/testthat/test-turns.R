### load_turns

test_that("load_turns - no turns file", {
  local_mocked_bindings(
    file_exists = function(...) FALSE,
    .package = "myownrobs"
  )
  expect_equal(load_turns(), list())
})

test_that("load_turns - regular run", {
  turns <- list(ellmer::Turn("user", "Hi!"), ellmer::Turn("assistant", "How can I help you?"))
  local_mocked_bindings(
    file_exists = function(...) TRUE,
    .package = "myownrobs"
  )
  local_mocked_bindings(
    readRDS = function(...) turns,
    .package = "base"
  )
  expect_equal(load_turns(), turns)
})

### save_turns

test_that("save_turns - regular run", {
  turns <- list(ellmer::Turn("user", "Hi!"), ellmer::Turn("assistant", "How can I help you?"))
  local_mocked_bindings(
    dir_exists = function(...) FALSE,
    dir_create = function(...) NULL,
    .package = "myownrobs"
  )
  local_mocked_bindings(
    saveRDS = function(...) NULL,
    .package = "base"
  )
  expect_equal(save_turns(turns), turns)
})

### turns_to_ui

test_that("turns_to_ui - empty", {
  turns <- list()
  expect_equal(turns_to_ui(turns), turns)
})

test_that("turns_to_ui - two turns", {
  turns_list <- list(
    list(role = "user", text = "Hi!"), list(role = "assistant", text = "How can I help you?")
  )
  turns <- lapply(turns_list, function(x) ellmer::Turn(x$role, x$text))
  expect_equal(turns_to_ui(turns), rev(turns_list))
})

test_that("turns_to_ui - three turns, one tool_runner", {
  turns_list <- list(
    list(role = "user", text = "Hi!"),
    list(role = "tool_runner", text = "run_some_tool"),
    list(role = "assistant", text = "How can I help you?")
  )
  turns <- lapply(turns_list, function(x) ellmer::Turn(x$role, x$text))
  expect_equal(turns_to_ui(turns), rev(turns_list))
})

test_that("turns_to_ui - three turns, one empty text", {
  turns_list <- list(
    list(role = "user", text = "Hi!"),
    list(role = "tool_runner", text = list()),
    list(role = "assistant", text = "How can I help you?")
  )
  turns <- lapply(turns_list, function(x) ellmer::Turn(x$role, x$text))
  expect_equal(turns_to_ui(turns), rev(turns_list[-2]))
})

test_that("turns_to_ui - two turns, one multiple text", {
  turns_list <- list(
    list(role = "user", text = c("I am ", "an R dev!")),
    list(role = "assistant", text = "How can I help you?")
  )
  turns <- lapply(turns_list, function(x) ellmer::Turn(x$role, lapply(x$text, ellmer::ContentText)))
  expect_equal(turns_to_ui(turns), rev(turns_list))
})

### get_turn_role

test_that("get_turn_role - regular roles", {
  expect_equal(get_turn_role(ellmer::Turn("user")), "user")
  expect_equal(get_turn_role(ellmer::Turn("tool_runner")), "tool_runner")
  expect_equal(get_turn_role(ellmer::Turn("assistant")), "assistant")
})

test_that("get_turn_role - tool_runner", {
  turn <- ellmer::Turn(
    "user", list(ellmer::ContentText("Hi!"), ellmer::ContentToolRequest("id", "name"))
  )
  expect_equal(get_turn_role(turn), "tool_runner")
})

### content_to_ui

test_that("content_to_ui - ContentText", {
  expect_equal(content_to_ui(ellmer::ContentText("Hi!")), "Hi!")
})

test_that("content_to_ui - ContentToolResult", {
  expect_null(content_to_ui(ellmer::ContentToolResult("result")))
})

test_that("content_to_ui - ContentToolRequest no args", {
  expect_equal(content_to_ui(ellmer::ContentToolRequest("id", "name")), "name()")
})

test_that("content_to_ui - ContentToolRequest one arg", {
  expect_equal(
    content_to_ui(ellmer::ContentToolRequest("id", "name", list(arg = "value"))),
    'name(arg = "value")'
  )
  expect_equal(
    content_to_ui(ellmer::ContentToolRequest("id", "name", list(arg = 420))),
    'name(arg = "420")'
  )
})

test_that("content_to_ui - ContentToolRequest multiple args", {
  expect_equal(
    content_to_ui(ellmer::ContentToolRequest(
      "id", "name", list(arg_1 = "value_1", arg_2 = 420, arg_3 = "value_3", arg_4 = FALSE)
    )),
    'name(arg_1 = "value_1", arg_2 = "420", arg_3 = "value_3", arg_4 = "FALSE")'
  )
})

test_that("content_to_ui - ContentToolRequest long result", {
  expect_equal(
    content_to_ui(ellmer::ContentToolRequest(
      "id",
      paste0("name", paste0(rep(0:9, 10), collapse = ""))
    )),
    paste0("name", paste0(rep(0:9, 10)[1:93], collapse = ""), "...")
  )
})

test_that("content_to_ui - ContentToolRequest long result with args", {
  expect_equal(
    content_to_ui(ellmer::ContentToolRequest(
      "id", "name",
      list(arg_1 = paste0(rep(0:9, 5), collapse = ""), arg_2 = paste0(rep(0:9, 5), collapse = ""))
    )),
    paste0(
      'name(arg_1 = "01234567890123456789012345678901234567890123456789", arg_2 = "',
      paste0(rep(0:9, 5)[1:21], collapse = ""), "...",
      collapse = ""
    )
  )
})
