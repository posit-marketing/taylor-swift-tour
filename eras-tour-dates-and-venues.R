## -----------------------------------------------------------------------------
#| message: false
#| warning: false
#| label: setup-map
# To clean data
library(tidyverse)
library(janitor)

# To scrape data
library(rvest)
library(httr)
library(polite)

# To geocode data
library(tidygeocoder)

# To visualize data
library(leaflet)


## -----------------------------------------------------------------------------
#| label: url-map
url_map <-
  "https://www.sportskeeda.com/pop-culture/taylor-swift-2023-the-eras-tour-ticket-cities-and-dates"

url_map_bow <- polite::bow(url_map)
url_map_bow


## -----------------------------------------------------------------------------
#| label: scrape-map
map_html <-
  polite::scrape(url_map_bow) |>  # scrape web page
  rvest::html_nodes("tbody") |> # pull out specific table
  rvest::html_table(fill = TRUE) |>
  bind_rows() |>
  row_to_names(row_number = 1) |>
  clean_names()


## -----------------------------------------------------------------------------
#| label: geocode-map
#| message: false
map_html_geo <-
  map_html |> 
  geocode(venue, method = 'osm', lat = latitude , long = longitude)

map_html_geo <-
  map_html_geo |>
  mutate(
    latitude = case_when(
      venue == "Empower Field at Mile Hi" ~ 39.74359,
      venue == "Johan Cruyff Arena" ~ 52.3143,
      .default = latitude
    ),
    longitude = case_when(
      venue == "Empower Field at Mile Hi" ~ -105.01968,
      venue == "Johan Cruyff Arena" ~ 4.94187,
      .default = longitude
    )
  )


## -----------------------------------------------------------------------------
#| label: leaflet-map
#| results: false
leaflet() |>
  addProviderTiles("OpenStreetMap.HOT",
                   options = (noWrap = TRUE)) |> 
  addMarkers(
    data = map_html_geo,
    label = paste(
      "Venue: ",
      map_html_geo$venue,
      "<br>",
      "City: ",
      map_html_geo$city,
      "<br>",
      "Date: ",
      map_html_geo$date
    ) |>
      lapply(htmltools::HTML)
  )

