library(leaflet)


MapGP <- function(data){
  #Création notre data frame spatiale
  df <- sp::SpatialPointsDataFrame(
    cbind((data$Lng), (data$Lat)),
    data.frame(type = factor(1:length(data$Lng))))
  
  Icon <- makeIcon(iconUrl = "www/test.png",iconWidth= 70,iconHeight= 35)
  #Création de la carte interactive
  leaflet(df) %>% addTiles()%>% addMarkers(icon = Icon) %>%addProviderTiles("CartoDB.DarkMatter")
  
}
