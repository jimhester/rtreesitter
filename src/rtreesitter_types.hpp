#include "tree_sitter/api.h"
#include <cpp11.hpp>

using rts_parser = cpp11::external_pointer<TSParser, ts_parser_delete>;

using rts_tree = cpp11::external_pointer<TSTree, ts_tree_delete>;
