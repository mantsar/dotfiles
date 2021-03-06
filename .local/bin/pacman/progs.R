#!/usr/bin/env/R

install.packages(c(
  "tidyverse",
  "devtools",
  "shiny",
  "shinyjs",
  "shinydashboard",
  "waiter",
  "shinyWidgets",
  "shinycssloaders",
  "DT",
  "glue",
  "data.table",
  "mongolite",
  "curl",
  "rmarkdown",
  "plotly",
  "rlist",
  "remotes",
  "shinyAce",
  "pacman",
  "kableExtra",
  "Hmisc",
  "uuid",
  "rhandsontable",
  "tinytex",
  "reticulate",
  "shinytest",
  "pool"
))
devtools::install_github("REditorSupport/languageserver")
remotes::install_github("rstudio/renv")
remotes::install_github("rstudio/shinyvalidate")
remotes::install_github("gadenbuie/regexplain")
tinytex::install_tinytex()

# Use persistent cache for formatting by styler
R.cache::getCachePath()
