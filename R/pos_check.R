POS_CHECK <-
"# check for positivity
{{#vars}}
{{{name}}} >= 0
{{/vars}}
"

#' @export
#' @rdname suggest_pos_check
write_pos_check <- function(d, vars=names(d), only_positive=TRUE, file=stdout()){
  vars <- Filter(function(name){is.numeric(d[[name]])}, vars)
  vars <- lapply(vars, function(name){
    x <- d[[name]]
      if (only_positive && any(x < 0, na.rm=TRUE)){
        return(NULL)
      }
      return(list(name = name))
  })
  vars <- Filter(function(v){!is.null(v)}, vars)
  writeLines(
    whisker::whisker.render(POS_CHECK, data = list(vars=vars)),
    file
  )
  invisible(vars)
}

#' Suggest a range check
#'
#' @export
#' @inheritParams suggest_type_check
#' @param only_positive if `TRUE` only numerical values for positive values are included
#' @example example/range_check.R
#' @returns `suggest_pos_check` returns [validate::validator()] object with the suggested rules.
#' `write_pos_check` write the rules to file and returns invisibly a named list of checks for each variable.
suggest_pos_check <- function(d, vars = names(d), only_positive=TRUE){
  tf <- tempfile()
  vars <- write_pos_check(d, vars, file = tf, only_positive = only_positive)
  if (length(vars) == 0){
    return(validate::validator())
  }

  rules <- validate::validator(.file = tf)
  validate::description(rules) <-
    sprintf("positivity check")
  validate::origin(rules) <-
    sprintf("validatesuggest %s"
            , packageVersion("validatesuggest")
    )
  names(rules) <- paste0("PC", seq_len(length(rules)))
  rules
}
