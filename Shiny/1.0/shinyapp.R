library(shiny)
library(shinythemes)
library(shinydashboard)
library(dashboardthemes)
library(shinydashboardPlus)

ui <- dashboardPage(
  #Tableau du haut 
  header = dashboardHeader(title = tags$img(src='logoF1.png', height = '40', width ='160')),
  #Tableau de gauche 
  sidebar = dashboardSidebar(       
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
  body = dashboardBody(
    
    #On remplit ici par page
    tabItems(
      tabItem(tabName = "Accueil",fluidRow(column(width = 12, align= "center",tags$img(src='voiturebis.png', height = '374', width ='666'))),
                                  fluidRow(column(width = 6, offset = 3, align = "center",includeMarkdown("www/Accueil.Rmd"))),
                                  fluidRow(column(width = 6,offset= 2,tags$img(src='logoblanc.png', height = '120', width ='198')))
      ),
      tabItem(tabName = "Pilotes",fluidRow(column(width = 12, box(title = "Année", width = NULL, solidHeader = TRUE,status = "info", style="circle",selectInput("anneepilotes", label = NULL,choices = seq(2020,1950, by =-1)),selected ="choisir"))),
              fluidRow(column(width = 12, box(title = "Position finale des pilotes ayant fait le tour le plus rapide",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("posfinal")))),
              fluidRow(column(width = 12, box(title = "Représentation des points gagnés par pilote par grand prix",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("ptdrivergp")))),
              fluidRow(column(width = 12, box(title = "Nombre de points moyens par grand prix de chaque pilote",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("ptmoy")))),
              fluidRow(column(width = 12, box(title = "Grand Prix", width = NULL, solidHeader = TRUE,status = "info", style="circle",uiOutput("grandprix"),selected ="choisir"))),
              fluidRow(column(width = 12, box(title = "Comparaison des positions de départ et d'arrivée des pilotes",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL, plotlyOutput("posdeparr"))))
      ),
      tabItem(tabName = "Ecuries",fluidRow(column(width = 12, box(title = "Année", width = NULL, solidHeader = TRUE, status = "info",style="circle",selectInput("anneeecuries", label = NULL,choices = seq(2020,1950, by =-1)),selected ="choisir"))),
              fluidRow(column(width = 12, box(title = "Pourcentage de victoires par écurrie",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("datateamanalyse")))),
              fluidRow(column(width = 12, box(title = "Représentation de la somme des points gagnés par écurie par grand prix",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL, plotlyOutput("pointecuriegp"))))
      ),
      tabItem(tabName = "Abandon",fluidRow(column(width = 12, box(title = "Année", width = NULL, solidHeader = TRUE, status = "info",style="circle",selectInput("anneeabandon", label = NULL,choices = seq(2020,1950, by =-1)),selected ="choisir"))),
              fluidRow(column(width = 12, box(title = "Nombre de DNF et DNS de chaque écurie",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("dnfteam")))),
              fluidRow(column(width = 12, box(title = "Nombre de DNF et DNS de chaque pilote",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL, plotlyOutput("dnfd")))),
              fluidRow(column(width = 12, box(title = "Nombre de DNF et DNS de chaque grand prix",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("dnfgp"))))
      ),
      tabItem(tabName = "Introduction"),
      tabItem(tabName = "Conclusion"),
      tabItem(tabName = "Questionnaire")
    ),
    
  #Theme général
  dashboardthemes::shinyDashboardThemes(theme = "grey_dark")
  
  ),
  footer = dashboardFooter(left= "En cours de création..."),
  #Titre dans le navigateur 
  title = "Projet F1"
  #as.numeric(format(Sys.Date(),"%Y")
)




server <- function(input, output) {
  
  filtre_annee_pilotes <- reactive({
    dataTest <-  read.csv("dataFL1950_2020.csv") 
    filter(dataTest, dataTest$Year == input$anneepilotes)
  })
  
  
  output$plot1 <- renderPlot({
  })
  
}

shinyApp(ui = ui, server = server)

