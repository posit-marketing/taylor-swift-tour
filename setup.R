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
library(htmltools)
library(leaflet)
library(leaflet.extras)
library(shiny)

# Other
library(confetti)
library(glue)

sysfonts::font_add_google("Abril Fatface", "abril-fatface")
sysfonts::font_add_google("Lato", "lato")

showtext::showtext_auto()

# Surprise!
confetti::diy_confetti("confetti")