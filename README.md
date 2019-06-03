# DataFest 2019 @ Ohio State
## "Name in Beta": *First Place in Judge's Choice*
*Duncan Capp, Brittany Shine, Justin Skirda, Troy Stein, Andrew Welsh*

The data set for the American Statistical Association's (ASA) 2019 DataFest competition came from a women's rugby team at the Canadian Sports Institute. There were four separate csv files:

**game.csv**: Meta-information about games, participating teams, and game outcomes.

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
To start, we created single linear regression (SLR) models between Fatigue and each other feature. From there, we chose one random linear regression model to perform an F-test on each other model. We repeated the same F-test procedure with those that had a p-value greater than a siginificance level of α = 0.05 in the first round of F-tests. This process left us with five features, which we use in our multiple linear regression (MLR) model to predict Fatigue:

`Fatigue per player per game ~ Soreness + Desire + Irritability + SleepHours + SleepQuality`

However, different players of the same team will play for different amounts of time during the game. In order for Fatigue to be a better predictor of game outcome, we developed a Fatigue value for entire teams (Team Fatigue) by weighing the Fatigue of individual players against the fraction of game time they spent playing, summed over all players in a team for each game. A player was said to be playing if their speed was above some threshold, measured in degrees (latitude/longtitude) per second. 

Team Fatigue calculation (per game):

![[weighted team fatigue]](https://github.com/andrew-welsh626/df2019/raw/master/presentation/weighted-team-fatigue.png "Weighted Team Fatigue")

The summation is iterated over all players on the team for that game. Here's a pseudocode snippet to give a better idea of how Team Fatigue was calculated:

```
teamFatigue <- 0
for player in team
    teamFatigue += (player.time / totalTeamTime) * player.fatigue
end
```

## Results
From our correlation tests, teams should focus on Soreness, Desire, Irritability, SleepHours, SleepQuality to minimize the fatigue of individual players. Below are the residuals for each player in our multiple linear regression model:

![[residuals plot]](https://github.com/andrew-welsh626/df2019/raw/master/presentation/fatigue-residuals.png "Fatigue Residuals")

Using our Team Fatigue calculations aggregated by game outcome (W/L), we're able to see how Team Fatigue can predict game outcome:

![[residuals plot]](https://github.com/andrew-welsh626/df2019/raw/master/presentation/box-plot-weighted-team-fatigue-game-outcome.png "Weighted Team Fatigue aggregated by Game")

**Note**: The fatigue scale from the raw data is more of an "energy" scale. A *higher* number indicates *less* fatigue, and a *lower* number indicates *more* fatigue.

Based on 38 observations of games, we can see that less fatigue leads to a higher chance of winning.

## Things Learned / Future Work
- General R-programming skills, competency in Tidyverse packages and using piping, working with regression models and measuring their effectiveness.
- We should have checked for normality on each feature in our F-tested SLR models. The easiest way to do this is a visual inspection via a [QQ-plot](http://www.sthda.com/english/wiki/qq-plots-quantile-quantile-plots-r-base-graphs), but [Levene's test](https://en.wikipedia.org/wiki/Levene%27s_test) should be used if there is any doubt.
- We should have built SLR models that fit to our Team Fatigue value and picked out features from F-tests from there, since Team Fatigue is the value we actually use to predict game outcome.
  - `Fatigue per team per game ~ Soreness + Desire + Irritability + SleepHours + SleepQuality`.
  - Maybe other features would have been chosen from our F-test procedure on all possible SLR models fitted to Team Fatigue?
  
