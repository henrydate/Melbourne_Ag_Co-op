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
df = {'Financial year': ['FY23', 'FY24', 'FY25', 'FY26', 'FY27', 'FY28', 'FY29'],
'Melbourne Ag Co-OP': ['$1,700,000', '$1,734,000', '$1,768,680', '$1,804,054',   '$1,840,135', '$1,876,937', '$1,914,476']}
df1 = pd.DataFrame(data = df)
st.table(df1)

df = {'Financial year': ['FY23', 'FY24', 'FY25', 'FY26', 'FY27', 'FY28', 'FY29'],
'Melbourne Ag Co-OP': [1700000,	1734000,	1768680,	1804054,	1840135,	1876937,	1914476]}
df2 = pd.DataFrame(data = df)

st.bar_chart(df2, x = 'Financial year')

st.subheader("Cost Breakdown")

df = {'Cost Items': 
['Utilities', 
'ATV', 
'Workshop Fitout', 
'Tractor - Heavy works', 
'Tractor- Orchard',
'Airblast Sprayer',
'Weedicide Sprayer',
'Mulcher',
'Landforming (v plane, x plane, graderbucket)',
'Misc Plant (trailers, weed sprayers, mower, fuel)',
'Telehandler',
'Side-by-Side Harvester and bulk cart',
'Sweepers',
'Harvester',
'Bankout Cart (1 Harvester Set)',
'Elevator',
'Annual Subtotal',
'',
'Costs over 7 years ($100,000 x 7)',
'Land',
'',
'Total'
],
'Amount': 
['$756',
'$189',
'$189',
'$567',
'$1,965',
'$756',
'$189',
'$302',
'$151',
'$94',
'$567',
'$56,679',
'$0',
'$0',
'$33,063',
'$4,534',
'$100,000', 
'',
'$700,000',
'$1,000,000',
'', 
'$1,700,000'
]}
df1 = pd.DataFrame(data = df)
st.table(df1)


st.write()





