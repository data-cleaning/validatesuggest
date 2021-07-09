data(SBS2000, package="validate")

suggest_range_check(SBS2000)

# checks the ranges of each variable
suggest_range_check(SBS2000[-1], min=TRUE, max=TRUE)

# checks the ranges of each variable
suggest_range_check(SBS2000, vars=c("turnover", "other.rev"), min=FALSE, max=TRUE)
