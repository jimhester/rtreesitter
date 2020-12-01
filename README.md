
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtreesitter

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/jimhester/rtreesitter/branch/main/graph/badge.svg)](https://codecov.io/gh/jimhester/rtreesitter?branch=main)
[![R-CMD-check](https://github.com/jimhester/rtreesitter/workflows/R-CMD-check/badge.svg)](https://github.com/jimhester/rtreesitter/actions)
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
library(rtreesitter)


lib_dir <- file.path(tempdir(), "rtreesitter")
lib <- file.path(lib_dir, "languages.so")

repos <- c(
  "tree-sitter/tree-sitter-python",
  "tree-sitter/tree-sitter-javascript",
  "jimhester/tree-sitter-r"
)
for (repo in repos) {
  processx::run("git", c("clone", "--depth=1", sprintf("https://github.com/%s", repo), file.path(lib_dir, basename(repo))))
}

build_library(lib, file.path(lib_dir, basename(repos)))

p_r <- rts_parser$new("tree_sitter_R")
p_r$parse("x <- function(x) 1")
#> {rts_tree}
#> (program (left_assignment name: (identifier) value: (function_definition (formal_parameters (identifier)) (float))))

p_py <- rts_parser$new("tree_sitter_python")
p_py$parse("
def foo():
    if bar:
       baz()
")
#> {rts_tree}
#> (module (function_definition name: (identifier) parameters: (parameters) body: (block (if_statement condition: (identifier) consequence: (block (expression_statement (call function: (identifier) arguments: (argument_list))))))))

p_js <- rts_parser$new("tree_sitter_javascript")
p_js$parse('
    let name = "world";
    alert("hello " + name);')
#> {rts_tree}
#> (program (lexical_declaration (variable_declarator name: (identifier) value: (string))) (expression_statement (call_expression function: (identifier) arguments: (arguments (binary_expression left: (string) right: (identifier))))))
```
