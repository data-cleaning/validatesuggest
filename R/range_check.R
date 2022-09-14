RANGE_CHECK <-
"# check the range of variables
{{#vars}}
{{#isnumeric}}
{{#in_range}}
in_range({{{name}}}, {{min}}, {{max}})
{{/in_range}}
{{^in_range}}
{{#min}}
{{{name}}} >= {{min}}
{{/min}}
{{#max}}
{{{name}}} <= {{max}}
{{/max}}
{{/in_range}}
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
#' @rdname suggest_range_check
write_range_check <- function(d, vars=names(d), min=TRUE, max=FALSE, file=stdout()){
  vars <- lapply(vars, function(name){
    x <- d[[name]]
    if (is.numeric(x)){
      l <- list(name = name, isnumeric=TRUE)
      if (isTRUE(min)){
        l$min <- min(x, na.rm = TRUE)
      }
      if (isTRUE(max)){
        l$max <- max(x, na.rm = TRUE)
      }
      l$in_range <- isTRUE(min && max)

      l
    } else if (is.logical(x)){
      list(name = name, islogical=TRUE)
    } else {
      #TODO date and so on
      x <- as.character(x)
      values <- unique(x)
      if (length(values) == length(x)){
        warning("Skipped range check '",name,"'", ", as it is unique for each record"
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
  writeLines(
    whisker::whisker.render(RANGE_CHECK, data = list(vars=vars)),
    file
  )
  invisible(vars)
}

#' Suggest a range check
#'
#' @export
#' @inheritParams suggest_type_check
#' @example example/range_check.R
#' @param min `TRUE` or `FALSE`, should the minimum value be checked?
#' @param max `TRUE` or `FALSE`, should the maximum value be checked?
suggest_range_check <- function(d, vars = names(d), min=TRUE, max=FALSE){
  tf <- tempfile()
  vars <- write_range_check(d, vars, min=min, max=max, file = tf)
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
  names(rules) <- paste0("RC", seq_len(length(rules)))
  rules
}
