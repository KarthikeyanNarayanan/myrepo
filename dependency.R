try(require(shiny) || install.packages("shiny"))
if (!require(udpipe)){install.packages("udpipe")}
if (!require(textrank)){install.packages("textrank")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(stringr)){install.packages("stringr")}

library(shiny)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggplot2)
library(ggraph)
library(wordcloud)
library(stringr)
