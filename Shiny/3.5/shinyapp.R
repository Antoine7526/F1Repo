library(shiny)
library(shinythemes)
library(shinydashboard)
library(dashboardthemes)
library(shinydashboardPlus)
library(plotly)
library(dplyr)
library(VroumVroum)
library(leaflet)

#Textes utiles pour interprétation graphique
g1 <- "Sur votre gauche vous remarquerez un diagramme en barre. Ce diagramme représente la fréquence de la position d'arrivée du pilote  ayant fait le tour le plus rapide. On s'attend à ce que la personne qui a fait le tour le plus rapide soit dans les premières positions, or ce n'est pas toujours le cas. Les pilotes ayant fait le tour le plus rapide finissent relativement dans le TOP 10. Il se peut que lors d'un grand prix un pilote ayant eu le meilleur tour ne finisse pas la course. Ainsi, cela sera matérialiser par un position égale à 0."   
g2 <- "Ici nous avons une représentation des points gagnés par les pilotes pour chaque grand prix sur une saison. Pour vous aidez à réaliser des comparaisons vous pouvez double cliquer sur un pilote pour obtenir sa courbe. Vous pouvez ensuite sélectionner plusieurs pilotes en cliquant sur leur nom. Si vous voulez revenir sur le graphique de départ veuillez double cliquer deux fois sur un nom de pilote."
g3 <- "Ce diagramme en barre représente le nombre moyen de points par pilote sur une saison. Remarquons qu'à l'aide de ce graphique nous pouvons retrouvons un semblant du classement final des pilotes. La barre la plus haute représentant le leader."
g4 <- "Sur votre droite nous avons tracé un nuage de point. Il représente la position d'arrivée en fonction de la position de départ sur un grand prix. Ce dernier que vous pouvez choisir à l'aide du menu déroulant. Si un point se trouve sur la droite cela signifie que le pilote est arrivé à la même position dont il est parti. En revanche, s'il se trouve en dessous de celle-ci, le pilote aura gagné des places et l'inverse s'il se trouve au dessus. Pour mieux comprendre, vous pouvez placer votre curseur sur l'un des points. Cela vous indiquera le nom du pilote, sa position de départ et celle d'arrivée. Si un pilote n'est pas présent sur ce graphique c'est qu'il n'a pas fini la course."
g5 <- "Ici vous trouverez un diagramme circulaire représentant le pourcentage de victoires d'une écurie sur une saison. Nous pouvons remarquer une diversité sur les écuries remportant des grands prix. On peut également remarquer au fil des années l'évolution des écuries."
g6 <- "A votre droite, vous trouverez un graphique réprésentant la somme des points gagnés par les pilotes des écuries par grand prix. Pour vous aider à réaliser des comparaisons vous pouvez double cliquer sur une écurie pour obtenir sa courbe. Vous pouvez ensuite sélectionnez plusieurs écuries en cliquant sur leur noms. Si vous voulez revenir sur le graphique de départ, veuillez double cliquer deux fois sur un nom d'écurie."
g7 <- "Ce diagramme circulaire représente le pourcentage d'abandon pour chaque écuries lors d'une saison. Nous considérons comme abandon tous ceux n'ayant pas pris les départs mais également ceux qui n'ont pas terminé la course."
g8 <- "Sur votre droite, nous avons un diagramme en barres représentant le nombre d'abandons par pilotes sur une saison. Remarquons que le nombre d'abandons n'est pas forcément lié au classement final. Les pilotes n'aparaissant pas sur le graphique sont ceux ayant débuté et fini tous les grands prix."
g9 <- "Ici vous trouverez un diagramme en barre représentant le nombre d'abandons par grand prix sur une saison. On pourrait se demander si les circuits ayant eu le plus d'abandons sont les plus dangereux. D'autres facteurs peuvent rentrer en jeu comme la météo."
g10 <- "Sur votre gauche vous remarquerez un diagramme en barre. Ce diagramme représente la fréquence d'abandon de chaque pilotes entre deux années choisies. Vous remarquerez que plus l'écart entre les deux années est grand plus la graphe est dense. Ceci s'explique du fait de l'ajout de pilotes. De plus, plus la barre sera haute plus le pilote a de chance de ne pas finir sa course."

