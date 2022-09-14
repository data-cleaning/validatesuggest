NA_CHECK <-
"# check the type of variables
{{#vars}}
is.complete({{{name}}})
{{/vars}}
"

#' @export
#' @rdname suggest_na_check
write_na_check <- function(d, vars=names(d), file=stdout()){
  # only columns that are complete in d or use a fraction?
  vars <- Filter(function(name){
    !anyNA(d[[name]])
  }, vars)

  vars <- lapply(vars, function(name){
    x <- d[[name]]
    list(name = name, type = class(x)[1])
  })
  writeLines(
    whisker::whisker.render(NA_CHECK, data = list(vars=vars)),
    file
  )
  invisible(vars)
}

#' Suggest a check for completeness.
#'
#' Suggest a check for completeness.
#' @export
#' @example example/na_check.R
#' @inheritParams suggest_type_check
suggest_na_check <- function(d, vars = names(d)){
  tf <- tempfile()
  vars <- write_na_check(d, vars = vars, file = tf)
  if (length(vars) == 0){
    return(validate::validator())
  }

  rules <- validate::validator(.file=tf)
  validate::description(rules) <-
    sprintf("type check")
  validate::origin(rules) <-
    sprintf("validatesuggest %s"
            , packageVersion("validatesuggest")
    )
  names(rules) <- paste0("NA", seq_len(length(rules)))
  rules
}


