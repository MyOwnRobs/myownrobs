test_that("validate_command_args - valid args", {
  command <- list(parameters = list(list(name = "param_1"), list(name = "param_2")))
  args <- list(param_1 = "value_1", param_2 = "value_2")
  expect_true(validate_command_args(command, args))
})

test_that("validate_command_args - extra (unused) args", {
  command <- list(parameters = list(list(name = "param_1"), list(name = "param_2")))
  args <- list(param_1 = "value_1", param_2 = "value_2", param_3 = "value_3")
  expect_true(validate_command_args(command, args))
})

test_that("validate_command_args - missing args", {
  command <- list(parameters = list(list(name = "param_1"), list(name = "param_2")))
  args <- list(param_1 = "value_1")
  expect_false(validate_command_args(command, args))
})
