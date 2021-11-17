# Projet F1

Ce projet a visé à créer une application shiny permettant la visualisation de données sur la Formule 1 depuis 1950.

## Informations Générales 

Le dossier le plus important sur ce Git, est le dossier [```Shiny```](https://github.com/Antoine7526/F1Repo/tree/main/Shiny). En effet, ce dernier fait référence à tous les autres : [```DATA```](https://github.com/Antoine7526/F1Repo/tree/main/DATA), [```Fonctions```](https://github.com/Antoine7526/F1Repo/tree/main/Fonctions),
[```Test```](https://github.com/Antoine7526/F1Repo/tree/main/Test), et [```Rapport```](https://github.com/Antoine7526/F1Repo/tree/main/Rapport). Chaque dossier comporte plusieurs versions. Nous utilisons à chaque fois la plus récente. Les autres versions sont disponibles car elles permettent la compréhension et la visualisation de l'évolution de notre travail.


## Packages

Plusieurs packages ont été utilisés pour mener a bien ce projet. Nous recensons ceux qui sont relatifs à l'application *shiny* : 
```shiny```,```shinythemes```,```shinydashboard```,```dashboardthemes```,```shinydashboardPlus```.

Et d'autres pour la visualisation et manipulation de données : 
```plotly```,```dplyr```, et ```VroumVroum```.

Vérifiez bien que vous les ayez tous pour pouvoir lancer le fichier [```shinyapp.R```](https://github.com/Antoine7526/F1Repo/blob/main/Shiny/2.3/shinyapp.R).

Le package ```VroumVroum``` contient toutes les données recueillies ainsi que toutes les fonctions développées sur ce dépôt. Pour plus d'informations sur ce dernier, il est disponible [ici](https://github.com/CharlineChamp/VroumVroum). Pour profiter plainement de notre application shiny, il est nécessaire de l'installer.
Pour ce faire, vous pouvez procèder comme suit: 
```r
remotes::install_github('CharlineChamp/VroumVroum') 
```
## Auteurs

[Batiste Amistadi](https://github.com/devilbaba), [Charline Champ](https://github.com/CharlineChamp), [Antoine Grancher](https://github.com/Antoine7526)

