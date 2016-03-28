create_validator <- function(value, value_name, validator_func, msg, additional_args=list(), ...){
  additional <- c(msg, value_name, additional_args)

  checks <- data.frame(Names = value_name,
                       Results = validator_func(value),
                       Errors = msg, stringsAsFactors = F)

  from_checks(checks)
}

from_checks <- function(checks) {
  validator <- list(checks = checks)
  class(validator) <- "validator"

  validator
}

vector_class_validator <- function(value, cls, non_empty=F) {
  ((!non_empty & is_null(value)) | (is_vector(value) &
                                      (length(value) == 0 |
                                        class(value) == cls) |
                                       (class(value) == "integer" & cls == "numeric")
                                    ))
}

is_validator <- function(value) {
  ("validator" %in% class(value)) && is.list(value) && !is.null(value$checks)
}

combine_validators <- function(...) {
  from_checks(do.call(rbind, lapply(list(...), function(c) c$checks)))
}

empty_validator <- function(){
  from_checks(data.frame(Names = c(), Results=c(), Errors=c()))
}


validator_and_value <- function(prev_validator, value, validator_str, value_str) {

  if(!is_validator(prev_validator)){
    value <- prev_validator
    prev_validator <- empty_validator()
    value_name <- validator_str
  } else {
    stopifnot(!is.null(value))
    value_name <- value_str
  }

  list(prev_validator=prev_validator, value=value, value_name=value_name)
}


#' @export
is_string_vector <- function(prev_validator, value = NULL, non_empty=F, ...) {
  xx <- validator_and_value(prev_validator, value, deparse(substitute(prev_validator)), deparse(substitute(value)))

  validator <- create_validator(xx$value,
                                xx$value_name,
                                function(value) vector_class_validator(value, "character", non_empty),
                                "Expected $$1 to be a vector of strings")

  combine_validators(xx$prev_validator, validator)
}

#' @export
is_logical_vector <- function(prev_validator, value = NULL, non_empty=F, ...) {
  xx <- validator_and_value(prev_validator, value, deparse(substitute(prev_validator)), deparse(substitute(value)))

  validator <- create_validator(xx$value,
                                xx$value_name,
                                function(value) vector_class_validator(value, "logical", non_empty),
                                "Expected $$1 to be a vector of logicals")

  combine_validators(xx$prev_validator, validator)
}

#' @export
is_int_vector <- function(prev_validator, value = NULL, non_empty=F, ...) {
  xx <- validator_and_value(prev_validator, value, deparse(substitute(prev_validator)), deparse(substitute(value)))

  validator <- create_validator(xx$value,
                                xx$value_name,
                                function(value) vector_class_validator(value, "integer", non_empty),
                                "Expected $$1 to be a vector of integers")

  combine_validators(xx$prev_validator, validator)
}

#' @export
is_numeric_vector <- function(prev_validator, value = NULL, non_empty=F, ...) {
  xx <- validator_and_value(prev_validator, value, deparse(substitute(prev_validator)), deparse(substitute(value)))

  validator <- create_validator(xx$value,
                                xx$value_name,
                                function(value) vector_class_validator(value, "numeric", non_empty),
                                "Expected $$1 to be a vector of numeric")

  combine_validators(xx$prev_validator, validator)
}

#' @export
is_factor <- function(prev_validator, value = NULL, with_levels=NULL, ...) {
  xx <- validator_and_value(prev_validator, value, deparse(substitute(prev_validator)), deparse(substitute(value)))

  levels_msg <- ""
  if(!is.null(with_levels)) {
    levels_msg <- paste(" with levels {", paste(with_levels, collapse=","), "}", sep="")
  }

  validator <- create_validator(xx$value,
                                xx$value_name,
                                function(value) is.factor(value) & (is.null(with_levels)|
                                                                      setequal(levels(value), with_levels)),
                                paste("Expected $$1 to be a factor", levels_msg, sep=""))

  combine_validators(xx$prev_validator, validator)
}
#' @export
numeric_vector <- is_numeric_vector

#' @export
logical_vector <- is_logical_vector

#' @export
int_vector <- is_int_vector

#' @export
string_vector <- is_string_vector
