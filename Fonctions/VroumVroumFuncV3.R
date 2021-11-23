library(dplyr)
library(plotly)
library(ggplot2)
library(viridis)


#*******************************************************************************************************
#                                             TEAM FUNCTIONS 
#*******************************************************************************************************

DataTeamAnalyse <- function(data){
  
  #On récupÃ¨re toutes les lignes associées Ã  la premiÃ¨re position
  listTeamWinner <- which(data$Position=="1")
  
  #Vecteur des winners
  cars <- c()
  for(i in listTeamWinner){
    cars <- c(cars,data$Car[i])
  }
  
  
  car <- as.factor(cars)
  #data frame des fréquences 
  TeamWinner <- Tri(car)
  
  #Compute the bottom of each rectangle
  TeamWinner$ymin = c(0, head(TeamWinner$ymax, n=-1))
  
  #Compute the cumulative percentages (top of each rectangle)
  TeamWinner$ymax = cumsum(TeamWinner$frequence)
  
  #Donut chart avec plotly
  TeamWinner <- TeamWinner %>% group_by(modalite)
  fig <- TeamWinner %>% plot_ly(labels = ~modalite, values = ~frequence)
  fig <- fig %>% add_pie(hole = .5)
  fig <- fig %>% layout(showlegend = T,
                        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  fig <- fig %>% layout(legend = list(title=list(text='<b> Ecuries </b>')))
  fig
}

###############################################################
# Graphique de la somme des points par écurie par Grand Prix  #
###############################################################

PointEcurieGP <- function(data_race_driver){
  
  #Récupération des écuries et des grands prix
  Ecurie <- unique(data_race_driver$Car)
  gp <- unique(data_race_driver$GrandPrix)
  
  #Initialisation des vecteurs
  somme <- c()
  ecurie <- c()
  GP <- c()
  
  #Somme des points des ecuries par Grand Prix
  for(i in gp){
    tmp_gp <- data_race_driver[data_race_driver$GrandPrix==i,c(6,8)]
    for(j in Ecurie){
      tmp_ecurie <- tmp_gp$Points[tmp_gp$Car==j]
      somme <- c(somme,sum(tmp_ecurie))
      ecurie <- c(ecurie,j)
      GP <- c(GP,i)
    }
  }
  
  #Data frame comportant les écuries, les grands prix et la somme des points gagnés par les écuries
  position_ecurie <- data.frame(Ecurie=ecurie,GrandPrix=GP,Points=somme)
  
  #Graphe de la sommes des points des écuries par Grand Prix
  position_ecurie_graph <- ggplot(data = position_ecurie,aes(x=GrandPrix,y=Points,group=Ecurie,colour=Ecurie))+
                           geom_line()+
                           theme_bw()+
                           guides(fill=guide_legend("Ecuries"))+
                           xlab("Grands Prix")+
                           ylab("Nombre de points gagnes")+
                           theme(plot.title=element_text(hjust=0.5,size=18,face="bold"))+
                           theme(axis.title.x = element_text(hjust=0.5,size=15))+
                           theme(axis.title.y=element_text(hjust=0.5,size=15))+
                           theme(legend.title = element_text(size=10))+
                           theme(axis.text.x = element_text(face="bold", color="black", size=10, angle=30))
  
  #Concersion en plotly
  ggplotly(position_ecurie_graph)
  
}

#*******************************************************************************************************
#                                             DRIVERS FUNCTIONS 
#*******************************************************************************************************

########################################################################
# Regardons si la personne qui possÃ¨de le meilleur tour est le gagnant #
########################################################################

PosFinalePilote <- function(data_driver_race,data_fl,data_races,data_driver){
  
  #Total du nombre de circuits
  total_circuit <- length(data_races$GrandPrix)
  
  #Total du nombre de pilotes
  total_pilote <- length(data_driver$Driver)
  
  #Liste de toutes les positions finales des pilotes ayant fait le tour le plus rapide
  liste_position <- c()
  for (i in (1:total_circuit)){
    grandprix <- data_fl$GrandPrix[i]
    driver <- data_fl$Driver[i]
    position <- which((data_driver_race$GrandPrix == grandprix) & (data_driver_race$Driver == driver))
    position_driver <- data_driver_race$Position[position]
    position_driver <- as.numeric(position_driver)
    liste_position <- c(liste_position,position_driver)
  }
  
  #On convertit les NA en 0
  liste_position[is.na(liste_position)] <- 0
  
  #data frame comprenant les fréquences des positions d'arrivées
  g <- Tri(liste_position)
  position_pilote <- g$modalite
  #Diagramme en barre des fréquences
  diagramme <- ggplot(g, aes(x=position_pilote, y=frequence,fill = position_pilote))+ 
               geom_bar(stat = "identity",show.legend= F)+
               scale_x_continuous(name="Position finale des pilotes", breaks = c(1:total_pilote))+
               scale_y_continuous(name="Fréquence")+
               scale_fill_viridis(discrete=F,begin=0,end=1,option = "plasma")+
               theme(plot.title = element_text(face = "bold",hjust = 0.5))
  
  #Conversion en plotly
  ggplotly(diagramme)
}


############################################################################
# Comparons la position de départ des pilotes avec leur position d'arrivée #
############################################################################

PosDepArr <- function(data_sg, data_driver_race, grand_prix){
  
  #Récupération du grand prix
  l <- data_sg[data_sg$GrandPrix == grand_prix,]
  
  #Récupération des positions de départ du grand prix
  position_depart <- as.numeric(l$Position)
  pilote_depart <- l$Driver
  depart <- data.frame(position_depart,pilote_depart)
  
  #Récupération du grand prix
  lbis <- data_driver_race[data_driver_race$GrandPrix == grand_prix,]
  
  #Récupération des positions d'arrivée du grand prix
  position_arrivee <- as.numeric(lbis$Position)
  pilote_arrivee <- lbis$Driver
  arrivee <- data.frame(position_arrivee,pilote_arrivee)
  
  #Data frame finales comportant les positions de départ et d'arrivée associées Ã  chaque pilote
  g <- data.frame(depart[order(pilote_depart),],position_arrivee=arrivee[order(pilote_arrivee),]$position_arrivee)
  
  #Graphe des position de départ et d'arrivée 
  graphique <- ggplot(g, aes(x=position_depart, y=position_arrivee, color=pilote_depart))+ 
               geom_point() +
               geom_segment(aes(x = 0, y = 0, xend = length(position_depart), yend = length(position_depart),color="black")+
               labs(color = "Pilotes")+
               theme(plot.title = element_text(face = "bold",hjust = 0.5))
  
  #Conversion en plotly
  ggplotly(graphique)
  
}

##########################################################################################################################
# Fonction affichant un diagramme en barres qui représentent le nombre de points moyens par grand prix de chaque pilote. #
##########################################################################################################################

#Fonction affichant un diagramme en barres qui représentent le nombre de points moyens eu par grand prix de chaque pilote.
Pts_moyens_Driver_GP <-function(datadrivers,dataraces){
  
  #On récupère les années.
  year<-unique(dataraces$Year)
  GP_annee<-rep(0,length(year))
  
  for(i in (1:length(year))){
    #GP_annee stocke le nombre de grand prix par année
    GP_annee[i]<-length(dataraces$Year[dataraces$Year==year[i]])
  }
  #On crée notre data frame oÃ¹ on associe au Driver l'année.
  data_driver_pts <-data.frame(Driver=datadrivers$Driver,Points=datadrivers$Points)
  freq<-c()
  for(i in 1:length(year)){
    #On crée un vecteur freq de la mÃªme taille que le nombre de lignes de la data.frame.
    freq<-c(freq,rep(GP_annee[i],length(datadrivers$Year[datadrivers$Year==year[i]])))
  }
  #On divise le nombre de pts par le nombre de grand prix pour obtenir les points moyens.
  data_driver_pts$Points<-data_driver_pts$Points/freq
  
  driver_pts_gp <- ggplot(data=data_driver_pts,aes(x=Driver,y=Points,fill=Driver))+
                   geom_bar(stat="identity")+
                   labs(fill="Pilotes")+
                   xlab("Pilotes")+
                   ylab("Nombre de points moyens")+
                   #On supprime l'abscisse qui contient le nom des pilotes. Ceux si sont dans la légende.
                   scale_x_discrete(labels=c(rep("",length(data_driver_pts$Driver))))+
                   theme(plot.title=element_text(hjust=0.5,size=25,face="bold"))+
                   theme(axis.title.x = element_text(hjust=0.5,size=15))+
                   theme(axis.title.y=element_text(hjust=0.5,size=15))+
                   theme_classic()+
                   theme(legend.title = element_text(size=15))
  
  ggplotly(driver_pts_gp)
}

###################################################
# Graphique des points des drivers par Grand Prix #
###################################################

PointDriverGP <- function(data_driver_race, data_race){
  
  #Récupération des points, des Grands Prix et des pilotes
  Points <- as.numeric(data_driver_race$Points)
  GrandPrix <- data_driver_race$GrandPrix
  Driver <- data_driver_race$Driver
  
  #Création de la data frame comprenant ces données
  data <- data.frame(GrandPrix,Points,Driver)
  
  #Plot des courbes des pilotes (nombre de ppints en fonction de chaque gp)
  DriversparRaces <- ggplot(data=data,aes(x=GrandPrix,y=Points,group=Driver,colour=Driver))+
                     geom_line()+
                     theme_bw()+
                     scale_x_discrete(limits=unique(data_race$GrandPrix))+
                     labs(colour="Pilotes")+
                     xlab("Grands Prix")+
                     ylab("Nombre de points gagnes")+
                     theme(plot.title=element_text(hjust=0.5,size=18,face="bold"))+
                     theme(axis.title.x = element_text(hjust=0.5,size=15))+
                     theme(axis.title.y=element_text(hjust=0.5,size=15))+
                     theme(legend.title = element_text(size=10))+
                     theme(axis.text.x = element_text(face="bold", color="black", size=10, angle=30))
  
  #Conversion en plotly
  ggplotly(DriversparRaces)
  
}

#*******************************************************************************************************
#                                             DNF FUNCTIONS 
#*******************************************************************************************************

DNFTeam <-  function(data){
  
  #Récupération des lignes associées aux DNF/DNS
  listDNFTeam <- which(data$Position=="DNF")
  listDNSTeam <- which(data$Position=="DNS")
  
  #Fusion des listes
  DNFS <- sort(c(listDNFTeam,listDNSTeam))
  
  DNFT <- c()
  for(i in DNFS){
    DNFT <- c(DNFT,data$Car[i])
  }
  
  DNF <- as.factor(DNFT)
  DNFTeam <- Tri(DNF)
  
  #Compute the bottom of each rectangle
  DNFTeam$ymin = c(0, head(DNFTeam$ymax, n=-1))
  
  #Compute the cumulative percentages (top of each rectangle)
  DNFTeam$ymax = cumsum(DNFTeam$frequence)
  
  #Donut chart avec plotly
  DNFTeam <- DNFTeam %>% group_by(modalite)
  fig <- DNFTeam %>% plot_ly(labels = ~modalite, values = ~frequence)
  fig <- fig %>% add_pie(hole = .5)
  fig <- fig %>% layout(showlegend = T,
                        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  fig <- fig %>% layout(legend = list(title=list(text='<b> Ecuries </b>')))
  fig
}


##############################################
# Graphique du nombre d'abandons par pilote  #
##############################################

DNFDriver <- function(data_driver_races){
  
  #Récupération des pilotes qui on été DNF/DNS
  DNF <- data_driver_races$Driver[data_driver_races$Position=='DNF']
  DNS <- data_driver_races$Driver[data_driver_races$Position=='DNS']
  
  #data frame des DNF/DNS
  total<-data.frame(modalite=as.factor(c(DNF,DNS)))
  
  #Diagramme en barre des proportions de DNF/DNS par pilote
  DNF_S_pilote <- ggplot(data=total,aes(modalite))+
                  geom_bar(aes(fill=modalite))+
                  labs(fill="Pilotes")+
                  xlab("Pilotes")+
                  ylab("Nombre de DNF et DNS")+
                  theme(plot.title=element_text(hjust=0.5,size=25,face="bold"))+
                  theme(axis.title.x = element_text(hjust=0.5,size=15))+
                  theme(axis.text.x = element_text(face="bold", color="black", size=10, angle=30))+
                  theme(axis.title.y=element_text(hjust=0.5,size=15))+
                  theme(legend.title = element_text(size=15))
  
  #Conversion en plotly
  ggplotly(DNF_S_pilote)
}

######################################
# Graphique des DNF/S par Grand Prix #
######################################

DNFGrandPrix <- function(data_race_driver,data_race){
  
  #Récupération des DNF/DNS
  DNF <- data_race_driver$GrandPrix[data_race_driver$Position=='DNF']
  DNS <- data_race_driver$GrandPrix[data_race_driver$Position=='DNS']
  
  
  #Data frame comportant la proportion de DNF/DNS par grands prix
  total <- data.frame(modalite=as.factor(c(DNF,DNS)))
  
  #Diagramme en barre des DNF/DNS par grand prix
  DNF_S <- ggplot(data=total,aes(modalite))+
           geom_bar(aes(fill=modalite))+
           labs(fill="Grands prix")+
           xlab("Grands Prix")+
           ylab("Nombre de DNF et DNS")+
           theme(plot.title=element_text(hjust=0.5,size=25,face="bold"))+
           theme(axis.title.x = element_text(hjust=0.5,size=15))+
           theme(axis.title.y=element_text(hjust=0.5,size=15))+
           theme(legend.title = element_text(size=15))+
           theme(axis.text.x = element_text(face="bold", color="black", size=10, angle=30))
  
  #Conversion en plotly
  ggplotly(DNF_S)
  
}

################################################################################
# Fréquence de DNF/DNS de chaque pilote entre 2 années sélectionnées en amont. #
# Un pilote apparait seulement s'il a au moins une fois DNF/DNS.               #
################################################################################

DNF_S_freq <- function(dataDrivers,annee_inf,annee_sup){
  #Fréquence de DNF/DNS de chaque pilote entre 2 années sélectionnées en amont.
  #Un pilote apparer seulement s'il a au moins une fois DNF/DNS.
  
  #On récupÃ¨re les noms des personnes qui ont DNF et DNS.
  dataDrivers<- filter(dataDrivers, dataDrivers$Year >= annee_inf)
  dataDrivers<- filter(dataDrivers, dataDrivers$Year <= annee_sup)
  DNF <- dataDrivers$Driver[dataDrivers$Position=='DNF']
  DNS <- dataDrivers$Driver[dataDrivers$Position=='DNS']
  
  #On crée la data frame pour le graphique
  total2 <- as.data.frame(table(c(DNF,DNS)))
  colnames(total2) <- c("modalite","frequence")
  
  liste_driver <- total2$modalite
  #On calcule le nombre de grands prix qu'a fait chaque pilote qui a au moins DNF/DNS.
  nbr_grandprix <- rep(0,length(liste_driver))
  for(i in 1:length(nbr_grandprix)){
    nbr_grandprix[i] <- length(dataDrivers$GrandPrix[dataDrivers$Driver==liste_driver[i]])
  }
  #On calcule la fréquence.
  total2$frequence <- total2$frequence/nbr_grandprix
  
  #On crée un diagramme en barres des fréquences de DNF/DNS de chaque pilote.
  DNF_S_pilote <- ggplot(data=total2,aes(x=modalite,y=frequence,fill=modalite))+
                  geom_bar(stat="identity")+
                  labs(fill="Pilotes")+
                  xlab("Pilotes")+
                  ylab("Nombre de DNF et DNS")+
                  #On supprime l'abscisse qui contient le nom des pilotes. Ceux si sont dans la légende.
                  scale_x_discrete(labels=c(rep("",length(total2$modalite))))+
                  theme(plot.title=element_text(hjust=0.5,size=25,face="bold"))+
                  theme(axis.title.x = element_text(hjust=0.5,size=15))+
                  theme(axis.title.y=element_text(hjust=0.5,size=15))+
                  theme_classic()+
                  theme(legend.title = element_text(size=15))
  
  #Affichage du ggplot avec ggplotly pour une interactivité avec le diagramme.
  ggplotly(DNF_S_pilote)
}

