library(rvest)
library(dplyr)
library(stringr)
library(plyr)

#******************************************************************#
#                Fonctions utiles pour le web scraping
#******************************************************************#

trim_string <- function(string)   gsub("\\s+", " ", gsub("^\\s+|\\s+$", "", string))

race<- function(gp,year){
  #On crée une partie du lien URL pour extraire les données de chaque grand prix.
  listRace<-c()
  for(i in 1:length(gp)){
    GP<-gp[i]
    Gprix<-unlist(strsplit(GP,split=" "))
    Gprix<-Gprix[Gprix!=""]
    assemblage=paste0(year[i],"-",Gprix[1])
    if(length(Gprix)>1){
      for(j in Gprix[2:length(Gprix)]){
        assemblage<-paste0(assemblage,"-",j)
      }
    }
    listRace<-c(listRace,tolower(assemblage))
  }
  listRace
}

#******************************************************************#
#                      Récupération des courses 
#******************************************************************#

#Récupération des données concernant les courses à l'aide du webscraping

#On crée les vecteurs qui seront les colonnes de notre data frame
GrandPrix <- c()
Date <- c()
Year <- c()
Winner <- c()
Car <- c()
Laps <- c()
Time <- c()


#On parcourt toutes les années voulues.
for(i in 1950:2020){
  link <- paste0("https://www.formula1.com/en/results.html/",i,"/races.html")
  page <- read_html(link)
  #On stocke les valeurs de l'année
  grandprix <- page %>% html_nodes(".table-wrap .limiter+ .bold") %>% html_text()
  date <- page %>% html_nodes(".table-wrap .dark.hide-for-mobile") %>% html_text()
  winner <- page %>% html_nodes(".table-wrap .dark+ .bold") %>% html_text()
  car <- page %>% html_nodes(".table-wrap .uppercase") %>% html_text()
  laps <- page %>% html_nodes(".table-wrap .bold.hide-for-mobile") %>% html_text()
  time <- page %>% html_nodes(".table-wrap .bold.hide-for-tablet") %>% html_text()
  
  #Modification de deux colonnes pour enlever \n et les espaces 
  winner <- trim_string(winner)
  grandprix <- trim_string(grandprix)
  
  #Les voitures sont aux indices pairs donc on enlève les indices impairs.
  car <- car[seq(2,length(car),by=2)]
  
  #Suppression des 4 derniers caractères ex: "HAM "
  winner <- str_sub(winner,1,nchar(winner)-4)
  
  #On actualise nos vecteurs de la data frame
  GrandPrix <- c(GrandPrix,grandprix)
  Date <- c(Date,date)
  Year <- c(Year,rep(i,length(grandprix)))
  Winner <- c(Winner,winner)
  Car <- c(Car,car)
  Laps <- c(Laps,laps)
  Time <- c(Time,time)
}

#Création de la data frame finale   
dataRaces <- data.frame(GrandPrix,Date,Year,Winner,Car,Laps,Time, stringsAsFactors = FALSE)


#Ecriture de la data frame dans un fichier .csv
write.csv(dataRaces,"dataRaces1950_2020.csv")


#******************************************************************#
#                     Récupération des pilotes 
#******************************************************************#

#On crée les vecteurs qui seront les colonnes de notre data frame
Year <- c()
Position <- c()
Driver <- c()
Car <- c()
Points <- c()

#On parcourt toutes les années voulues.
for(i in 1950:2020){
  link = paste0("https://www.racing-statistics.com/en/seasons/",i)
  page = read_html(link)
  #On stocke les valeurs de l'année
  position = page %>% html_nodes(".blocks2 td:nth-child(1)") %>% html_text()
  driver = page %>% html_nodes(".blocks2 td:nth-child(3)") %>% html_text()
  car  = page %>% html_nodes(".blocks2 td:nth-child(5)") %>% html_text()
  points  = page %>% html_nodes(".blocks2 td:nth-child(6)") %>% html_text()
  
  #Modification de deux colonnes pour enlever \n et les espaces 
  position<-trim_string(position)
  
  
  #On actualise nos vecteurs de la data frame
  Year <- c(Year,rep(i,length(driver)))
  Position <- c(Position,position)
  Driver <- c(Driver,driver)
  Car <- c(Car,car)
  Points <-c(Points,points)
  
}

