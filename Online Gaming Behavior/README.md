# SQL Queries and Analysis

## Overview
This folder contains SQL scripts and queries used for analyzing the [online_gaming_behavior_dataset](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/Data/online_gaming_behavior_dataset.csv). Each script performs a specific analysis to extract insights from the data.

### 1. Demographic Analysis: Calculate the average age of players segmented by gender and location.
```sql
SELECT 
    location, 
    gender, 
    ROUND(AVG(age), 2) AS average_age 
FROM gamers
GROUP BY location, gender
ORDER BY location, gender;
```
![Query 1](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/SQL/SQL%20images/Query%201.png)

### 2. Engagement Level Analysis: Determine the average playtime and sessions per week for each engagement level.
```sql
SELECT 
    engagement_level, 
    ROUND(AVG(play_time_hours), 2) AS avg_playtime_hours, 
    ROUND(AVG(sessions_per_week), 2) AS avg_sessions_per_week
FROM gamers
GROUP BY engagement_level;

-- Find the engagement level with the highest average play time hours
WITH avg_stats AS (
    SELECT 
        engagement_level, 
        ROUND(AVG(play_time_hours), 2) AS avg_playtime_hours, 
        ROUND(AVG(sessions_per_week), 2) AS avg_sessions_per_week
    FROM gamers
    GROUP BY engagement_level
)
SELECT 
    engagement_level,
    avg_playtime_hours,
    avg_sessions_per_week
FROM avg_stats
ORDER BY avg_playtime_hours DESC;
```
![Query 2](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/SQL/SQL%20images/Query%202.png)


### 3. Game Genre Popularity: Rank the game genres based on the total playtime across all players.
```sql
SELECT 
    gamegenre, 
    ROUND(SUM(play_time_hours), 2) AS total_playtime
FROM gamers
GROUP BY gamegenre
ORDER BY total_playtime DESC;
```
![Query 3](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/SQL/SQL%20images/Query%203.png)

### 4. In-Game Purchases vs. Player Level: Analyze the correlation between in-game purchases and player levels.
```sql
WITH categorized_level AS (
    SELECT 
        CASE
            WHEN player_level BETWEEN 0 AND 24 THEN 'low'
            WHEN player_level BETWEEN 25 AND 49 THEN 'medium'
            WHEN player_level BETWEEN 50 AND 74 THEN 'high'
            WHEN player_level > 74 THEN 'very high'
            ELSE 'Unknown'
        END AS level_category,
        COUNT(*) AS total_players,
        COUNT(CASE WHEN in_game_purchases > 0 THEN 1 END) AS players_with_purchases
    FROM gamers
    GROUP BY level_category
)
SELECT 
    level_category,
    total_players,
    players_with_purchases,
    ROUND((players_with_purchases::NUMERIC / total_players) * 100, 2) AS percentage_with_purchases
FROM categorized_level;
```
![Query 4](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/SQL/SQL%20images/Query%204.png)

### 5. Difficulty vs. Player Achievement: Compare the average achievements unlocked across different game difficulties.
```sql
SELECT 
    game_difficulty, 
    ROUND(AVG(achievements_unlocked), 2) AS avg_achievements, 
    COUNT(*) AS number_of_players
FROM gamers
GROUP BY game_difficulty;
```
![Query 5](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/SQL/SQL%20images/Query%205.png)

### 6. Player Retention Analysis: Calculate the average session duration for players who play Strategy games.
```sql
SELECT 
    sessions_per_week, 
    ROUND(AVG(avgsession_duration_minutes), 2) AS avg_duration
FROM gamers
WHERE gamegenre = 'Strategy' AND sessions_per_week > 0
GROUP BY sessions_per_week
ORDER BY sessions_per_week DESC;
```
![Query 6](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/SQL/SQL%20images/Query%206.png)

### 7. Top Players Identification: Identify the top 10 players based on PlayerLevel and AchievementsUnlocked.
```sql
SELECT 
    player_id, 
    player_level, 
    achievements_unlocked, 
    player_level * achievements_unlocked AS points 
FROM gamers
ORDER BY points DESC
LIMIT 10;
```
![Query 7](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/SQL/SQL%20images/Query%207.png)

### 8. Regional Engagement Comparison: Compare the average engagement level across different locations.
```sql
WITH regional_engagement AS (
    SELECT 
        location, 
        CASE 
            WHEN engagement_level = 'High' THEN 3
            WHEN engagement_level = 'Medium' THEN 2
            WHEN engagement_level = 'Low' THEN 1
            ELSE 0
        END AS engagement_number_level
    FROM gamers
)
SELECT 
    location,
    ROUND(AVG(engagement_number_level), 2) AS avg_engagement_level
FROM regional_engagement
GROUP BY location;
```
![Query 8](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/SQL/SQL%20images/Query%208.png)

### 9. Session Duration Insights: Find the game genre with the longest average session duration and correlate with player level.
```sql
SELECT 
    gamegenre, 
    ROUND(AVG(avgsession_duration_minutes), 2) AS avg_session_duration,
    ROUND(AVG(player_level), 2) AS avg_player_level
FROM gamers
GROUP BY gamegenre
ORDER BY avg_session_duration DESC;
```
![Query 9](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/SQL/SQL%20images/Query%209.png)

### 10. In-Game Purchases Analysis: Calculate the percentage of players making in-game purchases within each game genre.
```sql
WITH spending_behavior AS (
    SELECT 
        gamegenre,
        COUNT(*) AS total_players,
        COUNT(CASE WHEN in_game_purchases > 0 THEN 1 END) AS players_who_purchased
    FROM gamers
    GROUP BY gamegenre
)
SELECT 
    gamegenre, 
    players_who_purchased, 
    total_players,
    ROUND((players_who_purchased::decimal / total_players::decimal) * 100, 2) AS percentage
FROM spending_behavior
ORDER BY percentage DESC;
```
![Query 10](https://github.com/markjeromecifra/Portfolio/blob/main/Online%20Gaming%20Behavior/SQL/SQL%20images/Query%2010.png)
