test_that("configure_provider - wrong provider", {
  expect_error(configure_provider("FAKE_PROVIDER"), "`name` must be one of ")
})

test_that("configure_provider - network issues", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    models_anthropic = function(...) stop("some error"),
    .package = "myownrobs"
  )
  expect_error(configure_provider("anthropic", "ANT_KEY"), "The provided `api_key` is not working.")
})

### anthropic

test_that("configure_provider - anthropic - add key", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    set_config = function(...) NULL,
    models_anthropic = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("anthropic", "ANT_KEY"), list(anthropic = "ANT_KEY"))
})

test_that("configure_provider - anthropic - add key to non-empty keys", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY"}',
    set_config = function(...) NULL,
    models_anthropic = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("anthropic", "ANT_KEY"),
    list(provider = "FAKE_KEY", anthropic = "ANT_KEY")
  )
})

test_that("configure_provider - anthropic - update key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","anthropic":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_anthropic = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("anthropic", "ANT_KEY"),
    list(provider = "FAKE_KEY", anthropic = "ANT_KEY")
  )
  expect_equal(
    configure_provider("anthropic", "ANT_KEY2"),
    list(provider = "FAKE_KEY", anthropic = "ANT_KEY2")
  )
})

test_that("configure_provider - anthropic - delete key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","anthropic":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_anthropic = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("anthropic", NULL), list(provider = "FAKE_KEY"))
})

test_that("configure_provider - anthropic - delete key to empty", {
  local_mocked_bindings(
    get_config = function(...) '{"anthropic":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_anthropic = function(...) NULL,
    .package = "myownrobs"
  )
  expect_length(configure_provider("anthropic", NULL), 0)
})

### google_gemini

test_that("configure_provider - google_gemini - add key", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    set_config = function(...) NULL,
    models_google_gemini = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("google_gemini", "GG_KEY"), list(google_gemini = "GG_KEY"))
})

test_that("configure_provider - google_gemini - add key to non-empty keys", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY"}',
    set_config = function(...) NULL,
    models_google_gemini = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("google_gemini", "GG_KEY"),
    list(provider = "FAKE_KEY", google_gemini = "GG_KEY")
  )
})

test_that("configure_provider - google_gemini - update key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","google_gemini":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_google_gemini = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("google_gemini", "GG_KEY"),
    list(provider = "FAKE_KEY", google_gemini = "GG_KEY")
  )
  expect_equal(
    configure_provider("google_gemini", "GG_KEY2"),
    list(provider = "FAKE_KEY", google_gemini = "GG_KEY2")
  )
})

test_that("configure_provider - google_gemini - delete key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","google_gemini":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_google_gemini = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("google_gemini", NULL), list(provider = "FAKE_KEY"))
})
