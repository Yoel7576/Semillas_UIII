
source("https://inkaverse.com/setup.r")




# Cargar librerías necesarias
library(googlesheets4)
library(dplyr)
library(huito)


# Cargar datos

url <- "https://docs.google.com/spreadsheets/d/1H3YK7GrI85Te3MwHDeOoa9SXpUEvNlzoZci49nr48Yo/edit?gid=0#gid=0"

gs <- as_sheets_id(url)
fb <- range_read(gs, sheet = "fb")

View(fb)


# Crear etiqueta

# Cargar fuentes
font <- c("Permanent Marker", "Tillana", "Courgette")
huito_fonts(font)

# Asegúrate de que numero sea numérico
fb <- fb %>%
  mutate(numero = as.numeric(numero))

# Crear objeto label
label2 <- fb %>%
  mutate(color = case_when(
    numero >= 1 & numero <= 9  ~ "#BEA037",   # Leguminosas
    numero >= 10 & numero <= 19 ~ "#33a02c",  # Hortalizas
    numero >= 20 & numero <= 26 ~ "#DB5920",  # Frutales
    numero >= 27 & numero <= 30 ~ "#BD85AC",  # Oleaginosas
    TRUE ~ "black"
  )) %>%
  label_layout(
    size = c(1.5, 1.5),
    border_color = "black",
    border_width = 0
  ) %>%
  include_text(
    value = "numero",
    size = 15,
    color = "color",
    position = c(0.8, 0.8),
    font = font[1]
  ) %>% 
  include_shape(size = 1.40,
                border_width = 1,
                border_color = "color",
                position = c(0.8, 0.76),
                panel_color = "white")

label2 %>% 
  label_print(mode = "preview")


label2 %>% 
  label_print(mode = "complete", filename = "números", nlabels = 30)



