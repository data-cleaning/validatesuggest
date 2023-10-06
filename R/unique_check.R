UNIQUE_CHECK <-
"# check if these columns are unique
{{#vars}}
all_unique({{{name}}})
{{/vars}}
"

#' Suggest range checks
#' @export
#' @rdname suggest_unique_check
write_unique_check <- function(d, vars=names(d), file=stdout(), fraction=0.95){

  vars <- lapply(vars, function(name){
    x <- d[[name]]
    if (is.character(x) || is.factor(x)){ #|| is.integer(x)){
      u <- unique(x)
      if (length(u)/length(x) >= fraction){
        list(name=name)
      }
    }
  })
  vars <- Filter(function(v){!is.null(v)}, vars)
  writeLines(
    whisker::whisker.render(UNIQUE_CHECK, data = list(vars=vars)),
    file
  )
  invisible(vars)
}

#' @export
#' @inheritParams suggest_type_check
#' @param fraction if values in a column > `fraction` unique,
#' the check will be generated.
#' @returns `suggest_unique_check` returns [validate::validator()] object with the suggested rules.
#' `write_unique_check` write the rules to file and returns invisibly a named list of checks for each variable.
suggest_unique_check <- function(d, vars = names(d), fraction=0.95){
  tf <- tempfile()
  vars <- write_unique_check(d, vars, fraction=0.95, file = tf)
  if (length(vars) == 0){
    return(validate::validator())
  }
  rules <- validate::validator(.file = tf)
  validate::description(rules) <-
    sprintf("range check")
  validate::origin(rules) <-
    sprintf("validatesuggest %s"
            , packageVersion("validatesuggest")
    )
  names(rules) <- paste0("UN", seq_len(length(rules)))
  rules
}
