library(Rcpp)
library(tidyr)
library(ggbeeswarm)
library(microbenchmark)
library(bench)


sourceCpp('~/Documents/UGA/M1/S7/Logiciels Spécialisés/R/TestRcpp/TestRcpp.cpp')


lb <- bench::mark(PosFinalePilote(dataDriversParRaces1950_2020,dataFL1950_2020,dataRaces1950_2020,dataDrivers1950_2020))
plot(lb)
