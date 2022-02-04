#' @title Tutorial submission functions
#'
#' @description
#' The following function has modified from Colin
#' Rundel's learnrhash package, available at
#' https://github.com/rundel/learnrhash. Many thanks to Professor Rundel, who
#' has developed a fantastic tool for courses that teach R and use the learnr
#' package.
#'
#' Adapted by sjgknight from mattblackwell/qsslearnr
#'
#' This note is also modified from Professor Rundel's description: Note that when
#' including these functions in a learnr Rmd document it is necessary that the
#' server function, `submission_server()`, be included in an R chunk where
#' `context="server"`. Conversely, any of the ui functions, `*_ui()`, must *not*
#' be included in an R chunk with a `context`.
#'
#' @rdname submission_functions
#' @export
submission_server <- function(input, output) {
  p <- parent.frame()
  check_server_context(p)
  
  # Evaluate in parent frame to get input, output, and session
  local({
    
    process_learnr <- function() {
      # Set up parameters to pass to Rmd document
      objs <- learnr:::get_all_state_objects(session)
      skips <- learnr:::section_skipped_progress_from_state_objects(objs)
      subs <- learnr:::submissions_from_state_objects(objs)
      ##browser()
      out <- tibble::tibble(
        id = purrr::map_chr(subs, "id"),
        answers = purrr::map_chr(subs, list("data", "answer"),
                                 .default = NA),
        checked = purrr::map_lgl(subs, list("data", "checked"),
                                 .default = NA),
        correct = purrr::map_lgl(subs, list("data", "feedback", "correct"),
                                 .default = NA)
      )
      out$attempted <- !is.na(out$answers) | out$checked
      params <<- list(reporttitle = tut_reptitle,
                      output = out,
                      student_name = input$name,
                      skipped = length(skips))
      
    }
    
    build_report <- function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "tutorial-report.Rmd")
      file.copy(here::here("tutorial-report.Rmd"), tempReport, overwrite = TRUE)
      
      
      process_learnr()
      
      ext <- tools::file_ext(file)
      #out_format <- switch(ext, pdf = "pdf_document", html = "html_document")
      out_format <- switch(ext, html = "html_document")
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(
        tempReport,
        output_format = out_format,
        output_file = file,
        params = params,
        envir = new.env(parent = globalenv())
      )
    }
    # output$download_pdf <- downloadHandler(
    #   filename = "report.pdf",
    #   content = build_report
    # )
    
    output$download_html <- downloadHandler(
      filename = "report.html",
      content = build_report
    )
    
    #This creates a URL, at the moment only for outlook.office links to send results
    
    send_emails <- shiny::eventReactive(input$send_email, {
      #make sure params has run
      #if(!exists("params")) { process_learnr() }
      
      #or use the function from learnrhash
      # shiny::getDefaultReactiveDomain()$userData$tutorial_state
      state = learnr:::get_tutorial_state()
      shiny::validate(shiny::need(length(state) > 0, "No progress yet."))
      
      user_state = purrr::map_dfr(state, identity, .id = "label")
      user_state = dplyr::group_by(user_state, .data$label, .data$type, .data$correct)
      user_state = dplyr::summarize(
        user_state,
        answer = list(.data$answer),
        timestamp = dplyr::first(.data$timestamp),
        .groups = "drop")
      
      user_state = dplyr::relocate(user_state, .data$correct, .before = .data$timestamp)
      
      body_text <- paste0("report title: ",
                          tut_reptitle,
                          ", student name: ", 
                          input$name, 
                          # ", how many completed: ", 
                          # params$skipped, 
                          ", output: ", 
                          learnrhash::encode_obj(user_state))
                          #learnrhash::encode_obj(params))
                          #paste(params$output, collapse = ","))
      
      body = paste0("&body=",body_text)
      #body = paste0("&body=",build_report())
      #body = NULL
      instructor_email = paste0("&to=",input$instructor_email)
      subject = paste0("subject=DSI learnr activity", Sys.Date())
      composer_string = "https://outlook.office.com/mail/0/deeplink/compose?"
      
      email <- paste0(composer_string,subject,instructor_email,body)
      
      #email <- glue::glue("window.open('{email}', '_blank')")
      
      email    
      })
    
    output$send_email_url <- shiny::renderText(send_emails())
    
      
  }, envir = p)
}

check_server_context <- function(.envir) {
  if (!is_server_context(.envir)) {
    calling_func <- deparse(sys.calls()[[sys.nframe() - 1]])
    
    err <- paste0(
      "Function `", calling_func, "`",
      " must be called from an Rmd chunk where `context = \"server\"`"
    )
    
    stop(err, call. = FALSE)
  }
}

is_server_context <- function(.envir) {
  # We are in the server context if there are the follow:
  # * input - input reactive values
  # * output - shiny output
  # * session - shiny session
  #
  # Check context by examining the class of each of these.
  # If any is missing then it will be a NULL which will fail.
  
  inherits(.envir$input,   "reactivevalues") &
    inherits(.envir$output,  "shinyoutput")    &
    inherits(.envir$session, "ShinySession")
}

#' @rdname submission_functions
#' @export
submission_ui <- shiny::div(
  "When you have completed this tutorial, you can generate a report below. This will create a html version, and allow you to email a copy of this to me:",
  shiny::tags$br(),
  shiny::tags$ol(
    shiny::tags$li("Enter your name into the text box below..."),
    #shiny::tags$li("Click the Download button next to generate a report PDF with a summary of your work. "),
    shiny::tags$li("Upload this file as requested.")),
  shiny::textInput("name", "Your Name"),
  shiny::textInput("instructor_email","your instructor's email (probably Simon)", "simon.knight@uts.edu.au"),
  #shiny::downloadButton(outputId = "download_pdf", label = "Download PDF"),
  shiny::downloadButton(outputId = "download_html", label = "Download HTML (backup)"),
  #shiny::textOutput("send_emails"),
  shiny::actionButton(inputId = "send_email", label = "Send email to me using URL below"),
  shiny::verbatimTextOutput("send_email_url")
  
)


utils::globalVariables(c("input", "session", "download_report"))