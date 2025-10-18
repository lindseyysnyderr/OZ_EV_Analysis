# OZ_EV_Analysis
Policy analysis of Opportunity Zone designation and EV station deployment (2018-2023)

# Opportunity Zone EV Station Analysis

## Project Summary
This project analyzes the impact of Opportunity Zone (OZ) designation on electric vehicle (EV) charging station deployment from 2018 to 2023. Using a self-compiled panel dataset of census tracts, I examine whether OZ designation influences EV station density and assess urban/rural heterogeneity.

## Methods & Tools
- **Coding & Analysis:** R  
- **Packages:** tidyverse, fixest, sf, ggplot2  
- **Models:** Poisson, log-transformed, event-study, fixed-effects  
- **Data Wrangling:** Spatial joins, normalization by area, merging multiple datasets

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


**Regression Discontinuity: OZ Designation Effect**  
![Regression Discontinuity](figures/Regression_Disc.png)

![Uploading Regression_Disc.png…]()

