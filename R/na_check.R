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
  whisker::whisker.render(NA_CHECK, data = list(vars=vars)) |>
    writeLines(file)
}

#' Suggest an check for completeness.
#'
#' Suggest an check for completeness.
#' @export
#' @inheritParams suggest_type_check
suggest_na_check <- function(d, vars = names(d)){
  tf <- tempfile()
  write_na_check(d, vars = vars, file = tf)

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


