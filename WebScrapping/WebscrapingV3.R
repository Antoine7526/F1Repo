library(rvest)
library(dplyr)
library(stringr)
library(plyr)

# Année 2020

#******************************************************************#
#                      Récupération des courses 
#******************************************************************#

#Récupération des données concernant les courses à l'aide du webscraping
link = "https://www.formula1.com/en/results.html/2020/races.html"
page = read_html(link)
GrandPrix = page %>% html_nodes(".table-wrap .limiter+ .bold") %>% html_text()
Date = page %>% html_nodes(".table-wrap .dark.hide-for-mobile") %>% html_text()
Winner = page %>% html_nodes(".table-wrap .dark+ .bold") %>% html_text()
Car  = page %>% html_nodes(".table-wrap .uppercase") %>% html_text()
Laps  = page %>% html_nodes(".table-wrap .bold.hide-for-mobile") %>% html_text()
Time = page %>% html_nodes(".table-wrap .bold.hide-for-tablet") %>% html_text()
#Création d'une data frame temporaire
tmp = data.frame(GrandPrix,Date, Winner,Car, Laps,Time, stringsAsFactors = FALSE)

#Modification de deux colonnes pour enlever \n et les espaces 
g<-str_replace_all(Winner,"  ","")
Winner<-str_replace_all(g,"\n"," ")

g <- str_replace_all(GrandPrix,"  ","")
GrandPrix<-str_replace_all(g,"\n"," ")

#Modification de la colonne "car" pour qu'elle soit juste 
Car<-Car[seq(2,length(Car),by=2)]

#Suppression des 4 derniers caractères ex: "HAM "
Winner <- str_sub(Winner,1,nchar(Winner)-4) 

#tmp2 = data.frame(Grandprix,Date, Winner,Car, Laps,Time, stringsAsFactors = FALSE)
#Recodage des données 
#GrandPrix <- as.factor(tmp2$Grandprix)
#Date <- as.factor(tmp2$Date)
#Winner <- as.factor(tmp2$Winner)
#Car <- as.factor(tmp2$Car)
#Laps <- as.numeric(tmp2$Laps)
#Time <- as.factor(tmp2$Time)

#Création de la data frame final 
dataRaces <- data.frame(GrandPrix,Date,Winner,Car,Laps,Time, stringsAsFactors = FALSE)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataRaces,"dataRaces2020.csv")

#******************************************************************#
#                     Récupération des pilotes 
#******************************************************************#

#Récupération des données à l'aide du webscraping
link = "https://www.formula1.com/en/results.html/2020/drivers.html"
page = read_html(link)
Position = page %>% html_nodes(".table-wrap .limiter+ .dark") %>% html_text()
Driver = page %>% html_nodes(".table-wrap td:nth-child(3)") %>% html_text()
Nationality = page %>% html_nodes(".table-wrap .dark.uppercase") %>% html_text()
Car  = page %>% html_nodes(".table-wrap .uppercase+ td") %>% html_text()
Points  = page %>% html_nodes(".table-wrap td.bold") %>% html_text()

#Création d'une data frame temporaire
tmp = data.frame(Position,Driver, Nationality,Car, Points, stringsAsFactors = FALSE)

#Modification de deux colonnes pour enlever \n et les espaces 
g <- str_replace_all(Driver,"  ","")
Driver <- str_replace_all(g,"\n"," ")

g <- str_replace_all(Car,"  ","")
Car <- str_replace_all(g,"\n"," ")

#Suppression des 5 derniers caractères ex: "HAM  "
Driver <- str_sub(Driver,1,nchar(Driver)-5) 

# tmp2 = data.frame(Position,Driver, Nationality,Car, Points, stringsAsFactors = FALSE)
# #Recodage des données 
# Position <- as.numeric(tmp2$Position)
# Driver <- as.factor(tmp2$Driver)
# Nationality <- as.factor(tmp2$Nationality)
# Car <- as.factor(tmp2$Car)
# Points <- as.numeric(tmp2$Points)

