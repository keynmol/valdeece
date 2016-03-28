#' @export
is_data_frame <-
  function(prev_validator,
           value = NULL,
           non_empty = F,
           ...) {

    xx <- validator_and_value(prev_validator,
                          value,
                          deparse(substitute(prev_validator)),
                          deparse(substitute(value)))

    validator <- create_validator(xx$value,
                                  xx$value_name,
                                  function(value)
                                    is.data.frame(value) & (!non_empty | nrow(value) > 0),
                                  "Expected $$1 to be a data frame")

    base_validator <- combine_validators(xx$prev_validator, validator)

    column_validators <- list(...)

    if (length(column_validators) > 0) {
      col_validators <-
        do.call(combine_validators, lapply(names(column_validators),
                                           function(column) {
                                             do.call(column_validators[[column]], list(xx$value[[column]]))
                                           }))

      col_validators$checks$Names <-
        paste(xx$value_name, names(column_validators), sep = "$")

      do.call(combine_validators, list(base_validator, col_validators))
    } else {
      base_validator
    }
  }
