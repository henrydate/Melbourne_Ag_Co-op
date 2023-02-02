# @TODO: Import the libraries for Pandas and Streamlit
import streamlit as st
import pandas as pd
from PIL import Image

image = Image.open('Pistachio2.png')
st.image(image, caption='Pistachios Galore')


st.title("Melbourne Ag Co-Op Valuation")
st.text("""Melbourne Ag Co-Op Valuation is projected to compound at 2% per annum.""")
## Insert image st.image('./images/464487main_AS11-40-5886_full.jpg', caption = "Pistachio 1")
# Melbourne Ag Co-op valuation
df = {'Financial year': ['FY23', 'FY24', 'FY25', 'FY26', 'FY27', 'FY28', 'FY29', 'FY30', 'FY31'],
'Melbourne Ag Co-OP': [1700000, 1734000, 1768680, 1804054,   1840135, 1876937, 1914476, 1952766, 1991821]}
df1 = pd.DataFrame(data = df)
st.table(df1)

st.bar_chart(df1, x = 'Financial year')


st.line_chart(df1, x = 'Financial year')


st.area_chart(df1, x = 'Financial year')



