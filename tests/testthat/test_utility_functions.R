context("Utility functions")

test_that("errmsg correctly interpolates strings", {
  expect_equal(errmsg("Hello, $$1", "World"), "Hello, World")
  expect_equal(errmsg("Hello, my $$1 $$1 $$2", "cruel", "World"), "Hello, my cruel cruel World")
})
