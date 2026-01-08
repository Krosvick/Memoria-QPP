#import "../template.typ": *
#import "@preview/fletcher:0.5.4" as fletcher: diagram, node, edge
#import fletcher.shapes: *

#let blob(pos, label, tint: white, ..args) = node(
    pos, align(center, label),
    width: 27mm,
    fill: tint.lighten(65%),
    stroke: 1pt + tint.darken(20%),
    corner-radius: 5pt,
    ..args,
)

#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= ANÁLISIS DE RESULTADOS
\
A traves de la literatura se ha establecido de manera casi unánime el análisis del rendimiento de los métodos QPP mediante el uso de métricas de correlación. Entre los primeros trabajos se puede encontrar el de E.M Voorhees en la conferencia TREC-6, donde se presenta el primer análisis de la capacidad de expertos en predecir el rendimiento de las consultas, donde se pudo observar que la mayor correlación lineal entre los resultados de los expertos fue de solo 0.26. @trec-6.

El campo de la predicción del rendimiento de consultas se ha desarrollado a lo largo de los años, y se ha establecido el uso de juicios de relevancia y métricas como el tau de Kendall para la evaluación de los predictores. En este sentido, se encuentran dos puntos de interés, por un lado la evaluación del sistema de recuperación subyacente, y por otro la evaluación de los predictores utilizando como pre-requisito la evaluación del sistema de recuperación.

En esta sección se presentan los resultados obtenidos al evaluar los métodos QPP sobre cinco conjuntos de datos ampliamente utilizados en la comunidad de recuperación de información: *Antique/Test*, *Cranfield*, *BEIR-TREC-COVID*, *MS MARCO (Passage)* y *CAR*. Todos ellos se acceden a través del catálogo _ir_datasets_, lo que garantiza reproducibilidad y un tratamiento consistente de documentos, consultas y juicios de relevancia. En el caso de *MS MARCO (Passage)* y *CAR* se utilizaron específicamente las variantes con juicios multinivel, lo que permite analizar el comportamiento de los predictores en escenarios con información de relevancia más rica.

El rendimiento del sistema de recuperación subyacente (BM25) se midió principalmente con las métricas nDCG\@10 y MAP. A partir de estas métricas se computaron coeficientes de correlación de Pearson, Spearman y Tau de Kendall entre las puntuaciones de los métodos QPP y los valores de nDCG\@10 y MAP, lo que permite estudiar tanto relaciones lineales como monótonas entre predictores y rendimiento real.
\
#figure(
    diagram(
        spacing: 1pt,
        cell-size: (23mm, 10mm),
        edge-stroke: 1pt,
        edge-corner-radius: 5pt,
        mark-scale: 80%,
    label-size: 12pt,

    // Input Data (named nodes)
    blob((-2,4), [Qrels], shape: chevron, tint: yellow, name: "qrels"),
    blob((-2,2), [Resultados de la\ recuperación], shape: chevron, tint: yellow, name: "run"),
    blob((-2,0), [Puntuaciones QPP], shape: chevron, tint: yellow, name: "qpp"),

    // Processing Steps
    blob((0,3), [Evaluación de recuperación], shape: hexagon, tint: orange, name: "eval"),
    blob((0,1), [Análisis de correlación], shape: hexagon, tint: orange, name: "analysis"),
    
    // Metrics & Outputs
    blob((2.3,4), [Métricas nDCG/MAP], tint: green, name: "metrics"),
    blob((2.3,2), [Resultados de \
    correlación], tint: green, name: "scores"),
    blob((2.3,0), [Reporte \ estadístico], tint: green, name: "report"),

    // Connections using proper edge syntax
    edge(<qrels>, <eval>, "-|>"),
    edge(<run>, <eval>, "-|>"),
    edge(<eval>, <metrics>, "<|-", label: []),
    
    edge(<qpp>, <analysis>, "-|>"),
    edge(<eval>, <analysis>, "-|>", label: [Resultados]),
    edge(<analysis>, <scores>, "-|>"),
    edge(<analysis>, <report>, "-|>"),
    
  ),
  caption: [Diagrama de flujo del análisis de resultados]
) <Diagrama_evaluación_resultados>

\
La configuración general utilizada para el experimento se presenta en la @fig:Diagrama_evaluación_resultados donde se puede observar que el proceso de evaluación involucra métricas de evaluación de recuperación clásicas como nDCG o MAP, y más adelante, métricas de correlación de predictores como el tau de Kendall, el cual debido a su naturaleza no lineal, se presenta como una métrica más fuerte frente a otras métricas como el coeficiente de Pearson.

\
== Caracterización de los conjuntos de datos
\
Previo a la evaluación de los métodos QPP, resulta imprescindible caracterizar los conjuntos de datos utilizados y el rendimiento del sistema de recuperación subyacente. Esta caracterización permite contextualizar los resultados de correlación posteriores y verificar que las diferencias observadas entre predictores se deben a su capacidad predictiva y no a artefactos del corpus o del ranker.

El análisis se estructura en dos ejes complementarios: primero, la #emph[distribución de los juicios de relevancia] (_Qrels_), que describe la composición y balance de cada colección; segundo, la #emph[dificultad de las consultas] según el rendimiento observado del sistema BM25, clasificada mediante umbrales percentilares.

