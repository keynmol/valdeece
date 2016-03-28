context("Data frames validation")

test_that("is_data_frame validates a data frame", {
  expect_invalid(is_data_frame(5))
  expect_invalid(is_data_frame(list(a=1)))
  expect_invalid(is_data_frame("hello"))

  expect_valid(is_data_frame(data.frame(A=1)))
  expect_invalid(is_data_frame(data.frame(A=c()), non_empty=T))
  expect_valid(is_data_frame(data.frame(A=c()), non_empty=F))
})

test_that("is_data_frame validates columns of a data frame", {
  df <- data.frame(X=1, Y="hello", Z = T, stringsAsFactors = F)
  expect_valid(is_data_frame(df, X=numeric_vector))
  expect_valid(is_data_frame(df, X=numeric_vector, Z=logical_vector))
  expect_valid(is_data_frame(df, X=numeric_vector, Y = string_vector,  Z=logical_vector))
})
