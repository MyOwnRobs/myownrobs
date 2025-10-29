test_that("run_r_command", {
  expect_equal(
    run_r_command("print('hey!')"),
    list(output = '[1] "hey!"')
  )
})
