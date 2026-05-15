import streamlit as st
from snowflake.snowpark.context import get_active_session

st.title("Offres par taille d'entreprise")

session = get_active_session()

data = session.sql("""
    SELECT
        CASE company_size
            WHEN 0 THEN 'Self-employed'
            WHEN 1 THEN '1-10 emp.'
            WHEN 2 THEN '11-50 emp.'
            WHEN 3 THEN '51-200 emp.'
            WHEN 4 THEN '201-500 emp.'
            WHEN 5 THEN '501-1000 emp.'
            WHEN 6 THEN '1001-5000 emp.'
            WHEN 7 THEN '5001+ emp.'
            ELSE 'Non renseigné'
        END AS TAILLE,
        COUNT(*) AS NB_ENTREPRISES
    FROM LINKEDIN.SILVER.COMPANIES
    GROUP BY company_size
    ORDER BY company_size ASC NULLS LAST
""").to_pandas()

st.bar_chart(data=data, x="TAILLE", y="NB_ENTREPRISES")
st.dataframe(data, use_container_width=True)
