#include "rtreesitter_types.h"
#include "R_ext/Rdynload.h"
#include <sstream>
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

//[[cpp11::register]]
//std::string layout_sexp(std::string str, int level) {
  //std::stringstream s;
  //layout_sexp_internal(str, s, 0);
  //return s.str();
//}

//void layout_sexp_internal(const std::string& input, std::stringstream& output, int level) {
  //REprintf("%i %s\n", level, input.c_str());
  //size_t i = 0;
  //while (i < input.length()) {
    //switch (input[i]) {
      //case ')': --level;
      //case '(': ++level;
                //output << '\n' << std::string(level, ' ');
      //default:
                //output << input[i];
    //}
  //}
  //if (input[i] == '(') {
    //size_t start = i;
    //do {++i; } while(!(str[i] == ' ' || str[i] == ')'));
    //if (str[i] == ' ') {
      //s << '\n' << std::string((level + 1) * 2, ' ')
        //do {++i; } while(str[i] == ' ');
    //}
    //s << layout_sexp_internal(str.substr(start, i), output, level + 1);
    //return;
  //} else if (input[i] == ')') {
    //size_t start = i;
    //do {++i; --level; } while(str[i] == ')');
    //s << str.substr(start, i);
    //return;
  //}
  //++i;
//}

[[cpp11::register]]
rts_node tree_root(rts_tree t) {
  return new ast_node(ts_tree_root_node(t.get()), t);
}
