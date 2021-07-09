data(SBS2000, package="validate")

# generates upper and lower checks for the
# ratio of two variables if their correlation is
# bigger then `lin_cor`
suggest_ratio_check(SBS2000, lin_cor=0.98)
