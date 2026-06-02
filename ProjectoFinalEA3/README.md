# NYC Taxi Fare Estimation - Applied Statistics Project

This project aims to estimate taxi fares in New York City using historical trip data. It was developed as a final project for the **Applied Statistics 3** course at ITAM. The analysis leverages geospatial data, temporal features, and machine learning to build an accurate predictive model for fare amounts.

## 🚕 Project Overview
The core objective is to understand the factors that influence taxi fares and build a model that can predict the cost of a trip given its pickup/dropoff coordinates and time of day.

## 📂 Key Components
- **Data Preprocessing:**
    *   Filtering spatial outliers (coordinates outside the NYC area).
    *   Handling missing values and data cleaning.
- **Feature Engineering:**
    *   **Haversine Distance:** Calculating the great-circle distance between pickup and dropoff points in miles.
    *   **Temporal Features:** Extracting year, month, day, and hour from timestamps to capture seasonal and daily traffic patterns.
- **Statistical Analysis & Modeling:**
    *   **Exploratory Data Analysis (EDA):** Visualizing trip distributions, distance vs. fare relationships, and peak hours.
    *   **Linear Regression:** Baseline statistical modeling for fare estimation.
    *   **Random Forest:** A non-linear approach to capture complex interactions between distance, time, and location.
- **Geospatial Visualization:** Maps showing pickup and dropoff clusters across NYC boroughs.

## 🛠️ Tech Stack
- **R:** The primary language for statistical analysis and modeling.
- **Tidyverse:** For data manipulation and visualization (`ggplot2`, `dplyr`).
- **Geospatial Libraries:** `geosphere` (for distance calculations), `leaflet`, `ggmap`, and `sp`.
- **Machine Learning:** `randomForest` for predictive modeling.

## 📈 Results
The project demonstrates that while distance is the strongest predictor of fare, incorporating temporal features (like hour of the day) and spatial coordinates significantly improves model accuracy by accounting for traffic conditions and borough-specific pricing.
