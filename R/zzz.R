#' .onAttach function for the 'phyloPipeR' package
#'
#' It is executed when the 'phyloPipeR' package is loaded. It checks if the 'crayon' package
#' is available to display a colorful welcome message. If 'crayon' is not found, a simpler message
#' is shown.
#'
#' @param libname Character string; the library name.
#' @param pkgname Character string; the package name.
#'
#' @importFrom crayon green blue magenta bold
#' @importFrom utils packageVersion
#'
#' @export
.onAttach <- function(libname, pkgname) {
  old_warn <- getOption("warn.conflicts")
  options(warn.conflicts = FALSE)

  if (requireNamespace("crayon", quietly = TRUE)) {
    green <- crayon::green
    blue <- crayon::blue
    magenta <- crayon::magenta
    bold <- crayon::bold

    packageStartupMessage(
      "\n", bold(green("==========================================\n")),
      bold(blue("       \U1F33F Welcome to phyloPipeR \U1F33F\n")),
      bold(magenta("  Phylogenetic Analysis Made Simple\n")),
      bold(green("==========================================\n")),
      "Version: ", utils::packageVersion("phyloPipeR"), "\n",
      "Author : Feifei Li & Bo Li\n",
      "Help   : type ", bold(blue("help(package = 'phyloPipeR')")), " to get started.\n"
    )
  } else {
    packageStartupMessage(
      "\n*** Welcome to phyloPipeR ***\n",
      "Version: ", utils::packageVersion("phyloPipeR"), "\n"
    )
  }

  options(warn.conflicts = old_warn)
  invisible()
}


.onLoad <- function(libname, pkgname) {
  # 1. Preserve original options and disable conflict warnings temporarily
  old_opts <- options(warn.conflicts = FALSE)
  assign(".temp_options", old_opts, envir = parent.env(environment()))

  # 2. Silently load 'dendextend' namespace; warn if not installed
  suppressMessages({
    if (!requireNamespace("dendextend", quietly = TRUE)) {
      warning("Package 'dendextend' not installed. Some functions may not work.")
    }
  })

  # 3. Handle rgl safely on macOS / Unix-like systems
  #    Use null device to avoid OpenGL errors in headless or M-series Mac environments
  if (.Platform$OS.type == "unix") {
    # Only set RGL_USE_NULL if the user hasn't manually set it
    if (Sys.getenv("RGL_USE_NULL") == "") {
      Sys.setenv(RGL_USE_NULL = "TRUE")
      message("rgl detected: using null device to avoid OpenGL errors on macOS/Linux")
    }
  }

  # 4. Return invisibly (standard practice for .onLoad)
  invisible()
}
