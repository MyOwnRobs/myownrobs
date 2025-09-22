test_that("run_r_command - invalid args", {
  expect_error(run_r_command(list()), "Invalid arguments for RunRCommand")
})

test_that("run_r_command", {
  expect_equal(
    run_r_command(list(command = "print('hey!')")),
    list(output = '[1] "hey!"')
  )
})
