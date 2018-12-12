

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
s <- shinyServer(
  function(input, output)
  {
    r_stats_text_corpus <- Corpus(VectorSource(data))
    
    matadj <- reactive({
      tdm <-TermDocumentMatrix(r_stats_text_corpus, control = list(wordLenghts = c(1, Inf)))
      idx <-which(dimnames(tdm)$Terms == "call") ##change the terms to be searched
      tdm2 <- removeSparseTerms(tdm, sparse = input$sparse)
      m2 <- as.matrix(tdm2)
      m2[m2 >= 1] <- 1
      m2 <- m2 %*% t(m2) ##Adjaceny Matrix - how often words co-occur in a sentence
      m2
    })
    
    fit <- reactive({
      fit <- hclust(dist(matadj()))
    })
    
    fmrlayout <- reactive({
      set.seed(input$fmrseed)
      g <- graph.adjacency(matadj(), weighted = T, mode = "undirected")
      g <- simplify(g)
      V(g)$label <- V(g)$name
      V(g)$degree <- degree(g)
      layout <- layout.fruchterman.reingold(g)
      rv <- list()
      rv$g <- g
      rv$layout <- layout
      rv
    })
    
    radialnet <- reactive({
      set.seed(input$fmrseed)
      radial <- as.radialNetwork(fit())
    })  
    
    ###Different Social Network Graphics
    
    #Radial Network
    output$radial <- renderRadialNetwork({
      radialNetwork(radialnet())
    })
    output$radial1 <- renderRadialNetwork({
      radialNetwork(radialnet())
    })
    
    # Fruchterman-Reingold Network
    output$fmr <- renderPlot({
      rv <- fmrlayout()
      plot(rv$g, layout = rv$layout)
    })
    output$fmr1 <- renderPlot({
      rv <- fmrlayout()
      plot(rv$g, layout = rv$layout)
    })
  }
)