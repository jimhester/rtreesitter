#include "rtreesitter_types.h"

static TSTreeCursor default_cursor = {0, 0, {0}};

[[cpp11::register]]
std::string node_sexp(rts_node n) {
  return ts_node_string(n->node);
}

[[cpp11::register]]
size_t node_get_child_count(rts_node n) {
  return ts_node_child_count(n->node);
}

[[cpp11::register]]
size_t node_get_named_child_count(rts_node n) {
  return ts_node_named_child_count(n->node);
}

[[cpp11::register]]
cpp11::list node_get_children(rts_node self) {
  R_xlen_t n = ts_node_child_count(self->node);
  if (n == 0) {
    return cpp11::list();
  }

  cpp11::writable::list res(n);

  ts_tree_cursor_reset(&default_cursor, self->node);
  ts_tree_cursor_goto_first_child(&default_cursor);
  R_xlen_t i = 0;
  do {
    res[i++] = rts_node(new ast_node(ts_tree_cursor_current_node(&default_cursor), self->tree));
  } while (ts_tree_cursor_goto_next_sibling(&default_cursor));

  return res;
}

[[cpp11::register]]
std::string node_get_type(rts_node n) {
  return ts_node_type(n->node);
}

[[cpp11::register]]
double node_get_start_byte(rts_node n) {
  return ts_node_start_byte(n->node);
}

[[cpp11::register]]
double node_get_end_byte(rts_node n) {
  return ts_node_end_byte(n->node);
}

[[cpp11::register]]
cpp11::writable::doubles node_get_start_point(rts_node n) {
  TSPoint point = ts_node_start_point(n->node);
  return {static_cast<double>(point.row), static_cast<double>(point.column)};
}

[[cpp11::register]]
cpp11::writable::doubles node_get_end_point(rts_node n) {
  TSPoint point = ts_node_end_point(n->node);
  return {static_cast<double>(point.row), static_cast<double>(point.column)};
}

[[cpp11::register]]
bool node_get_is_named(rts_node n) {
  return ts_node_is_named(n->node);
}
