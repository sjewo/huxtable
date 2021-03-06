% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rtf.R
\name{rtf_fc_tables}
\alias{rtf_fc_tables}
\title{Create RTF font and color tables}
\usage{
rtf_fc_tables(..., extra_fonts = "Times", extra_colors = character(0))
}
\arguments{
\item{...}{One or more objects of class \code{huxtable}.}

\item{extra_fonts}{Extra fonts to include. These will be first in the fonts table.}

\item{extra_colors}{Extra colors to include, as R color names.}
}
\value{
An object of class \code{rtfFCTables}. This is a list containing two items: \code{"fonts"}
is a character vector of unique font names; \code{"colors"} is a character vector of unique color
names.
}
\description{
Create RTF font and color tables
}
\details{
RTF documents have a single table of fonts, and a table of colors, in the RTF header. To
create font and color tables for multiple huxtables, use this command. You can \code{print} the
returned object in the RTF header. Pass it to \code{\link[=print_rtf]{print_rtf()}} or \code{\link[=to_rtf]{to_rtf()}} to ensure that
huxtables print out the correct colour references.
}
\examples{

# Printing multiple huxtables:

ht <- huxtable("Blue with red border")
ht <- set_all_borders(ht, 1)
ht <- set_all_border_colors(ht, "red")
background_color(ht) <- "blue"

ht2 <- huxtable("Dark green text")
text_color(ht2) <- "darkgreen"

fc_tbls <- rtf_fc_tables(ht, ht2)

# In the document header:
print(fc_tbls)

# In the document body:
print_rtf(ht, fc_tables = fc_tbls)
print_rtf(ht2, fc_tables = fc_tbls)
}
