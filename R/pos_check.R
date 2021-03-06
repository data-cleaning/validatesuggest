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
}

#' Suggest a range check
#'
#' @export
#' @inheritParams suggest_type_check
#' @param only_positive if `TRUE` only numerical values for positive values are included
#' @example example/range_check.R
suggest_pos_check <- function(d, vars = names(d), only_positive=TRUE){
  tf <- tempfile()
  write_pos_check(d, vars, file = tf, only_positive = only_positive)
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
