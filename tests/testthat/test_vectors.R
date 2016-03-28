context("Vectors validation")

test_that("is_string_vector validates a vector of strings", {
  expect_invalid(is_string_vector(1:5))
  expect_invalid(is_string_vector(c(F, F, T)))

  expect_invalid(is_string_vector(list("a", "b", "c")))

  expect_valid(is_string_vector(c("a", "b", "c")))
})


test_that("is_int_vector validates a vector of ints", {
  expect_invalid(is_int_vector(c("a", "b", "c")))
  expect_invalid(is_int_vector(c(F, F, T)))
  expect_invalid(is_int_vector(list(1, 2, 3)))

  expect_valid(is_int_vector(1:5))
  expect_invalid(is_int_vector(c(1,2,3,4,5))) # R's fantastic quirk. It's actually a numeric vector
})

test_that("is_numeric_vector validates a vector of ints", {
  expect_invalid(is_numeric_vector(c("a", "b", "c")))
  expect_invalid(is_numeric_vector(c(F, F, T)))
  expect_invalid(is_numeric_vector(list(1, 2, 3)))

  expect_valid(is_numeric_vector(1:5))
  expect_valid(is_numeric_vector(c(0.5, 0.3)))
  expect_valid(is_numeric_vector(c(1,2,3,4,5))) # R's fantastic quirk. It's actually a numeric vector
})


test_that("is_logical_vector validates a vector of logicals", {
  expect_invalid(is_logical_vector(c("a", "b", "c")))
  expect_invalid(is_logical_vector(1:5))

  expect_invalid(is_logical_vector(list(F, T, T)))

  expect_valid(is_logical_vector(c(F, F, T)))
})

test_that("is_factor validates a factor", {
  expect_invalid(is_factor(c("a", "b", "c")))
  expect_invalid(is_factor(1:5))

  expect_invalid(is_factor(list(F, T, T)))

  f <- factor(1:2, levels = c(1, 2))

  expect_valid(is_factor(f))
  expect_valid(is_factor(f, with_levels=c(1,2)))
  expect_invalid(is_factor(f, with_levels=c(1,2, 3)))
})
