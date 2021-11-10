library(shiny)
library(shinythemes)
library(shinydashboard)
library(dashboardthemes)
library(shinydashboardPlus)
library(plotly)
library(dplyr)
library(VroumVroum)

#Texte pour interprétation graphique
g1 <- "Sur votre gauche vous remarquerez un diagramme en barre. Ce diagramme représente la fréquence de la position d'arrivée du pilote ayant fait le tour le plus rapide. On s'attend à ce que la personne qui a fait le tour le plus rapide soit dans les premières positions, or ce n'est pas toujours le cas. Les pilotes ayant fait le tour le plus rapide finissent relativement dans le TOP 10. Il se peut que lors d'un grand prix un pilote ayant eu le meilleur tour ne finisse pas la course. Ainsi cela sera matérialiser par un position égale à 0."   
g2 <- "Ici nous avons une représentation des points gagnés par les pilotes pour chaque grand prix sur une saison. Pour vous aidez à réaliser des comparaisons vous pouvez double cliquer sur un pilote pour obtenir sa courbe. Vous pouvez ensuite sélectionnez plusieurs pilotes en cliquant sur leur noms. Si vous voulez revenir sur le graphique de départ veuillez double cliquer deux fois sur un nom de pilote."
g3 <- "Ce diagramme en barre représente le nombre moyen de points par pilote sur une saison. Remarquons qu'à l'aide de ce graphique nous pouvons retrouvons un semblant du classement final des pilotes. La barre la plus haute représentant le leader."
g4 <- "Sur votre droite nous avons tracé un nuage de point. Il représente la position d'arrivée en fonction de la position de départ sur un grand prix, ce dernier que vous pouvez choisir à l'aide du menu déroulant. Si un point se trouve sur la droite cela signifie que le pilote est arrivé à la même position dont il est partit. En revanche, s'il se trouve en dessous de celle-ci le pilote aura gagné des places et l'inverse s'il se trouve au dessus. Pour mieux comprendre, vous pouvez placer votre curseur sur l'un des points qui pourra vous indiquez le nom du pilote, sa position de départ et celle d'arrivée."
g5 <- "Ici vous trouverez un diagramme circulaire représente le pourcentage de victoires d'une écurie sur une saison. Nous pouvons remarquer une diversité sur les écuries remportant des grands prix. On peut également remarquer aux fils des années l'évolution des écuries."
g6 <- "A votre droite, vous trouverez un graphique réprésentant la somme des points gagnés par les pilotes des écuries par grand prix. Pour vous aidez à réaliser des comparaisons vous pouvez double cliquer sur une écurie pour obtenir sa courbe. Vous pouvez ensuite sélectionnez plusieurs écuries en cliquant sur leur noms. Si vous voulez revenir sur le graphique de départ veuillez double cliquer deux fois sur un nom d'écurie."
g7 <- "Ce diagramme circulaire représente le pourcentage d'abandon pour chaque écuries lors d'une saison. Nous considérons comme abandon tous ceux n'ayant pas pris les départs mais également ceux qui n'ont pas terminé la course."
g8 <- "Sur votre droite, nous avons un diagramme en barres représentant le nombre d'abandon par pilotes sur une saison. Remarquons que le nombre d'abandon n'est pas forcément lié au classement final. Les pilotes n'aparaissant pas sur le graphique sont ceux ayant débuté et finit tous les grands prix."
g9 <- "Ici vous trouverez un diagramme en barre représentant le nombre d'abandon par grand prix sur une saison. On pourrait se demander si les circuits ayant eu le plus d'abandon sont les plus dangereux. D'autres facteurs peuvent rentrer en jeux comme la météo."

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
      hr(),
      menuItem("Rapport", tabName = "Rapport",icon = icon("book-open"),
               menuSubItem("Introduction", tabName = "Introduction"),
               menuSubItem("Conclusion", tabName = "Conclusion")),
      menuItem("Questionnaire", tabName = "Questionnaire",icon = icon("question")),
      menuItem("Source",icon = icon("database"), 
               menuSubItem("formula1.com", icon = icon("arrow-alt-circle-right"),href = "https://www.formula1.com/en/results.html/2021/races.html"),
               menuSubItem("racing-statistics.com",icon = icon("arrow-alt-circle-right"), href = "https://www.racing-statistics.com/en/seasons")
      )
    )
  ),
  body = dashboardBody(

    #On remplit ici par page
    tabItems(
      tabItem(tabName = "Accueil",fluidRow(column(width = 6, offset = 3, align = "center",includeMarkdown("www/Accueil.Rmd")))
      ),
      tabItem(tabName = "Pilotes",fluidRow(column(width = 12, box(title = "Année", width = NULL, solidHeader = TRUE,status = "info", style="circle",selectInput("anneepilotes", label = NULL,choices = seq(2020,1950, by =-1)),selected ="choisir"))),
                                  fluidRow(column(width = 8, box(title = "Position finale des pilotes ayant fait le tour le plus rapide",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("posfinal"))),
                                           column(width = 4, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g1))),
                                  fluidRow(column(width = 3, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g2)),
                                           column(width = 9, box(title = "Représentation des points gagnés par pilote par grand prix",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("ptdrivergp")))),
                                  fluidRow(column(width = 8, box(title = "Nombre de points moyens pour chaque pilote",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("ptmoy"))),
                                           column(width = 4, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g3))),
                                  fluidRow(column(width = 12, box(title = "Grand Prix", width = NULL, solidHeader = TRUE,status = "info", style="circle",uiOutput("grandprix"),selected ="choisir"))),
                                  fluidRow(column(width = 4, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g4)),
                                           column(width = 8, box(title = "Comparaison des positions de départ et d'arrivée des pilotes",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL, plotlyOutput("posdeparr"))))
      ),
      tabItem(tabName = "Ecuries",fluidRow(column(width = 12, box(title = "Année", width = NULL, solidHeader = TRUE, status = "info",style="circle",selectInput("anneeecuries", label = NULL,choices = seq(2020,1950, by =-1)),selected ="choisir"))),
                                  fluidRow(column(width = 8, box(title = "Pourcentage de victoires par écurrie",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("datateamanalyse"))),
                                           column(width = 4, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g5))
                                           ),
                                  fluidRow(column(width = 3, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g6)),
                                           column(width = 9, box(title = "Représentation de la somme des points gagnés par écurie par grand prix",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL, plotlyOutput("pointecuriegp"))))
      ),
      tabItem(tabName = "Abandon",fluidRow(column(width = 12, box(title = "Année", width = NULL, solidHeader = TRUE, status = "info",style="circle",selectInput("anneeabandon", label = NULL,choices = seq(2020,1950, by =-1)),selected ="choisir"))),
                                  fluidRow(column(width = 8, box(title = "Nombre de DNF et DNS de chaque écurie",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("dnfteam"))),
                                           column(width = 4, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g7))),
                                  fluidRow(column(width = 3, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g8)),
                                           column(width = 9, box(title = "Nombre de DNF et DNS de chaque pilote",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL, plotlyOutput("dnfd")))),
                                  fluidRow(column(width = 9, box(title = "Nombre de DNF et DNS de chaque grand prix",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("dnfgp"))),
                                           column(width = 3, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g9))
                                           )
      ),
      tabItem(tabName = "Introduction"),
      tabItem(tabName = "Conclusion"),
      tabItem(tabName = "Questionnaire")
    ),

  #Theme général
  dashboardthemes::shinyDashboardThemes(theme = "grey_dark")

  ),
  footer = dashboardFooter(p(em("Réalisée par:"),br("Batiste Amistadi, Charline Champ et Antoine Grancher"),style="text-align:center; font-family: Arial; color: grey_dark")), 
  #Titre dans le navigateur
  title = "Projet F1"
)

