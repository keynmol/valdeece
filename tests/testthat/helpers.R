expect_invalid <- function(validator){
  expect_error(is_valid(validator), regexp="Valdeece failed to validate your input:\n")
}

expect_valid <- function(validator){
  expect_silent(is_valid(validator))
}
