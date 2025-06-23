
source("https://inkaverse.com/setup.r")

# Cargar librerías necesarias
library(googlesheets4)
library(dplyr)
library(huito)


# Cargar datos

url <- "https://docs.google.com/spreadsheets/d/1APoUsK8k7n8oSHP9dZXcmpYpJ4a6eJs3QikAp_eOvLQ/edit?usp=sharing"

gs <- as_sheets_id(url)
fb <- range_read(gs, sheet = "fb")

View(fb)


# Crear etiqueta


font <- c("Permanent Marker", "Tillana", "Courgette")

huito_fonts(font)

label <- fb %>% 
  mutate(color = case_when(
    Dosis == "C0_Control" & Variedad == "Criolla" ~ "navy",
  Dosis == "C0_Control" & Variedad == "Morada"  ~ "darkblue",
  Dosis == "C1_(05g/100 ml)" & Variedad == "Criolla" ~ "firebrick",
  Dosis == "C1_(05g/100 ml)" & Variedad == "Morada"  ~ "darkred",
  Dosis == "C2_(10g/100 ml)" & Variedad == "Criolla" ~ "saddlebrown",
  Dosis == "C2_(10g/100 ml)" & Variedad == "Morada"  ~ "chocolate",
  Dosis == "C3_(15g/100 ml)" & Variedad == "Criolla" ~ "darkgreen",
  Dosis == "C3_(15g/100 ml)" & Variedad == "Morada"  ~ "forestgreen",
  TRUE ~ "black"
  ),
  barcode = paste(Dosis, plots, Variedad, sep = "_"),
  barcode = gsub(" ", "-", barcode),
  treat_label = paste0("T", ntreat)) %>%
  
  
  label_layout(size = c(5, 8.5), border_color = "forestgreen"
               , border_width = 1.5) %>%
  include_image(value = "https://huito.inkaverse.com/img/scale.pdf"
                , size = c(4.8, 1)
                , position = c(2.5, 6.85)) %>% 
  include_image(value = "pts.pdf",
                size = c(1.4, 1.4),
                position = c(0.8, 0.8)) %>%
  include_image(value = "logo_fica.jpg",
                size = c(1.3, 1.3),
                position = c(4.2, 0.85)) %>% 
  include_barcode(value = "barcode",
                  size = c(4.3, 4.24),
                  position = c(2.5, 4.25)) %>%
  include_image(value = "https://www.untrm.edu.pe/assets/images/untrmazul.png"
                , size = c(3, 3)
                , position = c(1.8, 7.9)) %>% 
  include_text(value = "Dosis"
               , position = c(2.6, 1.87)
               , size = 13
               , color = "color"
               , font[2]) %>% 
  include_text(value = "Variedad"
               , position = c(2.6, 1.38)
               , size = 13
               , color = "color"
               , font[2]) %>% 
  include_text(value = "plots",
               position = c(4.4, 7.9),
               size = 16,
               color = "black",
               font[1]) %>% 
  include_text(
    value = "GRUPO 1",
    , position = c(2.5, 0.9)
    ,size = 13.5,
    color = "brown",
    font = font[2]
  ) %>% 
  include_text(value = "treat_label",
               position = c(2.45, 0.4), 
               size = 16, 
               color = "brown", 
               font = font[1])


label %>% 
  label_print(mode = "preview")


label %>% 
  label_print(mode = "complete", filename = "etiquetas", nlabels = 24)


