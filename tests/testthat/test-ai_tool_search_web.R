test_that("search_web - regular search", {
  skip_if_offline("duckduckgo.com")
  expect_true(nchar(search_web("MyOwnRobs")$output) > 0)
})
