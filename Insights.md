# Insights
<br>

This section explores the Disney movie dataset using SQL queries to identify trends and insights across movies, ratings, cast and crew, and financial performance.

<br>

## Movie Overview
<br>

### Which genres have the most movies?

- Useful for understanding the distribution of movies across different genres.
  
<br>

```sql
SELECT Genre, COUNT(MovieID) AS MovieCount
FROM movies
GROUP BY Genre
```

<br>

### Which years had the most movie releases?

- Useful for identifying trends in Disney's movie production and release patterns over time.

<br>

```sql
SELECT YEAR(Release_date) AS YearMade, 
       COUNT(MovieID) AS MovieCount
FROM Movies
GROUP BY YEAR(Release_date)
ORDER BY YearMade ASC;
``` 
<br>

## Ratings & Reception

<br>

### Which genres have the highest average ratings across different platforms?

- Useful for identifying differences in critic and audience reception between genres.
<br>

```sql
SELECT 
    m.genre, 
    ROUND(AVG(me.imdb_rating), 2) AS AvgIMDBRating,
    ROUND(AVG(me.rotten_tomatoes_rating), 2) AS AvgRottenTomatoesRating,
    ROUND(AVG(me.metacritic_score), 2) AS AvgMetacriticScore,
    ROUND(AVG(me.audience_score), 2) AS AvgAudienceScore
FROM Movies m
INNER JOIN Metrics me
    ON m.MovieID = me.MovieID
GROUP BY Genre
ORDER BY Genre ASC;
```
<br>

### Best-rated movies by audience and critics
- Reveals the most-loved movies from the audience perspective

<br>

```SQL
SELECT TOP 10
    m.Title,
    m.Genre,
    mt.imdb_rating,
    mt.rotten_tomatoes_rating,
    mt.metacritic_score,
    mt.audience_score
FROM Movies m
JOIN Metrics mt
    ON mt.MovieID = m.MovieID
ORDER BY mt.audience_score DESC, mt.imdb_rating DESC;
```

<br>

## Financial Performance

<br>

### Franchise performance summary

 - Compares franchise-level performance
 - Highlights which franchise families are strongest

<br>

```sql
SELECT
    m.Franchise,
    COUNT(*) AS movie_count,
    AVG(f.box_office_million_usd) AS avg_box_office,
    AVG(f.roi_percent) AS avg_roi_percent,
    AVG(mt.audience_score) AS avg_audience_score
FROM Movies m
INNER JOIN Financials f
    ON f.MovieID = m.MovieID
LEFT JOIN Metrics mt
    ON mt.MovieID = m.MovieID
GROUP BY m.Franchise
HAVING COUNT(*) > 1
ORDER BY avg_box_office DESC;

```

<br>

### Top 10 highest-grossing movies
 
- Identifies the biggest commercial hits
- Helps compare which titles delivered the strongest revenue and ROI

<br>

```sql

SELECT TOP 10
    m.Title,
    m.Franchise,
    m.Genre,
    m.Release_Date,
    f.box_office_million_usd,
    f.roi_percent
FROM Movies m
    INNER JOIN Financials f
        ON f.MovieID = m.MovieID
ORDER BY f.box_office_million_usd DESC;
```
<br>


### Which genres have the best average financial return?

 - Shows which genres are most profitable on average
 - Useful for spotting trends in audience appeal and financial performance

<br>

```sql
SELECT
    m.Genre,
    COUNT(*) AS movie_count,
    AVG(f.box_office_million_usd) AS avg_box_office_million_usd,
    AVG(f.roi_percent) AS avg_roi_percent
FROM Movies m
LEFT JOIN Financials f
    ON f.MovieID = m.MovieID
GROUP BY m.Genre
ORDER BY avg_roi_percent DESC;

```
<br>

### Does higher marketing spend lead to higher box office revenue?

- Higher marketing spend was associated with higher average box office revenue, suggesting a positive relationship between marketing investment and box office performance.

<br>

```sql

Select MarketingSpend, AVG(box_office_million_usd) AS AvgBoxOfficeReturn
from
(SELECT 
    m.Title,
    f.box_office_million_usd,
    CASE
        WHEN f.marketing_cost < 25 THEN 'Low'
        WHEN f.marketing_cost BETWEEN 25 AND 75 THEN 'Medium'
        ELSE 'High'
    END AS MarketingSpend
FROM Movies m
INNER JOIN Financials f
    ON m.MovieID = f.MovieID)temp
 GROUP BY MarketingSpend
 ORDER BY
    CASE MarketingSpend
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
    END;
```

<br>

## People & Cast/Crew

<br> 

### Who is the most frequent cast or crew member?
Identifies recurring talent across the catalogue
- Useful for studying actor/crew involvement and franchise continuity


<br>

```sql
SELECT TOP 10
    cc.Name,
    cc.Role,
    COUNT(*) AS movie_count
FROM MovieCastCrew mcc
JOIN CastCrew cc
    ON cc.CastID = mcc.PeopleID
GROUP BY cc.Name, cc.Role
ORDER BY movie_count DESC;
```
