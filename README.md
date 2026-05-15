# ESME — Architecture Big Data avec Snowflake

> Analyse des offres d'emploi LinkedIn via une architecture Bronze / Silver / Gold sur Snowflake, avec visualisations Streamlit.

---

## Sommaire

- [Objectif](#objectif)
- [Technologies](#technologies)
- [Architecture](#architecture)
- [Structure du projet](#structure-du-projet)
- [Étapes du pipeline](#étapes-du-pipeline)
  - [1. Initialisation](#1-initialisation)
  - [2. Couche Bronze](#2-couche-bronze)
  - [3. Couche Silver](#3-couche-silver)
  - [4. Couche Gold](#4-couche-gold)
  - [5. Analyses SQL](#5-analyses-sql)
  - [6. Applications Streamlit](#6-applications-streamlit)
- [Résultats](#résultats)
- [Difficultés rencontrées](#difficultés-rencontrées)
- [Reset du projet](#reset-du-projet)

---

## Objectif

Ce projet met en place une architecture Big Data complète sur **Snowflake** à partir d'un dataset LinkedIn contenant :

- des offres d'emploi
- des entreprises
- des industries
- des salaires
- des compétences

Les données sont ingérées, transformées, modélisées puis visualisées via des applications **Streamlit** interactives.

---

## Technologies

| Technologie | Usage |
|---|---|
| Snowflake | Stockage, transformation et requêtage des données |
| SQL | Pipeline de données et analyses |
| Python | Développement des applications Streamlit |
| Streamlit | Visualisation interactive |
| Git / GitHub | Versioning et collaboration |

---

## Architecture

```
[Dataset LinkedIn]
        |
        v
  [ BRONZE ]  →  Ingestion des données brutes (CSV / JSON)
        |
        v
  [ SILVER ]  →  Nettoyage, typage, transformations
        |
        v
  [  GOLD  ]  →  Tables analytiques (dimensions + faits)
        |
        v
  [Streamlit]  →  Visualisations interactives
```

---

## Structure du projet

```
.
├── sql/
│   ├── 01_setup.sql       # Initialisation Snowflake (base, schéma, stage S3)
│   ├── 02_bronze.sql      # Chargement des données brutes
│   ├── 03_silver.sql      # Nettoyage et transformation
│   ├── 04_gold.sql        # Modélisation analytique
│   ├── 05_analyses.sql    # Requêtes d'analyse
│   └── 06_reset.sql       # Suppression de la base
│
└── streamlit/
    ├── app1_top_titles.py     # Top 10 titres par industrie
    ├── app2_top_salaries.py   # Top 10 salaires par industrie
    ├── app3_company_size.py   # Répartition par taille d'entreprise
    ├── app4_industry.py       # Répartition par secteur d'activité
    └── app5_work_type.py      # Répartition par type d'emploi
```

---

## Étapes du pipeline

### 1. Initialisation

Le fichier `01_setup.sql` crée la base de données, le schéma Bronze, le stage S3 et les formats de fichiers.

```sql
CREATE DATABASE IF NOT EXISTS LINKEDIN;

CREATE SCHEMA IF NOT EXISTS LINKEDIN.BRONZE;

CREATE OR REPLACE STAGE LINKEDIN.BRONZE.linkedin_stage
  URL = 's3://snowflake-lab-bucket/';
```

> Avant toute exécution, s'assurer qu'un warehouse est actif :
> ```sql
> USE WAREHOUSE COMPUTE_WH;
> ```

---

### 2. Couche Bronze

Le fichier `02_bronze.sql` charge les données brutes CSV et JSON dans Snowflake sans transformation.

```sql
COPY INTO LINKEDIN.BRONZE.JOB_POSTINGS
FROM @linkedin_stage/job_postings.csv
FILE_FORMAT = (FORMAT_NAME = 'LINKEDIN.BRONZE.csv_format');
```

Les données sont conservées dans leur format d'origine pour garantir la traçabilité.

---

### 3. Couche Silver

Le fichier `03_silver.sql` transforme les données Bronze : typage, nettoyage, normalisation.

**Transformations appliquées :**

- Conversion des salaires en `DOUBLE`
- Conversion des dates en `TIMESTAMP`
- Normalisation des booléens

```sql
TRY_TO_DOUBLE(max_salary) AS max_salary,

CASE
  WHEN UPPER(remote_allowed) IN ('1', 'TRUE', 'YES') THEN TRUE
  ELSE FALSE
END AS remote_allowed
```

---

### 4. Couche Gold

Le fichier `04_gold.sql` construit les tables analytiques finales.

**Tables créées :**

| Table | Type | Description |
|---|---|---|
| `DIM_COMPANY_SIZE` | Dimension | Catégories de taille d'entreprise |
| `FACT_JOB_POSTINGS` | Fait | Offres d'emploi enrichies |
| `FACT_JOB_INDUSTRY` | Fait | Croisement offres / industries |

---

### 5. Analyses SQL

Le fichier `05_analyses.sql` contient cinq analyses principales :

1. Top 10 des titres de poste par industrie
2. Top 10 des salaires par industrie
3. Répartition des offres par taille d'entreprise
4. Répartition des offres par secteur d'activité
5. Répartition des offres par type d'emploi

```sql
SELECT industry, title, COUNT(*) AS nb_offres
FROM LINKEDIN.GOLD.FACT_JOB_INDUSTRY
GROUP BY industry, title
ORDER BY nb_offres DESC
LIMIT 10;
```

---

### 6. Applications Streamlit

Cinq applications interactives ont été développées avec Streamlit.

| Fichier | Visualisation |
|---|---|
| `app1_top_titles.py` | Top 10 des titres par industrie |
| `app2_top_salaries.py` | Top 10 des salaires par industrie |
| `app3_company_size.py` | Répartition par taille d'entreprise |
| `app4_industry.py` | Répartition par secteur d'activité |
| `app5_work_type.py` | Répartition par type d'emploi |

**Fonctionnalités communes :**

- Sélection dynamique du secteur via menu déroulant
- Graphiques interactifs (barres, camemberts)
- Tableaux récapitulatifs

---

## Résultats

**Secteurs les plus représentés**

- Staffing & Recruiting
- Information Technology
- Retail
- Health Care

**Types d'emploi dominants**

- Full-time
- Contract
- Internship

**Postes les plus fréquents**

- Sales Director
- Project Manager
- Staff Accountant

---

## Difficultés rencontrées

**Warehouse non sélectionné**

```
No active warehouse selected
```

Solution : ajouter `USE WAREHOUSE COMPUTE_WH;` en début de session.

---

**Synchronisation Snowflake / GitHub**

Le code exécuté dans l'interface Snowflake n'est pas automatiquement versionné. Il faut sauvegarder les fichiers localement puis les pousser manuellement :

```bash
git add .
git commit -m "feat: mise à jour du pipeline silver"
git push
```

---

**Lancement des applications Streamlit**

Certaines applications ont rencontré des problèmes de connexion liés aux services Snowflake. Solution : vérifier que les fichiers Python sont correctement structurés et que les credentials Snowflake sont bien configurés dans l'environnement.

---

## Reset du projet

Pour supprimer l'intégralité de la base de données :

```sql
DROP DATABASE IF EXISTS LINKEDIN;
```

---

## Conclusion

Ce projet implémente un pipeline Big Data complet sur Snowflake, de l'ingestion brute jusqu'à la visualisation finale, en respectant l'architecture médaillon Bronze / Silver / Gold et un suivi collaboratif via GitHub.