#Création de la data frame final 
dataDrivers = data.frame(Position,Driver, Nationality,Car, Points, stringsAsFactors = FALSE)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataDrivers,"dataDrivers2020.csv")

#******************************************************************#
#                      Récupération des équipes
#******************************************************************#

link = "https://www.formula1.com/en/results.html/2020/team.html"
page = read_html(link)
Position = page %>% html_nodes(".table-wrap .limiter+ .dark") %>% html_text()
Team = page %>% html_nodes(".table-wrap .ArchiveLink") %>% html_text()
Points = page %>% html_nodes(".table-wrap td.bold") %>% html_text()

# tmp <- data.frame(Position,Team,Points, stringsAsFactors = FALSE)
# Position <- as.numeric(tmp$Position)
# Team <- as.factor(tmp$Team)
# Points <- as.numeric(tmp$Points)

#Data frame récapitulant les résultats des teams sur l'année 2020
dataTeams = data.frame(Position,Team,Points, stringsAsFactors = FALSE)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataTeams,"dataTeams2020.csv")

#******************************************************************#
# Récupération du tour le plus rapide par Grand Prix
#******************************************************************#

link = "https://www.formula1.com/en/results.html/2020/fastest-laps.html"
page = read_html(link)
GrandPrix = page %>% html_nodes(".table-wrap .width30") %>% html_text()
Driver = page %>% html_nodes(".table-wrap .width25.bold") %>% html_text()
Car = page %>% html_nodes(".table-wrap .uppercase") %>% html_text()
Time = page %>% html_nodes(".table-wrap .uppercase+ .bold") %>% html_text()

#Création d'une data frame temporaire
tmp = data.frame(GrandPrix, Driver, Car, Time, stringsAsFactors = FALSE)

#Modification de deux colonnes pour enlever \n et les espaces 
g <- str_replace_all(Driver,"  ","")
Driver <- str_replace_all(g,"\n"," ")

#Suppression des 4 derniers caractères ex: "HAM "
Driver <- str_sub(Driver,1,nchar(Driver)-4) 

#Modification de la colonne car pour qu'elle soit juste 
Car<-Car[seq(2,length(Car),by=2)]

dataFL = data.frame(GrandPrix, Driver, Car, Time, stringsAsFactors = FALSE)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataFL,"dataFL2020.csv")

#******************************************************************#
# Récupération des données des pilotes par tour 
#******************************************************************#

#récupération des pilotes de l'année 2020
link<-'https://www.formula1.com/en/results.html/2020/drivers.html'
page<-read_html(link)
men <- page %>% html_nodes("td:nth-child(3)") %>% html_text()
g<-str_replace_all(men,"  ","")
men<-str_replace_all(g,"\n"," ")
men<-substr(men,2,nchar(men)-5)

#liste des liens pour chaque pilote du premier au dernier sur l'année pour être en accord avec la variable men
liste_link<-c("LEWHAM01/lewis-hamilton.html","VALBOT01/valtteri-bottas.html","MAXVER01/max-verstappen.html","SERPER01/sergio-perez.html","DANRIC01/daniel-ricciardo.html","CARSAI01/carlos-sainz.html","ALEALB01/alexander-albon.html","CHALEC01/charles-leclerc.html","LANNOR01/lando-norris.html","PIEGAS01/pierre-gasly.html","LANSTR01/lance-stroll.html","ESTOCO01/esteban-ocon.html","SEBVET01/sebastian-vettel.html","DANKVY01/daniil-kvyat.html","NICHUL01/nico-hulkenberg.html","KIMRAI01/kimi-raikkonen.html","ANTGIO01/antonio-giovinazzi.html","GEORUS01/george-russell.html","ROMGRO01/romain-grosjean.html","KEVMAG01/kevin-magnussen.html","NICLAF01/nicholas-latifi.html","JACAIT01/jack-aitken.html","PIEFIT01/pietro-fittipaldi.html")
link<-'https://www.formula1.com/en/results.html/2020/drivers/'

#initialisation du dataframe contenant les données
tmp<-data.frame(Driver=c(),GrandPrix=c(),Date=c(),Car=c(),Position=c(),Points=c())


