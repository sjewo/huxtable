% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/properties-cell.R
\name{font_size}
\alias{font_size}
\alias{font_size<-}
\alias{set_font_size}
\alias{map_font_size}
\title{Make text larger or smaller}
\usage{
font_size(ht)
font_size(ht) <- value
set_font_size(ht, row, col, value )
map_font_size(ht, row, col, fn)
}
\arguments{
\item{ht}{A huxtable.}

\item{row}{A row specifier. See \link{rowspecs} for details.}

\item{col}{An optional column specifier.}

\item{fn}{A mapping function. See \link{mapping-functions} for details.}

\item{value}{A numeric vector.

Set to \code{NA} to reset to the default, which is \code{NA}.}
}
\value{
\code{font_size()} returns the \code{font_size} property.
\code{set_font_size()} returns the modified huxtable.
}
\description{
Font size is in points.
}
\examples{

font_size(jams) <-  14
font_size(jams)

jams2 <- set_font_size(jams,
      12)
font_size(jams2)

jams3 <- set_font_size(jams,
      2:3, 1, 12)
font_size(jams3)

jams4 <- map_font_size(jams,
      by_rows(
        12,
        14)
      )
font_size(jams4)
}
\seealso{
Other formatting functions: 
\code{\link{background_color}()},
\code{\link{bold}()},
\code{\link{font}()},
\code{\link{na_string}()},
\code{\link{number_format}()},
\code{\link{text_color}()}
}
\concept{formatting functions}
