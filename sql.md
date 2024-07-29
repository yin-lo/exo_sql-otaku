# # O'taku, la plateforme des gros mangeurs de séries

## Regarder un bout des données

```sql
SELECT *
FROM viewing
LIMIT 15;
```

## L'échantillonage

Sélectionner toutes les données, rangées dans un ordre aléatoire :

```sql
SELECT *
FROM viewing
ORDER BY random();
```

Récupérer 15 lignes de manière aléatoire :

```sql
SELECT *
FROM viewing
ORDER BY random()
LIMIT 15;
```

## Les fonctions d'agrégat

Récupérer la moyenne d'âge des viewers classée par pays :

```sql
SELECT 
ROUND(AVG(viewer_age_group)),
viewer_country  
FROM viewing
GROUP BY viewer_country ;
```

Récupérer le nombre d'épisodes regardés, classé par tranche d'âge de manière décroissante :

```sql
SELECT
COUNT(episode),
viewer_age_group
FROM viewing
GROUP BY viewer_age_group 
ORDER BY viewer_age_group DESC;
```

CORRECTION : COUNT(*) AS nb_visionnage // l'étoile permet de prendre toutes les lignes.

Récupérer le nombre de visionnage par an :

```sql
SELECT
COUNT(episode),
EXTRACT (year from viewing_date) as year
FROM viewing
GROUP BY year
;
```
