% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/range_check.R
\name{write_range_check}
\alias{write_range_check}
\alias{suggest_range_check}
\title{Suggest a range check}
\usage{
write_range_check(d, vars = names(d), min = TRUE, max = FALSE, file = stdout())

suggest_range_check(d, vars = names(d), min = TRUE, max = FALSE)
}
\arguments{
\item{d}{\code{data.frame}, used to generate the checks}

\item{vars}{\code{character} optionally the subset of variables to be used.}

\item{min}{\code{TRUE} or \code{FALSE}, should the minimum value be checked?}

\item{max}{\code{TRUE} or \code{FALSE}, should the maximum value be checked?}

\item{file}{file to which the checks will be written to.}
}
\description{
Suggest a range check
}
\examples{
data(SBS2000, package="validate")

suggest_range_check(SBS2000)

# checks the ranges of each variable
suggest_range_check(SBS2000[-1], min=TRUE, max=TRUE)

# checks the ranges of each variable
suggest_range_check(SBS2000, vars=c("turnover", "other.rev"), min=FALSE, max=TRUE)
}