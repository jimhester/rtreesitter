#' Build a tree sitter library
#' @param output_path Path where the shared library should be built.
#' @param repo_paths Paths to one or more local tree-sitter repositories.
#' @export
build_library <- function(output_path, repo_paths) {
  repo_files <- character()
  for (repo in repo_paths) {
    repo_src <- normalizePath(file.path(repo, "src"))
    repo_files <- append(repo_files, list.files(path = repo_src, pattern = "(parser|scanner)[.]cc?", full.names = TRUE))
    callr::rcmd("COMPILE", c(sprintf("PKG_CPPFLAGS=-I%s", repo_src), repo_files), fail_on_status = TRUE)
  }
  callr::rcmd("SHLIB", c("--output", output_path, repo_files), fail_on_status = TRUE)
  out <- dyn.load(output_path)
  invisible(out)
}
