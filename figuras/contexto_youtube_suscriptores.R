# Figura de contexto: suscriptores pagos de YouTube Music y Premium (incluye pruebas gratuitas).
# Datos públicos de los anuncios oficiales de YouTube; no vienen de Chartmetric.
#   sep 2021:  50 M (anunciado en sep 2021; citado en el blog de nov 2022)
#   sep 2022:  80 M  https://blog.youtube/news-and-events/youtube-music-premium-80-million-lyor-cohen/
#   ene 2024: 100 M  https://blog.youtube/news-and-events/youtube-music-premium-100-million-subscribers/
#   mar 2025: 125 M  https://blog.google/intl/en-in/feed/a-new-milestone-for-youtube-music-and-premium/
# Uso (desde la carpeta music_industry_st): Rscript figuras/contexto_youtube_suscriptores.R
suppressMessages({library(data.table); library(ggplot2)})
systemfonts::register_font("LWR Titulo", plain = "C:/Windows/Fonts/BRLNSDB.TTF")
systemfonts::register_font("LWR Mono", plain = "fuentes/DejaVuSansMono.ttf", bold = "fuentes/DejaVuSansMono-Bold.ttf")

hitos_youtube <- data.table(
  fecha = as.Date(c("2021-09-01", "2022-09-01", "2024-01-01", "2025-03-01")),
  etiqueta_fecha = c("sep 2021", "sep 2022", "ene 2024", "mar 2025"),
  millones = c(50, 80, 100, 125)
)
# Crecimiento anualizado entre hitos consecutivos (los intervalos no son de un año)
hitos_youtube[, meses := c(NA, diff(as.numeric(format(fecha, "%Y")) * 12 + as.numeric(format(fecha, "%m"))))]
hitos_youtube[, crecimiento_anual := round(100 * ((millones / shift(millones))^(12 / meses) - 1))]
hitos_youtube[, posicion := seq_len(.N)]

# Sanity check: 60%, 18% y 21% anualizados
stopifnot(identical(hitos_youtube$crecimiento_anual[-1], c(60, 18, 21)))

grafico_youtube <- ggplot(hitos_youtube, aes(x = posicion, y = millones)) +
  geom_col(width = 0.62, fill = c("#BDBDBD", "#9A9A9A", "#5E5E5E", "#111111")) +
  geom_text(aes(label = paste0(millones, " M")), vjust = -0.5, family = "LWR Titulo", size = 8, colour = "#111111") +
  geom_label(data = hitos_youtube[-1], aes(x = posicion - 0.5, y = millones + 22, label = paste0("+", crecimiento_anual, "%\npor año")),
             family = "LWR Mono", fontface = "bold", size = 3.6, colour = "#4A4A4A", fill = "white",
             linewidth = 0, lineheight = 0.95) +
  scale_x_continuous(breaks = hitos_youtube$posicion, labels = hitos_youtube$etiqueta_fecha) +
  scale_y_continuous(limits = c(0, 160), expand = c(0, 0)) +
  labs(
    title = "De +60% a cerca de +20% por año",
    subtitle = "Suscriptores pagos de YouTube Music y Premium\n(incluye pruebas gratuitas)",
    caption = "Fuente: anuncios oficiales de YouTube (2021-2025).\nCrecimiento anualizado entre hitos. YouTube no publica usuarios mensuales.",
    x = NULL, y = NULL
  ) +
  theme_minimal(base_size = 13, base_family = "LWR Mono") +
  theme(
    plot.title = element_text(family = "LWR Titulo", size = 26, colour = "#111111", margin = margin(b = 6)),
    plot.subtitle = element_text(size = 12, colour = "#4A4A4A", lineheight = 1.15, margin = margin(b = 14)),
    plot.caption = element_text(size = 9, colour = "#6B6B6B", hjust = 0, margin = margin(t = 10)),
    axis.text.x = element_text(face = "bold", size = 12, colour = "#111111"),
    axis.text.y = element_blank(),
    panel.grid = element_blank(),
    plot.title.position = "plot", plot.caption.position = "plot",
    plot.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(18, 18, 12, 18)
  )

ggsave(file.path("figuras", "contexto_youtube_suscriptores.png"), grafico_youtube,
       width = 6.5, height = 6, dpi = 300, bg = "white", device = ragg::agg_png)
