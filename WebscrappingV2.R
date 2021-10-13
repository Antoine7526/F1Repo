library(rvest)
library(dplyr)
library(stringr)
library(plyr)

# Année 2020

#******************************************************************#
# Récupération des courses 
#******************************************************************#

#Récupération des données à l'aide du webscraping
link = "https://www.formula1.com/en/results.html/2020/races.html"
page = read_html(link)
Grandprix = page %>% html_nodes(".table-wrap .limiter+ .bold") %>% html_text()
Date = page %>% html_nodes(".table-wrap .dark.hide-for-mobile") %>% html_text()
Winner = page %>% html_nodes(".table-wrap .dark+ .bold") %>% html_text()
Car  = page %>% html_nodes(".table-wrap .uppercase") %>% html_text()
Laps  = page %>% html_nodes(".table-wrap .bold.hide-for-mobile") %>% html_text()
Time = page %>% html_nodes(".table-wrap .bold.hide-for-tablet") %>% html_text()
#Création d'une data frame temporaire
tmp = data.frame(Grandprix,Date, Winner,Car, Laps,Time, stringsAsFactors = FALSE)

#Modification de deux colonnes pour enlever \n et les espaces 
g<-str_replace_all(Winner,"  ","")
Winner<-str_replace_all(g,"\n"," ")

g <- str_replace_all(Grandprix,"  ","")
Grandprix<-str_replace_all(g,"\n"," ")

#Modification de la colonne car pour qu'elle soit juste 
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
dataRaces <- data.frame(Grandprix,Date,Winner,Car,Laps,Time)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataRaces,"dataRaces2020.csv")

#******************************************************************#
# Récupération des pilotes 
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

# tmp2 = data.frame(Position,Driver, Nationality,Car, Points, stringsAsFactors = FALSE)
# 
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
# Récupération des équipes
#******************************************************************#

link = "https://www.formula1.com/en/results.html/2020/team.html"
page = read_html(link)
Position = page %>% html_nodes(".limiter+ .dark") %>% html_text()
Team = page %>% html_nodes(".ArchiveLink") %>% html_text()
Points = page %>% html_nodes("td.bold") %>% html_text()

# tmp <- data.frame(Position,Team,Points, stringsAsFactors = FALSE)
# 
# Position <- as.numeric(tmp$Position)
# Team <- as.factor(tmp$Team)
# Points <- as.numeric(tmp$Points)

#Data frame récapitulant les résultats des teams sur l'année 2020
dataTeams = data.frame(Position,Team,Points, stringsAsFactors = FALSE)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataTeams,"dataTeams2020.csv")
