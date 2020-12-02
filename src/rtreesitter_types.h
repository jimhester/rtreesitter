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

class ts_query {
  public:
    TSQuery* query;
    cpp11::strings capture_names;
    ts_query(const TSLanguage* language, std::string& source) {
      uint32_t error_offset;
      TSQueryError error_type;
      query = ts_query_new(language, source.c_str(), source.length(), &error_offset, &error_type);
      /*TODO: handle query errors */
      R_xlen_t n = ts_query_capture_count(query);
      cpp11::writable::strings names(n);
      for (R_xlen_t i = 0; i < n; ++i) {
        unsigned length;
        const char* capture_name = ts_query_capture_name_for_id(query, i, &length);
        names[i] = capture_name;
      }
      capture_names = names;
    }
    ~ts_query() {
      if (query) {
        ts_query_delete(query);
      }
    }
};

MAKE_RTS_CLASS(rts_parser, TSParser, ts_parser_delete)
MAKE_RTS_CLASS(rts_node, ast_node, cpp11::default_deleter)
MAKE_RTS_CLASS(rts_query, ts_query, cpp11::default_deleter)
