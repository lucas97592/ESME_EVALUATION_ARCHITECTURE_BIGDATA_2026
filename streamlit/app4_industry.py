import streamlit as st
from snowflake.snowpark.context import get_active_session

st.title("Offres par secteur d'activité")
session = get_active_session()

data = session.sql("""
    SELECT NVL(industry, 'Non renseigné') AS INDUSTRIE, COUNT(*) AS NB_OFFRES
    FROM LINKEDIN.GOLD.FACT_JOB_INDUSTRY
    GROUP BY industry ORDER BY NB_OFFRES DESC LIMIT 20
""").to_pandas()

top_n = st.slider("Nombre de secteurs", 5, 20, 10)
st.bar_chart(data=data.head(top_n), x="INDUSTRIE", y="NB_OFFRES", color="INDUSTRIE")
st.dataframe(data, use_container_width=True)
