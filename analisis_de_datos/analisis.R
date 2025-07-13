
# Cargar librerias

source("https://inkaverse.com/setup.r")

library(GerminaR)
library(dplyr)
library(ggplot2)
library(GerminaR)
library(knitr)

# Cargar datos


gs <- ("https://docs.google.com/spreadsheets/d/1APoUsK8k7n8oSHP9dZXcmpYpJ4a6eJs3QikAp_eOvLQ/edit?gid=537863656#gid=537863656") %>% 
  as_sheets_id(url)

fb <- gs %>% 
  range_read("fb") %>%
  mutate(
    across(1:cols, ~as.factor(.)),
    qrcode = as.character(qrcode),
    plots = as.integer(plots),
    Seed = as.integer(Seed),
    hora_evaluc = as.character(hora_evaluc)
  ) %>%
  as.data.frame()


str(fb)



# Resumen de germinación

gsm <- ger_summary(SeedN = "Seed",
                   evalName = "Ger_",
                   data = fb)

gsm %>% kable()

# Porcentaje de germinación (grp)

## ANOVA de grp.

av <- aov(grp ~ dosis * variedad + block, data = gsm)

anova(av)

## Prueba de comparación de medias por cada factor

mc_grp <- ger_testcomp(
  aov = av,
  comp = c("dosis", "variedad"),
  type = "snk"
)


## Tabla de resultados
mc_grp$table %>%
  kable(caption = "Comparación de medias del porcentaje de germinación (GRP)")


## Gráfico de barras de porcentage de germinación

grp <- mc_grp$table %>% 
  fplot(data = .,
        type = "bar",
        x = "variedad",         # eje X: variedad
        y = "grp",              # variable a graficar
        group = "dosis",        # agrupamiento por color
        ylimits = c(0, 120, 20),
        ylab = "Germinación ('%')",   # <- evitar % y tildes
        xlab = "Variedad",
        glab = "Dosis",
        error = "ste",
        sig = "sig",
        color = TRUE
  )

grp


# Tiempo medio de germinación (mgt)


## ANOVA para mgt
av_mgt <- aov(mgt ~ dosis * variedad + block, data = gsm)
anova(av_mgt)

## Comparación de medias
mc_mgt <- ger_testcomp(
  aov = av_mgt,
  comp = c("dosis", "variedad"),
  type = "snk"
)

## Tabla de resultados
mc_mgt$table %>%
  kable(caption = "Comparación de medias del tiempo medio de germinación (MGT)")

## Gráfico de barras
mgt_plot <- mc_mgt$table %>%
  fplot(data = .,
        type = "bar",
        x = "variedad",
        y = "mgt",
        group = "dosis",
        ylimits = c(0, max(.$mgt + .$ste, na.rm = TRUE) * 1.2, 1),
        ylab = "Tiempo medio de germinación (días)",
        xlab = "Variedad",
        glab = "Dosis",
        error = "ste",
        sig = "sig",
        color = TRUE)

mgt_plot

# Índice de sincronización (syn)

## ANOVA para syn
av_syn <- aov(syn ~ dosis * variedad + block, data = gsm)
anova(av_syn)

## Comparación de medias
mc_syn <- ger_testcomp(
  aov = av_syn,
  comp = c("dosis", "variedad"),
  type = "snk"
)

## Tabla de resultados
mc_syn$table %>%
  kable(caption = "Comparación de medias del índice de sincronización (SYN)")

## Gráfico de barras
syn_plot <- mc_syn$table %>%
  fplot(data = .,
        type = "bar",
        x = "variedad",
        y = "syn",
        group = "dosis",
        ylimits = c(0, max(.$syn + .$ste, na.rm = TRUE) * 1.2, 0.1),
        ylab = "Índice de sincronización",
        xlab = "Variedad",
        glab = "Dosis",
        error = "ste",
        sig = "sig",
        color = TRUE)

syn_plot



# Objetivo 2

# ============================================
# Análisis de germinación - Objetivo Específico 2
# Comparación entre variedades y dosis de canela
# ============================================

# 📦 Cargar librerías necesarias
library(ggplot2)
library(dplyr)

# ============================================
# 1. Preparar tablas de medias
# ============================================

# GRP: porcentaje de germinación
grp_df <- mc_grp$table %>%
  dplyr::select(variedad, dosis, valor = grp, ste, sig) %>%
  mutate(variable = "GRP")

# MGT: tiempo medio de germinación
mgt_df <- mc_mgt$table %>%
  dplyr::select(variedad, dosis, valor = mgt, ste, sig) %>%
  mutate(variable = "MGT")

# SYN: índice de sincronización
syn_df <- mc_syn$table %>%
  dplyr::select(variedad, dosis, valor = syn, ste, sig) %>%
  mutate(variable = "SYN")

# Unir todas las tablas
todo_df <- bind_rows(grp_df, mgt_df, syn_df)

# Agregar columna de posición adaptativa para cada variable
todo_df <- todo_df %>%
  group_by(variable) %>%
  mutate(
    ajuste = case_when(
      variable == "GRP" ~ 5,
      variable == "MGT" ~ 0.5,
      variable == "SYN" ~ 0.05,
      TRUE ~ 0.1
    ),
    pos_letra = valor + ste + ajuste
  ) %>%
  ungroup()

# Crear gráfico con letras bien posicionadas
grafico_objetivo2 <- ggplot(todo_df, aes(x = variedad, y = valor, fill = dosis)) +
  geom_bar(stat = "identity", 
           position = position_dodge(width = 0.9), 
           color = "black") +
  geom_errorbar(aes(ymin = valor - ste, ymax = valor + ste),
                position = position_dodge(width = 0.9), 
                width = 0.2) +
  geom_text(aes(y = pos_letra, label = sig),
            position = position_dodge(width = 0.9),
            size = 3) +
  facet_wrap(~variable, scales = "free_y") +
  labs(
    title = "Respuesta germinativa de dos variedades de lechuga frente a diferentes dosis de canela",
    x = "Variedad",
    y = "Valor del índice germinativo",
    fill = "Dosis"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    strip.text = element_text(face = "bold"),
    legend.position = "bottom"
  )

# Mostrar gráfico
grafico_objetivo2


# Exportar gráficos con fondo blanco
ggsave("grafico_objetivo2.png", plot = grafico_objetivo2, width = 10, height = 6, dpi = 300, bg = "white")
ggsave("mgt_plot.png", plot = mgt_plot, width = 8, height = 5, dpi = 300, bg = "white")
ggsave("syn_plot.png", plot = syn_plot, width = 8, height = 5, dpi = 300, bg = "white")
ggsave("grp.png", plot = grp, width = 8, height = 5, dpi = 300, bg = "white")




