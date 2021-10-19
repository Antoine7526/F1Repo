
#Test pour DataTeamAnalyse
dataTest <- dataDriversParRaces1950_2020
g = filter(dataTest, dataTest$Year == 2010)
DataTeamAnalyse(g)