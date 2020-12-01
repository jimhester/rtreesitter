#' A parser object
#'
#' @export
rts_parser <- R6::R6Class("rts_parser",
  private = list(
    ptr = NULL
  ),
  public = list(
    #' @description
    #' Create a new parser object
    #' @param language The language to parse
    #' @return A new `rts_parser` object
    initialize = function(language) {
      private$ptr <- parser_new(language)
    },
    #' @param ... Additional parameters ignored.
    print = function(...) {
      cat("{rts_parser}\n")
    },
    #' @param text The text to parse.
    parse = function(text) {
      rts_tree$new(parser_parse(private$ptr, text))
    }
  )
)

rts_tree <- R6::R6Class("rts_tree",
  active = list(
    root_node = function() rts_node$new(tree_root(private$ptr))
  ),
  private = list(
    ptr = NULL
  ),
  public = list(
    initialize = function(ptr) {
      private$ptr <- ptr
    },
    print = function(...) {
      cat("{rts_tree}\n")

      cat(tree_sexp(private$ptr))
    }
  )
)

rts_node <- R6::R6Class("rts_node",
  active = list(
    type = function() node_get_type(private$ptr),
    start_point = function() node_start_point(private$ptr),
    end_point = function() node_end_point(private$ptr),
    children = function() {
      lapply(node_get_children(private$ptr), rts_node$new)
    }
  ),
  private = list(
    ptr = NULL
  ),
  public = list(
    initialize = function(ptr) {
      private$ptr <- ptr
    },
    print = function(...) {
      cat("{rts_node}\n")
      cat(node_sexp(private$ptr))
    }
  )
)

pp <- function(x) {
  words <- strsplit(x, ' ')[[1]]
  open <- startsWith(words, "(")
  closed <- endsWith(words, ")")
  words[open & !closed] <- paste0(words[open & !closed], "\n")
  paste(words, collapse = " ")
}
