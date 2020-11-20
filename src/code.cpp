#include "rtreesitter_types.hpp"
#include "R_ext/Rdynload.h"
using namespace cpp11;

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