#Création de la data frame finale
dataDrivers <- data.frame(Year,Position,Driver,Car,Points, stringsAsFactors = FALSE)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataDrivers,"dataDrivers1950_2020.csv")



#******************************************************************#
#                      Récupération des équipes
#******************************************************************#

#On crée les vecteurs qui seront les colonnes de notre data frame
Year <- c()
Position <- c()
Team <- c()
Points <- c()

#On parcourt les années voulues.
for(i in 1950:2020){
  link = paste0("https://www.formula1.com/en/results.html/",i,"/team.html")
  page = read_html(link)
  #On stocke les valeurs de l'année
  position = page %>% html_nodes(".table-wrap .limiter+ .dark") %>% html_text()
  team = page %>% html_nodes(".table-wrap .ArchiveLink") %>% html_text()
  points = page %>% html_nodes(".table-wrap td.bold") %>% html_text()
  
  #On actualise nos vecteurs du data.frame
  Year <-c(Year,rep(i,length(position)))
  Position <-c(Position,position)
  Team <-c(Team,team)
  Points <-c(Points,points)
  
}

#Création de la data frame finale
dataTeams <- data.frame(Year,Position,Team,Points, stringsAsFactors = FALSE)


#Ecriture de la data frame dans un fichier .csv
write.csv(dataTeams,"dataTeams1958_2020.csv")



#******************************************************************#
# Récupération du tour le plus rapide par Grand Prix
#******************************************************************#

#On crée les vecteurs qui seront les colonnes de notre data frame
Year <- c()
GrandPrix <- c()
Driver <-c()
Car <-c()
Time <-c()

#On parcourt les années voulues.
for(i in 1950:2020){
  link = paste0("https://www.formula1.com/en/results.html/",i,"/fastest-laps.html")
  page = read_html(link)
  #On stocke les valeurs de l'année
  grandprix = page %>% html_nodes(".table-wrap .width30") %>% html_text()
  driver = page %>% html_nodes(".table-wrap .width25.bold") %>% html_text()
  car = page %>% html_nodes(".table-wrap .uppercase") %>% html_text()
  time = page %>% html_nodes(".table-wrap .uppercase+ .bold") %>% html_text()
  
  #Modification de driver pour enlever \n et les espaces 
  driver <- trim_string(driver)
  grandprix <- trim_string(grandprix)
  
  #Suppression des 4 derniers caractères ex: "HAM "
  driver <- str_sub(driver,1,nchar(driver)-4) 
  
  #Modification de la colonne car pour qu'elle soit juste 
  car<-car[seq(2,length(car),by=2)]
  
  #On actualise nos vecteurs du data.frame
  Year <-c(Year,rep(i,length(grandprix)))
  GrandPrix <-c(GrandPrix,grandprix)
  Driver <-c(Driver,driver)
  Car <-c(Car,car)
  Time <-c(Time,time)

}


#Création de la data frame finale
dataFL = data.frame(Year,GrandPrix,Driver,Car,Time, stringsAsFactors = FALSE)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataFL,"dataFL1950_2020.csv")



#******************************************************************#
# Récupération des données des pilotes par tour 
#******************************************************************#

Grandprix<-c()
year<-c()

#On récupère dans un premier temps la liste de tous les grands prix de 1950 à 2020.
#On crée un vecteur year qui contient les années associées à chaque grand prix.
for(i in 1950:2020){
  
  link <- paste0("https://www.racing-statistics.com/en/seasons/",i)
  page <- read_html(link)
  #On stocke les valeurs de l'année.
  grandprix <- page %>% html_nodes("table:nth-child(2) tr :nth-child(3)") %>% html_text()
  
  #Le vecteur des grands prix contient des données inutiles donc on cherche l'indice où commencent les grands prix.
  indice<-match("event",grandprix)
  #On enlève les données inutiles.
  grandprix<-grandprix[-c(1:indice)]
  
  Grandprix<-c(Grandprix,grandprix)
  year<-c(year,rep(i,length(grandprix)))
}

