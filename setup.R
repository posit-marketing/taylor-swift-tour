# Load packages
library(tidyverse)
library(janitor)

# To scrape data
library(rvest)
library(httr)
library(polite)

# To visualize data
library(ggplot2)
library(ggpattern)
library(showtext)
library(bslib)
library(bsicons)
library(glue)
library(htmltools)
library(leaflet)
library(shiny)
library(confetti)

font_add_google("Abril Fatface", "abril-fatface")
font_add_google("Lato", "lato")

showtext::showtext_auto()

# Surprise!
diy_confetti("confetti")