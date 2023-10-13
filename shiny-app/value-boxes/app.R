library(bslib)
library(shiny)
library(bsicons)
library(glue)
library(readr)
spotify_data <- read_csv(
  "~/Dropbox/rstudio_git/taylor-swift-tour/data/spotify_data.csv", 
  col_types = cols(
    monthly_listeners_millions_rank = col_integer(), 
    monthly_listeners_millions = col_number()) 
)

vbs <- list()
cp <- c("#201F39", "#A91E47", "#7E6358", "#B0A49A", "#DDD8C9")

for (i in 1:5){
  
  row_vals <- spotify_data[i,]
  
  vbs[[row_vals$artist]] <-  
    list(
      layout_column_wrap(
        width = "250px",
        !!!list(
          value_box(
            title = h1(glue("{row_vals$artist} on Spotify")),
            value = NULL,
            p(),
            h4(glue("{row_vals$monthly_listeners_millions} million")),
            p("Monthly Spotify Listeners"),
            showcase = div(htmltools::img(src = glue("artist-images/{row_vals$artist}.png"), width="100%")),
            br(),
            hr(),
            br(),
            h4(glue("{row_vals$monthly_listeners_millions} million")),
            p("Spotify Follower"),
            style = glue('background-color: {cp[i%% 5+1]}!important;'),
          )
        )
      ),
      br()
    )
}



# tswift <- 
#   layout_column_wrap(
#     width = "250px",
#     !!!list(
#       value_box(
#         title = spotify_data[2,]$artist,
#         value = spotify_data[2,]$monthly_listeners_millions,
#         showcase = div(htmltools::img(src = "artist-images/Taylor Swift.png", width="100%")),
#         p("Monthly listeners on Spotify"),
#         style = glue('background-color: {cp[2]}!important;'),
#       ),
#       value_box(
#         title = spotify_data[2,]$artist,
#         value = spotify_data[2,]$monthly_listeners_millions,
#         showcase = bs_icon("spotify"),
#         p("Spotify followers"),
#         br(),
#         hr(),
#         br(),
#         h3("Another value"),
#         p("Another bit of text"),
#         style = glue('background-color: {cp[2]}!important;'),
#       )
#     )
#   )
# tswift


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Value boxes"),
  
  vbs
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