#On crée les parties de lien pour récupérer les données de chaque grand prix.
raceID<-race(Grandprix,year)
#On enlève les caractères " Grand prix" pour avoir des données et un affichage graphique plus lisible.
GP<-substr(Grandprix,1,nchar(Grandprix)-11)

Driver <- c()
GrandPrix <- c()
Year <- c()
Position <- c()
Points <- c()
Car <-c()


for(j in 1:length(GP)){
  
  link <- paste0("https://www.racing-statistics.com/en/events/",raceID[j])
  page <- read_html(link)
  
  #On récupère les données voulues
  position <- page %>% html_nodes(".block:nth-child(1) .driver_row td:nth-child(1)") %>% html_text()
  points <- page %>% html_nodes(".driver_row .nomob:nth-child(7)") %>% html_text()
  driver <- page %>% html_nodes(".block:nth-child(1) .driver_row td:nth-child(3)") %>% html_text()
  car <- page %>% html_nodes(".block:nth-child(1) .driver_row td:nth-child(4)") %>% html_text()
  #driver_debut contient les pilotes qui sont dans la starting grid.
  driver_debut <- page %>% html_nodes(".block+ .block td:nth-child(3)") %>% html_text()
  
  #Il y a que les drivers qui ont terminé la course qui ont une position pour les autres on leur donne le tag DNF.
  ff<-which(position=="")
  position[ff]<-"DNF"
  
  #On nettoie les données de caractères génants.
  driver<-trim_string(driver)
  car<-trim_string(car)
  
  #On récupère les pilotes qui étaient sur la starting grid et sur celle de fin pour ne pas avoir de données pas exploitables.
  list<-intersect(driver,driver_debut)
  indice<-match(list,driver)
  #On garde que les données des pilotes qu'on a récupéré dans list.
  driver<-driver[indice]
  car<-car[indice]
  position<-position[indice]
  points<-points[indice]
  
  
  Driver<-c(Driver,driver)
  GrandPrix<-c(GrandPrix,rep(GP[j],length(driver)))
  Year<-c(Year,rep(year[j],length(driver)))
  Position<-c(Position,position)
  Points<-c(Points,points)
  Car<-c(Car,car)
  
}

#Création de la data frame finale
dataDriversParRaces <- data.frame(Indice=c(1:length(Driver)),Driver,GrandPrix,Year,Car,Position,Points, stringsAsFactors = FALSE)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataDriversParRaces,"dataDriversParRaces1950_2020.csv")

#******************************************************************#
# Récupération des positions de départ 
#******************************************************************#

#On récupère les données sur le même lien que les données de dataDriversParRaces.
Grandprix<-c()
year<-c()

for(i in 1950:2020){
  
  link <- paste0("https://www.racing-statistics.com/en/seasons/",i)
  page <- read_html(link)
  #On stocke les valeurs de l'année
  grandprix <- page %>% html_nodes("table:nth-child(2) tr :nth-child(3)") %>% html_text()
  
  indice<-match("event",grandprix)
  
  grandprix<-grandprix[-c(1:indice)]
  
  Grandprix<-c(Grandprix,grandprix)
  year<-c(year,rep(i,length(grandprix)))
}

raceID<-race(Grandprix,year)

GP<-substr(Grandprix,1,nchar(Grandprix)-11)

Driver <- c()
GrandPrix <- c()
Year <- c()
Position <- c()
Car <-c()


for(j in 1:length(GP)){
  
  link <- paste0("https://www.racing-statistics.com/en/events/",raceID[j])
  page <- read_html(link)
  
  position <- page %>% html_nodes(".block+ .block .driver_row td:nth-child(1)") %>% html_text()
  driver <- page %>% html_nodes(".block+ .block td:nth-child(3)") %>% html_text()
  car <- page %>% html_nodes(".block+ .block td:nth-child(4)") %>% html_text()
  
  Driver<-c(Driver,driver)
  GrandPrix<-c(GrandPrix,rep(GP[j],length(driver)))
  Year<-c(Year,rep(year[j],length(driver)))
  Position<-c(Position,position)
  Car<-c(Car,car)
  
}

#Création de la data frame finale
dataSG <- data.frame(Year,GrandPrix,Position,Driver,Car)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataSG,"dataStartingGrid1950_2020.csv")
