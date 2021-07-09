RATIO_CHECK <-
"# check the range of variables
{{#vars}}
{{/vars}}
"

#' Suggest range checks
#' @export
write_ratio_check <- function(d, vars=names(d), file=stdout()){
  vars <- lapply(vars, function(name){
    x <- d[[name]]
    if (is.numeric(x)){
      list( name = name
            , isnumeric=TRUE
            , min=min(x, na.rm = TRUE)
            , max=max(x, na.rm = TRUE)
      )
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
  whisker::whisker.render(RATIO_CHECK, data = list(vars=vars)) |>
    writeLines(file)
}

suggest_ratio_check <- function(d, vars = names(d)){
  tf <- tempfile()
  write_ratio_check(d, vars, file = tf)
  rules <- validate::validator(.file = tf)
  validate::description(rules) <-
    sprintf("ratio check")
  validate::origin(rules) <-
    sprintf("validatesuggest %s"
            , packageVersion("validatesuggest")
    )
  names(rules) <- paste0("RC", seq_len(length(rules)))
  rules
}
