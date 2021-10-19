#Work Directory
#setwd("~/Documents/UGA/M1/S7/Logiciels Spécialisés/R/Projet/DATA")

#Libraries
library(plotly)
library(dplyr)

#FUNCTION
DataTeamAnalyse <- function(data){
  
  #Getting all the row associated with the 1st position
  listTeamWinner <- which(data$Position=="1")

  #Vector of winners
  cars <- c()
  for(i in listTeamWinner){
    cars <- c(cars,data$Car[i])
  }

  
  car <- as.factor(cars)
  #data frame of frequencies 
  TeamWinner <- Tri(car)

  # Compute the bottom of each rectangle
  TeamWinner$ymin = c(0, head(TeamWinner$ymax, n=-1))

  #Compute the cumulative percentages (top of each rectangle)
  TeamWinner$ymax = cumsum(TeamWinner$frequence)

  #Donut chart with plotly
  TeamWinner <- TeamWinner %>% group_by(modalite)
  fig <- TeamWinner %>% plot_ly(labels = ~modalite, values = ~frequence)
  fig <- fig %>% add_pie(hole = .5)
  fig <- fig %>% layout(showlegend = T,
                        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  fig <- fig %>% layout(legend = list(title=list(text='<b> Écuries </b>')))
  fig
}

dataTest <- dataDriversParRaces1950_2020
g = filter(dataTest, dataTest$Year == 2010)


