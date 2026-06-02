# IMDb Movie Analysis & Recommendation System

This project is a comprehensive data mining exploration of the IMDb dataset, focusing on movie metadata, ratings, and user preferences. The goal is to perform in-depth exploratory data analysis (EDA), build predictive models for movie ratings, and design a robust recommendation engine.

## 📂 Project Structure
The repository is organized into three main phases:

### 1. Exploratory Data Analysis (EDA)
Located in the `EDA/` directory, these notebooks cover the cleaning and initial analysis of:
- **IMDb Movies:** General metadata analysis (genres, release dates, runtime).
- **IMDb Ratings:** Distribution of user scores and voting patterns.
- **Names & Principals:** Analysis of cast and crew (directors, actors) and their impact on movie success.
- **Data Cleaning:** Intensive preprocessing of raw metadata (`Limpieza_Metadata.ipynb`).

### 2. Modeling
Located in the `Modelos/` directory:
- **Rating Prediction:** Regression models built to predict a movie's average rating based on its features (genre, budget, cast popularity, etc.).
- **Initial Recommender:** Prototyping recommendation logic based on content similarity.

### 3. Final Implementation
Located in the `Modelos_Finales/` directory:
- **Clustering-based Recommender:** A hybrid recommendation system utilizing K-Means and Mean Shift clustering to group similar movies.
- **Feature Importance:** Analysis of which variables most significantly affect movie ratings and clusters.
- **Hyperparameter Tuning:** Systematic optimization of the models for better performance.
- **Production Code:** Python scripts (`modelos.py`) and an interactive notebook (`recomendador_de_peliculas.ipynb`) for generating movie suggestions.

## 🛠️ Tech Stack
- **Python:** Primary language for data processing and modeling.
- **Pandas & NumPy:** Data manipulation and numerical computation.
- **Scikit-learn:** Clustering algorithms (K-Means, Mean Shift) and regression models.
- **Matplotlib & Seaborn:** Data visualization.
- **Jupyter Notebooks:** For interactive development and reporting.

## 🚀 Key Insights
- Identified significant correlations between production budget, director reputation, and final movie ratings.
- Developed a high-performing recommendation engine that balances similarity and serendipity through clustering.
