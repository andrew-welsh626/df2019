library(lubridate)
library(tidyverse)

games <- read.csv("data/games.csv")
wellness <- read.csv("data/wellness.csv")
gps <- read.csv("data/gps.csv")
rpe <- read.csv("data/rpe.csv")

wellnessSubset <- wellness[sample(nrow(wellness), 200),]
gpsSubset <- left_join(gps, wellnessSubset)
rpeSubset <- left_join(rpe, gpsSubset)
