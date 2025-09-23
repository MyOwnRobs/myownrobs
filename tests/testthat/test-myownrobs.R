test_that("myownrobs - mock execution", {
  local_mocked_bindings(
    validate_policy_acceptance = function(...) TRUE,
    validate_credentials = function(...) NULL,
    runGadget = function(...) NULL,
    .package = "myownrobs"
  )
  expect_null(myownrobs())
})

test_that("myownrobs - mock execution", {
  local_mocked_bindings(
    validate_policy_acceptance = function(...) FALSE,
    .package = "myownrobs"
  )
  expect_equal(myownrobs(), "Accept MyOwnRobs terms of use in order to run it")
})
