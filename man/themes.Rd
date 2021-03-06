% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/themes.R
\name{themes}
\alias{themes}
\alias{theme_plain}
\alias{theme_bright}
\alias{theme_basic}
\alias{theme_compact}
\alias{theme_striped}
\alias{theme_grey}
\alias{theme_blue}
\alias{theme_orange}
\alias{theme_green}
\alias{theme_article}
\alias{theme_mondrian}
\title{Theme a huxtable}
\usage{
theme_plain(ht, header_rows = TRUE, position = "center")

theme_bright(
  ht,
  header_rows = TRUE,
  header_cols = FALSE,
  colors = c("#7eabf2", "#e376e3", "#fcbb03", "#7aba59", "#fc0356")
)

theme_basic(ht, header_rows = TRUE, header_cols = FALSE)

theme_compact(ht, header_rows = TRUE, header_cols = FALSE)

theme_striped(
  ht,
  stripe = "grey90",
  stripe2 = "grey95",
  header_rows = TRUE,
  header_cols = TRUE
)

theme_grey(ht, header_rows = TRUE, header_cols = TRUE)

theme_blue(ht, header_rows = TRUE, header_cols = TRUE)

theme_orange(ht, header_rows = TRUE, header_cols = TRUE)

theme_green(ht, header_rows = TRUE, header_cols = TRUE)

theme_article(ht, header_rows = TRUE, header_cols = TRUE)

theme_mondrian(ht, prop_colored = 0.1, font = NULL)
}
\arguments{
\item{ht}{A huxtable object.}

\item{header_rows}{Logical: style header rows?}

\item{position}{"left", "center" or "right"}

\item{header_cols}{Logical: style header columns?}

\item{colors}{Colors for header rows. Can also be a palette function.}

\item{stripe}{Background colour for odd rows}

\item{stripe2}{Background colour for even rows}

\item{prop_colored}{Roughly what proportion of cells should have
a primary-color background?}

\item{font}{Font to use. For LaTeX, try \code{"cmss"}.}
}
\value{
The huxtable object, appropriately styled.
}
\description{
These functions quickly set default styles for a huxtable.
}
\details{
\itemize{
\item \code{theme_plain} is a simple theme with a bold header, a grey striped
background, and an outer border.
\item \code{theme_basic} sets header rows/columns to bold, and adds a border beneath
them.
\item \code{theme_compact} is like \code{theme_basic} but with minimal padding.
\item \code{theme_striped} uses different backgrounds for alternate rows, and for
headers.
\item \code{theme_article} is similar to the style of many scientific journals.
It sets horizontal lines above and below the table.
\item \code{theme_bright} uses thick white borders and a colourful header. It
works nicely with sans-serif fonts.
\item \code{theme_grey}, \code{theme_blue}, \code{theme_orange} and \code{theme_green} use white
borders and subtle horizontal stripes.
\item \code{theme_mondrian} mimics the style of a Mondrian painting, with thick black
borders and randomized colors.
}
}
\examples{

theme_plain(jams)
theme_basic(jams)
theme_compact(jams)
theme_striped(jams)
theme_article(jams)
theme_bright(jams)
theme_grey(jams)
theme_blue(jams)
theme_orange(jams)
theme_green(jams)
theme_mondrian(jams)
\dontrun{
  quick_pdf(
          theme_plain(jams),
          theme_basic(jams),
          theme_compact(jams)
          theme_striped(jams),
          theme_article(jams),
          theme_bright(jams),
          theme_grey(jams),
          theme_blue(jams),
          theme_orange(jams),
          theme_green(jams),
          theme_mondrian(jams)
        )
}

}
