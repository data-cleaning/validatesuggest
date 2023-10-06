#' @importFrom rpart rpart
get_tree <- function(d){
  m <- rpart(car_color ~ ., data = d)
  node <- as.numeric(row.names(m$frame))
  lab <- labels(m)
  parent_node <- get_parents(node)
}

get_parents <- function(node){
  l <- lapply(node[-1], function(n){
    floor(n * cumprod(rep(0.5, log2(n) - 1)))
  })
}

SPLIT <- "[<>=]=? ?(.+)"
LEVS <- ".+=([a-z]+)$"
LOGICAL <- "(.+)(<)"

get_q <- function(m, d){
  split_lab <- labels(m)
  vars <- labels(m$terms)
  split_vars <- sub(SPLIT, "", split_lab)
  #TODO fix logical, factor and character
  types <- attr(m$terms, "dataClasses")[split_vars]
  expr <- vector(mode="expression", length = length(split_lab))

  is_numeric <- which(types == "numeric")
  expr[is_numeric] <- sapply(split_lab[is_numeric], str2lang)

  is_character <- which(types == "character")
  expr[is_character] <- sapply(split_lab[is_character], function(e){
    let <- sub(LEVS, "\\1", e)
    v <- sub(SPLIT, "", e)
    f <- factor(d[[v]])
    idx <- match(strsplit(let, "")[[1]], letters)
    levs <- levels(f)[idx]
    substitute(v %in% levs, list(v = as.symbol(v), levs=levs))
  })

  is_logical <- which(types == "logical")
  expr[is_logical] <- sapply(split_lab[is_logical], function(e){
    let <- sub(LEVS, "\\1", e)
    v <- sub(SPLIT, "", e)
    f <- factor(d[[v]])
    idx <- match(strsplit(let, "")[[1]], letters)
    levs <- levels(f)[idx]
    substitute(v %in% levs, list(v = as.symbol(v), levs=levs))
  })

  expr
}