#v(10pt)
=== Distribución de niveles de relevancia
\
Los juicios de relevancia constituyen el estándar de referencia para evaluar tanto el sistema de recuperación como los predictores QPP. Cada dataset emplea una escala de relevancia propia, que varía desde esquemas binarios simples hasta escalas graduadas con múltiples niveles. La @tbl:qrels_distribucion resume la distribución de juicios por nivel para los cinco conjuntos de datos evaluados.

\
#{
  show table.cell.where(y: 0): set text(style: "normal", weight: "bold")
  set table(stroke: (x: none))
  set align(center)
  [#figure(
    table(
      columns: 5,
      inset: (x: 8pt, y: 6pt),
      row-gutter: (2pt, auto),
      align: center + horizon,
      table.header[*Dataset*][*Niveles*][*Total Qrels*][*% No Relevantes*][*Observación*],
      [Antique/Test], [4], [6,589], [61.6%], [Dominan Out of context y Not relevant],
      [Cranfield], [5], [1,837], [19.2%], [80.8% documentos útiles o relevantes],
      [CAR], [6], [29,571], [74.5%], [Incluye nivel "Trash" (-2)],
      [MS MARCO], [4], [11,386], [68.3%], [Dominado por Irrelevant],
      [TREC-COVID], [4], [66,336], [62.8%], [Mayor volumen de juicios],
    ),
    caption: [Distribución de juicios de relevancia por dataset]
  ) <qrels_distribucion>]
}
\

Se observa una considerable heterogeneidad entre colecciones. #emph[Cranfield] destaca por su alta proporción de documentos relevantes (80.8%), lo que sugiere un corpus cuidadosamente curado donde el sistema BM25 tiene mayor probabilidad de éxito. En contraste, #emph[CAR] presenta la escala más compleja (6 niveles, incluyendo "Trash" con valor -2) y el mayor porcentaje de documentos no relevantes (74.5%), características que anticipan dificultades para los predictores.

#figure(
  grid(
    columns: 2,
    gutter: 10pt,
    image("../assets/imagenes/nuevos_resultados/qrels_metricas_otros/cranfield/qrels_distribucion_niveles_relevancia.png"),
    image("../assets/imagenes/nuevos_resultados/qrels_metricas_otros/car_v15_trec_y1_manual/qrels_distribucion_niveles_relevancia.png"),
  ),
  caption: [Contraste en distribución de relevancia: Cranfield (izq.) vs CAR (der.)]
) <fig:qrels_contraste>

\
La @fig:qrels_contraste ilustra visualmente este contraste. En #emph[Cranfield], los niveles "High relevance" y "Complete answer" dominan la distribución, reflejando un corpus donde la mayoría de los documentos juzgados aportan información útil. En #emph[CAR], por el contrario, prevalecen los juicios negativos, incluyendo una categoría "Trash" que indica párrafos completamente irrelevantes. Esta diferencia estructural tiene implicaciones directas para la predicción: en Cranfield, las consultas tienen mayor probabilidad de obtener resultados satisfactorios, mientras que en CAR el sistema enfrenta un escenario inherentemente adverso.

El caso de #emph[TREC-COVID] merece atención especial: con 66,336 juicios, constituye la colección más densamente anotada, lo que proporciona una base estadística robusta para el análisis de correlaciones. Por otra parte, #emph[Antique/Test] y #emph[MS MARCO] presentan distribuciones intermedias con predominio de juicios no relevantes.

#v(10pt)
=== Dificultad de consultas basada en rendimiento
\
La dificultad de una consulta se define operacionalmente a partir del rendimiento observado del sistema de recuperación. Siguiendo la metodología descrita en el marco teórico, se empleó una clasificación basada en percentiles: las consultas cuyo valor de nDCG\@10 cae en el percentil 20 o inferior se etiquetan como #emph[difíciles], aquellas en el percentil 80 o superior como #emph[fáciles], y el resto como #emph[intermedias].

\
#{
  show table.cell.where(y: 0): set text(style: "normal", weight: "bold")
  set table(stroke: (x: none))
  set align(center)
  [#figure(
    table(
      columns: 5,
      inset: (x: 8pt, y: 6pt),
      row-gutter: (2pt, auto),
      align: center + horizon,
      table.header[*Dataset*][*Consultas*][*Difíciles*][*Intermedias*][*Fáciles*],
      [Antique/Test], [180], [36 (20%)], [108 (60%)], [36 (20%)],
      [Cranfield], [221], [45 (20%)], [131 (59%)], [45 (20%)],
      [CAR], [699], [198 (28%)], [361 (52%)], [140 (20%)],
      [MS MARCO], [51], [11 (22%)], [29 (57%)], [11 (22%)],
      [TREC-COVID], [50], [10 (20%)], [30 (60%)], [10 (20%)],
    ),
    caption: [Distribución de dificultad de consultas según nDCG\@10]
  ) <dificultad_consultas>]
}
\

