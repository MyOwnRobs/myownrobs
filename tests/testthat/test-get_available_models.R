test_that("get_available_models returns default when config is null", {
  # local_mocked_bindings(
  #   get_config = function(config) {
  #     NULL
  #   },
  #   .package = "myownrobs"
  # )
  # result <- get_available_models()
  # expect_equal(result, list(Gemini = list("Gemini 2.5 Flash" = "gemini-2.5-flash")))
})

test_that("get_available_models returns one model", {
  # local_mocked_bindings(
  #   get_config = function(config) {
  #     if (config == "api_keys") NULL else if (config == "available_models") '{"Model A": "model-a"}'
  #   },
  #   .package = "myownrobs"
  # )
  # result <- get_available_models()
  # expect_equal(result, list("Model A" = "model-a"))
})

test_that("get_available_models returns multiple models", {
  # local_mocked_bindings(
  #   get_config = function(config) {
  #     if (config == "api_keys") {
  #       NULL
  #     } else if (config == "available_models") {
  #       '{"Model A": "model-a", "Model B": "model-b", "Model C": "model-c"}'
  #     }
  #   },
  #   .package = "myownrobs"
  # )
  # result <- get_available_models()
  # expect_equal(result, list("Model A" = "model-a", "Model B" = "model-b", "Model C" = "model-c"))
})
