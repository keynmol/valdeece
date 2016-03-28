
is_vector <- function(value){
  is.vector(value, mode="any") & !is.vector(value, mode="list")
}

is_list <- function(value){
  is.vector(value, mode="list")
}

is_null <- function(value){
  is.null(value)
}

errmsg <- function(msg, ...){
  args <- list(...)
  reducer <- function(msg, idx) gsub(paste0("\\$\\$", idx), args[idx], msg)

  Reduce(reducer, seq_along(args), msg)
}

validate <- function(checks) {
  results <- checks$Results
  errors <- checks$Errors
  names <- checks$Names


  if(!all(results)) {
    msgs <- errors[!results]
    names <- names[!results]

    msgs <- paste(sapply(seq_along(msgs), function(i) paste("    ", errmsg(msgs[i], names[i]))), collapse="\n")

    stop(paste("Valdeece failed to validate your input:\n", msgs, sep=""))
  }
}

#' @export
is_valid <- function(validator) {
  validate(validator$checks)
}

create_validator <- function(value, value_name, validator_func, msg, additional_args=list(), ...){
  additional <- c(msg, value_name, additional_args)

  checks <- data.frame(Names = value_name,
                       Results = validator_func(value),
                       Errors = msg, stringsAsFactors = F)

  from_checks(checks)
}
