
library(huito)

font <- c("Permanent Marker", "Tillana", "Courgette")

huito_fonts(font)


label <- label_layout(size = c(5.5, 2),
                      border_width = 1) %>% 
  include_text(value = "Grupo 1"
               , position = c(2.5, 1.7)
               , size = 8
               , font = font[1]) %>% 
  include_text(value = "Muestrario de semillas dicotiledóneas"
               , size = 5.5
               , position = c(2.6, 1.4)
               , font = font[1]) %>% 
  include_text(value = "Barboza Saldaña, Lili; Diaz Saucedo, Yoel"
               , position = c(2.6, 1)
               , size = 7
               , font = font[2]) %>% 
  include_text(value = "Julca Celiz, Nilson; Llaja Zuta, Erika"
               , position = c(2.65, 0.65)
               , size = 7
               , font = font[2]) %>% 
  include_text(value = "Mendoza Bernilla, Alejandro; Vargas Rojas, Mayli"
               , position = c(2.65, 0.3)
               , size = 7
               , font = font[2]) %>% 
  include_image(value = "logo_fica.jpg"
                , size = c(0.5, 0.5)
                , position = c(5, 1.6)) %>% 
  include_image(value = "logo.jpg"
                , size = c(0.6, 0.6)
                , position = c(0.4, 1.6))
  




label %>% 
  label_print(mode = "preview")

label %>%
  label_print(
    mode = "complete",
    filename = "etiquetas_integrantes")

