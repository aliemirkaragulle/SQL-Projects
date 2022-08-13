SELECT COUNT(ratings.rating)
FROM ratings
JOIN movies
ON movies.id = ratings.movie_id
WHERE ratings.rating = 10;