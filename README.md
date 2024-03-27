# O'taku, la plateforme des gros mangeurs de séries

O'clock a lancé il y a maintenant plus d'un an sa plateforme de séries originales à consommer depuis son canapé.

![Popcorn time](https://media.giphy.com/media/tyqcJoNjNv0Fq/giphy.gif)

## Hopopop

Pas si vite ! Vous n'êtes pas là pour en bénéficier mais plutôt pour rendre un précieux service à la team marketing :smiling_imp:.

Notre plateforme pas comme les autres a la particularité de récolter des informations stratégiques sur qui visionne quoi. 

On préfère le préciser tout de suite, c'est évidemment parce que nous sommes des visionnaires et que nous sommes pragmatiques : à quoi vous sert votre vie privée si les séries qu'on vous propose ne vous intéressent pas ? Attention, ça peut paraître évident mais nos concurrents n'oseraient jamais faire ça, bien entendu :angel:

![Peter](https://media.giphy.com/media/2ioUS6hZDARNMQXKo7/giphy.gif)
<br/>
<em style="color: #777">Compte là-dessus et bois de l'eau, comme on dit</em>

Bref... Après un an de collecte d'informations, on a de quoi faire : 61422 visionnages de pas moins de 6 séries (très) originales, dont une qui compte 22 saisons, disponibles en 7 langues :boom:

Mais pour en tirer quoi que ce soit d'utile, pas évident...

Bon, regardons ensemble ce qu'on peut faire :mag:

## Mise en place

Le fichier `data.sql` est fourni, il crée une unique table nommée `viewing` et insère toutes les données tout seul, comme un grand.

Créez une base de données et un utilisateur propriétaire en suivant la procédure habituelle, exécutez le script puis jetez un oeil à la structure de la table.

D'autre part, créez dans ce repo un fichier `sql.md`, dans lequel vous pourrez écrire les magnifiques requêtes créés pendant ce challenge. (parce que bon, elle vont être plutôt balèze, ça serait dommage de les oublier !)

## Regarder un bout des données

Écrire une requête pour récupérer les données... Pas toutes, hein, **limitez** à une quinzaine de lignes :wink:

## L'échantillonage
(ou comment redécouvrir ORDER BY)

Bon, on limite on limite, c'est bien, mais c'est toujours les même lignes ! 

Ce qu'il nous faudrait, c'est des lignes piochées aléatoirement. Et ça, ça s'appelle de l'échantillonnage (je vous le dis parce que pour pécho en soirée, c'est plutôt efficace).

Pour ça, fort heureusement, il existe une fonction toute faite et elle est vachement bien nommée :sunglasses: Elle s'appelle `géraldine`... Ok, c'était une blague, elle s'appelle `random` :unamused:

Essayez donc de lancer cette commande quelques fois :
```sql
SELECT random();
```
:tada: Mais c'est génial ! Mais c'est pas fini : la meilleure nouvelle, c'est qu'on peut se servir de cette fonction pour **ordonner** les données de manière aléatoire !

- Écrire une requête pour sélectionner toutes les données, rangées dans un ordre aléatoire
- Écrire une requete pour récupérer 15 lignes de manière aléatoire

<details>
<summary>un indice ?</summary>

```sql
... ORDER BY maFonction();
```
</details>

## Le mode agrégé

Échantillonner, c'est bien, calculer sur l'ensemble, c'est mieux !

Un SGBD fonctionne nativement dans un mode où il considère une ligne (=un enregistrement) comme son unité de valeur. Il ne peut pas ajouter ou supprimer d'unité plus petite qu'une ligne dans son résultat. Il ne peut pas, par exemple, retirer un champ à une ligne, car toutes les lignes doivent avoir le même format.

BREF, ce mode ligne par ligne n'est, par contre, pas le seul mode disponible. SQL permet aussi de faire un grand nombre d'opérations en mode tas par tas. C'est pas classe comme nom mais ça en décrit très bien le fonctionnement. Le vrai nom de ce mode, c'est le mode agrégé.

**Agréger les données**, c'est regrouper les lignes en fonction d'un ou plusieurs critères. On finit alors avec des "tas" de lignes sur lesquels on va effectuer des calculs, du dénombrement par exemple.

Pour regrouper les données, on utiliser l'opérateur GROUP BY.

Essayons de récupérer l'âge des _viewers_, regroupé par pays!
```SQL
SELECT
	viewer_country,
	viewer_age_group
FROM viewing
GROUP BY viewer_country;
```

Mince... ça marche pas.

## Les fonctions d'agrégat

Mais l'erreur, si on prend le temps de la lire, est tout de même assez explicite ! 

> ERROR:  column "viewing.viewer_age_group" must appear in the GROUP BY clause or be used in an aggregate function

soit, en français : 

> ERREUR: la colonne « viewing.viewer_age_group » doit apparaître dans la clause GROUP BY ou doit être utilisé dans une fonction d'agrégat

Une fonction d'agrégat ? Keskessé ?

Et bien, note SGBD ne peut afficher qu'une seule information par champ. Or, en agrégeant nos données, on a créer des "tas".  
Il faut donc définir la façon de traiter les données du tas, pour qu'elles puissent s'afficher dans un seul champ !

C'est le rôle des fonctions d'aggrégat ! En voici quelques unes :

- `min(champ)` permet de selectionner la plus petite valeur dans le tas. Dans le cas de chaines de caractères, c'est la première dans l'ordre alphabétique.
- `max(champ)` permet de selectionner la plus grande valeur dans le tas. Pour les chaines de caractères, c'est la dernière dans l'ordre alphabétique.
- `count(champ)` permet de compter le nombre de lignes dans le tas.
- `avg(champ)` permet de calculer la moyenne des valeurs du tas.


Par exemple, si on veut la moyenne d'âge de tous les viewers, on peut faire :
```sql
SELECT AVG(viewer_age_group) FROM viewing;
```

En utilisant ces informations, écrire des requêtes pour récupérer ces informations :

- la moyenne d'age des viewers, classée par pays.
- le nombre d'épisodes regardés, classé par tranche d'âge, et rangé par tranche d'age décroissant.
- BONUS CACTUS (attention, ça parait simple mais ça pique !) : le nombre de visionnage par an.

<details>
<summary>un indice ?</summary>

Il va falloir utiliser `extract` !

Aller voir [la doc](https://www.postgresql.org/docs/11/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT) est une bonne idée :wink:

</details>
