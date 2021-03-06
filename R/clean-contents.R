
# return character matrix of formatted contents, suitably escaped
clean_contents <- function(
  ht,
  type = c("latex", "html", "screen", "markdown", "word", "excel", "rtf"),
  ...
) {
  type <- match.arg(type)
  contents <- as.matrix(as.data.frame(ht))

  for (col in seq_len(ncol(contents))) {
    for (row in seq_len(nrow(contents))) {
      cell <- contents[row, col]
      num_fmt <- number_format(ht)[[row, col]] # a list element, double brackets
      cell <- format_numbers(cell, num_fmt)
      if (is.na(cell)) cell <- na_string(ht)[row, col]
      contents[row, col] <- as.character(cell)
    }
  }
  contents[is.na(contents)] <- na_string(ht)

  for (col in seq_len(ncol(contents))) {
    md_rows <- markdown(ht)[, col]
    contents[md_rows, col] <- render_markdown(contents[md_rows, col], type)
    if (type %in% c("latex", "html", "rtf")) {
      to_esc <- escape_contents(ht)[, col] & ! md_rows
      contents[to_esc, col] <-  sanitize(contents[to_esc, col], type)
    }
    # has to be after sanitization because we add &nbsp; for HTML (and non-space stuff for LaTeX):
    pad_chars <- rep(NA, length(col))
    align_pad   <- ncharw(align(ht)[, col]) == 1
    pad_chars[align_pad] <- align(ht)[align_pad, col]
    contents[, col] <- decimal_pad(contents[, col], pad_chars, type)
  }

  if (type == "rtf") {
    contents <- utf8_to_rtf(contents)
  }

  contents
}


utf8_to_rtf <- function (mx) {
  utf8_codes <- function (x) utf8ToInt(enc2utf8(x))

  rtf_encode <- function (x) {
    code <- utf8_codes(x)
    x <- strsplit(x, split = "")[[1]]
    x[code > 127L & code <= 32767L]   <- code[code > 127L & code <= 32767L]
    x[code > 32767L] <- code[code > 32767L] - 65536L
    x[code > 127L] <- paste0("\\u", x[code > 127L], "?")
    paste0(x, collapse = "")
  }

  needs_conv <- vapply(c(mx), function (x) any(utf8_codes(x) > 127L),
                       logical(1))
  mx[needs_conv] <- vapply(mx[needs_conv], rtf_encode,
                           character(1))

  mx
}


# Format numeral generics
numeral_formatter <- function (x) {
  UseMethod("numeral_formatter")
}

#' @export
numeral_formatter.default <- function (x) {
  stop("Unrecognized number_format. Please use a number, string or function.")
}


# If we are a function then return output from the function
#' @export
numeral_formatter.function <- function (x) {
  return(x)
}


#' @export
numeral_formatter.character <- function (x) {
  return(function(numeral) sprintf(x, numeral))
}


#' @export
numeral_formatter.numeric <- function (x) {
  return(function(numeral) formatC(round(numeral, x), format = "f", digits = x))
}


# find each numeric substring, and replace it:
format_numbers <- function (string, num_fmt) {
  if (is.na(string)) return(NA_character_)

  # ! is.function avoids a warning if num_fmt is a function:
  if (! is.function(num_fmt) && is.na(num_fmt)) return(string)

  format_numeral <- numeral_formatter(num_fmt)
  # Breakdown:
  # -?                    optional minus sign
  # [0-9]*                followed by any number of digits
  # \\.?                  optionally followed by a decimal
  # [0-9]+                which may also be followed by any number of digits
  # ([eE]-?[0-9]+)?       optionally including e or E as in scientific notation
  #                       along with (optionally) a sign preceding the digits
  #                       specifying the level of the exponent.
  stringr::str_replace_all(string,  "-?[0-9]*\\.?[0-9]+([eE][+-]?[0-9]+)?", function (x) format_numeral(as.numeric(x)))
}


decimal_pad <- function(col, pad_chars, type) {
  # where pad_chars is NA we do not pad
  orig_col  <- col
  na_pad    <- is.na(pad_chars)
  col       <- col[! na_pad]
  pad_chars <- pad_chars[! na_pad]
  if (length(col) == 0) return(orig_col)

  find_pos  <- function(string, char) {
    regex <- gregexpr(char, string, fixed = TRUE)[[1]]
    regex[length(regex)]
  }
  pos <- mapply(find_pos, col, pad_chars)
  nchars <- nchar(col, type = "width")
  # take the biggest distance from the decimal point
  pos[pos == -1L] <- nchars[pos == -1L] + 1
  chars_after_. <- nchars - pos

  pad_n_spaces <- max(chars_after_.) - chars_after_.
  pad_char <- switch(type,
                     "html"   = "&nbsp;",
                     "latex"  = "~",
                     "screen" = "\u00a0", # screen non-breaking space
                     "rtf"    = "\\~",
                     " ")
  col <- paste0(col, str_rep(pad_char, pad_n_spaces))

  orig_col[! na_pad] <- col
  orig_col
}


