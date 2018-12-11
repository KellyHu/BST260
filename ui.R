library(wordcloud)
library(tidyverse)   
library(stringr)      
library(tidytext)
library(shiny)
library(rsconnect)
u <- shinyUI(fluidPage(
  titlePanel("Word Cloud for text variables in our dataset"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selection", "Choose a variable:",
                  choices = food_health),
      hr(),
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 20, value = 5)),
    mainPanel(plotOutput("plot")))))