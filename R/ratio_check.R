RATIO_CHECK <-
"# check the ratio of highly correlated variables
{{#pairs}}
{{{var1}}} >= {{min}} * {{{var2}}}
{{{var1}}} <= {{max}} * {{{var2}}}
{{/pairs}}
"

#' Suggest ratio checks
#' @export
write_ratio_check <- function(d, vars=names(d), file=stdout(), lin_cor=0.95){
  vars <- Filter(function(v){
    is.numeric(d[[v]])
  }, vars)
  cd <- cor(d[vars], d[vars], "pairwise.complete.obs")
  cdl <- which(abs(cd) >= lin_cor, arr.ind = TRUE)
  cdl <- cdl[cdl[,1] < cdl[,2],]
  cdl <- matrix(vars[cdl], ncol=2)
  pairs <- lapply(seq_len(nrow(cdl)), function(r){
    ratio_check(d, cdl[r,1], cdl[r,2])
  })
  pairs
  whisker::whisker.render(RATIO_CHECK, data = list(pairs=pairs)) |>
    writeLines(file)
}

ratio_check <- function(d, var1, var2){
  ratio <- d[[var1]]/d[[var2]]
  ratio <- ratio[is.finite(ratio)] # remove all NA, divide by zero ***
  list( var1 = var1
      , var2 = var2
      , min = round(min(ratio),2)
      , max = round(max(ratio),2)
      )
}


# write_ratio_check(retailers)
# write_ratio_check(SBS2000)

#' @export
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
