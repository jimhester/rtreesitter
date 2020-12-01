#include "rtreesitter_types.h"
using namespace cpp11;

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
list node_get_children(rts_node self) {
  R_xlen_t n = ts_node_child_count(self->node);
  if (n == 0) {
    return list();
  }

  writable::list res(n);

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
