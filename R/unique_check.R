UNIQUE_CHECK <-
"# check if these columns are unique
{{#vars}}
all_unique({{{name}}})
{{/vars}}
"

#' Suggest range checks
#' @export
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
  whisker::whisker.render(UNIQUE_CHECK, data = list(vars=vars)) |>
    writeLines(file)
}

suggest_unique_check <- function(d, vars = names(d), fraction=0.95){
  tf <- tempfile()
  write_unique_check(d, vars, fraction=0.95, file = tf)
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
