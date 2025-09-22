test_that("execute_llm_tools - empty tools", {
  tools <- list()
  mode <- "agent"
  result <- execute_llm_tools(tools, mode)
  expect_equal(result, list(ai = list(tools = list()), ui = list()))
})

test_that("execute_llm_tools - empty tools", {
  tools <- list(list(name = "RunRCommand"))
  mode <- "ask"
  expect_error(execute_llm_tools(tools, mode), "AI trying to perform edits on Ask mode.")
})

test_that("execute_llm_tools - run 1 tool", {
  tools <- list(list(name = "RunRCommand", args = list(command = "print('hey!')")))
  mode <- "agent"
  result <- execute_llm_tools(tools, mode)
  expected <- tools
  expected[[1]]$output$output <- '[1] "hey!"'
  expect_equal(
    result,
    list(ai = list(tools = expected), ui = list("Ran the R command: `print('hey!')`"))
  )
})

test_that("execute_llm_tools - run 2 tools", {
  tools <- list(
    list(name = "RunRCommand", args = list(command = "print('hey!')")),
    list(name = "RunRCommand", args = list(command = "print('second command!')"))
  )
  mode <- "agent"
  result <- execute_llm_tools(tools, mode)
  expected <- tools
  expected[[1]]$output$output <- '[1] "hey!"'
  expected[[2]]$output$output <- '[1] "second command!"'
  expect_equal(
    result,
    list(
      ai = list(tools = expected),
      ui = list(
        "Ran the R command: `print('hey!')`",
        "Ran the R command: `print('second command!')`"
      )
    )
  )
})
