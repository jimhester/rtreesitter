
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtreesitter

<!-- badges: start -->

<!-- badges: end -->

rtreesitter provides R bindings to the
[tree-sitter](https://tree-sitter.github.io/tree-sitter/) parsing
library.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("jimhester/rtreesitter")
```

## Usage

``` bash
mkdir vendor
cd vendor
git clone https://github.com/jimhester/tree-sitter-r
git clone https://github.com/tree-sitter/tree-sitter-python
git clone https://github.com/tree-sitter/tree-sitter-javascript
git clone https://github.com/tree-sitter/tree-sitter-go
```

``` r
pkgload::load_all("~/p/rtreesitter")
#> Loading rtreesitter

build_library("build/my-languages.so",
  c("vendor/tree-sitter-r",
    "vendor/tree-sitter-python",
    "vendor/tree-sitter-javascript",
    "vendor/tree-sitter-go")
)

out <- dyn.load("build/my-languages.so")
p_r <- parser_new("tree_sitter_R")
tree_sexp(parser_parse(p_r, "x <- function(x) 1"))
#> [1] "(program (left_assignment name: (identifier) value: (function_definition (formal_parameters (identifier)) (float))))"

p_py <- parser_new("tree_sitter_python")
tree_sexp(parser_parse(p_py,
"
def foo():
    if bar:
       baz()
"))
#> [1] "(module (function_definition name: (identifier) parameters: (parameters) body: (block (if_statement condition: (identifier) consequence: (block (expression_statement (call function: (identifier) arguments: (argument_list))))))))"


p_go <- parser_new("tree_sitter_go")

tree_sexp(parser_parse(p_go,
'package main
import "fmt"
func main() {
    fmt.Println("hello world")
}'))
#> [1] "(source_file (package_clause (package_identifier)) (import_declaration (import_spec path: (interpreted_string_literal))) (function_declaration name: (identifier) parameters: (parameter_list) body: (block (call_expression function: (selector_expression operand: (identifier) field: (field_identifier)) arguments: (argument_list (interpreted_string_literal))))))"

p_js <- parser_new("tree_sitter_javascript")
tree_sexp(parser_parse(p_js, '
    let name = "world";
    alert("hello " + name);'))
#> [1] "(program (lexical_declaration (variable_declarator name: (identifier) value: (string))) (expression_statement (call_expression function: (identifier) arguments: (arguments (binary_expression left: (string) right: (identifier))))))"
```
