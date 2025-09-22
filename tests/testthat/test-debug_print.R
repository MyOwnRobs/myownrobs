test_that("debug_print - prints DEBUG", {
  debug_value <- Sys.getenv("DEBUG")
  Sys.setenv(DEBUG = "TRUE")
  captured_msg <- capture.output(
    captured_output <- capture.output(debug_print("Test value")),
    type = "message"
  )
  expect_true(any(grepl("--- DEBUG", captured_msg)))
  expect_equal(captured_output, '[1] "Test value"')
  Sys.setenv(DEBUG = debug_value)
})

test_that("debug_print - doesn't print DEBUG", {
  debug_value <- Sys.getenv("DEBUG")
  Sys.unsetenv("DEBUG")
  captured_msg <- capture.output(
    captured_output <- capture.output(debug_print("Test value")),
    type = "message"
  )
  expect_equal(captured_msg, character())
  expect_equal(captured_output, character())
  Sys.setenv(DEBUG = debug_value)
})
