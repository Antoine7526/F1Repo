library(rvest)
library(dplyr)
library(stringr)
library(plyr)

#2021
#Récupération des données ? l'aide du webscraping
link = "https://www.formula1.com/en/results.html/2021/races.html"
page = read_html(link)
grandprix = page %>% html_nodes(".table-wrap .limiter+ .bold") %>% html_text()
date = page %>% html_nodes(".table-wrap .dark.hide-for-mobile") %>% html_text()
winner = page %>% html_nodes(".table-wrap .dark+ .bold") %>% html_text()
car  = page %>% html_nodes(".table-wrap .uppercase") %>% html_text()
laps  = page %>% html_nodes(".table-wrap .bold.hide-for-mobile") %>% html_text()
time = page %>% html_nodes(".table-wrap .bold.hide-for-tablet") %>% html_text()
#Cr?ation d'une data frame qui ne poss?de que les ann?es, les tours, la granularit?,les candidats et les votes 
tmp = data.frame(grandprix,date, winner, car,laps,time, stringsAsFactors = FALSE)

g<-str_replace_all(grandprix,"\n","")
grandprix<-str_replace_all(g," ","")

g<-str_replace_all(winner,"  ","")
winner<-str_replace_all(g,"\n"," ")


str_sub(winner,1,nchar(winner)-4) #Supprimer les 4 derniers caractères ex: "HAM "



