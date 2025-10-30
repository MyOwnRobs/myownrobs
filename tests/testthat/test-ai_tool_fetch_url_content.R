test_that("fetch_url_content - invalid url", {
  expect_error(
    fetch_url_content("ftp://ftp.MOCK_URL.com"), "Only http/https URLs are supported"
  )
})

test_that("fetch_url_content - valid url", {
  skip_if_offline("github.com")
  url_content <- fetch_url_content("https://github.com/MyOwnRobs/myownrobs")
  expect_true(grepl("MyOwnRobs", url_content$output))
})

test_that("fetch_url_content - truncated url", {
  skip_if_offline("wikipedia.org")
  url_content <- fetch_url_content(
    "https://es.wikipedia.org/wiki/Instituto_Atl%C3%A9tico_Central_C%C3%B3rdoba"
  )
  expect_true(grepl("...[truncated]...", url_content$output))
})
