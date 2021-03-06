


render_markdown <- function (text, type) {
  switch(type,
    "html"     = vapply(text, commonmark::markdown_html,
                   FUN.VALUE = character(1), extensions = "strikethrough"),
    "latex"    = vapply(text, commonmark::markdown_latex,
                   FUN.VALUE = character(1), extensions = "strikethrough"),
    "markdown" = text,
    "screen"   = markdown_screen(text),
    vapply(text, commonmark::markdown_text, FUN.VALUE = character(1),
          extensions = "strikethrough")
  )
}


markdown_screen <- function (text) {
  if (! requireNamespace("crayon", quietly = TRUE)) return(text)

  my_italic <- function (x) {
    x <- sub("^\\*(.*)\\*$", "\\1", x)
    x <- sub("^_(.*)_$", "\\1", x)
    crayon::italic(x)
  }
  my_bold <- function (x) {
    x <- sub("^\\*\\*(.*)\\*\\*$", "\\1", x)
    x <- sub("^__(.*)__$", "\\1", x)
    crayon::bold(x)
  }
  my_strikethrough <-  function (x) {
    x <- sub("^~(.*)~$", "\\1", x)
    crayon::strikethrough(x)
  }

  res <- text
  res <- stringr::str_replace_all(res, "\\*\\*(.*?)\\*\\*", my_bold)
  res <- stringr::str_replace_all(res, "__(.*?)__", my_bold)
  res <- stringr::str_replace_all(res, "\\*(.*?)\\*", my_italic)
  res <- stringr::str_replace_all(res, "_(.*?)_", my_italic)
  res <- stringr::str_replace_all(res, "~(.*?)~", my_strikethrough)

  res
}


#' Set cell contents to markdown
#'
#' This convenience function calls [set_contents()] and [set_markdown()].
#'
#' @inherit set_contents params
#' @param value Cell contents, as a markdown string.
#'
#' @return The modified huxtable.
#'
#' @export
#'
#' @seealso [markdown()].
#'
#' @examples
#' set_markdown_contents(jams, 1, 1,
#'       "**Type** of jam")
set_markdown_contents <- function (ht, row, col, value) {
  call <- match.call()
  call[["ht"]] <- quote(ht)
  call[[1]] <- as.symbol("set_contents")
  ht <- eval(call, list(ht = ht), parent.frame())

  call <- match.call()
  call[["ht"]] <- quote(ht)
  if (missing(value)) call[["row"]] <- TRUE else call[["value"]] <- TRUE
  call[[1]] <- as.symbol("set_markdown")
  ht <- eval(call, list(ht = ht), parent.frame())

  ht
}
