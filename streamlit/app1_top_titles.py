import streamlit as st
from snowflake.snowpark.context import get_active_session
 
st.title(" Top 10 titres par industrie")
session = get_active_session()
 
industries = session.sql("""
    SELECT DISTINCT industry FROM LINKEDIN.GOLD.FACT_JOB_INDUSTRY
    WHERE industry IS NOT NULL ORDER BY industry
""").to_pandas()["INDUSTRY"].tolist()
 
selected = st.selectbox("Secteur d'activité", industries)
 
data = session.sql(f"""
    SELECT title, COUNT(*) AS NB_OFFRES
    FROM LINKEDIN.GOLD.FACT_JOB_INDUSTRY
    WHERE industry = '{selected}'
    GROUP BY title ORDER BY NB_OFFRES DESC LIMIT 10
""").to_pandas()
 
st.bar_chart(data=data, x="TITLE", y="NB_OFFRES")
st.dataframe(data, use_container_width=True)