SELECT movies.title
FROM movies
JOIN ratings
ON movies.id = ratings.movie_id
JOIN stars
ON movies.id = stars.movie_id
JOIN people
ON people.id = stars.person_id
WHERE stars.person_id = (SELECT id FROM people WHERE name = "Chadwick Boseman")
ORDER BY ratings.rating DESC
LIMIT 5;