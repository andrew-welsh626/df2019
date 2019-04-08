# DataFest 2019: "Name in Beta"

(Fill in with details about challenge after ASA releases stuff at the start of May, and also details not included in slides)

## Problem
- How do we predict the self-reported fatigue of individual players?
- How can we use the self-reported fatigue of players to predict game outcomes?

## Methods
- Best linear regression: 
  - Fatigue per player per day ~ Soreness + Desire + Irritability + SleepHours + SleepQuality
- Weighted team fatigue calculation:
```
numberOfGames <- 38
for (game <- 1 to numberOfGames):
    (PlayerTime[game] / TotalTeamTime ) * PlayerFatigue[game]
end
```

![[residuals plot]](https://github.com/andrew-welsh626/df2019/raw/master/presentation/weighted-team-fatigue.png "Fatigue Residuals")

## Results
- Teams should focus on Soreness, Desire, Irritability, SleepHours, SleepQuality
- Less fatigue leads to higher chance of winning
  - Based on only 38 observations of games
  
![[residuals plot]](https://github.com/andrew-welsh626/df2019/raw/master/presentation/fatigue-residuals.png "Fatigue Residuals")
 PlayerID

  ![[residuals plot]](https://github.com/andrew-welsh626/df2019/raw/master/presentation/box-plot-weighted-team-fatigue-game-outcome.png "Weighted Team Fatigue aggregated by Game")
