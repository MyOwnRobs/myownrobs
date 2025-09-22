test_that("validate_policy_acceptance - never accepted policy", {
  local_mocked_bindings(
    get_config = function(config) {
      NULL
    },
    runGadget = function(...) TRUE,
    .package = "myownrobs"
  )
  result <- validate_policy_acceptance()
  expect_true(result)
})

test_that("validate_policy_acceptance - accepted outdated policy", {
  local_mocked_bindings(
    get_config = function(config) {
      0
    },
    runGadget = function(...) TRUE,
    .package = "myownrobs"
  )
  result <- validate_policy_acceptance()
  expect_true(result)
})

test_that("validate_policy_acceptance - accepted policy", {
  local_mocked_bindings(
    get_config = function(config) {
      Inf
    },
    .package = "myownrobs"
  )
  result <- validate_policy_acceptance()
  expect_true(result)
})
