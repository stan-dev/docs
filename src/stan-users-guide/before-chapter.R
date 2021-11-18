# LIBRARY CONFIGURATION

library(dplyr)
library(ggplot2)
library(kableExtra)

library(knitr)
  knitr::opts_chunk$set(
    cache = TRUE,
    collapse = TRUE,
    comment = NA,
    dev = "png",
    dpi = 150,
    echo = FALSE,
    fig.align = "center",
    fig.width = 6,
    fig.asp = 0.618,  # 1 / phi
    fig.show = "hold",
    include = TRUE,
    message = FALSE,
    out.width = "70%",
    tidy = FALSE,
    warning = FALSE
  )

# GENERAL R CONFIGURATION

options(digits = 2)
options(htmltools.dir.version = FALSE)