La @tbl:dificultad_consultas revela un patrón distintivo en #emph[CAR]: el 28.3% de sus consultas se clasifican como difíciles, la proporción más alta entre todos los datasets. Este hallazgo es consistente con la naturaleza de la tarea #emph[Complex Answer Retrieval], donde las consultas derivan de encabezados jerárquicos de Wikipedia y requieren recuperar párrafos que no necesariamente comparten vocabulario con la consulta. Dado que BM25 opera mediante coincidencias léxicas (#emph[bag-of-words]), muchas consultas de CAR resultan intrínsecamente problemáticas para este ranker, lo que limita el techo de correlación alcanzable por cualquier método de predicción.

En contraste, #emph[Antique/Test] y #emph[TREC-COVID] exhiben distribuciones perfectamente balanceadas (20%-60%-20%), reflejando una variedad equilibrada de consultas que permite evaluar el comportamiento de los predictores a lo largo de todo el espectro de dificultad.

#figure(
  grid(
    columns: 2,
    gutter: 10pt,
    image("../assets/imagenes/nuevos_resultados/qrels_metricas_otros/antique_test/dificultad_consultas_ndcg@10.png"),
    image("../assets/imagenes/nuevos_resultados/qrels_metricas_otros/car_v15_trec_y1_manual/dificultad_consultas_ndcg@10.png"),
  ),
  caption: [Distribución de dificultad de consultas: Antique/Test (izq.) vs CAR (der.)]
) <fig:dificultad_comparacion>

\
La @fig:dificultad_comparacion ilustra visualmente el contraste entre #emph[Antique/Test], con una distribución balanceada, y #emph[CAR], donde se observa un sesgo hacia consultas difíciles. Esta diferencia estructural anticipa el comportamiento divergente de los predictores QPP en ambos datasets, como se analizará en las secciones siguientes.

#figure(
  image("../assets/imagenes/nuevos_resultados/qrels_metricas_otros/cranfield/dificultad_consultas_ndcg@10.png", width: 60%),
  caption: [Distribución de dificultad de consultas en Cranfield]
) <fig:dificultad_cranfield>

\
Por su parte, #emph[Cranfield] (@fig:dificultad_cranfield) exhibe una distribución prácticamente idéntica a Antique/Test: 45 consultas difíciles (20%), 131 intermedias (59%) y 45 fáciles (20%). Esta simetría, junto con su alta proporción de documentos relevantes (80.8%), confirma su clasificación como dataset favorable para la tarea de predicción. A pesar de su reducido tamaño de corpus (~1,400 documentos), la variedad equilibrada de consultas proporciona un escenario adecuado para evaluar la capacidad predictiva de los métodos QPP.

\
== Comparación de métodos QPP
\
Los métodos QPP evaluados en esta sección fueron contrastados directamente con los resultados de la evaluación del sistema de recuperación utilizando correlaciones de Pearson, Spearman y tau de Kendall entre las puntuaciones de los predictores y las métricas nDCG\@10 y MAP. La evaluación se realizó sobre cinco conjuntos de datos distintos: _Antique/Test_ (180 consultas), _Cranfield_ (221 consultas), _BEIR-TREC-COVID_ (50 consultas), _MS MARCO (Passage)_ (51 consultas) y _CAR_ (699 consultas). Esta diversidad de colecciones permite evaluar la robustez y generalización de los métodos QPP en diferentes contextos y tamaños de corpus, desde colecciones pequeñas y especializadas hasta grandes colecciones web.

=== Visión general de las correlaciones
\
A continuación se presentan los diagramas de dispersión para cada dataset, los cuales permiten visualizar la relación entre las puntuaciones de cada método QPP y el rendimiento real (nDCG\@10) a nivel de consulta individual. Estas visualizaciones revelan patrones que los coeficientes de correlación agregados no capturan, tales como #emph[heterocedasticidad] (varianza no constante), presencia de #emph[outliers] y regiones de predicción más o menos confiables.

#v(10pt)
=== Visualización de correlaciones por dataset
\
Para complementar el análisis tabular, los diagramas de dispersión permiten visualizar la relación entre las puntuaciones de cada método QPP y el rendimiento real (nDCG\@10) a nivel de consulta individual. Estas visualizaciones revelan patrones que los coeficientes de correlación agregados no capturan, tales como #emph[heterocedasticidad] (varianza no constante), presencia de #emph[outliers] y regiones de predicción más o menos confiables.

A continuación se presentan los diagramas de dispersión para cada dataset, organizados en grids que incluyen los 10 métodos QPP evaluados. Cada subplot muestra la puntuación del predictor en el eje horizontal y nDCG\@10 en el eje vertical, junto con la línea de tendencia y su banda de confianza.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/antique_test/dispersion_qpp_ndcg@10.png", width: 100%),
  caption: [Diagramas de dispersión QPP vs nDCG\@10 en Antique/Test]
) <fig:dispersion_antique>
\

La @fig:dispersion_antique evidencia el comportamiento diferenciado de los métodos en #emph[Antique/Test]. Los métodos NQC y UEF-NQC presentan las pendientes más pronunciadas y bandas de confianza más estrechas, indicando predicciones más estables. En contraste, los métodos IDF (promedio y máximo) muestran líneas de tendencia casi horizontales con dispersión extrema, confirmando su incapacidad predictiva. El método Clarity exhibe varios #emph[outliers] en valores altos (>150), lo que sugiere sensibilidad a consultas con términos muy específicos.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/car_v15_trec_y1_manual/dispersion_qpp_ndcg@10.png", width: 100%),
  caption: [Diagramas de dispersión QPP vs nDCG\@10 en CAR]
) <fig:dispersion_car>
\

