# Hotel Booking Cancellations - Machine Learning Project

This project focuses on predicting hotel booking cancellations using a dataset from a Kaggle competition. The goal is to build a classification model that can accurately identify which bookings are likely to be cancelled, allowing hotels to manage their inventory and revenue more effectively.

## 📊 Dataset
The dataset includes information about hotel bookings (City Hotel and Resort Hotel), such as:
- **Lead time:** Number of days between booking and arrival.
- **Arrival date:** Year, month, and day.
- **Stay details:** Number of weekend and week nights.
- **Guest information:** Number of adults, children, and babies.
- **Booking details:** Meal plan, country of origin, market segment, and distribution channel.
- **Room information:** Reserved and assigned room types.
- **History:** Previous cancellations and non-cancelled bookings.

## 🛠️ Methodology & Models
The project follows a standard machine learning workflow using the `tidymodels` ecosystem in R:
1.  **Exploratory Data Analysis (EDA):** Visualizing distributions and correlations (see `EDA.Rmd`).
2.  **Feature Engineering:** Date manipulation, handling missing values, and encoding categorical variables.
3.  **Model Exploration:**
    *   **Logistic Regression:** Baseline model with hyperparameter tuning (`LogisticReg_Hyperparameters.Rmd`).
    *   **Random Forests:** Ensembles of decision trees to capture non-linearities (`RandomForest.Rmd`).
    *   **Boosted Trees (XGBoost):** Advanced gradient boosting for improved performance (`Boost_Tree.Rmd`).
4.  **Ensembling:** Bagging and other techniques to improve stability.

## 📈 Results
The final models were used to generate predictions for the Kaggle competition leaderboard. The implementation details and model comparisons can be found in the `HotelesN2.Rmd` and `Boost_Tree.Rmd` files.

## 🔗 External Links
- **Kaggle Competition:** [Cancelaciones en Hoteles](https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=11007) (Note: The link in the original README points to the project team page).
