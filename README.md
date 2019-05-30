# DataFest 2019 @ Ohio State
## "Name in Beta": *1st Place in Judge's Choice* 

The data set for the American Statistical Association's (ASA) 2019 DataFest competition came from a women's rugby team at the Canadian Sport Institute. There are four separate csv files:

**game.csv**: Meta-information about games and participating teams, and game outcome.

GameID	Date	Tournament	TournamentGame	Team	Opponent	Outcome	TeamPoints	TeamPointsAllowed


**rpe.csv**: Information about physical exertion of during game/practice. Some self-reported features. 

Date	PlayerID	Training	SessionType	Duration	RPE	SessionLoad	DailyLoad	AcuteLoad	ChronicLoad	AcuteChronicRatio	ObjectiveRating	FocusRating	BestOutOfMyself


**wellness.csv**: Self-reported information about the player's health and internal state. Asked before the game.

Date	PlayerID	Fatigue	Soreness	Desire	Irritability	BedTime	WakeTime	SleepHours	SleepQuality	MonitoringScore	Pain	Illness	Menstruation	Nutrition	NutritionAdjustment	USGMeasurement	USG	TrainingReadiness


**gps.csv**: Information on player location and movement (most of the data). 

GameID  Half	PlayerID	FrameID	Time	GameClock	Speed	AccelImpulse	AccelLoad	AccelX	AccelY	AccelZ	Longitude	Latitude


## Team Problem Statements
- We need predict the self-reported fatigue of individual players.
- We aim to use the self-reported fatigue of players to predict game outcome.

## Methods 
To start, we tested the linear correlation between fatigue and each other feature, using the cor(x,y) function in the RStudio console. From there, we found a cluster of values that indicated the highest correlation, which we used to build our multiple linear regression model:

`Fatigue per player per game ~ Soreness + Desire + Irritability + SleepHours + SleepQuality`

However, different players of the same team will play for different amounts of time during the game. So that fatigue can be a better predictor of game outcome, we developed a fatigue value for an entire team by weighing the fatigue of individual players against the fraction of game time they spent playing, summed over all players in a team for each game. 

Team fatigue calculation (per game):

![[weighted team fatigue]](https://github.com/andrew-welsh626/df2019/raw/master/presentation/weighted-team-fatigue.png "Weighted Team Fatigue")

The summation is iterated over all players on the team for that game. Here's a pseudocode snippet to give a better idea of how team fatigue was calculated:

```
teamFatigue <- 0
for player in team
    teamFatigue += (player.time / totalTeamTime) * player.fatigue
end
```

## Results
From our correlation tests, teams should focus on Soreness, Desire, Irritability, SleepHours, SleepQuality to minimize the fatigue of individual players. Below are the residuals for each player in our multiple linear regression model:

![[residuals plot]](https://github.com/andrew-welsh626/df2019/raw/master/presentation/fatigue-residuals.png "Fatigue Residuals")

Using our team fatigue calculations aggregated by game outcome (W/L), we're able to see how team fatigue can predict game outcome:

![[residuals plot]](https://github.com/andrew-welsh626/df2019/raw/master/presentation/box-plot-weighted-team-fatigue-game-outcome.png "Weighted Team Fatigue aggregated by Game")

**Note**: The fatigue scale from the raw data is more of an "energy" scale. A *higher* number indicates *less* fatigue, and a *lower* number indicates *more* fatigue.

Based on 38 observations of games, we can see that less fatigue leads to a higher chance of winning.

## Future Work
- We should have built this multiple linear regression model (with our team fatigue values) so that we could better predict the value that we use to try to predict game outcomes:
  - ``Fatigue per team per game ~ Soreness + Desire + Irritability + SleepHours + SleepQuality``
  - Maybe other features would have been more highly correlated with team fatigue?
  
