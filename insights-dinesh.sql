-- Insights from the database

-- 1) Top 10 highest-grossing movies

-- - Identifies the biggest commercial hits
-- - Helps compare which titles delivered the strongest revenue and ROI
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

-- 2) Which genres have the best average financial return?
-- - Shows which genres are most profitable on average
-- - Useful for spotting trends in audience appeal and financial performance
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

-- 3) Best-rated movies by audience and critics
-- Reveals the most-loved movies from the audience perspective
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

-- 4) Who is the most frequent cast or crew member?
-- - Identifies recurring talent across the catalog
-- - Useful for studying actor/crew involvement and franchise continuity
SELECT TOP 10
    cc.Name,
    cc.Role,
    COUNT(*) AS movie_count
FROM MovieCastCrew mcc
JOIN CastCrew cc
    ON cc.CastID = mcc.PeopleID
GROUP BY cc.Name, cc.Role
ORDER BY movie_count DESC;

-- 5) Franchise performance summary
-- - Compares franchise-level performance
-- - Highlights which franchise families are strongest
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

