
source("https://inkaverse.com/setup.r")

install.packages("qpdf")



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

library(dplyr)

fb <- fb %>%
  mutate(color = case_when(
    semillas == "Leguminosas" ~ "#BEA037",
    semillas == "Hortalizas"  ~ "#33a02c",
    semillas == "Frutales"    ~ "#DB5920",  
    semillas == "Oleaginosas" ~ "#BD85AC",   
    TRUE ~ "black"
  ),
  nc_size = case_when(
    nc == "Beta vulgaris subsp. cicla" ~ 6,  # tamaño especial
    nc == "Solanum lycopersicum" ~ 8,
    nc == "Linum usitatissimum" ~ 8,
    TRUE ~ 9                                 # tamaño general
  ))

font <- c("Permanent Marker", "Tillana", "Courgette")

huito_fonts(font)

label <- fb %>%
  
  label_layout(
    size = c(3, 6),
    border_color = "black",
    border_width = 1) %>% 
  
  include_barcode(value = "link",
                  size = c(2.7, 2.7),
                  position = c(1.5, 1.5)) %>%
  include_image(value = "https://www.untrm.edu.pe/assets/images/untrmazul.png"
                , size = c(2.7, 2.7)
                , position = c(1.5, 5.5)) %>% 
  include_text(value = "numero"
               , size = 14
               , color = "color"
               , position = c(1.5, 4.8)
               , font = font[1]) %>% 
  include_text(value = "semillas"
               , size = 12
               , color = "color"
               , position = c(1.5 , 4.3)
               , font = font[2]) %>% 
  include_text(value = "nm"
               , size = 14
               , position = c(1.5, 3.7)
               , font = font[2]) %>% 
  include_text(value = "nc"
               , size = "nc_size"
               , position = c(1.5, 3.2)
               , font = font[3])




label %>% 
  label_print(mode = "preview")


label %>%
  label_print(
    mode = "complete",
    filename = "etiquetas_muestrario",
    paper = c(29.7, 21),  # A4 horizontal en cm
    units = "cm",
    margin = 0.2,         # margen opcional
    nlabels = 30,         # ajusta a tu número real
    viewer = TRUE         # abre PDF al terminar
  )
