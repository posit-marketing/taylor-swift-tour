## -----------------------------------------------------------------------------
#| message: false
#| warning: false
# To clean data
library(tidyverse)
library(janitor)

# To scrape data
library(rvest)
library(httr)
library(polite)

# To visualize data
library(ggplot2)
library(showtext)
library(viridis)

font_add_google("Abril Fatface", "abril-fatface")
font_add_google("Lato", "lato")

showtext::showtext_auto()


## -----------------------------------------------------------------------------
url <-
  "https://en.wikipedia.org/wiki/List_of_highest-grossing_concert_tours"


## -----------------------------------------------------------------------------
#| message: false
url_bow <- polite::bow(url)
url_bow


## -----------------------------------------------------------------------------
ind_html <-
  polite::scrape(url_bow) |>  # <1>
  rvest::html_nodes("table.wikitable") |> # <2>
  rvest::html_table(fill = TRUE) 


## -----------------------------------------------------------------------------
ind_tab <- 
  ind_html[[2]] |> 
  clean_names()


## -----------------------------------------------------------------------------
ind_tab_clean <-
  ind_tab |>
  dplyr::mutate(across(
    c(adjusted_gross_in_2022_dollars,
      actual_gross,
      averagegross),
    ~ as.numeric(str_replace_all(.x, "[$,]", ""))
  ))


## -----------------------------------------------------------------------------
ind_tab_tay <-
  ind_tab_clean |> 
  add_row(artist = "Taylor Swift",
          tour_title = "The Eras Tour (Expected)",
          year_s = "2023-2024",
          shows = 146,
          adjusted_gross_in_2022_dollars = 1400000000,
          .before = 1)


## -----------------------------------------------------------------------------
#| results: hide
#| out.width: 400px
#| dpi: 300
#| fig.show: hide
#| fig.path: "../images/"
#| label: highest-grossing-tours-r
ind_tab_tay |>
  slice(1:10) |> 
  mutate(color = case_when(artist == "Taylor Swift" ~ "#D3ABD0",
                           .default = "#903345")) |>
  ggplot(aes(x = forcats::fct_reorder(tour_title,
                             adjusted_gross_in_2022_dollars),
             y = adjusted_gross_in_2022_dollars)) +
  geom_col(aes(fill = color),
           color = "black",
           width = .9) +
  scale_fill_identity() +
  labs(title = "Highest-grossing tours of all time",
       subtitle = "(as of 2023)") +
  theme(text = element_text(size = 9,
                            family = "lato"),
        title = element_text(size = 16,
                             family = "abril-fatface")) +
  geom_text(aes(y = 12000000, label = tour_title),
            family = "lato",
            hjust = 0,
            vjust = 0.5,
            size = 3,
            color = "white",
            fontface = "bold") +
  geom_text(aes(y = 12000000,
                label = ifelse(artist == "Taylor Swift", tour_title, "")),
            family = "lato",
            hjust = 0,
            vjust = 0.5,
            size = 3,
            color = "black",
            fontface = "bold") +
  geom_text(aes(
      label = scales::dollar(
        adjusted_gross_in_2022_dollars,
        accuracy = 1,
        scale = 1e-6,
        suffix = "M")),
      family = "lato",
      hjust = -0.1,
      vjust = 0.5,
      size = 3) +
  coord_flip() +
  scale_y_continuous(limits = c(0, 1500000000)) +
  scale_x_discrete(labels = ind_tab_tay |> slice(1:10) |> arrange(adjusted_gross_in_2022_dollars) |> pull(artist)) +
  theme(panel.background = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank())


## -----------------------------------------------------------------------------
#| results: hide
#| out.width: 400px
#| dpi: 300
#| fig.show: hide
#| fig.path: "../images/"
#| label: highest-grossing-tours-r-images
library(ggpattern)

taylor <- here::here("notebooks", "tours-images", "taylor.jpg")
u2 <- here::here("notebooks", "tours-images", "u2.jpg")
elton <- here::here("notebooks", "tours-images", "elton.jpg")
ed <- here::here("notebooks", "tours-images", "ed.jpg")
stones <- here::here("notebooks", "tours-images", "stones.jpg")
gnr <- here::here("notebooks", "tours-images", "gnr.jpg")
coldplay <- here::here("notebooks", "tours-images", "coldplay.jpg")
harry <- here::here("notebooks", "tours-images", "harry.jpg")
beyonce <- here::here("notebooks", "tours-images", "beyonce.jpg")

ind_tab_tay |>
  slice(1:10) |> 
  ggplot(aes(x = forcats::fct_reorder(tour_title,
                             adjusted_gross_in_2022_dollars),
             y = adjusted_gross_in_2022_dollars)) +
  geom_bar_pattern(aes(x = forcats::fct_reorder(tour_title,
                             adjusted_gross_in_2022_dollars),
                       y = adjusted_gross_in_2022_dollars,
                   pattern_filename = as.factor(artist)),
                   alpha = 0,
                   pattern = "image",
                   pattern_type = "squish",
                   stat = "identity") +
  scale_pattern_filename_manual(
    values = c(`Taylor Swift` = taylor, 
               `Elton John` = elton, 
               `Ed Sheeran` = ed,
               `U2` = u2,
               `Coldplay` = coldplay,
               `Harry Styles` = harry,
               `Guns N' Roses` = gnr,
               `Beyonce` = beyonce,
               `The Rolling Stones` = stones)) +
  scale_fill_identity() +
  labs(title = "Highest-grossing tours of all time",
       subtitle = "(as of 2023)") +
  theme(text = element_text(size = 9,
                            family = "lato"),
        title = element_text(size = 16,
                             family = "abril-fatface")) +
  geom_text(aes(y = 12000000, label = tour_title),
            family = "lato",
            hjust = 0,
            vjust = 0.5,
            size = 3,
            color = "white",
            fontface = "bold") +
  geom_text(aes(y = 12000000,
                label = ifelse(artist == "Taylor Swift", tour_title, "")),
            family = "lato",
            hjust = 0,
            vjust = 0.5,
            size = 3,
            color = "black",
            fontface = "bold") +
  geom_text(aes(
      label = scales::dollar(
        adjusted_gross_in_2022_dollars,
        accuracy = 1,
        scale = 1e-6,
        suffix = "M")),
      family = "lato",
      hjust = -0.1,
      vjust = 0.5,
      size = 3) +
  coord_flip() +
  scale_y_continuous(limits = c(0, 1500000000)) +
  scale_x_discrete(labels = ind_tab_tay |> slice(1:10) |> arrange(adjusted_gross_in_2022_dollars) |> pull(artist)) +
  theme(panel.background = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank())