ui <- dashboardPage(
  #Tableau du haut
  header = dashboardHeader(title = tags$img(src='logo.png', height = '50', width ='150'),
                           dropdownMenu(type = "messages", 
                                        icon = icon("info-circle"),
                                        badgeStatus =NULL,
                                        headerText = ("Cette Application est en cours de création. Dernière mise à jour réalisée le 22 nov. 2021"))
  ),
  #Tableau de gauche
  sidebar = dashboardSidebar(
    sidebarMenu(
      menuItem("Accueil", tabName = "Accueil",icon = icon("home")),
      menuItem("Pilotes", tabName = "Pilotes",icon = icon("user")),
      menuItem("Ecuries", tabName = "Ecuries",icon = icon("users")),
      menuItem("Abandon", tabName = "Abandon",icon = icon("car-crash")),
      menuItem("Comparaison", tabName = "Comparaison",icon = icon("compress-alt")),
      menuItem("Map", tabName = "Map",icon = icon("map-pin")),
      hr(),
      menuItem("Rapport", tabName = "Rapport",icon = icon("book-open")),
      menuItem("Dépôt GitHub",icon = icon("github"),href = "https://github.com/Antoine7526/F1Repo"),
      menuItem("Sources",icon = icon("database"), 
               menuSubItem("formula1.com", icon = icon("arrow-alt-circle-right"),href = "https://www.formula1.com/en/results.html/2021/races.html"),
               menuSubItem("racing-statistics.com",icon = icon("arrow-alt-circle-right"), href = "https://www.racing-statistics.com/en/seasons")
      ),
      menuItem("Aide", tabName = "Aide",icon = icon("question-circle"))
    )
  ),
  body = dashboardBody(
    #Thème général
    dashboardthemes::shinyDashboardThemes(theme = "grey_dark"),
    #On remplit pages par pages
    tabItems(
      tabItem(tabName = "Accueil", fluidRow(column(width = 6,  align = "center", tags$div(tags$br(),tags$br(),tags$br(), tags$h1("Bienvenue sur notre site"),tags$br(),tags$br(),tags$br(),tags$br(),tags$div(style= "font-weight: 1000; font-family: DejaVu Sans Mono, monospace", "Si vous vous posez des questions sur la Formule 1 vous êtes au bon endroit.Vous trouverez ici différentes analyses graphiques (bien entendu expliquées) reprennant les données depuis 1950 jusqu'à 2020."),tags$br(),tags$br(),tags$br(),tags$br()),
                                                   fluidRow(column(width= 6, tags$img(src='logoblanc.png', height = '125', width ='203')),
                                                            column(width= 6, tags$div(style= "font-weight: 1000; font-family: DejaVu Sans Mono, monospace","Cette application a été réalisée dans le cadre d'un projet demandé au sein du M1 Statistique et Sciences des Données de l'Université Grenoble Alpes", tags$br(),tags$br(),tags$br(),tags$br()))),
                                                   fluidRow(column(width = 4,  align = "center",tags$div(style= "font-weight: 1000; font-family: DejaVu Sans Mono, monospace",tags$br(),tags$br(),"Réalisé par:", tags$br(), "Batiste Amistadi, Charline Champ et Antoine Grancher")),
                                                            column(width = 8,  align = "center",tags$img(style = "width: 100%", src="f1.gif")))),
                                            column(width = 6,  align = "center",tags$img(style = "height: 100%", src="voiture.png", height = '758', width ='427')))
              
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
              fluidRow(column(width = 8, box(title = "Nombre d'abandons pour chaque écurie",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("dnfteam"))),
                       column(width = 4, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g7))),
              fluidRow(column(width = 3, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g8)),
                       column(width = 9, box(title = "Nombre d'abandons pour chaque pilote",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL, plotlyOutput("dnfd")))),
              fluidRow(column(width = 9, box(title = "Nombre d'abandons pour chaque grand prix",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("dnfgp"))),
                       column(width = 3, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g9))
              )
      ),
      tabItem(tabName = "Map", fluidRow(column(width = 12, box(title = "Année", width = NULL, solidHeader = TRUE, status = "info",style="circle",selectInput("anneemap", label = NULL,choices = seq(2020,1950, by =-1)),selected ="choisir"))),
              fluidRow(column(width = 12, box(title = "Carte des emplacements des Grands Prix",height = "100%",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,leafletOutput("mymap",height = 600))))
      ),
      #Ici on utilise iframe pour nous permettre de copier une page HTML sur notre application Shiny qui est elle même une page HTML
      tabItem(tabName = "Rapport",fluidRow(column(width =12, tags$iframe(style="width: 100%", height= 800 ,src= "Rapport.html")))
      ),
      tabItem(tabName = "Comparaison",fluidRow(column(width = 6, box(title = "Année n°1", width = NULL, solidHeader = TRUE,status = "info", style="circle",selectInput("anneecompar1", label = NULL,choices = seq(2019,1950, by =-1)),selected ="choisir")),
                                               column(width = 6, box(title = "Année n°2", width = NULL, solidHeader = TRUE,status = "info", style="circle",selectInput("anneecompar2", label = NULL,choices = seq(2020,1950, by =-1)),selected ="choisir"))),
              fluidRow(column(width = 6, box(title = "Nombre de points moyens pour chaque pilote",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("ptmoyA1"))),
                       column(width = 6, box(title = "Nombre de points moyens pour chaque pilote",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("ptmoyA2")))),
              fluidRow(column(width = 6, box(title = "Pourcentage de victoires par écurrie",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("datateamanalyseA1"))),
                       column(width = 6, box(title = "Pourcentage de victoires par écurrie",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("datateamanalyseA2")))),
              fluidRow(column(width = 9, box(title = "Fréqeunce d'abandons de chaque pilote entre deux années choisies",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,plotlyOutput("dnffrq"))),
                       column(width = 3, box(title = "Interprétation",width = NULL,solidHeader = TRUE, status = "info",style="circle",label = NULL,g10))
              )
              
      ),
      tabItem(tabName = "Aide", fluidRow(column(width =12, tags$iframe(style="width: 100%", height= 800 ,src= "Help.html"))))
    )
  ),
  #Titre dans le navigateur
  title = "F1 Project"
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
  
  #Graphiques page Comparaison
  output$ptmoyA1 <- renderPlotly({
    dataRaces2 <- filter(dataRaces, dataRaces$Year == input$anneecompar1)
    dataDrivers2 <- filter(dataDrivers, dataDrivers$Year == input$anneecompar1)
    ptmoy <- Pts_moyens_Driver_GP(dataDrivers2, dataRaces2)
  })
  
  output$ptmoyA2 <- renderPlotly({
    dataRaces2 <- filter(dataRaces, dataRaces$Year == input$anneecompar2)
    dataDrivers2 <- filter(dataDrivers, dataDrivers$Year == input$anneecompar2)
    ptmoy <- Pts_moyens_Driver_GP(dataDrivers2, dataRaces2)
  })
  
  output$datateamanalyseA1 <- renderPlotly({
    dataDriversParRaces2 <- filter(dataDriversParRaces, dataDriversParRaces$Year == input$anneecompar1)
    datateamanalyse <- DataTeamAnalyse(dataDriversParRaces2)
  })
  
  output$datateamanalyseA2 <- renderPlotly({
    dataDriversParRaces2 <- filter(dataDriversParRaces, dataDriversParRaces$Year == input$anneecompar2)
    datateamanalyse <- DataTeamAnalyse(dataDriversParRaces2)
  })

  output$dnffrq <- renderPlotly({
    dnffrq <- DNF_S_freq(dataDriversParRaces, input$anneecompar1, input$anneecompar2)
  })
  
  #Map
  output$mymap <- renderLeaflet({
    map <- filter(dataCoord, dataCoord$Year == input$anneemap)
    MapGP(map)
  })
  
}

shinyApp(ui = ui, server = server)

