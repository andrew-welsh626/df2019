library(readr)
gps <- read_csv("C:/Users/Duncan/Desktop/Datafest/data/gps.csv")
View(gps)

games.dates <- read_csv("C:/Users/Duncan/Desktop/Datafest/data/games.csv", 
                        col_types = cols(Date = col_date(format = "%Y-%m-%d")))
games <- read_csv("C:/Users/Duncan/Desktop/Datafest/data/games.csv")

games.gps = inner_join(games, gps)
games.gps.wellness = inner_join(games.gps, wellness)
View(games.gps.wellness)

library(ggplot2)
library(GGally)
library(readr)
library(MASS)
library(car)
library(leaps)
library(dplyr)
library(glmnet)

gps.subset = subset(gps, gps$GameID == 1)
View(gps.subset)
gps.subset.1 = subset(gps.subset, gps.subset$PlayerID == 2)
View(gps.subset.1)

x = group_by(gps.subset.1, GameClock) 
sum(gps$Speed)
x.sec = x %>% summarise(time_second = sum(Speed))
View(x.sec)
write.csv(x.sec, file = "Speed4.csv")
x.sec$movement = x.sec$time_second > 0
x.sec$move = as.integer(as.logical(x.sec$movement))

x.min = x.sec %>% mutate(min = minute(Time)) 
x.min.m = group_by(x.min, min)
x.min.move = x.min.m %>% summarise(min_move = sum(move))
sum(x.min.move$min_move > 30)

#---------------------------------------------------------------------
gps.subset = subset(gps, gps$GameID == 1)
View(gps.subset)
gps.subset.3 = subset(gps.subset, gps.subset$PlayerID == 3)
View(gps.subset.3)

x2 = group_by(gps.subset.3, Time) 
sum(gps$Speed)
x.sec2 = x2 %>% summarise(time_second = sum(Speed))
View(x.sec2)
write.csv(x.sec2, file = "Speed3.csv")
x.sec2$movement = x.sec2$time_second > 0
x.sec2$move = as.integer(as.logical(x.sec2$movement))

x.min2 = x.sec2 %>% mutate(min = minute(Time)) 
x.min.m2 = group_by(x.min2, min)
x.min.move2 = x.min.m2 %>% summarise(min_move = sum(move))
sum(x.min.move2$min_move > 30)

#----------------------------------------------------------------------------
gps.subset.4 = subset(gps, gps$GameID == 1)
unique(gps.subset.4$PlayerID)
unique((subset(gps, gps$GameID == 20))$PlayerID)

#-----------------------------------------------------------------------------
weights = data.frame()

for(ii in unique(gps$GameID)) {
  weight = c()
  a = 1
  for(i in unique((subset(gps, gps$GameID == ii))$PlayerID)) {
    gps.g1 = subset(gps, gps$GameID == ii)
    gps.g2 = subset(gps.g1, gps.g1$PlayerID == i)
    
    g3 = group_by(gps.g2, Time) 
    g4 = g3 %>% summarise(time_second = sum(Speed))
    g4$movement = g4$time_second > 0
    g4$move = as.integer(as.logical(g4$movement))
    
    g5 = g4 %>% mutate(min = minute(Time)) 
    g6 = group_by(g5, min)
    g7 = g6 %>% summarise(min_move = sum(move))
    b = sum(g7$min_move > 30)
    weight[a] = b
    a = a + 1
  }
  c = sum(weight)
  w = weight/c
  d = w
  a = 1
  for(i in unique((subset(gps, gps$GameID == ii))$PlayerID)){
    g8 = subset(games.gps.wellness, GameID == ii & PlayerID == i)
    fat = unique(g8$Fatigue)
    if(length(fat) == 0) {
      fat = 4
    }
    d[a] = d[a] * fat
    a = a + 1
  }
  data$weighted_fatigue[ii] = sum(d)
}

#-----------------------------------------------------------------------------
boxplot(data$weighted_fatigue ~ data$Win, ylim = c(2.5,4.5))
plot(data$Win ~ data$weighted_fatigue)
hist()
boxplot(data$Team_Fatigue ~ data$Win, ylim = c(2.5,4.5))
summary(data$Team_Fatigue)
summary(data$weighted_fatigue)

?boxplot

View(games)

data$Opponent = games$Opponent
View(data)
games.fatigue = games
games.fatigue$weighted_Fatigue = data$weighted_fatigue
games.fatigue$team_Fatigue = data$Team_Fatigue
games.fatigue$point.diff = (games$TeamPoints - games$TeamPointsAllowed)
View(games.fatigue)

plot(y = games.fatigue$point.diff, x = games.fatigue$weighted_Fatigue)
p.f = lm(games.fatigue$point.diff ~ games.fatigue$weighted_Fatigue)
summary(p.f)
abline(p.f)

anova(p.f)

ggplot(games.fatigue, aes(weighted_Fatigue, point.diff, color = Tournament)) +
  geom_point() + geom_smooth(method='lm', se=FALSE) + geom_hline(yintercept = 0)

g.f.s = subset(games.fatigue, Opponent == "England" | Opponent == "France" |
                 Opponent == "Ireland" | Opponent == "Russia" | Opponent == "Spain" | Opponent == "Brazil" | 
                 Opponent == "Japan" | Opponent == "Kenya" | Opponent == "South Africa" | Opponent == "USA")
g.f.s = subset(games.fatigue, Opponent == "Russia")

ggplot(g.f.s, aes(weighted_Fatigue, point.diff, color = Opponent)) +
  geom_point()

ggplot(games.fatigue, aes(weighted_Fatigue, point.diff)) + geom_point() +
  geom_smooth(method='lm',formula=y~x)

plot(y = g.f.s$point.diff, x = g.f.s$team_Fatigue)
p.tf = lm(g.f.s$point.diff ~ g.f.s$team_Fatigue)
summary(p.tf)
abline(p.tf)

View(g.f.s)

?geom_line

#-----------------------------------------------------------------------
rpe <- read_csv("C:/Users/Duncan/Desktop/Datafest/data/rpe.csv")
View(well.acr2)

acr = group_by_(rpe, .dots=c("PlayerID", "Date"))
acr$DailyLoad[is.na(acr$DailyLoad)] <- 0
acr2 = acr %>% summarise(DL = sum(DailyLoad))

well.acr = inner_join(wellness, acr2)
well.acr2 = inner_join(wellness, acr2)

boxplot(well.acr$Fatigue ~ well.acr$ACR)
plot(well.acr$ACR ~ well.acr$Fatigue)

summary(lm(well.acr$Fatigue ~ well.acr$ACR))
??avPlot

dave = lm(Fatigue~Soreness+Desire+Irritability+SleepHours+SleepQuality,data=wellness)
summary(dave)
BIC(dave)


summary(dave)

boxplot(dave$residuals~wellness$PlayerID)
abline(h=0,lty=3)

avPlot(dave, "Soreness")
avPlot(dave, "Desire")
avPlot(dave, "Irritability")
avPlot(dave, "SleepHours")
avPlot(dave, "SleepQuality")

plot(wellness$Fatigue ~ wellness$SleepHours)
hist(wellness$Fatigue)
?hist