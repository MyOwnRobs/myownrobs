test_that("search_web - invalid args", {
  expect_error(search_web(list()), "Invalid arguments for SearchWeb")
})

test_that("search_web - regular search", {
  skip_if_offline("duckduckgo.com")
  expect_true(nchar(search_web(list(query = "MyOwnRobs"))$output) > 0)
})
