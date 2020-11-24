#include "rtreesitter_types.hpp"
#include "R_ext/Rdynload.h"
using namespace cpp11;

static TSTreeCursor default_cursor = {0, 0, {0}};

[[cpp11::register]]
rts_parser parser_new(std::string language) {
  auto p = ts_parser_new();
  TSLanguage* (*language_ptr)() = (TSLanguage* (*)()) R_FindSymbol(language.c_str(), "", nullptr);

  ts_parser_set_language(p, (*language_ptr)());

  return p;
}

[[cpp11::register]]
rts_tree parser_parse(rts_parser p, std::string code) {
  return ts_parser_parse_string(p.get(), nullptr, code.c_str(), code.length());
}

[[cpp11::register]]
std::string tree_sexp(rts_tree t) {
  char *buf = ts_node_string(ts_tree_root_node(t.get()));
  std::string out(buf);
  free(buf);
  return out;
}

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

  res.attr("class") = "rts_node_list";

  return res;
}

[[cpp11::register]]
rts_node tree_root(rts_tree t) {
  return new ast_node(ts_tree_root_node(t.get()), t);
}
