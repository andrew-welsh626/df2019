library(lubridate)
library(tidyverse)

# Read in data
games <- read_csv("data/games.csv", col_types = cols(Date = col_date(format = "%Y-%m-%d")))
wellness <- read_csv("data/wellness.csv", col_types = cols(Date = col_date(format = "%m/%d/%Y")))
gps <- read.csv("data/gps.csv")
rpe <- read.csv("data/rpe.csv")

# Sample of wellness data
wellnessSubset <- wellness[sample(nrow(wellness), 200),]

# Games joined with subset of wellness by PlayerID and Date
wellnessSubsetGames <- inner_join(wellness, games)

# Group average fatigue by GameID
byGameIDFatigue <- wellnessSubsetGames %>%
  group_by(GameID, Outcome) %>%
  summarise(avgFatigue=mean(Fatigue))

# Box plot of average Fatigue over a game categorized by win/loss
boxplot(byGameIDFatigue$avgFatigue~byGameIDFatigue$Outcome)

# Join wellness subset by RPE
wellnessSubsetRPE <- inner_join(wellnessSubset, rpe, by="PlayerID")

# Fatigue over Session Load, colored by Session Type
ggplot(wellnessSubsetRPE, aes(SessionLoad, Fatigue, color = SessionType)) +
  geom_point()

# Fatigue over Objective Rating, colored by Session Type
ggplot(wellnessSubsetRPE, aes(ObjectiveRating, Fatigue, color = SessionType)) +
  geom_point()

# Fatigue over Focus Rating, colored by Session Type
ggplot(wellnessSubsetRPE, aes(FocusRating, Fatigue, color = SessionType)) +
  geom_point()

# Group average monitoring score by GameID
byGameIDMS <- wellnessSubsetGames %>%
  group_by(GameID, Outcome) %>%
  summarise(avgMS=mean(MonitoringScore))

# Box plot of average MonitoringScore over a game categorized by win/loss
boxplot(byGameIDMS$avgMS~byGameID$Outcome)
