library(wordcloud)
library(tidyverse)   
library(stringr)      
library(tidytext)
library(shiny)
library(rsconnect)

s <- shinyServer(
  function(input, output, session) {
    terms <- reactive({getWords(input$selection)})
    
    wordcloud_rep <- repeatable(wordcloud)
    output$plot <- renderPlot({
      v <- terms()
      wordcloud_rep(v, scale=c(4,0.5),
                    min.freq = input$freq, 
                    colors=brewer.pal(8, "Dark2"))})})
