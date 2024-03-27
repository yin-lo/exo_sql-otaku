CREATE TABLE viewing (
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	show_name text NOT NULL,
	season smallint NOT NULL,
	episode smallint NOT NULL,
	viewing_date date NOT NULL,
	viewer_country text NOT NULL,
	viewer_age_group int NOT NULL,
	binge_session bool NOT NULL
);

-- holy cow ! ne cherchez pas à comprendre ce qui suit, exécutez le script les yeux fermés
-- j'insiste, ferme ce fichier tout de suite !
-- allez allez, tu crois ptêt que je vois que t'es encore dessus ?

CREATE OR REPLACE FUNCTION normal(mini integer, maxi integer, skew float) RETURNS integer AS $$
DECLARE
	alea float;
BEGIN
	alea := sqrt( -5.0 * log( random() ) ) * cos( 5.0 * pi() * random() );
	alea := floor((exp(alea))/(skew+exp(alea)) * (maxi - mini + 1) + mini);
	RETURN (alea)::int;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION randomint(mini integer, maxi integer) RETURNS integer AS $$
SELECT (floor(random() * (maxi - mini + 1) + mini))::int;
$$ LANGUAGE 'sql' STRICT;

INSERT INTO viewing (show_name, season, episode, viewing_date, viewer_country, viewer_age_group, binge_session)
SELECT
	s show_name,
	randomint(1, least(t.n, randomint(1, 40))) season,
	randomint(1, least(20,randomint(1, 40))) episode,
	(now() - (randomint(0, p.n*100) || ' days')::interval)::date viewing_date,
	p.l viewer_country,
    normal(2,p.a,t.a) * 10 viewer_age_group,
    normal(0, 1, t.a) = 0 binge_session
FROM (
	VALUES (1, 'Sherclock', 4, 2.0),
	(2, 'Game of Crowns', 8, 4.0),
	(3, 'Dexterate Housewives', 11, 1.0),
	(4, 'Dr Mouse', 5, 5.0),
	(5, 'Les Experts Saint-Tropez', 22, 1.0),
	(6, 'prompt() à Malibu', 13, 0.5)
) t(i, s, n, a)
JOIN (
	SELECT d, normal(1, 6, 1.0) r
	FROM generate_series(1, 61422, 1) v(d)
) t2 ON t.i = t2.r
JOIN (
	VALUES (1, 'France', 7, 7),
	(2, 'France', 7, 6),
	(3, 'France', 6, 5),
	(4, 'Angleterre', 5, 7),
	(5, 'Angleterre', 5, 6),
	(6, 'Allemagne', 7, 7),
	(7, 'Allemagne', 6, 7),
	(8, 'Allemagne', 5, 7),
	(9, 'Allemagne', 4, 7),
	(10, 'Allemagne', 3, 7),
	(11, 'Italie', 6, 4),
	(12, 'Italie', 6, 4),
	(13, 'Italie', 5, 4),
	(14, 'Grèce', 4, 5),
	(15, 'Finlande', 3, 6),
	(16, 'Finlande', 2, 6),
	(17, 'Espagne', 7, 7)
) p (i, l, n, a) ON true
JOIN (
    SELECT d, randomint(1, 17) r
    FROM generate_series(1, 61422, 1) v(d)
) t3 ON p.i = t3.r AND t2.d = t3.d;