El caso de #emph[CAR] (@fig:dispersion_car) representa el escenario más problemático. Con 699 consultas, la alta densidad de puntos revela un patrón distintivo: #emph[todas] las líneas de tendencia son prácticamente horizontales (τ máximo = 0.1259), y existe una concentración masiva de puntos en el rango nDCG\@10 ≈ 0 - 0.3. Este comportamiento refleja la incompatibilidad fundamental entre BM25 (basado en coincidencias léxicas) y la tarea de #emph[Complex Answer Retrieval], que requiere comprensión semántica. La heterocedasticidad severa observable en todos los métodos indica que ningún predictor logra capturar consistentemente la dificultad de estas consultas.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/trec_covid/dispersion_qpp_ndcg@10.png", width: 100%),
  caption: [Diagramas de dispersión QPP vs nDCG\@10 en TREC-COVID]
) <fig:dispersion_covid>
\

En #emph[TREC-COVID] (@fig:dispersion_covid) emerge un patrón único que invierte las tendencias observadas en otros datasets. Visualmente, Clarity y UEF-Clarity presentan las pendientes más pronunciadas y las bandas de confianza más estrechas, mientras que NQC y WIG —habitualmente dominantes— muestran líneas casi horizontales. Esta inversión se explica por la naturaleza del corpus: artículos científicos con vocabulario técnico homogéneo favorecen los modelos de lenguaje (base de Clarity), mientras que la buena separación de puntuaciones BM25 reduce la variabilidad que explotan NQC y WIG.

\
#figure(
  grid(
    columns: 2,
    gutter: 10pt,
    image("../assets/imagenes/nuevos_resultados/correlación/cranfield/dispersion_qpp_ndcg@10.png"),
    image("../assets/imagenes/nuevos_resultados/correlación/msmarco_dl20_judged/dispersion_qpp_ndcg@10.png"),
  ),
  caption: [Diagramas de dispersión: Cranfield (izq.) y MS MARCO (der.)]
) <fig:dispersion_cranfield_msmarco>
\

La @fig:dispersion_cranfield_msmarco compara dos datasets con tamaños muestrales muy diferentes. En #emph[Cranfield] (izquierda, 221 consultas), la mayor densidad de puntos permite identificar patrones más claros: WIG, NQC y sus variantes UEF muestran pendientes ascendentes bien definidas, mientras que Clarity exhibe una tendencia descendente distintiva —los puntos se distribuyen inversamente, con predicciones altas correspondiendo a rendimientos bajos. Los métodos pre-retrieval (IDF, SCQ) presentan nubes de puntos dispersas sin estructura clara.

En #emph[MS MARCO] (derecha, 51 consultas), la escasez de puntos produce bandas de confianza notablemente más amplias, aumentando la incertidumbre de las estimaciones. Sin embargo, se observa un patrón interesante: WIG y NQC muestran pendientes pronunciadas y paralelas, mientras que —a diferencia de otros datasets— IDF presenta una tendencia positiva moderada. Clarity, por su parte, muestra una línea prácticamente horizontal, indicando ausencia de capacidad predictiva en este corpus.



#v(10pt)
=== Análisis por familia de métodos
\
Los métodos evaluados pueden agruparse en tres familias según su acceso a información del sistema de recuperación:

*Métodos pre-retrieval (IDF, SCQ)*: Estos predictores operan únicamente con estadísticas del índice, sin conocer los documentos recuperados. Los diagramas de dispersión muestran consistentemente líneas de tendencia casi horizontales para IDF, con varianza extrema que invalida cualquier capacidad predictiva. SCQ presenta un comportamiento marginalmente mejor, alcanzando correlaciones moderadas en Antique/Test y Cranfield, pero su rendimiento se degrada en corpus grandes o especializados como TREC-COVID. La ventaja de estos métodos radica exclusivamente en su eficiencia computacional.

*Métodos post-retrieval clásicos (WIG, NQC, Clarity)*: Al acceder a la lista de documentos recuperados y sus puntuaciones, estos métodos capturan señales más informativas. NQC y WIG muestran comportamientos complementarios: mientras NQC se basa en la varianza de puntuaciones del top-k, WIG considera la desviación respecto al promedio del corpus. Clarity, basado en divergencia KL respecto al modelo de lenguaje de la colección, exhibe alta sensibilidad al dominio: domina en TREC-COVID pero presenta correlaciones negativas en Cranfield.

*Variantes UEF*: El marco Utility Estimation Framework extiende los métodos base incorporando información de pseudo-relevance feedback. Los diagramas revelan que UEF mejora consistentemente a NQC en la mayoría de datasets, con la excepción de MS MARCO donde ambos empatan. Para Clarity, UEF amplifica tanto sus fortalezas (TREC-COVID) como sus debilidades (Cranfield con correlación cercana a cero).

