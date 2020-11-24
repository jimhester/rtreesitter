#include "tree_sitter/api.h"
#include <cpp11.hpp>

#define STR(s) #s

#define MAKE_RTS_CLASS(NAME, TYPE, DELETER) \
class NAME : public cpp11::external_pointer<TYPE, DELETER> { \
  using xptr = cpp11::external_pointer<TYPE, DELETER>; \
  public: \
  NAME(SEXP x) : xptr(x) { } \
  NAME(TYPE* x) : xptr(x) { \
    cpp11::sexp(*this).attr("class") = STR(NAME); \
  } \
};

MAKE_RTS_CLASS(rts_tree, TSTree, ts_tree_delete)

class ast_node {
  public: ast_node(TSNode n, rts_tree t) : node(n), tree(t) {}
  TSNode node;
  rts_tree tree;
};

MAKE_RTS_CLASS(rts_parser, TSParser, ts_parser_delete)
MAKE_RTS_CLASS(rts_node, ast_node, cpp11::default_deleter)
