# Adapted from py-tree-sitter tests from https://github.com/tree-sitter/py-tree-sitter/blob/master/tests/test_tree_sitter.py

test_that("children works", {
  parser <- rts_parser$new("tree_sitter_python")
  tree <- parser$parse("def foo():\n  bar()")
  root_node <- tree$root_node
  expect_equal(root_node$type, "module")
  expect_equal(root_node$start_byte, 0)
  expect_equal(root_node$end_byte, 18)
  expect_equal(root_node$start_point, rts_point$new(0, 0))
  expect_equal(root_node$end_point, rts_point$new(1, 7))

  fn_node <- root_node$children[[1]]
  expect_equal(fn_node$type, "function_definition")
  expect_equal(fn_node$start_byte, 0)
  expect_equal(fn_node$end_byte, 18)
  expect_equal(fn_node$start_point, rts_point$new(0, 0))
  expect_equal(fn_node$end_point, rts_point$new(1, 7))

  def_node <- fn_node$children[[1]]
  expect_equal(def_node$type, "def")
  expect_equal(def_node$is_named, FALSE)

  id_node <-  fn_node$children[[2]]
  expect_equal(id_node$type, "identifier")
  expect_equal(id_node$is_named, TRUE)
  expect_equal(length(id_node$children), 0)

  params_node <-  fn_node$children[[3]]
  expect_equal(params_node$type, "parameters")
  expect_equal(params_node$is_named, TRUE)

  colon_node <-  fn_node$children[[4]]
  expect_equal(colon_node$type, ":")
  expect_equal(colon_node$is_named, FALSE)

  statement_node <-  fn_node$children[[5]]
  expect_equal(statement_node$type, "block")
  expect_equal(statement_node$is_named, TRUE)
})

test_that("node$by_field_id works", {
  parser <- rts_parser$new("tree_sitter_python")
  tree <- parser$parse("def foo():\n  bar()")
  root_node <- tree$root_node
  fn_node <- root_node$children[[1]]

  name_field <- parser$field_id_for_name("name")
  alias_field <- parser$field_id_for_name("alias")

  expect_type(name_field, "double")
  expect_type(alias_field, "double")

  expect_null(root_node$child_by_field_id(name_field))
  expect_null(root_node$child_by_field_id(alias_field))

  expect_equal(fn_node$child_by_field_id(name_field)$type, "identifier")
  expect_null(fn_node$child_by_field_id(alias_field))
})

test_that("node$by_field_name works", {
  parser <- rts_parser$new("tree_sitter_python")
  tree <- parser$parse("def foo():\n  bar()")
  root_node <- tree$root_node
  fn_node <- root_node$children[[1]]
  nme <- fn_node$child_by_field_name("name")
  expect_equal(nme$type, "identifier")
  expect_true(is.null(fn_node$child_by_field_name("arstarst")))
})

test_that("node$children works", {
  parser <- rts_parser$new("tree_sitter_python")
  code <- "def foo():\n  bar()\n\ndef foo():\n  bar()"
  tree <- parser$parse(code)
  for (item in tree$root_node$children) {
    expect_true(item$is_named)
  }
})

test_that("parser$query works", {
  parser <- rts_parser$new("tree_sitter_python")
  source <- "def foo():\n  bar()\ndef baz():\n  quux()\n"
  tree <- parser$parse(source)
  tree_root <- tree$root_node
  query <- parser$query("
    (function_definition name: (identifier) @func-def)
    (call function: (identifier) @func-call)
    ")
  captures <- query$captures(tree_root)

  expect_equal(length(captures), 4)

  expect_equal(captures[[1]]$start_point, rts_point$new(0, 4))
  expect_equal(captures[[1]]$end_point, rts_point$new(0, 7))
  expect_equal(names(captures)[[1]], "func-def")

  expect_equal(captures[[2]]$start_point, rts_point$new(1, 2))
  expect_equal(captures[[2]]$end_point, rts_point$new(1, 5))
  expect_equal(names(captures)[[2]], "func-call")

  expect_equal(captures[[1]]$start_point, rts_point$new(2, 4))
  expect_equal(captures[[1]]$end_point, rts_point$new(2, 7))
  expect_equal(names(captures)[[1]], "func-def")

  expect_equal(captures[[2]]$start_point, rts_point$new(3, 2))
  expect_equal(captures[[2]]$end_point, rts_point$new(3, 6))
  expect_equal(names(captures)[[2]], "func-call")
})
