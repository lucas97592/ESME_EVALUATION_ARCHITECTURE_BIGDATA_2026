import streamlit as st
from snowflake.snowpark.context import get_active_session

st.title("Offres par type d'emploi")
session = get_active_session()

data = session.sql("""
    SELECT NVL(formatted_work_type, 'Non renseigné') AS TYPE_EMPLOI,
           COUNT(*) AS NB_OFFRES
    FROM LINKEDIN.SILVER.JOB_POSTINGS
    GROUP BY formatted_work_type ORDER BY NB_OFFRES DESC
""").to_pandas()

st.bar_chart(data=data, x="TYPE_EMPLOI", y="NB_OFFRES", color="TYPE_EMPLOI")
st.dataframe(data, use_container_width=True)
