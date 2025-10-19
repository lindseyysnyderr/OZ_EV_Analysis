setwd("~/Downloads/OZData")

library(tidyverse)
library(ggplot2)
library(sf)
library(fixest)
library(stringr)

### reloading final panel data into env

panel_data= read.csv("OppZone_EVStations_PanelData.csv", colClasses = c(GEOID= "character"))

### histogram of DV

hist(panel_data$EV_Count, main= "Histogram of EV Count", xlab= "EV Count", col= "skyblue", xlim = c(0, 100),breaks= 30)

### normalizing by SQMI

st_crs(shpOZ)

# If it's in geographic coordinates (e.g., EPSG:4326), reproject to a projected CRS
# Here’s an example using EPSG:3857 (Web Mercator) — you can pick another based on your region
shpOZ <- st_transform(shpOZ, 3857)

# Now calculate area and store it in a new column called 'area_m2'
shpOZ$area_m2 <- st_area(shpOZ)

# ok, calculated area so now dropping geometry + sf

areas <- as.data.table(st_drop_geometry(shpOZ))[, c("GEOID", "area_m2")]

areas$area_m2 <- as.numeric(areas$area_m2)

# now left joining with panel data

panel_data <- left_join(panel_data, areas)

# and changing units and adding normalization col

panel_data$area_mi2 <- as.numeric(set_units(panel_data$area_m2, mi^2))

# Normalize
panel_data$EV_per_mi2 <- panel_data$EV_Count / panel_data$area_mi2

panel_data$log_EV_density <- log1p(panel_data$EV_per_mi2)

# now, histogram of EV/SQMI

hist(panel_data$EV_per_mi2)
hist(panel_data$log_EV_density)

## obviously very skewed low, so running poisson 

panel_data$GEOID <- as.factor(panel_data$GEOID)
panel_data$Year <- as.factor(panel_data$Year)

pmodel <- feglm(EV_Count ~ OZ_Desig * post | GEOID + Year, 
                family = "poisson", 
                data = panel_data)

summary(pmodel)

summary(panel_data$EV_per_mi2)
summary(panel_data$EV_Count)

### getting descriptive STATS for OZ/Non-OZ.. need to show that they are statistically similar

educ <- read.csv("Educ19.csv") %>%
  select(B15003_022E, GEO_ID) %>%
  mutate(GEOID = substr(as.character(GEO_ID), nchar(GEO_ID) - 10, nchar(GEO_ID)))

panel_data <- left_join(panel_data, educ) %>%
  rename("bachdeg" = B15003_022E)

### 

panel_data <- panel_data %>%
  mutate(bachdeg = as.numeric(bachdeg))

sumstats= panel_data %>%
  group_by(OZ_Desig) %>%
  summarize(
    mean_income = mean(medInc, na.rm = TRUE),
    mean_bachelors = mean(bachdeg, na.rm = TRUE),
    count = n()
  )

summary(sumstats)

### t-test of descriptive stats 

t.test(medInc ~ OZ_Desig, data = panel_data)

# ok pivoting off of that, doing the parallel trend test

pretreat = panel_data %>% 
  filter(post== 0)

parallelmodel <- feols(EV_Count ~ OZ_Desig*Year, data= pretreat)
summary(parallelmodel)

## now time for event study analysis 

panel_data <- panel_data %>%
  mutate(Year = as.numeric(as.character(Year)),
         event_time = Year - 2019)

event_model <- feols(EV_Count ~ i(event_time, OZ_Desig, ref = -1) | GEOID + Year, 
                     data = panel_data,
                     cluster = ~GEOID)
summary(event_model)

iplot(log_model,
      main = "Event Study: OZ Designation and EV Station Count",
      xlab = "Years Since OZ Implementation",
      ylab = "Percent Change in EV Station Density",
      col = "steelblue")

summtwo= panel_data %>%
  select(EV_Count, EV_per_mi2)

summary(summtwo)

### log model 

panel_data <- panel_data %>%
  mutate(log_EV_Count = log1p(EV_Count))

log_model <- feols(log_EV_Count ~ i(event_time, OZ_Desig, ref = -1) | GEOID + Year,
                   data = panel_data,
                   cluster = ~GEOID)
summary(log_model)

### poisson model 

poisson_model <- fepois(EV_Count ~ i(event_time, OZ_Desig, ref = -1) | GEOID + Year,
                        data = panel_data,
                        cluster = ~GEOID)
summary(poisson_model)

## seeing Urban vs. Rural heterogeneity

rucc = read.csv("Ruralurbancontinuumcodes2023 (1).csv") %>%
  filter(Attribute == "RUCC_2023") %>%
  select(FIPS, Value) %>%
  mutate(Urban= case_when(
    Value %in% c(1,2,3,4,6,8) ~ 1,
    Value %in% c(5,7,9) ~ 0
  ))

rucc <- rucc %>%
  mutate(county_fips = sprintf("%05d", FIPS)) 

panel_data= panel_data %>%
  mutate(county_fips= substr(GEOID, 1,5)) %>%
  left_join(rucc, by= "county_fips")


hetero_model <- feols(log_EV_Count ~ i(event_time, OZ_Desig, ref = -1) * Urban | GEOID + Year,
                      data = panel_data,
                      cluster = ~GEOID)
summary(hetero_model)


