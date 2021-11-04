library(rvest)
library(dplyr)
library(stringr)
library(plyr)


#******************************************************************#
#                      Récupération des courses 
#******************************************************************#

#R?cup?ration des donn?es concernant les courses à l'aide du webscraping

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
  winner <- str_replace_all(winner,"  ","")
  winner <- str_replace_all(winner,"\n"," ")
  
  grandprix <- str_replace_all(grandprix,"  ","")
  grandprix <- str_replace_all(grandprix,"\n"," ")
  
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

#On enlève les lignes où le site avait fait une erreur
dataRaces <- dataRaces[-c(12,50,64),]

#Ecriture de la data frame dans un fichier .csv
write.csv(dataRaces,"dataRaces1950_2020.csv")



#******************************************************************#
#                     Récupération des pilotes 
#******************************************************************#

#On crée les vecteurs qui seront les colonnes de notre data frame
Year <- c()
Position <- c()
Driver <- c()
Nationality <- c()
Car <- c()
Points <- c()

#On parcourt toutes les années voulues.
for(i in 1950:2020){
  link = paste0("https://www.formula1.com/en/results.html/",i,"/drivers.html")
  page = read_html(link)
  #On stocke les valeurs de l'ann?e
  position = page %>% html_nodes(".table-wrap .limiter+ .dark") %>% html_text()
  driver = page %>% html_nodes(".table-wrap td:nth-child(3)") %>% html_text()
  nationality = page %>% html_nodes(".table-wrap .dark.uppercase") %>% html_text()
  car  = page %>% html_nodes(".table-wrap .uppercase+ td") %>% html_text()
  points  = page %>% html_nodes(".table-wrap td.bold") %>% html_text()
  
  #Modification de deux colonnes pour enlever \n et les espaces 
  driver <- str_replace_all(driver,"  ","")
  driver <- str_replace_all(driver,"\n"," ")
  
  car <- str_replace_all(car,"  ","")
  car <- str_replace_all(car,"\n"," ")
  
  #Suppression des 5 derniers caract?res ex: "HAM  "
  driver <- str_sub(driver,1,nchar(driver)-5) 
  
  #On actualise nos vecteurs de la data frame
  Year <- c(Year,rep(i,length(driver)))
  Position <- c(Position,position)
  Driver <- c(Driver,driver)
  Nationality <- c(Nationality,nationality)
  Car <- c(Car,car)
  Points <-c(Points,points)
  
}

