library(VroumVroum)
library(dplyr)

################################################################################
#                   TEST DES FONCTIONS DU PACKAGE VroumVroum                   #
################################################################################

#INITIALISATION

#Chargement des data frame
dataDPR <- dataDriversParRaces1950_2020
dataD <- dataDrivers1950_2020
dataFL <- dataFL1950_2020
dataR <- dataRaces1950_2020
dataT <- dataTeams1950_2020
dataSG <- dataStartingGrid1950_2020

#Nombre d'éléments que l'ont veut tirer au hasard
n <- 1  

#Intervalle où nous allons piocher n années
annees <- 1950:2020  

#Tirage au sort de n années 
sampA <- sample(annees,n); sampA 

#Tirage au sort d'un Grand Prix parmi ceux présents dans l'année sampA
gp <- c()
indices <- which(dataDPR$Year == sampA)

for(i in indices){
  gp <- c(gp,dataDPR$GrandPrix[i])
}

GP <-  unique(gp)

sampGP <- sample(GP,n); sampGP


#Récupération des sous bases de données
dr <- filter(dataR, dataR$Year == sampA)
dd <- filter(dataD, dataD$Year == sampA)
dpr <- filter(dataDPR, dataDPR$Year == sampA)
dfl <- filter(dataFL, dataFL$Year == sampA)
dsg <- filter(dataSG, dataSG$Year == sampA)
#if(sampA >= 1958){dt <- filter(dataT, dataT$Year == sampA)}

#TESTS

#Test DataTeamAnalyse       
DataTeamAnalyse(dpr)

#Test PointEcurieGP         
PointEcurieGP(dpr)

#Test PosFinalePilote
PosFinalePilote(dpr,dfl,dr,dd)

#Test PosDepArr
PosDepArr(dsg,dpr,sampGP)

#Test Pts_moyens_Driver_GP
Pts_moyens_Driver_GP(dd,dr)

#Test PointDriverGP
PointDriverGP(dpr,dr)

#Test DNFTeam
DNFTeam(dpr)

#Test DNFDriver
DNFDriver(dpr)

#Test DNFGrandPrix
DNFGrandPrix(dpr,dr)

#Test DNF_S_freq
DNF_S_freq(dpr)



