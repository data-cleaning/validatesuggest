% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/unique_check.R
\name{write_unique_check}
\alias{write_unique_check}
\alias{suggest_unique_check}
\title{Suggest range checks}
\usage{
write_unique_check(d, vars = names(d), file = stdout(), fraction = 0.95)

suggest_unique_check(d, vars = names(d), fraction = 0.95)
}
\arguments{
\item{d}{\code{data.frame}, used to generate the checks}

\item{vars}{\code{character} optionally the subset of variables to be used.}

\item{file}{file to which the checks will be written to.}

\item{fraction}{if values in a column > \code{fraction} unique,
the check will be generated.}
}
\description{
Suggest range checks
}