#Création de la data frame finale
dataDrivers = data.frame(Year,Position,Driver,Nationality,Car,Points, stringsAsFactors = FALSE)


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
for(i in 1958:2020){
  link = paste0("https://www.formula1.com/en/results.html/",i,"/team.html")
  page = read_html(link)
  #On stocke les valeurs de l'ann?e
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
dataTeams = data.frame(Year,Position,Team,Points, stringsAsFactors = FALSE)


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
  driver <- str_replace_all(driver,"  ","")
  driver <- str_replace_all(driver,"\n"," ")
  
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

#récupération des pilotes

list_link<-function(men){
  #La fonction crée une partie du lien pour récuperer les données sur le pilote
  liste_link=c()
  for(i in men){
    driver<-unlist(strsplit(i,split=" "))
    driver<-driver[driver!=""]
    if(is.na(driver[3])){
      driver<-driver[1:2]
    }
    driver<-chartr("éèëêÉÈËÊàÀçÇäö", "eeeeEEEEaAcCao", driver)
    initiales<-substr(driver,1,3)
    if(length(initiales)==3){
      liste_link<-c(liste_link,paste0(toupper(initiales[1]),toupper(initiales[3]),
                                      "01/",tolower(driver[1]),"-",tolower(driver[2]),"-",tolower(driver[3]),".html"))
    }else{
      liste_link<-c(liste_link,paste0(toupper(initiales[1]),toupper(initiales[2]),
                                      "01/",tolower(driver[1]),"-",tolower(driver[2]),".html"))
    }
  }
  liste_link
}


#On crée les vecteurs qui seront les colonnes de notre data frame
Driver <- c()
GrandPrix <- c()
Date <- c()
Year <- c()
Position <- c()
Points <- c()
Car <-c()

#On parcourt les années voulues.
for(i in 1950:2020){
  link<-paste0("https://www.formula1.com/en/results.html/",i,"/drivers.html")
  page<-read_html(link)
  #On récupere la liste des pilotes de l'année
  men <- page %>% html_nodes("td:nth-child(3)") %>% html_text()
  #On enlève les \n, les espaces et caractères qui ne sont pas utiles.
  men<-str_replace_all(men,"  ","")
  men<-str_replace_all(men,"\n"," ")
  men<-substr(men,3,nchar(men)-6)
  
  
  #On crée la liste des liens pour chaque pilote du premier au dernier sur l'année pour Ãªtre en accord avec la variable men
  
  liste_link<-list_link(men)
  link<-paste0("https://www.formula1.com/en/results.html/",i,"/drivers/")
  
  #Certaines personnes ont des noms particuliers et l'URL est différente donc on la change manuellement.
  if(i==1951){
    liste_link[15]="TOUDEG01/toulo-de-graffenried.html"
  }else if(i==1953){
    liste_link[8]="TOUDEG01/toulo-de-graffenried.html"
  }else if(i==1956){
    liste_link[17]="ALFDEP01/alfonso-de-portago.html"
    liste_link[20]="HERDAS01/hermano-da-silva-ramos.html"
  }else if(i==1957){
    liste_link[16]="WOLVON01/wolfgang-von-trips.html"
    liste_link[20]="ALFDEP01/alfonso-de-portago.html"
  }else if(i==1958){
    liste_link[12]="WOLVON01/wolfgang-von-trips.html"
    liste_link[20]="JOOBON01/jo-bonnier.html"
  }else if(i==1959){
    liste_link[8]="JOOBON01/jo-bonnier.html"
  }else if(i==1960){
    liste_link[7]="WOLVON01/wolfgang-von-trips.html"
    liste_link[18]="JOOBON01/jo-bonnier.html"
  }else if(i==1961){
    liste_link[2]="WOLVON01/wolfgang-von-trips.html"
    liste_link[15]="JOOBON01/jo-bonnier.html"
  }else if(i==1962){
    liste_link[15]="JOOBON01/jo-bonnier.html"
    liste_link[17]="CARDEB01/carel-godin-de-beaufort.html"
  }else if(i==1963){
    liste_link[11]="JOOBON01/jo-bonnier.html"
    liste_link[14]="CARDEB01/carel-godin-de-beaufort.html"
    liste_link[17]="JOOSIF01/jo-siffert.html"
    liste_link[31]="MARDEA01/mario-de-araujo-cabral.html"
    liste_link[44]="PETDEK01/peter-de-klerk.html"
  }else if(i==1964){
    liste_link[10]="JOOBON01/jo-bonnier.html"
    liste_link[15]="JOOSIF01/jo-siffert.html"
  }else if(i==1965){
    liste_link[12]="JOOSIF01/jo-siffert.html"
  }else if(i==1966){
    liste_link[20]="JOOBON01/jo-bonnier.html"
    liste_link[15]="JOOSIF01/jo-siffert.html"
  }else if(i==1967){
    liste_link[15]="JOOBON01/jo-bonnier.html"
    liste_link[13]="JOOSIF01/jo-siffert.html"
  }else if(i==1968){
    liste_link[22]="JOOBON01/jo-bonnier.html"
    liste_link[7]="JOOSIF01/jo-siffert.html"
  }else if(i==1969){
    liste_link[9]="JOOSIF01/jo-siffert.html"
  }else if(i==1971){
    liste_link[5]="JOOSIF01/jo-siffert.html"
  }else if(i==1972){
    liste_link[16]="ANDDEA01/andrea-de-adamich.html"
  }else if(i==1973){
    liste_link[15]="ANDDEA01/andrea-de-adamich.html"
  }else if(i==1974){
    liste_link[16]="HANSTU02/hans-joachim-stuck.html"
  }else if(i==1976){
    liste_link[13]="HANSTU02/hans-joachim-stuck.html"
  }else if(i==1977){
    liste_link[11]="HANSTU02/hans-joachim-stuck.html"
  }else if(i==1978){
    liste_link[18]="HANSTU02/hans-joachim-stuck.html"
  }else if(i==1979){
    liste_link[16]="ELIDEA01/elio-de-angelis.html"
    liste_link[20]="HANSTU02/hans-joachim-stuck.html"
  }else if(i==1980){
    liste_link[7]="ELIDEA01/elio-de-angelis.html"
  }else if(i==1981){
    liste_link[8]="ELIDEA01/elio-de-angelis.html"
    liste_link[19]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1982){
    liste_link[9]="ELIDEA01/elio-de-angelis.html"
    liste_link[17]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1983){
    liste_link[17]="ELIDEA01/elio-de-angelis.html"
    liste_link[8]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1984){
    liste_link[3]="ELIDEA01/elio-de-angelis.html"
    liste_link[18]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1985){
    liste_link[5]="ELIDEA01/elio-de-angelis.html"
    liste_link[17]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1987){
    liste_link[14]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1988){
    liste_link[15]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1989){
    liste_link[16]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1991){
    liste_link[9]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1992){
    liste_link[9]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1994){
    liste_link[20]="ANDDEC01/andrea-de-cesaris.html"
  }else if(i==1996){
    liste_link[2]="JACVIL02/jacques-villeneuve.html"
  }else if(i==1997){
    liste_link[1]="JACVIL02/jacques-villeneuve.html"
  }else if(i==1998){
    liste_link[5]="JACVIL02/jacques-villeneuve.html"
  }else if(i==1999){
    liste_link[17]="PEDDEL01/pedro-de-la-rosa.html"
  }else if(i==2000){
    liste_link[7]="JACVIL02/jacques-villeneuve.html"
    liste_link[16]="PEDDEL01/pedro-de-la-rosa.html"
  }else if(i==2001){
    liste_link[7]="JACVIL02/jacques-villeneuve.html"
    liste_link[16]="PEDDEL01/pedro-de-la-rosa.html"
  }else if(i==2002){
    liste_link[12]="JACVIL02/jacques-villeneuve.html"
    liste_link[21]="PEDDEL01/pedro-de-la-rosa.html"
    liste_link[22]="ENQBER01/enrique-bernoldi.html"
  }else if(i==2003){
    liste_link[16]="JACVIL02/jacques-villeneuve.html"
    liste_link[13]="CRIDAM01/cristiano-da-matta.html"
  }else if(i==2004){
    liste_link[21]="JACVIL02/jacques-villeneuve.html"
    liste_link[17]="CRIDAM01/cristiano-da-matta.html"
  }else if(i==2005){
    liste_link[14]="JACVIL02/jacques-villeneuve.html"
    liste_link[20]="PEDDEL01/pedro-de-la-rosa.html"
    liste_link[25]="ROBDOO02/robert-doornbos.html"
  }else if(i==2006){
    liste_link[15]="JACVIL02/jacques-villeneuve.html"
    liste_link[11]="PEDDEL01/pedro-de-la-rosa.html"
  }else if(i==2008){
    liste_link[12]="NELPIQ02/nelson-piquet.html"
  }else if(i==2009){
    liste_link[21]="NELPIQ02/nelson-piquet.html"
  }else if(i==2010){
    liste_link[17]="PEDDEL01/pedro-de-la-rosa.html"
    liste_link[24]="LUCDIG01/lucas-di-grassi.html"
  }else if(i==2011){
    liste_link[20]="PEDDEL01/pedro-de-la-rosa.html"
    liste_link[13]="PAUDIR01/paul-di-resta.html"
    liste_link[24]="JERDAM01/jerome-d'ambrosio.html"
  }else if(i==2012){
    liste_link[25]="PEDDEL01/pedro-de-la-rosa.html"
    liste_link[14]="PAUDIR01/paul-di-resta.html"
    liste_link[23]="JERDAM01/jerome-d'ambrosio.html"
  }else if(i==2013){
    liste_link[12]="PAUDIR01/paul-di-resta.html"
  }else if(i==2016){
    liste_link[18]="JOLPAL02/jolyon-palmer.html"
  }else if(i==2017){
    liste_link[17]="JOLPAL02/jolyon-palmer.html"
  }else if(i==2020){
    liste_link[21]="NICLAF01/nicholas-latifi.html"
  }
  
  #Remplissage du dataframe
  for(j in (1:length(men))){
    #Récupération du lien du pilote
    man <-paste0(link,liste_link[j])
    page = read_html(man)
    #Récupération des colonnes utiles du pilote
    grandprix = page %>% html_nodes(".limiter+ td") %>% html_text()
    date = page %>% html_nodes(".bold:nth-child(3)") %>% html_text()
    car  = page %>% html_nodes("td.hide-for-mobile") %>% html_text()
    position  = page %>% html_nodes(".hide-for-mobile+ .dark") %>% html_text()
    points = page %>% html_nodes(".dark+ .bold") %>% html_text()
    
    #Transformation de certaines colonnes
    grandprix<-substr(grandprix,14,nchar(grandprix)-9)
    
    car<-str_replace_all(car,"  ","")
    car<-str_replace_all(car,"\n"," ")
    
    #Actualisation des données avec le nouveau driver
    Driver <- c(Driver,rep(men[j],length(points)))
    GrandPrix <- c(GrandPrix,grandprix)
    Date <- c(Date,date)
    Year <- c(Year,rep(i,length(points)))
    Position <- c(Position,position)
    Points <- c(Points,points)
    Car <- c(Car,car)
  }
  
}

#Création de la data frame finale
dataDriversParRaces = data.frame(Indice=c(1:length(Driver)),Driver,GrandPrix,Date,Year,Car,Position,Points, stringsAsFactors = FALSE)


write.csv(dataDriversParRaces,"dataDriversParRaces1950_2020.csv")


#******************************************************************#
# Récupération des positions de départ 
#******************************************************************#



race<- function(gp){
  #On crée une partie du lien URL pour extraire les données de chaque grand prix.
  listRace<-c()
  for(i in gp){
    Gprix<-unlist(strsplit(i,split=" "))
    Gprix<-Gprix[Gprix!=""]
    assemblage=Gprix[1]
    if(length(Gprix)>1){
      for(j in Gprix[2:length(Gprix)]){
        assemblage<-paste0(assemblage,"-",j)
      }
    }
    listRace<-c(listRace,tolower(assemblage))
  }
  listRace
}

#Récupération du nom des Grand Prix

ListGP<-c()
annee<-c()

#On récupère le nom de chaque grand prix de 1950 à 2020
for(i in 1950:2020){
  link <- paste0("https://www.formula1.com/en/results.html/",i,"/races.html")
  page <- read_html(link)
  GrandPrix <- page %>% html_nodes(".table-wrap .limiter+ .bold") %>% html_text()
  g <- str_replace_all(GrandPrix,"  ","")
  GrandPrix<-str_replace_all(g,"\n"," ")
  #Il y a 3 grands prix doublés qu'on enlève.
  if(i==1951){
    GrandPrix=GrandPrix[-5]
  }else if(i==1956){
    GrandPrix=GrandPrix[-1]
  }else if(i==1957){
    GrandPrix=GrandPrix[-6]
  }
  
  #On actualise notre vecteur des grands prix en actualisant les ann?es correspondantes.
  ListGP<-c(ListGP,GrandPrix)
  annee<-c(annee,rep(i,length(GrandPrix)))
}

#Chaque grand prix dans l'url a un nombre unique associé.
listID <- c(94:421,80:93,422:452,9,453:457,8,458:513,5:7,514:558,
            64:79,559:574,2,575:597,3,598:702,47:63,703:878,28:46,
            10:17,4,18,1,19:27,879:925,927:936,938:944,958,945:957,959:1020,1045:1061)

#On récupère les grands prix sous leur forme dans l'URL pour extraire les données de chacun de ses grands prix.
listRace<-race(ListGP)

#Initialisation des futures colonnes de notre data frame
Year <- c()
GrandPrix <- c()
Position <- c()
Number <- c()
Driver <- c()
Car <- c()

#On parcourt chaque grand prix pour récupérer ses données
for(i in 1:length(listID)){
  link <-paste0("https://www.formula1.com/en/results.html/",annee[i],"/races/",listID[i],"/",listRace[i],"/starting-grid.html")
  page<-read_html(link)

  position <- page %>% html_nodes(".limiter+ .dark") %>% html_text()
  number <- page %>% html_nodes(".dark:nth-child(3)") %>% html_text()
  driver <- page %>% html_nodes(".dark+ .bold") %>% html_text()
  car <- page %>% html_nodes(".uppercase") %>% html_text()
  
  #On modifie driver et car pour les avoir sous le bon format
  driver <- str_replace_all(driver," ","")
  driver <- str_replace_all(driver,"\n"," ")
  driver <- substr(driver,2,nchar(driver)-5)
  driver <- driver[driver!=""]
  
  car<-car[seq(2,length(car),by=2)]
  
  #On actualise chaque vecteur
  Year <- c(Year,rep(annee[i],length(position)))
  GrandPrix <- c(GrandPrix,rep(ListGP[i],length(position)))
  Position <- c(Position,position)
  Number <- c(Number,number)
  Driver <- c(Driver,driver)
  Car <- c(Car,car)
}

#Création de la data frame finale
dataSG <- data.frame(Year,GrandPrix,Position,Number,Driver,Car)

#Ecriture de la data frame dans un fichier .csv
write.csv(dataSG,"dataStartingGrid1950_2020.csv")
