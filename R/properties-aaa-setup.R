
#' @import assertthat
#' @importFrom stats na.omit
NULL


huxtable_cell_attrs <- c(
        "align",
        "valign",
        "rowspan",
        "colspan",
        "background_color",
        "text_color",
        "top_padding",
        "left_padding",
        "right_padding",
        "bottom_padding",
        "wrap",
        "markdown",
        "escape_contents",
        "na_string",
        "bold",
        "italic",
        "font_size",
        "rotation",
        "number_format",
        "font"
      )
huxtable_col_attrs <- c("col_width", "header_cols")
huxtable_row_attrs <- c("row_height", "header_rows")
huxtable_table_attrs <- c(
        "width",
        "height",
        "position",
        "caption",
        "caption_pos",
        "caption_width",
        "tabular_environment",
        "label",
        "latex_float"
      )


#' @evalNamespace make_namespace_S3_entries(huxtable_cell_attrs)
#' @evalNamespace make_namespace_S3_entries(huxtable_col_attrs)
#' @evalNamespace make_namespace_S3_entries(huxtable_row_attrs)
#' @evalNamespace make_namespace_S3_entries(huxtable_table_attrs)
#' @evalNamespace make_exports(huxtable_col_attrs)
#' @evalNamespace make_exports(huxtable_row_attrs)
#' @evalNamespace make_exports(huxtable_table_attrs)
#' @evalNamespace make_exports(huxtable_cell_attrs, with_map = TRUE)
NULL


huxtable_env <- new.env()
huxtable_env$huxtable_default_attrs <- list(
        rowspan             = 1,
        colspan             = 1,
        align               = "left",
        valign              = "top",
        width               = NA_real_,
        height              = NA_real_,
        col_width           = NA_real_,
        row_height          = NA_real_,
        header_cols         = FALSE,
        header_rows         = FALSE,
        background_color    = NA_character_,
        text_color          = NA_character_,
        border              = 0,
        border_color        = NA_character_,
        border_style        = "solid",
        left_padding        = 6,
        right_padding       = 6,
        top_padding         = 6,
        bottom_padding      = 6,
        wrap                = TRUE,
        caption             = NA_character_,
        caption_pos         = "top",
        caption_width       = NA_real_,
        position            = "center",
        tabular_environment = NA_character_,
        label               = NA_character_,
        latex_float         = "ht",
        markdown            = FALSE,
        escape_contents     = TRUE,
        na_string           = "",
        bold                = FALSE,
        italic              = FALSE,
        font_size           = NA_real_,
        rotation            = 0,
        number_format       = list("%.3g"),
        font                = NA_character_
      )


make_getter_setters <- function(
        attr_name,
        attr_type    = c("cell", "row", "col", "table"),
        default      = NULL,
        check_fun    = NULL,
        check_values = NULL,
        extra_code   = NULL,
        only_set_map = FALSE
      ) {
  attr_type <- match.arg(attr_type)
  funs <- list()


  funs[[attr_name]] <- eval(bquote(
    function(ht) UseMethod(.(attr_name))
  ))

  setter <- paste0(attr_name, "<-")
  funs[[setter]] <- eval(bquote(
    function(ht, value) UseMethod(.(setter))
  ))

  if (! only_set_map) {
    funs[[paste0(attr_name, ".huxtable")]] <- eval(bquote(
      function(ht) attr(ht, .(attr_name))
    ))

    check_fun <- if (! missing(check_fun)) bquote(stopifnot(.(check_fun)(value)))
    check_dims <- switch(attr_type,
      table = quote(stopifnot(length(value) == 1))
    )
    check_values <- if (! missing(check_values)) bquote(
      stopifnot(all(na.omit(value) %in% .(check_values)))
    )
    extra_code <- if (! missing(extra_code)) substitute(extra_code)
    funs[[paste0(setter, ".huxtable")]] <- eval(bquote(
      function(ht, value) {
        if (! all(is.na(value))) .(check_fun)
        .(check_dims)
        .(check_values)
        .(extra_code)
        value[is.na(value)] <- huxtable_env$huxtable_default_attrs[[.(attr_name)]]
        attr(ht, .(attr_name))[] <- value
        mode(attr(ht, .(attr_name))) <- mode(value)
        ht
      }
    ))
  }

  alt_setter  <- sprintf("set_%s", attr_name)
  mapping_fun <- sprintf("map_%s", attr_name)
  attr_symbol <- as.symbol(attr_name)

  funs[[alt_setter]] <- switch(attr_type,
        cell = eval(bquote(
          function(ht, row, col, value) {
            assert_that(is_huxtable(ht))
            if (nargs() == 2) {
              if (missing(value)) value <- row
              row <- seq_len(nrow(ht))
              col <- seq_len(ncol(ht))
            }

            rc <- list()
            rc$row <- get_rc_spec(ht, row, 1)
            rc$col <- get_rc_spec(ht, col, 2)
            .(attr_symbol)(ht)[rc$row, rc$col] <- value

            ht
          }
        )),
        row = eval(bquote(
          function(ht, row, value) {
            if (nargs() == 2) {
              if (missing(value)) value <- row
              row <- seq_len(nrow(ht))
            }
            row <- get_rc_spec(ht, row, 1)
            .(as.name(attr_name))(ht)[row] <- value
            ht
          }
        )),
        col = eval(bquote(
          function(ht, col, value) {
            if (nargs() == 2) {
              if (missing(value)) value <- col
              col <- seq_len(ncol(ht))
            }
            col <- get_rc_spec(ht, col, 2)
            .(as.name(attr_name))(ht)[col] <- value
            ht
          }
        )),
        table = eval(bquote(
          function(ht, value) {
            .(as.name(attr_name))(ht) <- value
            ht
          }
        ))
  ) # end switch

  if (! missing(default)) {
    formals(funs[[alt_setter]])$value = default
  }

  funs[[mapping_fun]] <- eval(bquote(
    function (ht, row, col, fn) {
      assert_that(is_huxtable(ht))
      nargs <- nargs()

      if (nargs() == 2) {
        if (missing(fn)) fn <- row
        row <- seq_len(nrow(ht))
        col <- seq_len(ncol(ht))
      }
      rc <- list()
      rc$row <- get_rc_spec(ht, row, 1)
      rc$col <- get_rc_spec(ht, col, 2)

      current <- .(as.name(attr_name))(ht)
      current <- current[rc$row, rc$col, drop = FALSE]
      if (is_huxtable(current)) current <- as.matrix(current)
      .(as.name(attr_name))(ht)[rc$row, rc$col] <- fn(ht, rc$row, rc$col, current)

      ht
    }
  ))

  hux_ns <- getNamespace("huxtable")
  lapply(names(funs), function (x) {
    environment(funs[[x]]) <- hux_ns
    assign(x, funs[[x]], envir = hux_ns)
  })

  return(NULL)
}



