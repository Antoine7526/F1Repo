library(VroumVroum)
library(dplyr)
library(stringr)

################################################################################
#                   TEST DES FONCTIONS DU PACKAGE VroumVroum                   #
################################################################################

#INITIALISATION

#Nombre d'éléments que l'ont veut tirer au hasard
n <- 1  
#Intervalle où nous allons piocher n années
annees <- 1950:2020  

#Tirage au sort de n années 
sampA <- as.numeric(sample(annees,n)); sampA 

#Tirage au sort de n années pour dataTeams
sampAt <- as.numeric(sample(annees,n))
while(sampAt < 1958){sampAt <- as.numeric(sample(annees,n))}; sampAt

#Tirage au sort de n+1 années
sampAn <- as.numeric(sample(annees,n+1))

#On veut sampAn[1] < sampAn[2]
while(sampAn[1] >= sampAn[2]){sampAn <- as.numeric(sample(annees,n+1))}

sampA1 <- sampAn[1]; sampA2 <- sampAn[2]; sampA1; sampA2

#Tirage au sort d'un Grand Prix parmi ceux présents dans l'année sampA
gp <- c()
indices <- which(dataDriversParRaces$Year == sampA)

for(i in indices){gp <- c(gp,dataDriversParRaces$GrandPrix[i])}

GP <-  unique(gp)
sampGP <- sample(GP,n); sampGP

#Récupération des sous bases de données
dr <- filter(dataRaces, dataRaces$Year == sampA)
dd <- filter(dataDrivers, dataDrivers$Year == sampA)
dpr <- filter(dataDriversParRaces, dataDriversParRaces$Year == sampA)
dfl <- filter(dataFL, dataFL$Year == sampA)
dsg <- filter(dataStartingGrid, dataStartingGrid$Year == sampA)
dc <- filter(dataCoord, dataCoord$Year == sampA)
dt <- filter(dataTeams, dataTeams$Year == sampAt)

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
DNFGrandPrix(dpr)

#Test DNF_S_freq
#DNF_S_freq(dataDriversParRaces,année1,année2) tq année1 < année2 
DNF_S_freq(dpr,sampA1,sampA2)

#Test MapGP
MapGP(dc)




