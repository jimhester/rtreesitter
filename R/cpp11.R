# Generated by cpp11: do not edit by hand

parser_new <- function(language) {
  .Call("_rtreesitter_parser_new", language, PACKAGE = "rtreesitter")
}

parser_parse <- function(p, code) {
  .Call("_rtreesitter_parser_parse", p, code, PACKAGE = "rtreesitter")
}

parser_field_id_for_name <- function(p, name) {
  .Call("_rtreesitter_parser_field_id_for_name", p, name, PACKAGE = "rtreesitter")
}

tree_sexp <- function(t) {
  .Call("_rtreesitter_tree_sexp", t, PACKAGE = "rtreesitter")
}

tree_root <- function(t) {
  .Call("_rtreesitter_tree_root", t, PACKAGE = "rtreesitter")
}

query_new <- function(p, source) {
  .Call("_rtreesitter_query_new", p, source, PACKAGE = "rtreesitter")
}

query_captures <- function(query, node) {
  .Call("_rtreesitter_query_captures", query, node, PACKAGE = "rtreesitter")
}

node_sexp <- function(n) {
  .Call("_rtreesitter_node_sexp", n, PACKAGE = "rtreesitter")
}

node_get_child_count <- function(n) {
  .Call("_rtreesitter_node_get_child_count", n, PACKAGE = "rtreesitter")
}

node_get_named_child_count <- function(n) {
  .Call("_rtreesitter_node_get_named_child_count", n, PACKAGE = "rtreesitter")
}

node_get_children <- function(self) {
  .Call("_rtreesitter_node_get_children", self, PACKAGE = "rtreesitter")
}

node_get_type <- function(n) {
  .Call("_rtreesitter_node_get_type", n, PACKAGE = "rtreesitter")
}

node_get_start_byte <- function(n) {
  .Call("_rtreesitter_node_get_start_byte", n, PACKAGE = "rtreesitter")
}

node_get_end_byte <- function(n) {
  .Call("_rtreesitter_node_get_end_byte", n, PACKAGE = "rtreesitter")
}

node_get_start_point <- function(n) {
  .Call("_rtreesitter_node_get_start_point", n, PACKAGE = "rtreesitter")
}

node_get_end_point <- function(n) {
  .Call("_rtreesitter_node_get_end_point", n, PACKAGE = "rtreesitter")
}

node_get_is_named <- function(n) {
  .Call("_rtreesitter_node_get_is_named", n, PACKAGE = "rtreesitter")
}

node_child_by_field_name <- function(n, name) {
  .Call("_rtreesitter_node_child_by_field_name", n, name, PACKAGE = "rtreesitter")
}

node_child_by_field_id <- function(n, id) {
  .Call("_rtreesitter_node_child_by_field_id", n, id, PACKAGE = "rtreesitter")
}
