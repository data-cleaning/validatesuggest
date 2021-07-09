TYPE_CHECK <-
"# check the type of variables
{{#vars}}
is.{{{type}}}({{{name}}})
{{/vars}}
"

#' @export
#' @rdname suggest_type_check
#' @param file file to which the checks will be written to.
write_type_check <- function(d, vars=names(d), file=stdout()){
  vars <- lapply(vars, function(name){
    x <- d[[name]]
    list(name = name, type = class(x)[1])
  })
  whisker::whisker.render(TYPE_CHECK, data = list(vars=vars)) |>
    writeLines(file)
}

#' suggest type check
#' @export
#' @param d `data.frame`, used to generate the checks
#' @param vars `character` optionally the subset of variables to be used.
suggest_type_check <- function(d, vars = names(d)){
  tf <- tempfile()
  write_type_check(d, vars = vars, file = tf)

  rules <- validate::validator(.file=tf)
  validate::description(rules) <-
    sprintf("type check")
  validate::origin(rules) <-
    sprintf("validatesuggest %s"
            , packageVersion("validatesuggest")
    )
  names(rules) <- paste0("TC", seq_len(length(rules)))
  rules
}


