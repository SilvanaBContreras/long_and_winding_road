# The Long and Winding Road - Series Temporales
Autora: Silvana Contreras

**The Long and Winding Road (LWR)**: búsqueda de perfiles en las trayectorias digitales de artistas musicales entre marzo de 2022 y marzo de 2026, a partir de métricas de streaming y redes sociales de la API de Chartmetric.

## Objetivo

Extender **Come Together**, la investigación previa sobre los mismos artistas, que tuvo un enfoque sincrónico: cada artista era una foto de sus métricas digitales. LWR agrega el tiempo: la unidad de análisis es el artista y cada artista es una trayectoria mensual multivariada.

## Notebooks

Se corren en orden. Todos usan R (kernel `ir`) con `data.table`. Cada notebook responde una pregunta y su respuesta abre la siguiente.

**01 · `01_LWR_ST_extraccion_API.ipynb`**
- ¿Cómo construir trayectorias mensuales si no existe un dataset público? Muestra estratificada por deciles de popularidad, extracción de Fan Stats y Playlist Evolution desde Chartmetric, mensualización (último valor del mes) y consolidación.
- *Salida:* dataset mensual crudo `artistas_ST_raw_<n>_long.csv` / `_wide.csv`.

**02 · `02_LWR_ST_construccion_dataset.ipynb`**
- ¿Qué artistas, variables y meses permiten comparar a todos? Cobertura por variable y conjunta (con el diagnóstico del pozo de Twitter), elección de 5 variables y panel de 49 meses con NA explícitos.
- *Salida:* panel `artistas_ST_<n>de<m>_top5000_22_26_na_long.csv` / `_wide.csv`.

**03 · `03_LWR_ST_preprocesamiento_filtros.ipynb`**
- ¿Las series miden a los artistas o a la fuente? Validación del muestreo mensual, limpieza de picos y series anómalas, interpolación, transformación log1p, suavizado (media móvil y pasa-bajos FFT), crecimiento mensual y features por artista.
- *Salida:* panel preprocesado (1252 artistas) y tabla de features.

**04 · `04_LWR_ST_clustering_distancias.ipynb`**
- ¿Cómo medir cuánto se parecen dos trayectorias? Matrices de distancia euclídea, DTW y SBD sobre el nivel.
- *Salida:* matrices de distancia (local).

**05 · `05_LWR_ST_clustering_particiones.ipynb`**
- ¿Hay perfiles de trayectoria? Jerárquico, spectral y PAM, k de 2 a 8 y elección de k por lectura de perfiles. Resultado: tres perfiles que ordenan por *cuánto* crece cada artista; la tendencia tapa la forma.
- *Salida:* particiones e indicadores (local).

**06 · `06_LWR_ST_forma_crecimiento.ipynb`**
- Entonces, ¿*cómo* crecen? Segunda representación: la tasa de crecimiento centrada de las tres audiencias. Distancias, spectral y PAM, elección de k. Aparecen formas (parejos, enfriamiento) y DTW empieza a importar.
- *Salida:* particiones de la forma (local).

**07 · `07_LWR_ST_validacion_perfiles.ipynb`**
- ¿Son perfiles estables y no la popularidad disfrazada? ¿Cómo se combinan cuánto y cómo crecen? Estabilidad con semillas y remuestreo, control por decil, cruce de intensidad y forma, caracterización y artistas representativos.
- *Salida:* perfil de cada artista (local).

**Complementos**
- `LWR_contexto_industria/`: ingresos globales de la música grabada por formato (IFPI), para la introducción.
- `LWR_grafos_exploracion/`: red de vecinos entre artistas y eigengap, como lectura complementaria de los perfiles.
- `figuras/`: figuras generadas por los notebooks, más los scripts de contexto de plataformas (`contexto_*.R`).
- `fuentes/`: tipografía DejaVu Sans Mono usada en las figuras.

El notebook 01 tiene el interruptor `EJECUTAR_EXTRACCION_API` (sección 1). Con `FALSE` (valor por defecto) corre completo desde el cache local, sin hacer requests a la API.

## Datos y licencia

Los datos provienen de Chartmetric bajo licencia académica: **no se publican datos crudos ni registros que permitan reconstruir métricas individuales**. Por eso:

- los CSV y RDS con datos están excluidos del repo (`.gitignore`);
- los notebooks se suben **sin salidas**, mediante el filtro `limpiar-salidas` de `.gitattributes`;
- el código de extracción se conserva para la replicabilidad, con credenciales propias en `.Renviron` (excluido del repo).

### Activar el filtro de salidas en un clon nuevo

La configuración del filtro no viaja con el repo. En cada clon, antes del primer commit:

```
git config filter.limpiar-salidas.clean "jupyter nbconvert --ClearOutputPreprocessor.enabled=True --to=notebook --stdin --stdout --log-level=ERROR"
git config filter.limpiar-salidas.smudge cat
git config filter.limpiar-salidas.required true
```

---

Trabajo práctico final de la materia **Data Mining de Series Temporales**.
Maestría en Data Mining, Facultad de Ciencias Exactas y Naturales, Universidad de Buenos Aires.