server <- function(input, output) {

  #Graphiques page Pilotes
  output$posfinal <- renderPlotly({
    dataDriversParRaces2 <- filter(dataDriversParRaces, dataDriversParRaces$Year == input$anneepilotes)
    dataFL2 <- filter(dataFL, dataFL$Year == input$anneepilotes)
    dataRaces2 <- filter(dataRaces, dataRaces$Year == input$anneepilotes)
    dataDrivers2 <- filter(dataDrivers, dataDrivers$Year == input$anneepilotes)
    posfinal <- PosFinalePilote(dataDriversParRaces2,dataFL2,dataRaces2,dataDrivers2)
  })
  
  output$ptdrivergp <- renderPlotly({
    dataDriversParRaces2 <- filter(dataDriversParRaces, dataDriversParRaces$Year == input$anneepilotes)
    dataRaces2 <- filter(dataRaces, dataRaces$Year == input$anneepilotes)
    ptdrivergp <- PointDriverGP(dataDriversParRaces2, dataRaces2)
  })

  output$ptmoy <- renderPlotly({
    dataRaces2 <- filter(dataRaces, dataRaces$Year == input$anneepilotes)
    dataDrivers2 <- filter(dataDrivers, dataDrivers$Year == input$anneepilotes)
    ptmoy <- Pts_moyens_Driver_GP(dataDrivers2, dataRaces2)
  })
  
  output$grandprix <- renderUI({
    gp <- c()
    indices <- which(dataDriversParRaces$Year == input$anneepilotes)
    for(i in indices){
      gp <- c(gp,dataDriversParRaces$GrandPrix[i])
    }
    GP <-  unique(gp)
    selectInput("grandprix", label = NULL,choices = GP)
  })
  
  output$posdeparr <- renderPlotly({
    dataStartingGrid2 <- filter(dataStartingGrid, dataStartingGrid$Year == input$anneepilotes)
    dataDriversParRaces2 <- filter(dataDriversParRaces, dataDriversParRaces$Year == input$anneepilotes)
    posdeparr <- PosDepArr(dataStartingGrid2, dataDriversParRaces2, input$grandprix)
  })
  
  
  #Graphiques page Ecuries
  output$datateamanalyse <- renderPlotly({
    dataDriversParRaces2 <- filter(dataDriversParRaces, dataDriversParRaces$Year == input$anneeecuries)
    datateamanalyse <- DataTeamAnalyse(dataDriversParRaces2)
  })
  
  output$pointecuriegp <- renderPlotly({
    dataDriversParRaces2 <- filter(dataDriversParRaces, dataDriversParRaces$Year == input$anneeecuries)
    pointecuriegp <- PointEcurieGP(dataDriversParRaces2)
  })

  #Graphiques page Abandon
  output$dnfteam <- renderPlotly({
    dataDriversParRaces2 <- filter(dataDriversParRaces, dataDriversParRaces$Year == input$anneeabandon)
    dnfteam <- DNFTeam(dataDriversParRaces2)
  })
  
  output$dnfd <- renderPlotly({
    dataDriversParRaces2 <- filter(dataDriversParRaces, dataDriversParRaces$Year == input$anneeabandon)
    dnfd <- DNFDriver(dataDriversParRaces2)
  })
  
  output$dnfgp <- renderPlotly({
    dataDriversParRaces2 <- filter(dataDriversParRaces, dataDriversParRaces$Year == input$anneeabandon)
    dnfgp <- DNFGrandPrix(dataDriversParRaces2)
  })
  
}

shinyApp(ui = ui, server = server)

