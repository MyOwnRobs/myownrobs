test_that("parse_agent_response - incorrect reply", {
  mock_response <- "How can I help you today?"
  expect_warning(parsed_response <- parse_agent_response(mock_response))
  expected <- list(
    error = "Invalid JSON response from AI model", error_code = "invalid_ai_response"
  )
  expect_equal(parsed_response, expected)
})

test_that("parse_agent_response - correct reply with markdown", {
  mock_response <- "```json[]```"
  parsed_response <- parse_agent_response(mock_response)
  expected <- list()
  expect_equal(parsed_response, expected)
})

test_that("parse_agent_response - correct reply with no markdown", {
  mock_response <- "[]"
  parsed_response <- parse_agent_response(mock_response)
  expected <- list()
  expect_equal(parsed_response, expected)
})
