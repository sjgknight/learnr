
runlearnr <- function(tutname,submitway = "r/passr.Rmd") {
  library(rlang)
  
  suppressWarnings({
  
    reports <- c(tutname,submitway) %>%
    lapply(readLines) %>%
    unlist

  tmpFile <- writeLines(reports, paste0(fs::path_dir(tutname),"/tmpReport.Rmd"))
  
  #expr <- quote(rmarkdown::run(paste0(fs::path_dir(tutname),"/tmpReport.Rmd"), shiny_args = list(launch.browser = TRUE))) #quote returns argument. The argument is not evaluated and can be any R expression.
  #expr <- paste0("rmarkdown::run('",fs::path_dir(tutname),"/tmpReport.Rmd', shiny_args = list(launch.browser = TRUE))")
  #safe(args = list((eval(parse(text=expr))))) #The injection operator !! injects a value or expression inside another expression. In other words, it modifies a piece of code before R evaluates it.
  
  run_tutorial(paste0(fs::path_dir(tutname),"/tmpReport.Rmd"), shiny_args = list(launch.browser = T))

  })

}