#remplissage du dataframe
for(i in (1:length(men))){
  #récupération du lien du pilote
  man <-paste0(link,liste_link[i])
  page = read_html(man)
  #récupération des colonnes utiles du pilote
  grandprix = page %>% html_nodes(".limiter+ td") %>% html_text()
  date = page %>% html_nodes(".bold:nth-child(3)") %>% html_text()
  car  = page %>% html_nodes("td.hide-for-mobile") %>% html_text()
  position  = page %>% html_nodes(".hide-for-mobile+ .dark") %>% html_text()
  points = page %>% html_nodes(".dark+ .bold") %>% html_text()
  #transformation de certaines colonnes
  grandprix <- substr(grandprix,14,nchar(grandprix)-9)
  
  g <- str_replace_all(car,"  ","")
  car <- str_replace_all(g,"\n"," ")
  
  #ajout des données du pilote au dataframe
  tmp = data.frame(Driver=c(tmp$Driver,rep(men[i],length(points))),GrandPrix=c(tmp$GrandPrix,grandprix),Date=c(tmp$Date,date),Car=c(tmp$Car,car),Position=c(tmp$Position,position),Points=c(tmp$Points,points), stringsAsFactors = FALSE)
}

dataDriversParRaces <- tmp 

#Ecriture de la data frame dans un fichier .csv
write.csv(dataDriversParRaces,"dataDriversParRaces2020.csv")

#******************************************************************#
# Récupération des positions de départ 
#******************************************************************#

#Récupération du nom des Grand Prix
link <- "https://www.formula1.com/en/results.html/2020/races/1045/autria/starting-grid.html"
page<-read_html(link)
#Liste des Grand Prix
listGP <- page %>% html_nodes(".resultsarchive-filter-wrap~ .resultsarchive-filter-wrap+ .resultsarchive-filter-wrap .resultsarchive-filter-item+ .resultsarchive-filter-item .clip") %>% html_text()

#Listes utiles pour nos liens 
listID <- as.character(c(1045:1061))
listRace <- c("austria", "austria", "hungary","great-britain","great-britain", "spain", "belguim", "italy", "italy", "russia", "germany", "portugal", "italy", "turkey", "bahrain", "bahrain", "abu-dhabi")

#Création data frame vide 
dataSG <- data.frame(GrandPrix=c(),Position=c(),Number=c(),Driver=c(),Car=c(),Time=c())

#Boucle qui permet de récuperer chaque pages différentes
for(i in 1:length(listID)){
  link <-paste("https://www.formula1.com/en/results.html/2020/races/",listID[i],"/",listRace[i],"/starting-grid.html",sep="")
  page<-read_html(link)
  
  Position <- page %>% html_nodes(".limiter+ .dark") %>% html_text()
  Number <- page %>% html_nodes(".dark:nth-child(3)") %>% html_text()
  Driver <- page %>% html_nodes(".dark+ .bold") %>% html_text()
  Car <- page %>% html_nodes(".uppercase") %>% html_text()
  Time <- page %>% html_nodes(".hide-for-mobile+ .bold") %>% html_text()
  
  g1<-str_replace_all(Position,"\n","")
  Position<-str_replace_all(g1," ","")
  
  g2<-str_replace_all(Driver," ","")
  Driver<-str_replace_all(g2,"\n"," ")
  
  g3<-str_replace_all(Time,"\n","")
  Time<-str_replace_all(g3," ","")
  
  Car<-Car[seq(2,length(Car),by=2)]
  
  Driver <- substr(Driver,2,nchar(Driver)-5)
  
  dataSG <- data.frame(GrandPrix = c(dataSG$GrandPrix,rep(listGP[i],length(Position))),Position = c(dataSG$Position,Position),Number = c(dataSG$Number,Number),Driver = c(dataSG$Driver,Driver),Car = c(dataSG$Car,Car),Time = c(dataSG$Time,Time))
}

#Ecriture de la data frame dans un fichier .csv
write.csv(dataSG,"dataStartingGrid2020.csv")



