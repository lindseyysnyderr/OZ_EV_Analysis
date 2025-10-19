# OZ_EV_Analysis
Policy analysis of Opportunity Zone designation and EV station deployment (2014-2023)

# Opportunity Zone EV Station Analysis

## Project Summary
This project analyzes the impact of Opportunity Zone (OZ) designation on electric vehicle (EV) charging station deployment from 2014 to 2023. Using a self-compiled panel dataset of census tracts, I find OZ designation creates a 10% increase in EV station density over treatment years.

Opportunity Zones, passed in the Tax Cuts and Jobs Act of 2017, are a federal economic development tool meant to spur investment in undercapitalized communities. They allow deferral, reduction, or exemption of capital gains tax if gains are placed in a Qualified Opportunity Fund (QOF). From 2019-2020, $44B of investment went to OZ’s. For comparison, another place-based federal program, the New Markets Tax Credit, parceled out the same amount from 2003 to 2023. 

## Methods & Tools
- **Coding & Analysis:** R  
- **Packages:** tidyverse, fixest, sf, ggplot2  
- **Models:** Poisson, log-transformed, event-study, fixed-effects  
- **Data Wrangling:** Spatial joins, normalization by area, merging multiple datasets

To estimate the effects of Opportunity Zone designation on EV station density, I used a Dynamic Difference-in-Differences model, or event study. 

The treatment group are Designated OZs and the Control group are Eligible but not selected census tracts. To be eligible, a census tract must be a Low-Income Community (At least 20% Poverty Rate OR Median family income below 80% of income in the state). However, Governors were able to designate whichever eligible tracts at their disposal- this part of the selection process was quasi-random. 

The identification strategy strengthens the causual inference as the selection into the treatment group was quasi-random due to the OZ program structure, mitigating self selection bias. 


## Dataset
- `OZ_EV_panel_data.csv`: Self-compiled panel dataset, station-year, of OZ tracts and EV stations  
- Variables include:
  - `GEOID` – Census tract ID
  - `EV_Count` – Number of EV stations, compiled from the DOE's Alternative Fuels Data Center 
  - `OZ_Desig` – Opportunity Zone designation, merged from cenusus shapefile + IRS data on designation
  - `medInc` – Median income, U.S Census Bureau
  - `bachdeg` – Share with bachelor’s degree, U.S Census Bureau
  - `EV_per_mi2` – EV station density

*All data were compiled and cleaned by the author.*

## Figures
**Event Study (Log Normalized EV Station Count)**  

<img width="1038" height="1020" alt="LogNormalizedEventStudy" src="https://github.com/user-attachments/assets/d460278d-d8b1-4e76-bc8c-6cee4f89d1f2" />

*This figure displays the estimated dynamic effects of Opportunity Zone (OZ) designation on electric vehicle (EV) station density, normalized by square miles. Estimates come from a two-way fixed effects model with county and year fixed effects, where the outcome variable is log-transformed EV station count. Coefficients are shown relative to the year prior to OZ implementation (ref = -1), with 95% confidence intervals.*

*Pre-treatment coefficients are near zero and statistically insignificant, supporting the parallel trends assumption. By 2023, the model estimates roughly a 10% increase in EV station density relative to baseline levels.*


** This plot visualizes the parallel trends test, illustrating negligible pre-treatment differences between designated and non-designated tracts and supporting the identification strategy. **  

<img width="776" height="553" alt="Regression_Disc" src="https://github.com/user-attachments/assets/fd8f31a7-9678-47d3-8a00-dc0de9a1c75a" />

## Discussion 

Economic theory suggests that when investment incentives lack regulatory direction, funds may flow toward sectors like real estate rather than public goods such as green infrastructure. Additionally, little is known about the effects of OZ's outside of real estate and property values. Given this, the observed positive treatment effect on EV station deployment is notable.  

These findings suggest that place-based programs like OZs can, under certain conditions, complement environmental policy objectives, particularly in addressing infrastructure gaps in communities with latent demand. Further, Public EV chargers can have a positive effect on businesses + local economic growth (Zheng et. Al, 2024). 

Further research could explore the mechanisms driving this relationship and its distributional implications.




