data("retailers", package="validate")

v <- suggest_unique_check(retailers)
expect_equal(length(v), 0)


data("SBS2000", package="validate")
v <- suggest_unique_check(SBS2000)
expect_equal(v[[1]]@expr, quote(all_unique(id)))
