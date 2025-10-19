# OZ_EV_Analysis
Policy analysis of Opportunity Zone designation and EV station deployment (2018-2023)

# Opportunity Zone EV Station Analysis

## Project Summary
This project analyzes the impact of Opportunity Zone (OZ) designation on electric vehicle (EV) charging station deployment from 2018 to 2023. Using a self-compiled panel dataset of census tracts, I examine whether OZ designation influences EV station density.

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
![Event Study](figures/LogNormalizedEventStudy.png) 
<img width="1038" height="1020" alt="LogNormalizedEventStudy" src="https://github.com/user-attachments/assets/d460278d-d8b1-4e76-bc8c-6cee4f89d1f2" />

*This figure displays the estimated dynamic effects of Opportunity Zone (OZ) designation on electric vehicle (EV) station density, normalized by square miles. Estimates come from a two-way fixed effects model with county and year fixed effects, where the outcome variable is log-transformed EV station count. Coefficients are shown relative to the year prior to OZ implementation (ref = -1), with 95% confidence intervals.*

*Pre-Treatment Coefficients are close to 0 and not significant, By 2023, a 10% increase in EV Stations above treatment year level.*


** Parallel Line test to ensure pre-treatment effects are negligible, another way to visualize effects **  

<img width="776" height="553" alt="Regression_Disc" src="https://github.com/user-attachments/assets/fd8f31a7-9678-47d3-8a00-dc0de9a1c75a" />

