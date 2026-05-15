-- Analyse 3 : répartition par taille d'entreprise
SELECT company_size_label, COUNT(*) AS nb_offres
FROM LINKEDIN.GOLD.FACT_JOB_POSTINGS
WHERE company_size_label != 'Inconnu'
GROUP BY company_size_label, company_size
ORDER BY company_size ASC;

-- Analyse 4 : répartition par secteur (top 20)
SELECT NVL(industry, 'Non renseigné') AS industry, COUNT(*) AS nb_offres
FROM LINKEDIN.GOLD.FACT_JOB_INDUSTRY
GROUP BY industry
ORDER BY nb_offres DESC LIMIT 20;

-- Analyse 5 : répartition par type d'emploi
SELECT NVL(formatted_work_type, 'Non renseigné') AS work_type, COUNT(*) AS nb_offres
FROM LINKEDIN.SILVER.JOB_POSTINGS
GROUP BY formatted_work_type
ORDER BY nb_offres DESC;
