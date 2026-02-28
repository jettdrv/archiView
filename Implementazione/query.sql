
DROP INDEX IF EXISTS index_film; 
DROP INDEX IF EXISTS index_fk_bene_film;
DROP INDEX IF EXISTS index_fk_pellicola_bene;

EXPLAIN SELECT *
FROM FILM F
JOIN BENE_CULTURALE B ON B.Film=F.IdFilm
JOIN PELLICOLA P ON P.IdBene=B.IdBeneCulturale
WHERE Titolo='La vita è bella';

--EXPLAIN ANALYZE SELECT * 
--FROM FILM
--WHERE Titolo LIKE 'La%' AND AnnoProduzione>2000;

