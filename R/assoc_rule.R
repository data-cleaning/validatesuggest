COND_CHECK <-
"
# Conditional checks
{{#pairs}}
if ({{{cond}}}) {{{cons}}}
{{/pairs}}
"
derive_arule <- function(vars, d, fraction=0, debug = FALSE){
  tab <- table(d[vars])

  if (debug){
    print(tab)
  }

  # strict checking, TODO relax this restriction with fraction
  i <- which(tab == 0, arr.ind = TRUE)

  rn <- rownames(tab)
  cn <- colnames(tab)
  lapply(seq_len(nrow(i)), function(r){
    list( cond = atomic_check_expr( name = vars[1]
                     , value = rn[i[r,1]]
                     , is_logical = is.logical(d[[vars[1]]])
                     , negate = FALSE
                     ),
          cons = atomic_check_expr( name = vars[2]
                     , value = cn[i[r,2]]
                     , is_logical = is.logical(d[[vars[2]]])
                     , negate = TRUE
                     )
        )
  })
}

POS_CHECK_VAR <- "^\\.pos\\."

atomic_check_expr <- function(name, value, is_logical = FALSE, negate=FALSE){
  if (is_logical){
    value <- as.logical(value)
  }
  v <- as.symbol(name)
  expr <- if (negate){
    if (is.logical(value)){
      value <- !value
      bquote(.(v) == .(value))
    } else {
      bquote(.(v) != .(value))
    }
  } else {
    bquote(.(v) == .(value))
  }
  if (isTRUE(grepl(POS_CHECK_VAR, name)) && is.logical(value)){
    # note: negating value is done in line 44
      v <- as.symbol(sub(POS_CHECK_VAR, "", name))
      expr <- if (value) bquote(.(v) > 0) else bquote(.(v) <= 0)
  }
  deparse(expr)
}

#' @export
#' @rdname suggest_cond_rule
write_cond_rule <- function(d, vars=names(d), file = stdout()){
  is_numeric <- sapply(d[vars], is.numeric)
  for (v in vars[is_numeric]){
    vc <- paste0(".pos.", v)
    d[[vc]] <- d[[v]] > 0
    vars <- c(vars, vc)
  }
  vars <- Filter(function(v){
    is.logical(d[[v]])
    # !is.numeric(d[[v]])
  }, vars)
  pairs <- do.call(c, combn(vars, 2, derive_arule, d = d, simplify = FALSE))
  writeLines(
    whisker::whisker.render(COND_CHECK, data = list(pairs=pairs)),
    file
  )
  invisible(pairs)
}


#' Suggest a conditional rule
#'
#' Suggest a conditional rule based on a association rule.
#' This functions derives conditional rules based on the non-existance
#' of combinations of categories in pairs of variables.
#' For each numerical variable a logical variable is derived that tests for
#' positivity. It generates IF THEN rules based on two variables.
#' @export
#' @example example/na_check.R
#' @importFrom utils combn
#' @example example/conditional_rule.R
#' @inheritParams suggest_type_check
suggest_cond_rule <- function(d, vars = names(d)){
  tf <- tempfile()
  pairs <- write_cond_rule(d, vars = vars, file = tf)
  if (length(pairs) == 0){
    return(validate::validator())
  }

  rules <- validate::validator(.file=tf)
  validate::description(rules) <-
    sprintf("conditional rule")
  validate::origin(rules) <-
    sprintf("validatesuggest %s"
            , packageVersion("validatesuggest")
    )
  names(rules) <- paste0("CR", seq_len(length(rules)))
  rules
}
