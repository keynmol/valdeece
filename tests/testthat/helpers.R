expect_invalid <- function(validator){
  expect_error(is_valid(validator))
}

expect_valid <- function(validator){
  expect_silent(is_valid(validator))
}
