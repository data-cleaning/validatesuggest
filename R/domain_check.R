DOMAIN_CHECK <-
"# check the domain of variables
{{#vars}}
{{#isnumeric}}
{{{name}}} >= 0
{{/isnumeric}}
{{#islogical}}
{{{name}}} %in% c(TRUE, FALSE)
{{/islogical}}
{{#ischaracter}}
{{{name}}} %in% {{{values}}}
{{/ischaracter}}
{{/vars}}
"

#' @export
#' @rdname suggest_domain_check
write_domain_check <- function(d, vars=names(d), only_positive=TRUE, file=stdout()){
  vars <- lapply(vars, function(name){
    x <- d[[name]]
    if (is.numeric(x)){
      if (only_positive && any(x < 0, na.rm=TRUE)){
          return(NULL)
      }
      return(list(name = name, isnumeric=TRUE))
    } else if (is.logical(x)){
      list(name = name, islogical=TRUE)
    } else {
      #TODO date and so on
      x <- as.character(x)
      values <- unique(x)
      if (length(values) == length(x)){
        warning("Skipped domain check '",name,"'", ", as it is unique for each record"
                , call. = FALSE
        )
        return(NULL)
      }
      list( name = name
            , ischaracter = TRUE
            , values = deparse(values)
      )
    }
  })
  vars <- Filter(function(v) {!is.null(v)}, vars)
  writeLines(
    whisker::whisker.render(DOMAIN_CHECK, data = list(vars=vars)),
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
suggest_domain_check <- function(d, vars = names(d), only_positive=TRUE){
  tf <- tempfile()
  vars <- write_domain_check(d, vars, file = tf)
  if (length(vars) == 0){
    return(validate::validator())
  }
  rules <- validate::validator(.file = tf)
  validate::description(rules) <-
    sprintf("domain check")
  validate::origin(rules) <-
    sprintf("validatesuggest %s"
            , packageVersion("validatesuggest")
    )
  names(rules) <- paste0("DC", seq_len(length(rules)))
  rules
}
