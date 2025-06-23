library(huito)

font <- c("Paytone One", "Permanent Marker", "Tillana")

huito_fonts(font)


label <- label_layout(size = c(5.08, 5.08),
                      border_width = 0) %>% 
  include_image("fondo.png",
                size = c(5, 5),
                position = c(2.54, 2.54)) %>% 
  include_image(value = "seed.png", 
                size = c(1, 1),
                position = c(2.55, 1)) %>%
  include_shape(size = 5.08,
                border_width = 3,
                border_color = "darkgreen",
                position = c(2.54, 2.54),
                panel_color = "white",) %>%
  include_text(value = "Producción", 
               size = 14, 
               position = c(2.5, 3.6), 
               color = "#00a85a", 
               font[1]) %>%
  include_text(value = "Y", 
               size = 14, 
               position = c(2.5, 3), 
               color = "#00a85a", 
               font[1]) %>%
  include_text(value = "Tecnología", 
               size = 14, 
               position = c(2.5, 2.4), 
               color = "#00a85a", 
               font[3]) %>%
  include_text(value = "De Semillas", 
               size = 14, 
               position = c(2.5, 1.8), 
               color = "#00a85a", 
               font[1]) %>% 
  include_text(value = "Grupo 1"
               , size = 6
               , position = c(3.6, 0.75)
               , angle = 30
               , color = "white"
               , font[2])


label %>% 
  label_print(mode = "preview")


sticker <- label %>% 
  label_print(filename = "pts.png"
              , margin = 0
              , paper = c(5.5, 5.5)
              , mode = "complete"
  )
