test_that("fetch_url_content - invalid args", {
  expect_error(fetch_url_content(list()), "Invalid arguments for FetchUrlContent")
})

test_that("fetch_url_content - invalid url", {
  expect_error(
    fetch_url_content(list(url = "ftp://ftp.MOCK_URL.com")), "Only http/https URLs are supported"
  )
})

test_that("fetch_url_content - valid url", {
  skip_if_offline("github.com")
  url_content <- fetch_url_content(list(url = "https://github.com/MyOwnRobs/myownrobs"))
  expect_true(grepl("MyOwnRobs", url_content$output))
})
