library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Recipe Finder"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    sidebarPanel(
      # Sidebar panel for inputs ----
      fileInput("file_csv", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      fileInput("file_json", "Choose Json File",
                multiple = FALSE,
                accept = c("text/json",
                           "text/comma-separated-values,text/plain",
                           ".json"))
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      textOutput("result")
    )
  )
)