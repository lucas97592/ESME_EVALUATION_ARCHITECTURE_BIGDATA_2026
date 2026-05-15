
import streamlit as st
from snowflake.snowpark.context import get_active_session
 
st.title(" Top 10 salaires par industrie")
session = get_active_session()
 
industries = session.sql("""
    SELECT DISTINCT industry FROM LINKEDIN.GOLD.FACT_JOB_INDUSTRY
    WHERE industry IS NOT NULL AND max_salary IS NOT NULL
      AND pay_period = 'YEARLY' ORDER BY industry
""").to_pandas()["INDUSTRY"].tolist()
 
selected = st.selectbox("Secteur d'activité", industries)
 
data = session.sql(f"""
    SELECT title, ROUND(AVG(max_salary),0) AS AVG_MAX_SALARY
    FROM LINKEDIN.GOLD.FACT_JOB_INDUSTRY
    WHERE industry = '{selected}' AND max_salary IS NOT NULL
      AND pay_period = 'YEARLY'
    GROUP BY title ORDER BY AVG_MAX_SALARY DESC LIMIT 10
""").to_pandas()
 
st.bar_chart(data=data, x="TITLE", y="AVG_MAX_SALARY")
st.dataframe(data, use_container_width=True)