#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/cranfield/correlaciones_qpp_boxplot_kendall.png", width: 120%),
  caption: [Distribución de correlaciones Kendall por método QPP en Cranfield]
) <fig:boxplot_cranfield>

\
La @fig:boxplot_cranfield ilustra de manera contundente el comportamiento anómalo de Clarity en Cranfield: es el único método con correlación negativa (τ ≈ -0.07), lo que indica que sus predicciones son inversamente proporcionales al rendimiento real. UEF-Clarity, aunque logra elevarse a valores cercanos a cero, sigue siendo el segundo peor método. Este patrón contrasta marcadamente con los métodos basados en varianza de puntuaciones (NQC, UEF-NQC, WIG, UEF-WIG), que ocupan consistentemente las posiciones superiores del ranking. La explicación más plausible es la inestabilidad del modelo de lenguaje en un corpus tan reducido (~1,400 documentos).

#v(10pt)
=== Significancia estadística de las correlaciones
\
La validez de los patrones observados requiere verificar que las correlaciones sean estadísticamente significativas. Un coeficiente de correlación alto carece de utilidad práctica si no supera los umbrales de significancia, especialmente en datasets con pocas consultas donde el azar puede producir correlaciones espurias.

Los mapas de calor de p-values utilizan una escala de cuatro niveles: altamente significativo (p < 0.001), muy significativo (p < 0.01), significativo (p < 0.05) y no significativo (p ≥ 0.05). Esta gradación permite distinguir entre correlaciones robustas y aquellas que podrían deberse a fluctuaciones aleatorias.

#figure(
  grid(
    columns: 2,
    gutter: 10pt,
    image("../assets/imagenes/nuevos_resultados/correlación/antique_test/pvalues_qpp_kendall.png"),
    image("../assets/imagenes/nuevos_resultados/correlación/trec_covid/pvalues_qpp_kendall.png"),
  ),
  caption: [Significancia estadística (p-values): Antique/Test (izq.) vs TREC-COVID (der.)]
) <fig:pvalues_representativo>

\
El contraste entre ambos datasets contrasta fuertemente. En #emph[Antique/Test] (180 consultas), todos los métodos excepto IDF alcanzan significancia alta (p < 0.001), lo que valida la robustez de las correlaciones observadas. En #emph[TREC-COVID] (50 consultas), sin embargo, solo Clarity y UEF-Clarity presentan significancia consistente; métodos como NQC, que tradicionalmente dominan otros datasets, no superan el umbral de p < 0.05.

Este fenómeno se explica por la relación matemática entre tamaño muestral y significancia estadística. La prueba de significancia para correlaciones evalúa si el coeficiente observado podría haberse obtenido por azar; con muestras pequeñas, la varianza del estimador es alta y solo correlaciones sustanciales superan el umbral. Concretamente, para τ de Kendall con n ≈ 50 consultas, solo correlaciones relativamente altas (τ ≳ 0.18–0.20) tienden a alcanzar p < 0.05, mientras que con n ≈ 180 consultas correlaciones mucho menores (τ ≈ 0.10) pueden resultar significativas. Esto explica por qué métodos como NQC, con correlaciones moderadas en TREC-COVID (τ ≈ 0.09), no alcanzan significancia a pesar de mostrar tendencias positivas.


#v(5pt)
*Patrones transversales de significancia*

El análisis de los cinco datasets revela consistencias importantes:

- #emph[IDF nunca alcanza significancia estadística] en ningún dataset, confirmando su inutilidad práctica como predictor QPP con el sistema BM25 evaluado.

- #emph[NQC y UEF-NQC] son altamente significativos (p < 0.001) en cuatro de cinco datasets, con la única excepción de TREC-COVID.

- #emph[Clarity exhibe significancia polarizada]: altamente significativo en TREC-COVID y Antique, pero no significativo en Cranfield ni MS MARCO.

- #emph[SCQ presenta significancia intermedia]: alcanza p < 0.001 en Antique y CAR, pero no supera p < 0.05 en MS MARCO ni TREC-COVID.

- #emph[Los datasets pequeños] (MS MARCO con 51 consultas, TREC-COVID con 50) muestran mayor proporción de métodos no significativos, subrayando la importancia del tamaño muestral para conclusiones robustas.

Estos patrones de significancia complementan el análisis de correlaciones y deben considerarse conjuntamente al evaluar la utilidad práctica de cada método. Un predictor con correlación moderada pero altamente significativa puede ser preferible a uno con correlación alta pero estadísticamente dudosa.

Los resultados cuantitativos detallados, incluyendo las correlaciones exactas para cada combinación de método, métrica y dataset, se presentan en la siguiente sección.


\

== Análisis comparativo entre datasets
\
La evaluación de los métodos QPP en múltiples conjuntos de datos revela patrones importantes sobre la robustez y generalización de los predictores. Como se menciona en @correlation-depends-on-quality-of-dataset, el rendimiento de un predictor puede variar significativamente dependiendo de las características del corpus, incluyendo su homogeneidad, tamaño, tipo de documentos y calidad de los juicios de relevancia.

