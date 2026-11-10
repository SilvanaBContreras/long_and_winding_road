# Figura de contexto: crecimiento anual de los usuarios activos mensuales (MAU) de Spotify.
# Datos públicos de los informes de Spotify (fin de cada año); no vienen de Chartmetric.
#   2021: 406 M (+18%)  https://www.businesswire.com/news/home/20220202005417/en/
#   2022: 489 M y 2023: 602 M y 2024: 675 M  Form 20-F FY2024
#         https://www.sec.gov/Archives/edgar/data/1639920/000163992025000003/ck0001639920-20241231.htm
#   2025: 751 M (+11%)  https://newsroom.spotify.com/2026-02-10/spotify-q4-2025-earnings/
# Uso (desde la carpeta music_industry_st): Rscript figuras/contexto_spotify_usuarios.R
suppressMessages({library(data.table); library(ggplot2)})
systemfonts::register_font("LWR Titulo", plain = "C:/Windows/Fonts/BRLNSDB.TTF")
systemfonts::register_font("LWR Mono", plain = "fuentes/DejaVuSansMono.ttf", bold = "fuentes/DejaVuSansMono-Bold.ttf")

usuarios_spotify <- data.table(
  anio = 2021:2025,
  millones = c(406, 489, 602, 675, 751),
  crecimiento_informado = c(18, NA, NA, 12, 11)
)
usuarios_spotify[, crecimiento_anual := round(100 * (millones / shift(millones) - 1))]
usuarios_spotify[anio == 2021, crecimiento_anual := 18]   # informado por Spotify (base 2020: 345 M)
usuarios_spotify[, etapa := fifelse(anio >= 2024, "desde 2024", "hasta 2023")]

# Sanity check: coincide con lo que informa Spotify y con el guion (+20%, +23%, +12%, +11%)
stopifnot(identical(usuarios_spotify$crecimiento_anual, c(18, 20, 23, 12, 11)))

grafico_spotify <- ggplot(usuarios_spotify, aes(x = factor(anio), y = crecimiento_anual, fill = etapa)) +
  geom_col(width = 0.62) +
  geom_text(aes(label = paste0("+", crecimiento_anual, "%")), vjust = -0.45, family = "LWR Titulo", size = 9, colour = "#111111") +
  geom_text(aes(y = 1.2, label = paste0(millones, " M")), vjust = 0, family = "LWR Mono", fontface = "bold",
            size = 3.6, colour = "white") +
  scale_fill_manual(values = c("hasta 2023" = "#111111", "desde 2024" = "#A6A6A6"), guide = "none") +
  scale_y_continuous(limits = c(0, 28), expand = c(0, 0)) +
  labs(
    title = "Desde 2024, Spotify crece a la mitad",
    subtitle = "Crecimiento anual de usuarios activos mensuales.\nDentro de cada barra, el total a fin de año",
    caption = "Fuente: informes anuales y trimestrales de Spotify (2021-2025).",
    x = NULL, y = NULL
  ) +
  theme_minimal(base_size = 13, base_family = "LWR Mono") +
  theme(
    plot.title = element_text(family = "LWR Titulo", size = 24, colour = "#111111", margin = margin(b = 6)),
    plot.subtitle = element_text(size = 12, colour = "#4A4A4A", lineheight = 1.15, margin = margin(b = 14)),
    plot.caption = element_text(size = 9, colour = "#6B6B6B", hjust = 0, margin = margin(t = 10)),
    axis.text.x = element_text(face = "bold", size = 13, colour = "#111111"),
    axis.text.y = element_blank(),
    panel.grid = element_blank(),
    plot.title.position = "plot", plot.caption.position = "plot",
    plot.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(18, 18, 12, 18)
  )

ggsave(file.path("figuras", "contexto_spotify_usuarios.png"), grafico_spotify,
       width = 6.5, height = 6, dpi = 300, bg = "white", device = ragg::agg_png)
