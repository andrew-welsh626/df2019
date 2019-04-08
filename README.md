# DataFest 2019: "Name in Beta"

(Fill in with details about challenge after ASA releases stuff at the start of May)

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
[https://lh4.googleusercontent.com/xNyYZoWmYJL6JNazboml1Jcx3KacpOBbw3aXM39edzISdc_-NQyfV-xfdnzKVwJztIwHhkeoNkWOTSONbF0Sif1BGmmeeZG8J7bPTU3q4PKOPMOVh_qfKc6UwM0le4yxDNCVyZGJL68]()

## Results
- Teams should focus on Soreness, Desire, Irritability, SleepHours, SleepQuality
- Less fatigue leads to higher chance of winning
  - Based on only 38 observations of games
  
[https://lh4.googleusercontent.com/tK_kLeKGFEByLR0Er7r7T7FETwonIC0L4WlZlACCs-B8VM947wPVQJ6j5fBLkx9GxGM6tkbCaXPJlaG8qEHIsxLTpbIxv9hj6jmzKUI]()

[https://lh5.googleusercontent.com/M7rUpVm0Fnw8DDPPSCpZ0078-e2rZKBrrdEdT_i68GL7hTPJAh0nWWBLk2FAK7efhdDWCNdtaOsC3U8at1y1o9GQOwp2BlTpP2ksTHrbwYXd1PqD3txeDKezGvLm_fmWoMhI8H2F3Qk]()
