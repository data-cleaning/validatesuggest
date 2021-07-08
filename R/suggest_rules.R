#' @export
suggest_rules <- function( d
                         , vars = names(d)
                         , range_check = TRUE
                         , type_check = TRUE
                         , na_check = TRUE
                         ){
  rules <- validate::validator()
  if (range_check){
    rules <- rules + suggest_range_check(d, vars=vars)
  }
  if (type_check){
    rules <- rules + suggest_type_check(d, vars= vars)
  }
  if (na_check){
    rules <- rules + suggest_na_check(d, vars= vars)
  }
  rules
}

# (rules <- suggest_rules(iris))
