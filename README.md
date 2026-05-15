# ESME_EVALUATION_ARCHITECTURE_BIGDATA_2026

## Objectif du projet

Ce projet a pour objectif de mettre en place une architecture Big Data avec Snowflake à partir d’un dataset LinkedIn contenant :

- des offres d’emploi
- des entreprises
- des industries
- des salaires
- des compétences

Le projet suit une architecture :

- Bronze : ingestion des données brutes
- Silver : nettoyage et transformation
- Gold : modélisation analytique

Les résultats sont ensuite exploités avec des analyses SQL et des applications Streamlit.

---

# Technologies utilisées

- Snowflake
- SQL
- Python
- Streamlit
- Git / GitHub

---

# Structure du projet

```text
sql/
├── 01_setup.sql
├── 02_bronze.sql
├── 03_silver.sql
├── 04_gold.sql
├── 05_analyses.sql
└── 06_reset.sql

streamlit/
├── app1_top_titles.py
├── app2_top_salaries.py
├── app3_company_size.py
├── app4_industry.py
└── app5_work_type.py

1. Initialisation Snowflake

Le fichier 01_setup.sql permet :

* la création de la base LINKEDIN
* la création du schéma Bronze
* la connexion au bucket S3
* la configuration des formats CSV et JSON

Exemple de commandes SQL

CREATE DATABASE IF NOT EXISTS LINKEDIN;

CREATE SCHEMA IF NOT EXISTS LINKEDIN.BRONZE;

CREATE OR REPLACE STAGE LINKEDIN.BRONZE.linkedin_stage
URL = 's3://snowflake-lab-bucket/';

2. Couche Bronze

Le fichier 02_bronze.sql permet le chargement des données brutes CSV et JSON dans Snowflake.

Exemple

COPY INTO LINKEDIN.BRONZE.JOB_POSTINGS
FROM @linkedin_stage/job_postings.csv
FILE_FORMAT = (FORMAT_NAME = 'LINKEDIN.BRONZE.csv_format');
Les données sont conservées dans leur format d’origine.

⸻

3. Couche Silver

Le fichier 03_silver.sql transforme les données Bronze en données propres et typées.

Transformations réalisées

* conversion des salaires en DOUBLE
* conversion des dates en TIMESTAMP
* conversion des booléens TRUE/FALSE

Exemple
TRY_TO_DOUBLE(max_salary) AS max_salary
CASE WHEN UPPER(remote_allowed)
IN ('1','TRUE','YES')
THEN TRUE ELSE FALSE END

4. Couche Gold

Le fichier 04_gold.sql crée les tables analytiques finales.

Tables principales

* DIM_COMPANY_SIZE
* FACT_JOB_POSTINGS
* FACT_JOB_INDUSTRY

Ces tables permettent de simplifier les analyses et les visualisations.

⸻

5. Analyses SQL

Le fichier 05_analyses.sql contient plusieurs analyses :

1. Top 10 titres par industrie
2. Top 10 salaires par industrie
3. Répartition par taille d’entreprise
4. Répartition par secteur
5. Répartition par type d’emploi

Exemple d’analyse
SELECT industry, title, COUNT(*) AS nb_offres
FROM LINKEDIN.GOLD.FACT_JOB_INDUSTRY
GROUP BY industry, title;

6. Applications Streamlit

Les visualisations ont été réalisées avec Streamlit.

Applications développées

* app1_top_titles.py
* app2_top_salaries.py
* app3_company_size.py
* app4_industry.py
* app5_work_type.py

Fonctionnalités

* sélection dynamique des secteurs
* graphiques interactifs
* tableaux récapitulatifs

⸻

7. Résultats obtenus

Secteurs les plus représentés

* Staffing & Recruiting
* Information Technology
* Retail
* Health Care

Types d’emploi dominants

* Full-time
* Contract
* Internship

Postes les plus fréquents

* Sales Director
* Project Manager
* Staff Accountant

⸻

8. Difficultés rencontrées

Warehouse non sélectionné

Erreur :
No active warehouse selected
Solution
USE WAREHOUSE COMPUTE_WH;
Synchronisation Snowflake / GitHub

Le code exécuté dans Snowflake n’est pas automatiquement enregistré dans GitHub.

Solution

Sauvegarder les fichiers localement puis utiliser :

git add
git commit
git push
Streamlit Snowflake

Certaines applications Streamlit ont rencontré des problèmes de lancement liés aux services Snowflake.

Solution

Conserver les fichiers Python correctement structurés dans le dépôt GitHub.

⸻

9. Reset du projet

Le fichier 06_reset.sql permet de supprimer la base :
DROP DATABASE IF EXISTS LINKEDIN;

Conclusion

Ce projet démontre la mise en place complète d’une architecture Big Data sur Snowflake :

* ingestion
* transformation
* modélisation
* analyses
* visualisation

Le projet respecte une architecture Bronze / Silver / Gold avec un suivi collaboratif via GitHub.
