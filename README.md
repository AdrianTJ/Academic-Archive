# Academic Portfolio: Statistics, Data Science, and Optimization

A comprehensive collection of academic projects, research, and technical notes developed during my studies at ITAM. This repository demonstrates proficiency in statistical modeling, machine learning, and data engineering using R and Python.

## 🚀 Featured Projects

### [Bookish Journey](./bookish-journey)
A production-grade cocktail recommendation system.
- **Tech Stack:** Python, GCP (Vertex AI, BigQuery, GCS), Apache Airflow.
- **Highlights:** Implemented a hybrid recommendation engine with automated ELT pipelines and cloud-based inference.

### [Optimization & BFGS](./Proyecto_final_opt_eq_4)
Implementation of the BFGS algorithm for logistic regression.
- **Focus:** Numerical optimization and large-scale statistical learning.
- **Implementation:** Custom Python implementation of second-order optimization methods.

### [NYC Taxi Fare Estimation](./ProjectoFinalEA3)
Statistical analysis of urban mobility data.
- **Focus:** Applied Statistics and Geospatial Analysis.
- **Outcome:** Predictive models for fare estimation using regression techniques and spatial visualization.

### [Multivariate Adaptive Regression Splines (MARS)](./Aprendizaje_MARS)
In-depth exploration of non-parametric regression.
- **Focus:** Model interpretability and non-linear relationship mapping using MARS.

---

## 📂 Repository Structure

### Machine Learning & Applied Statistics
*   **[Hoteles_Aprendizaje](./Hoteles_Aprendizaje):** Predictive modeling for hotel cancellations using Random Forests and Gradient Boosting.
*   **[Mineria_Proyecto](./Mineria_Proyecto):** End-to-end data mining project covering EDA, feature engineering, and model selection.
*   **[Aprendizaje_MARS](./Aprendizaje_MARS):** Research and application of MARS algorithms.

### Advanced Statistical Theory
*   **[fundamentos](./fundamentos):** Fundamentals of Statistics focusing on resampling methods (Bootstrap, Permutation), MLE, and hypothesis testing.
*   **[modelacion-bayesiana](./modelacion-bayesiana):** Bayesian inference, hierarchical modeling, and MCMC using Stan.
*   **[verse-bayesian](./verse-bayesian):** Environment configurations and research notes for Bayesian workflows.

### Computational Statistics & Methodology
*   **[metodos-analiticos](./metodos-analiticos):** Collection of analytical methods, including exams and research scripts.
*   **[Estadistica-Computacional-fall2021](./Estadistica-Computacional-fall2021):** Materials focused on simulation, optimization, and computational intensive methods.

### Academic Foundations
*   **[Intro-R-Otono2018](./Intro-R-Otono2018) / [Intro-R-Primavera2019](./Intro-R-Primavera2019):** Core R programming foundations and exploratory data analysis.
*   **[Diplomado2019](./Diplomado2019):** Specialized coursework from the 2019 Data Science Diploma.

---

## 🛠️ Tech Stack & Competencies

*   **Languages:** R (Tidyverse, Tidymodels, Stan), Python (Pandas, Scikit-learn, PyTorch).
*   **Infrastructure:** Docker, Google Cloud Platform (Vertex AI, BigQuery, GCS).
*   **Orchestration:** Apache Airflow.
*   **Reproducibility:** `renv` (R dependency management), Virtual Environments (Python).
*   **Reporting:** RMarkdown, Bookdown, LaTeX.

---

## ⚙️ Environment Setup

This repository is designed for reproducibility. You can set up the environment using either Docker or local package managers.

### Docker (Recommended)
Build and run the provided Docker image from the `setup/` directory to get a fully configured R/Python environment:
```bash
docker build -t academic-archive setup/
docker run -p 8787:8787 -e PASSWORD=your_password academic-archive
```

### Local Setup
If you prefer to set up the environment locally, you can use the shared dependency files located in the `setup/` directory:

1.  **R Environment:** Restore dependencies using `renv`:
    ```r
    install.packages("renv")
    renv::restore(lockfile = "setup/renv.lock")
    ```
2.  **Python Environment:** Install requirements:
    ```bash
    pip install -r setup/requirements.txt
    ```

---

## 📝 Disclaimer
This repository serves as an academic archive. While most projects are self-contained, some may require specific cloud credentials or legacy dependencies. It is intended for reference and research purposes.
