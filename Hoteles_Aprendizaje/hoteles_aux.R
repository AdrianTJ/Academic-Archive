### Auxiliar functions

# Convert tring month to a numeric value
month_to_number <- function(x){
  if (x == "January"){1}
  else if (x == "February"){2}
  else if (x == "March"){3}
  else if (x == "April"){4}
  else if (x == "May"){5}
  else if (x == "June"){6}
  else if (x == "July"){7}		
  else if (x == "August"){8}
  else if (x == "September"){9}
  else if (x == "October"){10}
  else if (x == "November"){11}			
  else if (x == "December"){12}
}

# Calculate logloss
calculate_logloss <- function(flujo_ajustado, data){
    dat_log_loss_prueba <- flujo_ajustado |>
      predict(data, type = "prob") |>
      bind_cols(data) |>
      select(is_canceled, .pred_cancelado, .pred_no_cancelado)|>
      mutate(hat_p_g = ifelse(is_canceled == "cancelado",
                              .pred_cancelado, .pred_no_cancelado )) |>
      mutate(log_loss = -log(hat_p_g)) |>
      arrange(desc(log_loss))
    
    # mn_log_loss ocupa el error de maquina cuando hay infinitos
    dat_log_loss_prueba$log_loss[dat_log_loss_prueba$log_loss == Inf] <- -log(.Machine$double.eps)
    
    dat_log_loss_prueba |>
      summarise(log_loss_prueba = mean(log_loss))
}

# Get most common level
most_common <- function(datos, columna){
  datos |> 
    group_by(across(all_of(c(columna)))) |>
    summarise(n = n()) |> 
    arrange(by = desc(n)) |>
    head(1) |> 
    pull(c(columna)) |>
    toString()
}

### Auxiliar variables

hoteles_aux <- read.csv("Datos/entrena.csv") 
hoteles_aux$children[is.na(hoteles_aux$children)] <- 0 # Si ninios es NA entonces se va a 0 (la mediana), solo hay 4 NA. 
hoteles_aux <- hoteles_aux |> mutate(num_is_canceled = ifelse(is_canceled == "no_cancelado", 0, 1))

#### country

new_cc <- hoteles_aux |>
            group_by(country) |>
            summarise(n = n(),
                      porc = 100*n()/dim(hoteles_aux)[1],
                      prop_cancel = 100*mean(num_is_canceled)) |>
            arrange(desc(porc)) |>
            filter(n > 0.01*dim(hoteles_aux)[1]) |>
            pull(country)

aux <- hoteles_aux |>
          filter(country %in% new_cc == FALSE ) |>
          group_by(country) |>
          summarise(n = n(),
                    porc = 100*n()/dim(hoteles_aux)[1],
                    prop_cancel = 100*mean(num_is_canceled)) |>
          arrange(desc(prop_cancel)) |>
          filter(n > 0.001*dim(hoteles_aux)[1])

new_cc_buenos <- aux |>
                  filter(prop_cancel < 45) |>
                  pull(country)


#### agent

new_ca <- hoteles_aux |>
            group_by(agent) |>
            summarise(n = n(),
                      porc = 100*n()/dim(hoteles_aux)[1],
                      prop_cancel = 100*mean(num_is_canceled)) |>
            arrange(desc(porc)) |>
            filter(n > 0.01*dim(hoteles_aux)[1]) |>
            pull(agent)

aux <- hoteles_aux |>
          filter(agent %in% new_cc == FALSE ) |>
          group_by(agent) |>
          summarise(n = n(),
                    porc = 100*n()/dim(hoteles_aux)[1],
                    prop_cancel = 100*mean(num_is_canceled)) |>
          arrange(desc(prop_cancel)) |>
          filter(n > 0.001*dim(hoteles_aux)[1])

new_ca_buenos <- aux |>
                  filter(prop_cancel < 40) |>
                  pull(agent)
                new_ca_malos <- aux |>
                  filter(prop_cancel > 60) |>
                  pull(agent)
                
                
#### company
                
new_ccs <- hoteles_aux |>
            group_by(company) |>
            summarise(n = n(),
                      porc = 100*n()/dim(hoteles_aux)[1],
                      prop_cancel = 100*mean(num_is_canceled)) |>
            arrange(desc(porc)) |>
            filter(n > 0.005*dim(hoteles_aux)[1]) |>
            pull(company)

aux <- hoteles_aux |>
          filter(company %in% new_ccs == FALSE ) |>
          group_by(company) |>
          summarise(n = n(),
                    porc = 100*n()/dim(hoteles_aux)[1],
                    prop_cancel = 100*mean(num_is_canceled)) |>
          arrange(desc(prop_cancel)) |>
          filter(n > 0.0005*dim(hoteles_aux)[1])

new_ccs_buenos <- aux |>
                    filter(prop_cancel < 40) |>
                    pull(company)                