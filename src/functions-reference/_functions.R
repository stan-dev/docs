since <- function(x) {
  x <- paste("Available since", x)
  if (knitr::is_latex_output()) {
    sprintf("\\newline\\mbox{\\small\\emph{%s}}", x)
  } else if (knitr::is_html_output()) {
    sprintf("<br/><small><i>%s</i></small>", x)
  } else x
}


