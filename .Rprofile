library("magrittr")
## Set CRAN mirror:
local({
  r <- getOption("repos")
  r["CRAN"] <- c("https://cloud.r-project.org/")
  options(repos = r)
})

.libPaths('~/.R/library')

options(prompt="R> ", digits=4)
# browser_path <- system(paste("which", Sys.getenv("BROWSER")))
browser_path <- "/usr/bin/firefox"
options(shiny.autoreload = TRUE, browser = browser_path)