La @tbl:Resumen_correlaciones_datasets presenta un resumen de las correlaciones de Kendall obtenidas por el mejor método en cada dataset para la métrica nDCG\@10. Se puede observar una variabilidad considerable en los valores de correlación, que van desde 0.1259 en _car_v15_trec_y1_manual_ hasta 0.4245 en _antique test_. Esta amplitud de valores pone de manifiesto que la dificultad intrínseca de la tarea de predicción cambia de forma sustancial entre colecciones y que no existe un único método universalmente óptimo.

#{
  show table.cell.where(y: 0): set text(style: "normal", weight: "bold")
  set align(center)
  [#figure(
    table(
    columns: 4,
    stroke: (x: none),
    inset: (x: 3pt, y: 7pt),
    row-gutter: (2.2pt, auto),

    table.header[*Dataset*][*Consultas*][*Mejor método*][*τ (nDCG\@10)*],

    [*antique test*],[180],[UEF-NQC],[0.4245],
    [*cranfield*],[91],[UEF-NQC],[0.3261],
    [*trec_covid*],[50],[UEF-Clarity],[0.3279],
    [*msmarco_dl20_judged*],[51],[NQC],[0.4080],
    [*car_v15_trec_y1_manual*],[699],[UEF-NQC],[0.1259],
  )
  , caption: [Resumen de correlaciones de Kendall (τ) para nDCG\@10 en cada dataset]
  ) <Resumen_correlaciones_datasets>]
}

\

Un hallazgo particularmente notable es el comportamiento del método Clarity, que muestra un rendimiento especialmente alto en el dataset _BEIR-TREC-COVID_ (τ = 0.3279 para nDCG\@10 y τ ≈ 0.44 para MAP), superando incluso a métodos post-retrieval tradicionales como NQC y WIG. Este resultado contrasta con su desempeño en otros datasets, donde Clarity presenta correlaciones más moderadas o incluso no significativas, como en _Cranfield_ donde alcanza valores cercanos a cero. La explicación más plausible es que _BEIR-TREC-COVID_ está compuesto por artículos científicos relativamente homogéneos en temática y estilo, lo que facilita la estimación de modelos de lenguaje robustos; en cambio, _Cranfield_ es una colección pequeña donde la escasez de datos provoca modelos de lenguaje inestables y, por tanto, puntuaciones de Clarity poco informativas. En _MS MARCO (Passage)_, que contiene pasajes tipo Wikipedia, Clarity obtiene correlaciones intermedias: el mayor tamaño del corpus ayuda a estabilizar el modelo de lenguaje, pero la diversidad temática de las consultas suaviza parte de la ganancia observada en _BEIR-TREC-COVID_.

Por otro lado, el dataset _CAR_ presenta las correlaciones más bajas en general, con el mejor método (UEF-NQC) alcanzando solo τ = 0.1259 para nDCG\@10. Este resultado es consistente con observaciones previas sobre la sensibilidad de los predictores a la calidad y características de los datasets @correlation-depends-on-quality-of-dataset. A pesar de ser el dataset con mayor número de consultas (699), la estructura jerárquica de los temas en CAR y la posible variabilidad en los juicios de relevancia (escala de −2 a 3) parecen introducir ruido adicional: pequeñas diferencias en la posición de párrafos relevantes se traducen en cambios bruscos de ganancia, lo que dificulta que los predictores capturen señales consistentes. Además, CAR es una tarea explícitamente semántica de *Complex Answer Retrieval*, donde con frecuencia se espera que el sistema recupere párrafos que no comparten necesariamente muchas palabras con la consulta. Dado que el modelo subyacente es BM25, basado en coincidencias léxicas *bag-of-words*, se generan muchas consultas con valores de nDCG\@10 muy bajos o incluso nulos, lo que limita fuertemente el techo de correlación alcanzable para cualquier método de predicción de rendimiento.

En contraste, los datasets _Antique/Test_ y _MS MARCO (Passage)_ muestran correlaciones más altas, con valores superiores a 0.40 para los mejores métodos. En _Antique/Test_, UEF-NQC alcanza τ = 0.4245, mientras que en _MS MARCO (Passage)_, NQC (sin UEF) presenta τ = 0.4080. Estos resultados sugieren que, aunque diferentes en tamaño y dominio, ambos corpus comparten características favorables para los métodos post-retrieval: por un lado, un número suficiente de consultas para estimar de forma estable estadísticas de varianza de puntuaciones; por otro, juicios de relevancia multinivel que recompensan de manera más gradual las mejoras en el ranking, permitiendo que las diferencias de calidad entre predictores se reflejen con mayor claridad en nDCG\@10 y MAP.

Un patrón consistente observado a través de todos los datasets es la superioridad general de los métodos post-retrieval sobre los pre-retrieval. En la mayoría de los casos, métodos como NQC, UEF-NQC, WIG y UEF-WIG superan a IDF y SCQ, aunque con variaciones en la magnitud de la diferencia. La única excepción notable es _BEIR-TREC-COVID_, donde Clarity (un método post-retrieval basado en modelado de lenguaje) domina, pero esto puede atribuirse a las características específicas del corpus.

