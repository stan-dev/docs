# "Available Since" quarto extension

This adds the custom logic we need to be able to write
```
{{< since 2.0 >}}
```
In the Functions Reference and have it rendered as a nicely-formatted
"Available Since 2.0" string.


This is a replacement for the following R code we used to have:


```R
since <- function(x) {
  x <- paste("Available since", x)
  if (knitr::is_latex_output()) {
    sprintf("\\newline\\mbox{\\small\\emph{%s}}", x)
  } else if (knitr::is_html_output()) {
    sprintf("<br/><small><i>%s</i></small>", x)
  } else x
}
```
