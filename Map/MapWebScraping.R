library(rvest)
library(plyr)
library(dplyr)
library(stringr)


racemap<- function(gp){
  #Création d'une partie du lien URL pour extraire les données de chaque grand prix.
  listRace<-c()
  for(i in 1:length(gp)){
    GP<-gp[i]
    Gprix<-unlist(strsplit(GP,split=" "))
    Gprix<-Gprix[Gprix!=""]
    assemblage <- Gprix[1]
    if(length(Gprix)>1){
      for(j in Gprix[2:length(Gprix)]){
        assemblage<-paste0(assemblage,"-",j)
      }
    }
    listRace<-c(listRace,tolower(assemblage))
  }
  listRace
}


Circuit<-c()
Year<-c()

for(i in 1950:2020){
  
  link <- paste0("https://www.racing-statistics.com/en/seasons/",i)
  page <- read_html(link)
  #On stocke les valeurs de l'année
  circuit <- page %>% html_nodes("td.nomob:nth-child(4)") %>% html_text()
  
  Circuit<-c(Circuit,circuit)
  Year<-c(Year,rep(i,length(circuit)))
}

Circuit<- chartr("éèëêÉÈËÊàÀçÇü", "eeeeEEEEaAcCu", Circuit)

CircuitID <- racemap(Circuit)
CircuitID[which(Circuit=="Nurburgring")] <- "nuerburgring"

Lng <- c()
Lat <- c()

#Parcours de chaque circuit pour récupérer les coordonnées
for(j in 1:length(CircuitID)){
  
  link <- paste0("https://www.racing-statistics.com/en/circuits/",CircuitID[j])
  page <- read_html(link)
  Lng_Lat <- page %>% html_nodes(".bottommargin tr:nth-child(2) a") %>% html_text()

  lng_lat<-unlist(strsplit(Lng_Lat,split=", "))
  
  Lat <- c(Lat, lng_lat[1])
  Lng <- c(Lng, lng_lat[2])
  
}

Lat <- as.numeric(Lat)
Lng <- as.numeric(Lng)

#Création de la data frame finale
dataCoord <- data.frame(Year=Year,Circuit=Circuit,Lat,Lng)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataCoord,"dataCoord1950_2020.csv")