Respecto al marco UEF, los resultados muestran un patrón mixto. En _Antique/Test_ y _Cranfield_, UEF-NQC supera consistentemente a NQC, lo que sugiere que la incorporación de información de expansión de consultas mejora la capacidad predictiva. Sin embargo, en _MS MARCO (Passage)_, NQC sin UEF presenta un rendimiento similar o ligeramente superior (τ = 0.4080 para ambos en nDCG\@10, pero τ = 0.5357 vs τ = 0.5075 para AP a favor de NQC). Esta variabilidad sugiere que la efectividad de UEF puede depender de las características específicas del dataset y del método base al que se aplica.

La variabilidad observada en los resultados entre datasets refuerza la importancia de evaluar los métodos QPP en múltiples colecciones, como se recomienda en la literatura @correlation-depends-on-quality-of-dataset. Un predictor que funciona bien en un contexto puede no generalizar a otros, lo que subraya la necesidad de desarrollar métodos más robustos o de adaptar las estrategias de predicción según las características del corpus.

\
== Discusión de los resultados
\

Los resultados obtenidos en este estudio revelan patrones significativos en el rendimiento de los diferentes métodos de predicción de consultas (QPP), proporcionando insights valiosos sobre su efectividad y limitaciones en el contexto de la recuperación de información.

=== Importancia de las correlaciones observadas
\
La evaluación de los métodos QPP en múltiples datasets mostró un rango de correlaciones que van desde valores cercanos a 0 (IDF en varios datasets) hasta aproximadamente 0.42 (UEF-NQC en _Antique/Test_). Aunque estas correlaciones podrían parecer modestas a primera vista, es importante contextualizarlas dentro del campo de la predicción del rendimiento de consultas. Como se señala en @how-much-correlation-is-good, correlaciones incluso tan bajas como 0.1 pueden tener valor práctico en ciertos contextos, siendo particularmente útiles cuando superan el umbral de 0.5. En este sentido, los resultados obtenidos por métodos como UEF-NQC (τ = 0.4245 en _Antique/Test_) y NQC (τ = 0.4080 en _MS MARCO (Passage)_) se acercan a niveles de correlación que pueden considerarse prácticamente significativos.

Sin embargo, la variabilidad observada entre datasets subraya la importancia de considerar el contexto específico al interpretar estas correlaciones. Mientras que en algunos datasets como _antique test_ y _msmarco_dl20_judged_ se alcanzan correlaciones moderadas-altas, en otros como _car_v15_trec_y1_manual_ las correlaciones son considerablemente más bajas, lo que refleja la sensibilidad de los predictores a las características del corpus y la calidad de los juicios de relevancia.


\
=== Rendimiento de métodos pre-retrieval
\
Un hallazgo particularmente interesante emerge al analizar el comportamiento de los métodos pre-retrieval a través de todos los datasets. Como señala @microsoft-preretrieval, estos métodos son especialmente atractivos debido a su eficiencia computacional, ya que no requieren ejecutar el proceso de recuperación. Sin embargo, nuestros resultados muestran una marcada diferencia entre los dos métodos pre-retrieval evaluados: mientras que IDF mostró correlaciones prácticamente nulas o muy bajas en todos los datasets (en torno a τ ≈ 0.00–0.05 tanto en nDCG\@10 como en MAP), SCQ alcanzó correlaciones moderadas en algunos casos y cercanas a cero en otros.

En concreto, SCQ logra correlaciones de Kendall en el rango τ ≈ 0.19–0.26 en *Antique/Test* y *Cranfield*, pero su rendimiento cae en *BEIR-TREC-COVID* y *MS MARCO (Passage)*, donde las correlaciones con nDCG\@10 y MAP se aproximan a cero. Esto sugiere que las señales puramente basadas en frecuencia de términos capturan razonablemente bien la dificultad de las consultas en colecciones pequeñas o relativamente homogéneas, pero pierden capacidad predictiva en colecciones grandes, ruidosas o con dominios especializados.

Esta disparidad confirma que, si bien los métodos pre-retrieval pueden ser prometedores por su eficiencia, su efectividad depende crucialmente de la sofisticación de sus métricas y del tipo de corpus. El mejor rendimiento de SCQ frente a IDF puede atribuirse a su capacidad para incorporar tanto la frecuencia de documentos como la frecuencia en la colección, proporcionando una vista más completa de la importancia de los términos. No obstante, el hecho de que incluso SCQ no alcance las correlaciones obtenidas por los métodos post-retrieval indica que la información disponible antes de la recuperación es insuficiente para capturar muchos de los factores que determinan el rendimiento real de las consultas.

Sin embargo, es importante notar que el rendimiento de SCQ también muestra variabilidad entre datasets. En _BEIR-TREC-COVID_ y _MS MARCO (Passage)_, SCQ presenta correlaciones más bajas o incluso no significativas, lo que sugiere que su efectividad puede depender de las características específicas del corpus. Por último cabe mencionar que el método SCQ presenta mejores resultados en su variante máxima y promedio frente a los benchmarks disponibles en la literatura en el conjunto de datos _Antique/Test_. @zendel2024qpptk Poniendo en evidencia la importancia del preprocesado de consultas y documentos en la predicción del rendimiento de las consultas.

