#' @export
print.rts_parser <- function(x) {
  cat("{rts_parser}\n")
}

#' @export
print.rts_tree <- function(x) {
  cat("{rts_tree}\n")

  cat(tree_sexp(x))
}

#' @export
print.rts_node <- function(x) {
  cat("{rts_node}\n")

  cat(node_sexp(x))
}

#' @export
print.rts_node_list <- function(x) {
  cat("{rts_node_list}\n")

  n <- length(x)
  label <- format(paste0("[[", seq_len(n), "]]"), justify = "right")
  contents <- vapply(x, node_sexp, FUN.VALUE = character(1))

  desc <- paste(label, contents)

  cat(desc, sep = "\n")

  invisible(x)
}
