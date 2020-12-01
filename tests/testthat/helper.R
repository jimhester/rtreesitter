test_library_dir <- file.path(tempdir(), "rtreesitter")
test_library <- file.path(test_library_dir, "languages.so")
if (!file.exists(test_library)) {
  repos <- c(
    "tree-sitter/tree-sitter-python",
    "tree-sitter/tree-sitter-javascript",
    "jimhester/tree-sitter-r"
  )
  for (repo in repos) {
    processx::run("git", c("clone", "--depth=1", sprintf("https://github.com/%s", repo), file.path(test_library_dir, basename(repo))))
  }
  build_library(test_library, file.path(test_library_dir, basename(repos)))
}
