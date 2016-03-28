
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

    msgs <- sapply(seq_along(msgs), function(i) errmsg(msgs[i], names[i]))

    stop(msgs)
  }
}

is_valid <- function(validator) {
  validate(validator$checks)
}
