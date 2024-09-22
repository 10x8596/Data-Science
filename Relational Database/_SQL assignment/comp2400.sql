-- Q1.1
SELECT COUNT(*) 
FROM movie 
WHERE major_genre = 'comedy' AND country = 'Australia';

-- Q1.2
SELECT title, production_year 
FROM restriction 
WHERE description = 'S' AND country = 'Finland'
ORDER BY production_year ASC;

-- Q1.3
SELECT country, COUNT(*)
FROM restriction_category
GROUP BY country
HAVING COUNT(*) > 2;

-- Q1.4
SELECT id FROM director NATURAL JOIN movie
WHERE major_genre = 'drama'
INTERSECT
SELECT id FROM director NATURAL JOIN movie
WHERE major_genre = 'romance';

-- Q1.5
SELECT title, production_year FROM director_award WHERE result = 'won'
UNION
SELECT title, production_year FROM writer_award WHERE result = 'won';

-- Q1.6
SELECT title, production_year, production_year-year_born AS age
FROM movie NATURAL JOIN director NATURAL JOIN person 
WHERE country='Germany';

-- Q1.7
SELECT MAX(cnum)
FROM (
    SELECT title, production_year, COUNT(*) AS cnum
    FROM crew
    GROUP BY title, production_year
) AS count;

-- Q1.8
WITH d2w AS (
    SELECT d.id
    FROM director d INNER JOIN writer w
    ON d.title = w.title AND d.production_year = w.production_year AND d.id != w.id
    GROUP BY d.id
    HAVING COUNT(DISTINCT w.id) > 1)
SELECT id, first_name, last_name
FROM person NATURAL JOIN d2w
ORDER BY last_name ASC;

-- Q1.9
WITH never_won AS (
    SELECT DISTINCT id
    FROM director
    EXCEPT
    SELECT DISTINCT id
    FROM director_award NATURAL JOIN director
    WHERE lower(result)='won'),
never_won_count AS (
    SELECT count(*) AS num, id
    FROM never_won NATURAL JOIN director
    GROUP BY id)
SELECT id
FROM never_won_count
WHERE num=(
    SELECT max(num)
    FROM never_won_count);

-- Q1.10
WITH multi_writer_movies AS (
    SELECT title, production_year
    FROM writer
    GROUP BY title, production_year
    HAVING count(*)>1)
SELECT count(*)
FROM (SELECT id
    FROM writer
    EXCEPT
    SELECT id
    FROM multi_writer_movies NATURAL JOIN writer) AS temp;