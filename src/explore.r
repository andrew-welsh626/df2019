wellness <- read.csv("data/wellness.csv")
gps <- read.csv("data/gps.csv")
rpe <- read.csv("data/rpe.csv")

wellnessSubset <- wellness[sample(nrow(wellness), 200),]
gpsSubset <- gps[sample(nrow(gps), 200),]
rpeSubset <- rpe[sample(nrow(rpe), 200),]
