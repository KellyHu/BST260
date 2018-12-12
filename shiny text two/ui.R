
library(shiny)
library(NLP)
library(tm)
library(igraph)
library(networkD3)
library(rsconnect)
library(wordcloud)
library(tidyverse)   
library(stringr)      
library(tidytext)

food <- read.csv("food_coded.csv",stringsAsFactors = FALSE) 

data <- food[,names(food) %in% c("comfort_food","comfort_food_reasons")] 
data <- do.call(paste, c(food[c("comfort_food", "comfort_food_reasons")], sep = ". ")) %>% str_to_lower()
u <- shinyUI(fluidPage(
  titlePanel("Junk food and mental health with network analysis"),
  
  sidebarLayout(
    position = "left",
    sidebarPanel(
      h2("Controls"),
      sliderInput("sparse", "Sparsity:", 0.9, 1, 0.994,0.002),
      numericInput("fmrseed", "F-R Seed:", 1234, 1, 10000, 1)
    ),
    mainPanel(
      h2("Network Graphs"),
      tabsetPanel(
        tabPanel("Radial",radialNetworkOutput("radial")),
        tabPanel("Fruchterman-Reingold", plotOutput("fmr"))
      )
    )
  ))
)