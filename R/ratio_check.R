RATIO_CHECK <-
"# check the ratio of highly correlated variables
{{#pairs}}
{{{var1}}} >= {{min}} * {{{var2}}}
{{{var1}}} <= {{max}} * {{{var2}}}
{{/pairs}}
"

#' @export
#' @rdname suggest_ratio_check
write_ratio_check <- function(d, vars=names(d), file=stdout(), lin_cor=0.95, digits=2){
  vars <- Filter(function(v){
    is.numeric(d[[v]])
  }, vars)
  cd <- stats::cor(d[vars], d[vars], "pairwise.complete.obs")
  cdl <- which(abs(cd) >= lin_cor, arr.ind = TRUE)
  cdl <- cdl[cdl[,1] < cdl[,2],]
  cdl <- matrix(vars[cdl], ncol=2)
  pairs <- lapply(seq_len(nrow(cdl)), function(r){
    ratio_check(d, cdl[r,1], cdl[r,2], digits = digits)
  })
  pairs
  writeLines(
    whisker::whisker.render(RATIO_CHECK, data = list(pairs=pairs)),
    file
  )
}

ratio_check <- function(d, var1, var2, digits = 2){
  ratio <- d[[var1]]/d[[var2]]
  ratio <- ratio[is.finite(ratio)] # remove all NA, divide by zero ***
  list( var1 = var1
      , var2 = var2
      , min = round(min(ratio), digits = digits)
      , max = round(max(ratio), digits = digits)
      )
}


# write_ratio_check(retailers)
# write_ratio_check(SBS2000)

#' Suggest ratio checks
#'
#' Suggest ratio checks
#' @export
#' @example example/ratio_check.R
#' @inheritParams suggest_type_check
#' @param lin_cor threshold for abs correlation to be included (details)
#' @param digits number of digits for rounding
suggest_ratio_check <- function(d, vars = names(d), lin_cor=0.95, digits=2){
  tf <- tempfile()
  write_ratio_check(d, vars, lin_cor = lin_cor, file = tf, digits = digits)
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