\
=== Rendimiento de métodos post-retrieval
\
Los resultados demuestran consistentemente que los métodos post-retrieval, particularmente en sus variantes UEF, superan a los métodos pre-retrieval en la mayoría de los datasets evaluados. El método UEF-NQC emerge como el mejor predictor en tres de los cinco datasets (*Antique/Test*, *Cranfield* y *CAR*), alcanzando correlaciones de τ = 0.4245, τ = 0.3261 y τ = 0.1259 respectivamente. En *MS MARCO (Passage)*, el mejor rendimiento lo presenta NQC sin UEF (τ = 0.4080), mientras que en *BEIR-TREC-COVID* el liderazgo corresponde a UEF-Clarity (τ = 0.3279). Esta superioridad general de los métodos post-retrieval sugiere que la información adicional disponible después de la recuperación —como las distribuciones de puntuaciones sobre los documentos recuperados— proporciona señales más confiables para la predicción del rendimiento.

Un aspecto particularmente revelador es el comportamiento de Clarity. En *Cranfield*, donde el corpus es pequeño y los documentos son relativamente cortos, Clarity muestra correlaciones muy bajas, cercanas a cero, tanto en nDCG\@10 como en MAP. Esto indica que el modelo de lenguaje estimado con tan pocos documentos no es suficientemente robusto y que pequeñas variaciones en la estimación de probabilidad de términos pueden distorsionar la medida de ambigüedad de la consulta. Sin embargo, en *MS MARCO (Passage)* y, sobre todo, en *BEIR-TREC-COVID*, Clarity y su variante UEF-Clarity alcanzan correlaciones sensiblemente mayores. En estos casos, el corpus está compuesto por pasajes derivados de fuentes tipo Wikipedia o por artículos científicos sobre COVID‑19, donde la coherencia temática y la longitud de los documentos favorecen la estimación de modelos de lenguaje más estables.

La combinación NQC/UEF-NQC también ilustra bien el efecto de la estructura del corpus. En colecciones relativamente pequeñas como *Cranfield* o con consultas de opinión como *Antique/Test*, UEF-NQC consigue mejorar de forma consistente a NQC al incorporar información de expansión de consultas. En cambio, en *MS MARCO (Passage)* la diferencia entre ambos se reduce: la gran cantidad de documentos y los juicios multinivel hacen que la varianza de las ganancias por consulta sea mayor, y la expansión no siempre introduce señales adicionales útiles. Finalmente, en *CAR*, donde las consultas se derivan de encabezados complejos de Wikipedia, tanto NQC como UEF-NQC obtienen correlaciones más modestas, lo que sugiere que la estructura jerárquica de los temas y la posible inconsistencia de los juicios manuales dificultan la tarea de predicción.

En conjunto, estos resultados están en línea o ligeramente por encima de los reportados por Zendel et al. @zendel2024qpptk para _Antique/Test_, y refuerzan la conclusión de que los métodos post-retrieval —especialmente aquellos que combinan información de dispersión de puntuaciones con expansión de consultas— constituyen la opción más sólida cuando el coste computacional adicional es aceptable.

\
=== Complejidad Inherente de la Tarea
\
La dificultad fundamental de predecir el rendimiento de las consultas se evidencia en estudios previos con expertos humanos @humans-cant-predict @user-ratings-vs-system-predictions, donde incluso profesionales con conocimiento profundo de la terminología y sus ambigüedades mostraron una capacidad limitada para predecir el rendimiento de las consultas. Este contexto hace que los resultados obtenidos por los métodos automáticos, particularmente UEF-NQC, sean más apreciables, ya que logran correlaciones moderadas en una tarea inherentemente compleja.

\
=== Implicaciones sobre una línea base experimental
\
Los resultados sugieren varias implicaciones importantes. Primero, la elección entre métodos pre y post-retrieval debe considerar el balance entre eficiencia y efectividad. Mientras que SCQ ofrece un compromiso razonable, logrando correlaciones moderadas sin el costo computacional de la recuperación, los métodos post-retrieval como UEF-NQC proporcionan predicciones significativamente más confiables cuando el tiempo de procesamiento no es una limitación crítica.

Segundo, la variabilidad en el rendimiento observada en el análisis de dispersión sugiere que podría ser beneficioso desarrollar métodos híbridos que combinen las fortalezas de diferentes predictores, potencialmente adaptando la estrategia de predicción según las características específicas de la consulta.

En tercer lugar, aun con los resultados prometedores obtenidos en ciertos casos como NQC y UEF-NQC en algunos datasets, cabe recalcar que las correlaciones siguen siendo bajas para la mayoría de los métodos, especialmente cuando se consideran todos los datasets evaluados. La variabilidad observada entre datasets, con correlaciones que van desde 0.13 hasta 0.42, sugiere que la tarea de predecir el rendimiento de las consultas sigue siendo una tarea compleja y que el desarrollo de métodos más sofisticados que puedan capturar mejor los matices que afectan el rendimiento de la recuperación de información sigue siendo una tarea pendiente.

Finalmente, la evaluación multi-dataset realizada en este estudio subraya la importancia de no generalizar conclusiones basadas en un único corpus. La variabilidad en el rendimiento de los predictores entre datasets refuerza la necesidad de desarrollar métodos más robustos que puedan adaptarse a diferentes características de corpus, o de establecer estrategias de selección de predictores basadas en las propiedades del dataset en cuestión.

