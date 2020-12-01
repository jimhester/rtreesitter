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

# python tests from https://github.com/tree-sitter/py-tree-sitter/blob/master/tests/test_tree_sitter.py
#class TestNode(TestCase):
    #def test_child_by_field_id(self):
        #parser = Parser()
        #parser.set_language(PYTHON)
        #tree = parser.parse(b"def foo():\n  bar()")
        #root_node = tree.root_node
        #fn_node = tree.root_node.children[0]

        #self.assertEqual(PYTHON.field_id_for_name("nameasdf"), None)
        #name_field = PYTHON.field_id_for_name("name")
        #alias_field = PYTHON.field_id_for_name("alias")
        #self.assertIsInstance(alias_field, int)
        #self.assertIsInstance(name_field, int)
        #self.assertEqual(root_node.child_by_field_id(alias_field), None)
        #self.assertEqual(root_node.child_by_field_id(name_field), None)
        #self.assertEqual(fn_node.child_by_field_id(alias_field), None)
        #self.assertEqual(fn_node.child_by_field_id(name_field).type, "identifier")
        #self.assertRaises(TypeError, root_node.child_by_field_id, "")
        #self.assertRaises(TypeError, root_node.child_by_field_name, True)
        #self.assertRaises(TypeError, root_node.child_by_field_name, 1)

        #self.assertEqual(fn_node.child_by_field_name("name").type, "identifier")
        #self.assertEqual(fn_node.child_by_field_name("asdfasdfname"), None)

        #self.assertEqual(
            #fn_node.child_by_field_name("name"),
            #fn_node.child_by_field_name("name"),
        #)

    #def test_named_and_sibling_and_count_and_parent(self):
        #parser = Parser()
        #parser.set_language(PYTHON)
        #tree = parser.parse(b"[1, 2, 3]")

        #root_node = tree.root_node
        #self.assertEqual(root_node.type, "module")
        #self.assertEqual(root_node.start_byte, 0)
        #self.assertEqual(root_node.end_byte, 9)
        #self.assertEqual(root_node.start_point, (0, 0))
        #self.assertEqual(root_node.end_point, (0, 9))

        #exp_stmt_node = root_node.children[0]
        #self.assertEqual(exp_stmt_node.type, "expression_statement")
        #self.assertEqual(exp_stmt_node.start_byte, 0)
        #self.assertEqual(exp_stmt_node.end_byte, 9)
        #self.assertEqual(exp_stmt_node.start_point, (0, 0))
        #self.assertEqual(exp_stmt_node.end_point, (0, 9))
        #self.assertEqual(exp_stmt_node.parent,
                         #root_node)

        #list_node = exp_stmt_node.children[0]
        #self.assertEqual(list_node.type, "list")
        #self.assertEqual(list_node.start_byte, 0)
        #self.assertEqual(list_node.end_byte, 9)
        #self.assertEqual(list_node.start_point, (0, 0))
        #self.assertEqual(list_node.end_point, (0, 9))
        #self.assertEqual(list_node.parent,
                         #exp_stmt_node)

        #open_delim_node = list_node.children[0]
        #self.assertEqual(open_delim_node.type, "[")
        #self.assertEqual(open_delim_node.start_byte, 0)
        #self.assertEqual(open_delim_node.end_byte, 1)
        #self.assertEqual(open_delim_node.start_point, (0, 0))
        #self.assertEqual(open_delim_node.end_point, (0, 1))
        #self.assertEqual(open_delim_node.parent,
                         #list_node)

        #first_num_node = list_node.children[1]
        #self.assertEqual(first_num_node,
                         #open_delim_node.next_named_sibling)
        #self.assertEqual(first_num_node.parent,
                         #list_node)

        #first_comma_node = list_node.children[2]
        #self.assertEqual(first_comma_node,
                         #first_num_node.next_sibling)
        #self.assertEqual(first_num_node,
                         #first_comma_node.prev_sibling)
        #self.assertEqual(first_comma_node.parent,
                         #list_node)

        #second_num_node = list_node.children[3]
        #self.assertEqual(second_num_node,
                         #first_comma_node.next_sibling)
        #self.assertEqual(second_num_node,
                         #first_num_node.next_named_sibling)
        #self.assertEqual(first_num_node,
                         #second_num_node.prev_named_sibling)
        #self.assertEqual(second_num_node.parent,
                         #list_node)

        #second_comma_node = list_node.children[4]
        #self.assertEqual(second_comma_node,
                         #second_num_node.next_sibling)
        #self.assertEqual(second_num_node,
                         #second_comma_node.prev_sibling)
        #self.assertEqual(second_comma_node.parent,
                         #list_node)

        #third_num_node = list_node.children[5]
        #self.assertEqual(third_num_node,
                         #second_comma_node.next_sibling)
        #self.assertEqual(third_num_node,
                         #second_num_node.next_named_sibling)
        #self.assertEqual(second_num_node,
                         #third_num_node.prev_named_sibling)
        #self.assertEqual(third_num_node.parent,
                         #list_node)

        #close_delim_node = list_node.children[6]
        #self.assertEqual(close_delim_node.type, "]")
        #self.assertEqual(close_delim_node.start_byte, 8)
        #self.assertEqual(close_delim_node.end_byte, 9)
        #self.assertEqual(close_delim_node.start_point, (0, 8))
        #self.assertEqual(close_delim_node.end_point, (0, 9))
        #self.assertEqual(close_delim_node,
                         #third_num_node.next_sibling)
        #self.assertEqual(third_num_node,
                         #close_delim_node.prev_sibling)
        #self.assertEqual(third_num_node,
                         #close_delim_node.prev_named_sibling)
        #self.assertEqual(close_delim_node.parent,
                         #list_node)

        #self.assertEqual(list_node.child_count, 7)
        #self.assertEqual(list_node.named_child_count, 3)
