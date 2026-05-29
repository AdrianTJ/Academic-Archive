library(tidyverse)
library(tidymodels)
library(rsample)



hoteles <- read.csv("Datos/entrena.csv") |>
  mutate(arrival_date_month = factor(arrival_date_month), 
         arrival_date_year = factor(arrival_date_year),
         meal = factor(meal) ,
         market_segment = factor(market_segment),
         is_repeated_guest = factor(is_repeated_guest),
         distribution_channel = factor(distribution_channel),
         deposit_type = factor(deposit_type),
         customer_type = factor(customer_type),
         reserved_room_type = factor(reserved_room_type),
         assigned_room_type = factor(assigned_room_type))
hoteles$children[is.na(hoteles$children)] <- 0 # Si niños es NA entonces se va a 0 (la mediana). 



hoteles_split = initial_split(hoteles, prop = 0.7)
hoteles_split
hoteles_ent <- training(hoteles_split)



receta_hoteles <- recipe(is_canceled ~ stays_in_week_nights + 
                           adults + 
                           children + 
                           babies + 
                           booking_changes + 
                           lead_time + 
                           stays_in_weekend_nights + 
                           arrival_date_month + 
                           arrival_date_year + 
                           adr + 
                           total_of_special_requests + 
                           meal +
                           market_segment + 
                           is_repeated_guest +
                           distribution_channel + 
                           deposit_type + 
                           customer_type + 
                           previous_cancellations +
                           previous_bookings_not_canceled +
                           reserved_room_type +
                           assigned_room_type,
                         data = hoteles_ent) |>
  step_dummy(all_nominal(), -is_canceled) |>
  step_normalize(all_numeric_predictors())



modelo_logistico <- 
  logistic_reg(mixture = tune(), penalty = tune()) |> 
  set_args(lambda.min_ratio = 1e-18) |> 
  set_engine("glmnet") |> 
  set_mode("classification")



flujo <- workflow() |> 
  add_recipe(receta_hoteles) |> 
  add_model(modelo_logistico)



val_split <- manual_rset(hoteles_split |> list(), "validación")
params <- parameters(penalty(range = c(-5, 2), trans = log10_trans()),
                     mixture(range = c(0, 1)))
grid <- grid_regular(params, levels = c(penalty = 20, mixture = 5))



mis_metricas <- metric_set(mn_log_loss)
eval_tbl <- tune_grid(flujo,
                      resamples = val_split,
                      grid = grid,
                      metrics = mis_metricas) 
ajustes_tbl <- eval_tbl |>
  unnest(cols = c(.metrics)) |> 
  select(id, mixture, penalty, .metric, .estimate)
ajustes_tbl |> arrange(by = .estimate)









