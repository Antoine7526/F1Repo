library(shiny)
library(shinythemes)
library(shinydashboard)
library(dashboardthemes)

ui <- dashboardPage(
  #Tableau du haut 
  dashboardHeader(title = tags$img(src='logoF1.png', height = '40', width ='160')),
  #Tableau de gauche 
  dashboardSidebar(       
    sidebarMenu(
      menuItem("Accueil", tabName = "Accueil",icon = icon("home")),
      menuItem("Pilotes", tabName = "Pilotes",icon = icon("user")),
      menuItem("Ecuries", tabName = "Ecuries",  icon = icon("users")),
      menuItem("Abandon", tabName = "Abandon",icon = icon("car-crash")),
      menuItem("Rapport", tabName = "Rapport",icon = icon("book-open"),              
               menuSubItem("Introduction", tabName = "Introduction"),
               menuSubItem("Conclusion", tabName = "Conclusion")),
      menuItem("Questionnaire", tabName = "Questionnaire",icon = icon("question")),
      menuItem("Source",icon = icon("database"), href = "https://www.formula1.com/en/results.html/2021/races.html")
    )
  ),
  dashboardBody(
    #Theme général
    dashboardthemes::shinyDashboardThemes(
      theme = "grey_dark"
    ),
    #On remplit ici par page
    tabItems(
      tabItem("Accueil",
              fixedRow(
                column(width = 4, align ="center",
                tags$img(src='voiturebis.png', height = '187', width ='333'))),
              fixedRow(column(width = 12)),
              fixedRow(
                column(4, offset= 4,
                       tags$img(src='logoblanc.png', height = '120', width ='198'))),
              fixedRow(
                column(4, offset= 4,
                       tags$img(src='voiture.png', height = '284', width ='160')))
      )
    ),
  #Titre dans le navigateur 
  title = "Projet F1"
  )
)



server <- function(input, output) {
  # output$Accueil <- renderUI({
  #   c=HTML(paste("", "Voici une explication point par point des différents éléments que vous pouvez trouver sur le graphique. Vous pourrez, grâce à ces explications, tirer une interprétation des résultats que vous obtenez.","",sep="<br/>"))
  # })
  
}

shinyApp(ui = ui, server = server)

