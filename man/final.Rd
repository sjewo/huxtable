% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/row-col-fns.R
\name{final}
\alias{final}
\title{Return the last n rows or columns}
\usage{
final(n = 1)
}
\arguments{
\item{n}{Number of rows to return.}
}
\description{
This is a convenience function to use in row and column specifications. In that context, it
returns the last n row or column numbers of the huxtable.
}
\details{
Technically, \code{final} returns a two-argument function - see \link{rowspecs} for more details.
}
\examples{
set_bold(jams, final(2), final(1), TRUE)
}
