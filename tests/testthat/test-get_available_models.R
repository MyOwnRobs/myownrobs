### get_available_models

test_that("get_available_models - myownrobs", {
  available_models <- list(provider_mock = list(Model_A = "model_a", Model_B = "model_b"))
  local_mocked_bindings(
    get_api_key = function(...) list(myownrobs = "api_key"),
    get_myownrobs_models = function(...) available_models,
    .package = "myownrobs"
  )
  expect_equal(get_available_models("https://MOCK_URL.com"), list(
    `Provider Mock` = list(Model_A = "model_a", Model_B = "model_b")
  ))
})

test_that("get_available_models - myownrobs no models", {
  local_mocked_bindings(
    get_api_key = function(...) list(myownrobs = "api_key"),
    get_myownrobs_models = function(...) list(),
    .package = "myownrobs"
  )
  expect_length(get_available_models("https://MOCK_URL.com"), 0)
})

test_that("get_available_models - api_keys", {
  local_mocked_bindings(
    get_api_key = function(...) {
      list(
        myownrobs = "api_key", provider_a = "key_a", provider_b = "key_b"
      )
    },
    get_ellmer_models = function(provider, api_key) {
      if (provider == "provider_a") {
        list(Model_A = "model_a")
      } else if (provider == "provider_b") {
        list(Model_B = "model_b", Model_C = "model_c")
      }
    },
    .package = "myownrobs"
  )
  expect_equal(get_available_models(), list(
    `Provider a` = list(Model_A = "model_a"),
    `Provider b` = list(Model_B = "model_b", Model_C = "model_c")
  ))
})

test_that("get_available_models - api_keys no models", {
  local_mocked_bindings(
    get_api_key = function(...) {
      list(
        myownrobs = "api_key", provider_a = "key_a", provider_b = "key_b"
      )
    },
    get_ellmer_models = function(provider, api_key) list(),
    .package = "myownrobs"
  )
  expect_equal(get_available_models(), list(`Provider a` = list(), `Provider b` = list()))
})

### get_myownrobs_models

test_that("get_myownrobs_models - network issue", {
  local_mocked_bindings(
    get_api_key = function(...) list(myownrobs = "API_KEY"),
    req_perform = function(...) NULL,
    resp_status = function(...) 500,
    .package = "myownrobs"
  )
  expect_error(
    get_myownrobs_models("https://MOCK_URL.com"),
    "Models listing failed with status: 500"
  )
})

test_that("get_available_models returns one model", {
  available_models <- list("Model A" = "model-a")
  local_mocked_bindings(
    get_api_key = function(...) list(myownrobs = "API_KEY"),
    req_perform = function(...) NULL,
    resp_status = function(...) 200,
    resp_body_json = function(...) available_models,
    .package = "myownrobs"
  )
  expect_equal(get_myownrobs_models("https://MOCK_URL.com"), available_models)
})

test_that("get_available_models returns multiple models", {
  available_models <- list("Model A" = "model-a", "Model B" = "model-b", "Model C" = "model-c")
  local_mocked_bindings(
    get_api_key = function(...) list(myownrobs = "API_KEY"),
    req_perform = function(...) NULL,
    resp_status = function(...) 200,
    resp_body_json = function(...) available_models,
    .package = "myownrobs"
  )
  expect_equal(get_myownrobs_models("https://MOCK_URL.com"), available_models)
})

### get_ellmer_models

test_that("get_ellmer_models - anthropic", {
  available_models <- list("Model A" = "model-a", "Model A" = "model-b", "Model C" = "model-c")
  local_mocked_bindings(
    models_anthropic = function(...) {
      data.frame(
        id = unlist(available_models), name = names(available_models)
      )
    },
    .package = "myownrobs"
  )
  expect_equal(get_ellmer_models("anthropic"), unlist(available_models))
})

test_that("get_ellmer_models - google_gemini", {
  available_models <- list("Model a" = "model-a", "Model b" = "model-b", "Model c" = "model-c")
  local_mocked_bindings(
    models_google_gemini = function(...) data.frame(id = unlist(available_models)),
    .package = "myownrobs"
  )
  expect_equal(get_ellmer_models("google_gemini"), unlist(available_models))
})
