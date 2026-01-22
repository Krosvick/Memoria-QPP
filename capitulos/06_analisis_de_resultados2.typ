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

A través de la literatura se ha establecido de manera casi unánime el análisis del rendimiento de los métodos QPP mediante el uso de métricas de correlación. Entre los primeros trabajos se puede encontrar el de E.M Voorhees en la conferencia TREC-6, donde se presenta el primer análisis de la capacidad de expertos en predecir el rendimiento de las consultas, donde se pudo observar que la mayor correlación lineal entre los resultados de los expertos fue de solo 0,26 @trec-6.

El campo de la predicción del rendimiento de consultas se ha desarrollado a lo largo de los años, y se ha establecido el uso de juicios de relevancia y métricas como el Tau de Kendall o el Coeficiente de correlación de Spearman para la evaluación de los predictores. En este sentido, se encuentran dos puntos de interés, por un lado la evaluación del *sistema de recuperación subyacente*, y por otro la *evaluación de los predictores* utilizando como pre-requisito la evaluación del sistema de recuperación.

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
    //blob((2.3,4), [Métricas nDCG/MAP], tint: green, name: "metrics"),
    blob((2.3,4), [Métricas nDCG/MAP], shape: chevron, tint: yellow, name: "metrics"),
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
  caption: [Diagrama de flujo del análisis de resultados.]
) <Diagrama_evaluación_resultados>
\

La configuración general utilizada para el experimento se presenta en la @fig:Diagrama_evaluación_resultados donde se puede observar que el proceso de evaluación involucra las métricas de evaluación de recuperación clásicas como nDCG o MAP, y más adelante, métricas de correlación de predictores como el Tau de Kendall, el cual debido a su naturaleza no lineal, se presenta como una métrica más fuerte frente a otras como el coeficiente de Pearson.

#v(10pt)
== Caracterización de los conjuntos de datos
\

Previo a la evaluación de los métodos QPP, resulta imprescindible caracterizar los conjuntos de datos utilizados y el rendimiento del sistema de recuperación subyacente. Esta caracterización permite contextualizar los resultados de correlación posteriores y verificar que las diferencias observadas entre predictores se deben a su capacidad predictiva y no a artefactos del corpus o del _ranker_.

El análisis se estructura en dos ejes complementarios: primero, la distribución de los juicios de relevancia (_Qrels_), que describe la composición y balance de cada colección; segundo, la dificultad de las consultas según el rendimiento observado del sistema BM25, clasificada mediante umbrales percentilares.

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
      [Antique/Test], [4], [6.589], [61,6%], [Dominan Out of context y Not relevant],
      [Cranfield], [5], [1.837], [19,2%], [80,8% documentos útiles o relevantes],
      [CAR], [6], [29.571], [74,5%], [Incluye \ nivel "Trash" (-2)],
      [MS MARCO], [4], [11.386], [68,3%], [Dominado por \ Irrelevant],
      [TREC-COVID], [4], [66.336], [62,8%], [Mayor volumen de juicios],
    ),
    caption: [Distribución de juicios de relevancia por dataset.]
  ) <qrels_distribucion>]
}
\

Se observa una considerable heterogeneidad entre colecciones. #emph[Cranfield] destaca por su alta proporción de documentos relevantes (80,8%), lo que sugiere un corpus cuidadosamente curado donde el sistema BM25 tiene mayor probabilidad de éxito. En contraste, #emph[CAR] presenta la escala más compleja (6 niveles, incluyendo "Trash" con valor -2) y el mayor porcentaje de documentos no relevantes (74,5%), características que anticipan dificultades para los predictores.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/qrels_metricas_otros/cranfield/qrels_distribucion_niveles_relevancia.png", width: 80%),
  caption: [Distribución de niveles de relevancia en Cranfield.]
) <qrels_dist_cranfield>
\

\
#figure(
  image("../assets/imagenes/nuevos_resultados/qrels_metricas_otros/car_v15_trec_y1_manual/qrels_distribucion_niveles_relevancia.png", width: 80%),
  caption: [Distribución de niveles de relevancia en CAR.]
) <qrels_dist_car>
\

La @fig:qrels_dist_cranfield y la @fig:qrels_dist_car ilustran visualmente este contraste. En #emph[Cranfield], los niveles "High relevance" y "Complete answer" dominan la distribución, reflejando un corpus donde la mayoría de los documentos juzgados aportan información útil. En #emph[CAR], por el contrario, prevalecen los juicios negativos, incluyendo una categoría "Trash" que indica párrafos completamente irrelevantes. Esta diferencia estructural tiene implicaciones directas para la predicción: en Cranfield, las consultas tienen mayor probabilidad de obtener resultados satisfactorios, mientras que en CAR el sistema enfrenta un escenario inherentemente adverso.

El caso de #emph[TREC-COVID] merece atención especial: con 66.336 juicios, constituye la colección más densamente anotada, lo que proporciona una base estadística robusta para el análisis de correlaciones. Por otra parte, #emph[Antique/Test] y #emph[MS MARCO] presentan distribuciones intermedias con predominio de juicios no relevantes.

#v(10pt)
=== Dificultad de consultas basada en rendimiento
\
La dificultad de una consulta se define operacionalmente a partir del rendimiento observado del sistema de recuperación. Siguiendo la metodología descrita en el marco teórico, se empleó una clasificación basada en percentiles: las consultas cuyo valor de nDCG\@10 cae en el percentil 20 o inferior se etiquetan como difíciles, aquellas en el percentil 80 o superior como fáciles, y el resto como intermedias.

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
    caption: [Distribución de dificultad de consultas según nDCG\@10.]
  ) <dificultad_consultas>]
}
\

La @tbl:dificultad_consultas revela un patrón distintivo en #emph[CAR]: el 28.3% de sus consultas se clasifican como difíciles, la proporción más alta entre todos los datasets. Este hallazgo es consistente con la naturaleza de la tarea #emph[Complex Answer Retrieval], donde las consultas derivan de encabezados jerárquicos de Wikipedia y requieren recuperar párrafos que no necesariamente comparten vocabulario con la consulta. Dado que BM25 opera mediante coincidencias léxicas (#emph[bag-of-words]), muchas consultas de CAR resultan intrínsecamente problemáticas para este ranker, lo que limita el techo de correlación alcanzable por cualquier método de predicción.

En contraste, #emph[Antique/Test] y #emph[TREC-COVID] exhiben distribuciones perfectamente balanceadas (20%-60%-20%), reflejando una variedad equilibrada de consultas que permite evaluar el comportamiento de los predictores a lo largo de todo el espectro de dificultad.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/qrels_metricas_otros/antique_test/dificultad_consultas_ndcg@10.png", width: 80%),
  caption: [Distribución de dificultad de consultas en Antique/Test.]
) <dificultad_antique>

\

#figure(
  image("../assets/imagenes/nuevos_resultados/qrels_metricas_otros/car_v15_trec_y1_manual/dificultad_consultas_ndcg@10.png", width: 80%),
  caption: [Distribución de dificultad de consultas en CAR.]
) <dificultad_car>
\

La @fig:dificultad_antique y @fig:dificultad_car ilustran visualmente el contraste entre #emph[Antique/Test], con una distribución balanceada, y #emph[CAR], donde se observa un sesgo hacia consultas difíciles. Esta diferencia estructural anticipa el comportamiento divergente de los predictores QPP en ambos datasets, como se analizará en las secciones siguientes.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/qrels_metricas_otros/cranfield/dificultad_consultas_ndcg@10.png", width: 80%),
  caption: [Distribución de dificultad de consultas en Cranfield.]
) <dificultad_cranfield>
\

Por su parte, #emph[Cranfield] (@fig:dificultad_cranfield) exhibe una distribución prácticamente idéntica a Antique/Test: 45 consultas difíciles (20%), 131 intermedias (59%) y 45 fáciles (20%). Esta simetría, junto con su alta proporción de documentos relevantes (80,8%), confirma su clasificación como dataset favorable para la tarea de predicción. A pesar de su reducido tamaño de corpus (\~1.400 documentos), la variedad equilibrada de consultas proporciona un escenario adecuado para evaluar la capacidad predictiva de los métodos QPP.

#v(10pt)
== Comparación de métodos QPP
\

Los métodos QPP evaluados en esta sección fueron contrastados directamente con los resultados de la evaluación del sistema de recuperación utilizando correlaciones de Pearson, Spearman y Kendall entre las puntuaciones de los predictores y las métricas nDCG\@10 y MAP. La evaluación se realizó sobre cinco conjuntos de datos distintos: _Antique/Test_ (180 consultas), _Cranfield_ (221 consultas), _BEIR-TREC-COVID_ (50 consultas), _MS MARCO (Passage)_ (51 consultas) y _CAR_ (699 consultas). Esta diversidad de colecciones permite evaluar la robustez y generalización de los métodos QPP en diferentes contextos y tamaños de corpus, desde colecciones pequeñas y especializadas hasta grandes colecciones web.

#v(10pt)
=== Visión general de las correlaciones
\

El análisis visual constituye un complemento indispensable a las métricas numéricas presentadas anteriormente. A continuación, se presentan los diagramas de dispersión generados para cada conjunto de datos, los cuales permiten examinar la relación entre las puntuaciones estimadas por cada método QPP y el rendimiento real del sistema (nDCG\@10) a nivel de consulta individual.

Estas visualizaciones son críticas para identificar patrones que los coeficientes de correlación agregados (como _Kendall_ o _Pearson_) no logran capturar por sí solos, tales como #emph[heterocedasticidad] (varianza no constante), la presencia de valores atípicos (#emph[outliers]) y la identificación de regiones específicas donde un predictor puede ser más o menos confiable.

Para garantizar una correcta lectura de los resultados gráficos, se detalla a continuación la metodología de construcción utilizada mediante la biblioteca de visualización estadística _Seaborn_ en Python, así como los criterios para su interpretación.

1.  *Representación de Datos (Puntos)*: Cada punto en el gráfico corresponde a una consulta única (_q_) del _dataset_.
- El Eje Horizontal (X) representa el valor de predicción (_score_) asignado por el método QPP evaluado.
- El Eje Vertical (Y) representa la métrica de efectividad real obtenida (nDCG\@10).

2.  *Línea de Tendencia (Regresión)*: La línea sólida que atraviesa la nube de puntos corresponde a un ajuste de regresión lineal calculado mediante el método de mínimos cuadrados, es decir, la mejor línea recta posible que representa la relación entre las dos variables. Esta línea indica la dirección de la correlación: una pendiente positiva pronunciada sugiere que el método predice correctamente el aumento del rendimiento.

3.  *Banda de Confianza (Sombreado)*: El área translúcida alrededor de la línea de regresión representa el intervalo de confianza del 95% calculado mediante *bootstrapping*. Este método estima la incertidumbre remuestreando los datos observados con reemplazo, generando múltiples regresiones alternativas y calculando percentiles sobre las predicciones resultantes. A diferencia de métodos paramétricos clásicos (distribución $t$ o normal), _bootstrap_ no asume ninguna distribución teórica, operando exclusivamente con los datos disponibles.

  El procedimiento reutiliza los datos observados mediante iteraciones sucesivas (por defecto 1.000 en _Seaborn_): cada iteración remuestrea consultas con reemplazo, ajusta una regresión sobre la nueva muestra y acumula predicciones; la distribución resultante de predicciones define los límites del intervalo mediante percentiles simétricos.

  El ancho de las bandas refleja fielmente la incertidumbre inherente. Bandas amplias surgen cuando el tamaño muestral es reducido (p. ej., 50 consultas en _TREC-COVID_), cuando los puntos exhiben alta dispersión respecto a la línea de tendencia (residuos grandes) o hacia los extremos del eje horizontal, donde pequeños cambios en la pendiente amplifican las diferencias de predicción. Por el contrario, bandas estrechas indican que la tendencia observada es robusta y que diferentes submuestras conducen a conclusiones consistentes sobre la relación entre predicción QPP y rendimiento real.

4.  *Coeficiente de Referencia ($τ$)*: Finalmente, cada diagrama incorpora el valor de correlación de _Kendall_ (τ) calculado para ese par específico de variables. La inclusión de esta métrica permite contrastar la percepción visual de la dispersión con la medida estadística formal de asociación ordinal, lo que es fundamental para contextualizar la línea de regresión, ya que mientras la línea muestra la tendencia lineal general, el valor τ cuantifica la calidad del ranking.

Bajo estos criterios, un método QPP ideal debería mostrar una nube de puntos compacta y elongada diagonalmente hacia la derecha, acompañada de un τ alto y positivo. Por el contrario, una nube dispersa verticalmente o con una línea de tendencia plana indica una capacidad predictiva pobre, donde el método no logra distinguir eficazmente entre consultas difíciles y fáciles.

A continuación se presentan los diagramas de dispersión organizados por _dataset_, incluyendo los métodos QPP evaluados para su contraste directo.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/antique_test/dispersion_qpp_ndcg@10.png", width: 100%,),
  caption: [Diagramas de dispersión QPP vs nDCG\@10 en Antique/Test.]
) <dispersion_antique>
\

La @fig:dispersion_antique evidencia el comportamiento diferenciado de los métodos en #emph[Antique/Test].

Los métodos _post-retrieval_ basados en divergencia (NQC, WIG y UEF-NQC) dominan visualmente el escenario, presentando las pendientes positivas más pronunciadas y, crucialmente UEF-NQC exhibe la banda de confianza más estrecha y una nube de puntos más compacta que su versión base (NQC), lo que confirma visualmente que la re-estimación de utilidad reduce el ruido de la predicción.

En contraste, los métodos _pre-retrieval_ (IDF promedio y máximo) muestran líneas de tendencia horizontales con una dispersión vertical extrema. Es notable cómo consultas con el máximo puntaje IDF pueden tener un nDCG de 0, evidenciando la desconexión entre la rareza de los términos y su relevancia real en este dataset. SCQ muestra un patrón distintivo en su variante #emph[SCQ-Max]: este método selecciona como puntaje el término más discriminativo de la consulta, lo que explica la agrupación observada en el rango $x in {45 dash 55}$. Esto sugiere que la mayoría de las consultas contienen al menos un término medianamente raro que domina el puntaje final, provocando que el método pierda sensibilidad para distinguir entre consultas fáciles y difíciles.

Finalmente, Clarity revela un comportamiento inestable, ya que, aunque su tendencia es positiva, presenta severos #emph[outliers] en valores altos (>150) asociados a un rendimiento mediocre, lo que sugiere que Clarity genera "falsos positivos" de dificultad, asignando puntajes altos a consultas con vocabulario inusual pero que no logran recuperar documentos relevantes.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/car_v15_trec_y1_manual/dispersion_qpp_ndcg@10.png", width: 100%),
  caption: [Diagramas de dispersión QPP vs nDCG\@10 en CAR.]
) <dispersion_car>
\

El caso de #emph[CAR] (@fig:dispersion_car) representa el escenario más crítico de la evaluación y de gran valor experimental. Con 699 consultas, la alta densidad de puntos revela un patrón sistemático distintivo caracterizado por dos fenómenos:

1.  *_Floor Effect_ (Efecto Suelo)*: Como se define en la literatura estadística @cramerstatistics, la concentración masiva de puntos en el rango de rendimiento nulo (nDCG\@10 ≈ 0) comprime la varianza de la variable dependiente, ya que al no existir una distribución de rendimiento efectiva, resulta matemáticamente inviable establecer una correlación lineal robusta, independientemente de la calidad del predictor.

1.  *Desacople Predictivo*: Se observa una desconexión estructural entre las señales que capturan los métodos QPP (basados en coincidencia léxica y divergencia estática) y la naturaleza de la tarea #emph[Complex Answer Retrieval]. Mientras que los métodos asignan puntuaciones dinámicas a las consultas, sugiriendo que detectan variabilidad en la dificultad, el rendimiento real permanece plano, esto confirma que las heurísticas estadísticas tradicionales son "ciegas" ante la dificultad semántica, validando la necesidad de enfoques neuronales para este tipo de _corpus_.


Este comportamiento confirma la incompatibilidad entre el modelo léxico base (BM25) y la tarea semántica de #emph[Complex Answer Retrieval]. Incluso los métodos de expansión UEF demuestran que la re-estimación de utilidad no es tan útil cuando los documentos iniciales recuperados carecen de relevancia.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/trec_covid/dispersion_qpp_ndcg@10.png", width: 100%),
  caption: [Diagramas de dispersión QPP vs nDCG\@10 en TREC-COVID.]
) <dispersion_covid>
\

En #emph[TREC-COVID] (@fig:dispersion_covid) emerge un patrón distintivo que invierte las jerarquías observadas en los otros conjuntos de datos, ya que visualmente Clarity y su variante UEF-Clarity dominan el espectro, presentando las pendientes positivas más pronunciadas y bandas de confianza estrechas, lo que denota una predicción robusta y bien correlacionada.

Por el contrario, los métodos basados en divergencia de puntajes (NQC, WIG), habitualmente dominantes en otros conjuntos de datos, colapsan en líneas de tendencia casi horizontales. Esta inversión se atribuye a la naturaleza técnica y homogénea del _corpus_:

1.  *Ventaja de Clarity*: Al basarse en modelos de lenguaje, Clarity explota eficazmente la especificidad del vocabulario médico, por lo que la divergencia entre el modelo de la consulta (términos técnicos precisos) y la colección general es una señal muy limpia en este dominio.

2.  *Fallo de NQC/WIG*: La alta densidad de términos relevantes en la colección provoca una "saturación de puntajes" en BM25, ya que al existir muchos documentos con puntuaciones de recuperación similares, la varianza de los _scores_ se comprime, privando a NQC y WIG de la señal de dispersión necesaria para discriminar la dificultad de la consulta.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/cranfield/dispersion_qpp_ndcg@10.png", width: 100%),
  caption: [Diagramas de dispersión en Cranfield.]
) <dispersion_cranfield>
\

\
#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/msmarco_dl20_judged/dispersion_qpp_ndcg@10.png", width: 100%),
  caption: [Diagramas de dispersión en MS MARCO (Passage).]
) <dispersion_msmarco>
\

Finalmente, al analizar la @fig:dispersion_cranfield y la @fig:dispersion_msmarco, es posible contrastar el impacto del tamaño muestral y la naturaleza del dominio.

En _Cranfield_ (221 consultas), la densidad de puntos permite identificar tendencias estructurales: WIG, NQC y sus variantes UEF muestran pendientes ascendentes bien definidas. Sin embargo, Clarity exhibe una tendencia descendente anómala (correlación negativa), donde el modelo asigna puntuaciones altas a consultas que obtienen bajo rendimiento real, lo que sugiere que el predictor confunde la coherencia terminológica de los documentos técnicos recuperados con su relevancia temática real. Por su parte, Los métodos _pre-retrieval_ (IDF, SCQ) presentan nubes de puntos amorfas sin direccionalidad, confirmando su ineficacia en colecciones especializadas.

Por otro lado, en #emph[MS MARCO] (51 consultas), la escasez de datos se traduce visualmente en bandas de confianza notablemente más amplias (sombras extensas), lo que alerta sobre la mayor incertidumbre estadística de estas regresiones. A pesar de ello, se observa un patrón interesante: WIG y NQC logran mantener pendientes pronunciadas y paralelas, demostrando capacidad para extraer señal predictiva incluso con una muestra de juicios limitada. Clarity, en cambio, colapsa en una línea horizontal, indicando una ausencia total de señal predictiva en este corpus masivo y heterogéneo.

#v(10pt)
=== Análisis por familia de métodos
\

Los métodos evaluados pueden agruparse en tres familias según su acceso a información del sistema de recuperación:

*Métodos pre-retrieval (IDF, SCQ)*: Estos predictores operan únicamente con estadísticas del índice, sin conocer los documentos recuperados. Los diagramas de dispersión muestran consistentemente líneas de tendencia casi horizontales para IDF, con varianza extrema que invalida cualquier capacidad predictiva. SCQ presenta un comportamiento marginalmente mejor, alcanzando correlaciones moderadas en Antique/Test y Cranfield, pero su rendimiento se degrada en corpus grandes o especializados como TREC-COVID. La ventaja de estos métodos radica exclusivamente en su eficiencia computacional.

*Métodos post-retrieval clásicos (WIG, NQC, Clarity)*: Al acceder a la lista de documentos recuperados y sus puntuaciones, estos métodos capturan señales más informativas. NQC y WIG muestran comportamientos complementarios: mientras NQC se basa en la varianza de puntuaciones del top-k, WIG considera la desviación respecto al promedio del corpus. Clarity, basado en divergencia KL respecto al modelo de lenguaje de la colección, exhibe alta sensibilidad al dominio: domina en TREC-COVID pero presenta correlaciones negativas en Cranfield.

*Variantes UEF*: El marco Utility Estimation Framework extiende los métodos base incorporando información de pseudo-relevance feedback. Los diagramas revelan que UEF mejora consistentemente a NQC en la mayoría de datasets, con la excepción de MS MARCO donde ambos empatan. Para Clarity, UEF amplifica tanto sus contextos favorables (TREC-COVID) y aumentando un poco su rendimiento en situaciones difíciles (Cranfield con correlación cercana a cero).


#v(10pt)
=== Significancia estadística de las correlaciones
\

La validez de los patrones observados requiere verificar que las correlaciones sean estadísticamente significativas. Un coeficiente de correlación alto carece de utilidad práctica si no supera los umbrales de significancia, especialmente en datasets con pocas consultas donde el azar puede producir correlaciones espurias.

Los mapas de calor de p-values utilizan una escala de cuatro niveles: altamente significativo (p < 0,001), muy significativo (p < 0,01), significativo (p < 0,05) y no significativo (p ≥ 0,05). Esta gradación permite distinguir entre correlaciones robustas y aquellas que podrían deberse a fluctuaciones aleatorias.

\
#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/antique_test/pvalues_qpp_kendall.png", width: 80%),
  caption: [Significancia estadística (p-values) en Antique/Test.]
) <pvalues_antique>
\

\
#figure(
  image("../assets/imagenes/nuevos_resultados/correlación/trec_covid/pvalues_qpp_kendall.png", width: 80%),
  caption: [Significancia estadística (p-values) en TREC-COVID.]
) <pvalues_trec_covid>
\

Como podemos ver en la @fig:pvalues_antique y la @fig:pvalues_trec_covid, ambos datasets contrastan fuertemente. En #emph[Antique/Test] (180 consultas), todos los métodos excepto IDF alcanzan significancia alta (p < 0,001), lo que valida la robustez de las correlaciones observadas. En #emph[TREC-COVID] (50 consultas), sin embargo, solo Clarity y UEF-Clarity presentan significancia consistente; métodos como NQC, que tradicionalmente dominan otros datasets, no superan el umbral de p < 0,05.

Este fenómeno se explica por la relación matemática entre tamaño muestral y significancia estadística. La prueba de significancia para correlaciones evalúa si el coeficiente observado podría haberse obtenido por azar; con muestras pequeñas, la varianza del estimador es alta y solo correlaciones sustanciales superan el umbral. Concretamente, para τ de Kendall con n ≈ 50 consultas, solo correlaciones relativamente altas (τ ≳ 0,18–0,20) tienden a alcanzar p < 0,05, mientras que con n ≈ 180 consultas correlaciones mucho menores (τ ≈ 0,10) pueden resultar significativas. Esto explica por qué métodos como NQC, con correlaciones moderadas en TREC-COVID (τ ≈ 0,09), no alcanzan significancia a pesar de mostrar tendencias positivas.

*Patrones transversales de significancia*

El análisis de los cinco datasets revela consistencias importantes:

- #emph[IDF nunca alcanza significancia estadística] en ningún dataset, confirmando su ineficacia práctica como predictor QPP con el sistema BM25 evaluado.

- #emph[NQC y UEF-NQC] son altamente significativos (p < 0,001) en cuatro de cinco datasets, con la única excepción de TREC-COVID.

- #emph[Clarity exhibe significancia polarizada]: altamente significativo en TREC-COVID y Antique, pero no significativo en Cranfield ni MS MARCO.

- #emph[SCQ presenta significancia intermedia]: alcanza p < 0,001 en Antique y CAR, pero no supera p < 0,05 en MS MARCO ni TREC-COVID.

- #emph[Los datasets pequeños] (MS MARCO con 51 consultas, TREC-COVID con 50) muestran mayor proporción de métodos no significativos, subrayando la importancia del tamaño muestral para conclusiones robustas.

Estos patrones de significancia complementan el análisis de correlaciones y deben considerarse conjuntamente al evaluar la utilidad práctica de cada método. Un predictor con correlación moderada pero altamente significativa puede ser preferible a uno con correlación alta pero estadísticamente dudosa.

Los resultados cuantitativos detallados, incluyendo las correlaciones exactas para cada combinación de método, métrica y dataset, se presentan en la siguiente sección.

#v(10pt)
== Análisis comparativo de los resultados
\

Una vez caracterizado el comportamiento visual de los predictores y las propiedades de los conjuntos de datos en las secciones previas, corresponde cuantificar con precisión el rendimiento de los métodos mediante los coeficientes de correlación.

Este análisis cuantitativo resulta indispensable para validar estadísticamente las tendencias observadas y determinar qué métodos ofrecen no solo una relación lineal (_Pearson_) o monótona (_Spearman_), sino un ordenamiento correcto de las consultas según su dificultad (_Kendall_), aspecto crítico para la aplicabilidad real de los sistemas de rendimiento de consultas (QPP).

La @tbl:Resultados_qpp_ndcg10_multidataset_tabla presenta la consolidación de los coeficientes obtenidos entre las puntuaciones de cada predictor y la métrica de efectividad nDCG\@10. Esta tabla constituye la evidencia central de este trabajo, permitiendo contrastar transversalmente el desempeño de los métodos en escenarios de recuperación con características estructural y semánticas muy diversas.

Al respecto, un aspecto técnico relevante que se desprende de la comparación entre los tres coeficientes calculados es la consistencia direccional entre las métricas de correlación, ya que se observa que, en la mayoría casos, los métodos que obtienen un alto τ de _Kendall_ también mantienen valores elevados de ρ de _Spearman_ y _Pearson_.

Esta alineación sugiere que la relación entre la predicción y el rendimiento real es robusta y no depende exclusivamente de la métrica estadística utilizada. Sin embargo, existen excepciones notables en los métodos pre-retrieval, como _IDF_, donde la discrepancia entre _Pearson_ y _Kendall_ se acentúa más, lo que indica que, aunque dichos métodos pueden capturar la magnitud general de la dificultad (relación lineal), pueden fallar sistemáticamente en ordenar correctamente las consultas individuales dentro del ranking.

\
#{ 
  // Encabezados en negrita para la primera fila de la tabla
  show table.cell.where(y: 0): set text(style: "normal", weight: "bold")

  // Estilo local de la tabla para replicar el diseño del artículo
  set table(
    align: (x, y) => if x > 0 { left } else { center },
    inset: (x: 3pt, y: 5pt),
    // Solo línea gruesa entre cabecera y cuerpo; sin líneas internas en métodos/puntajes
    stroke: (x, y) => if y < 3 { none } else if y == 3 { (top: 1pt) } else { none },
    column-gutter: 6pt,
    row-gutter: (2pt, auto),
  )

  [
    #figure(
      rotate(
        -90deg,
        reflow: true,
        table(
          columns: 16,

          // Líneas superior e inferior de la tabla
          table.hline(y: 0, position: top, stroke: 1pt),
          // Línea fina justo debajo del título de la tabla
          table.hline(y: 0, position: bottom, stroke: 0.5pt),
          // Pequeñas líneas bajo cada dataset
          table.hline(y: 1, start: 1, end: 4, position: bottom, stroke: 0.5pt),
          table.hline(y: 1, start: 4, end: 7, position: bottom, stroke: 0.5pt),
          table.hline(y: 1, start: 7, end: 10, position: bottom, stroke: 0.5pt),
          table.hline(y: 1, start: 10, end: 13, position: bottom, stroke: 0.5pt),
          table.hline(y: 1, start: 13, end: 16, position: bottom, stroke: 0.5pt),
          table.hline(y: 12, position: bottom, stroke: 1pt),

          // Cabecera multinivel: datasets y tipos de correlación
          table.header(
            table.cell(colspan: 16)[Correlaciones entre métodos QPP y nDCG\@10 en múltiples datasets],

            table.cell(rowspan: 2)[*Método*],
            table.cell(colspan: 3)[*Antique/Test*],
            table.cell(colspan: 3)[*Cranfield*],
            table.cell(colspan: 3)[*BEIR-TREC-COVID*],
            table.cell(colspan: 3)[*MS MARCO (Passage)*],
            table.cell(colspan: 3)[*CAR*],

            [P-ρ], [S-ρ], [K-τ],
            [P-ρ], [S-ρ], [K-τ],
            [P-ρ], [S-ρ], [K-τ],
            [P-ρ], [S-ρ], [K-τ],
            [P-ρ], [S-ρ], [K-τ],
          ),

          // Métodos QPP (pre y post-retrieval)
          [IDF Promedio],
          [$0,164$], [$0,139$], [$0,038$],
          [$0,249$], [$0,186$], [$0,102$],
          [$0,123$], [$0,005$], [$-0,006$],
          [$0,265$], [$0,292$], [$0,209$],
          [$-0,019$], [$-0,007$], [$-0,005$],

          [IDF Máximo],
          [$0,092$], [$0,076$], [$0,028$],
          [$0,117$], [$0,087$], [$0,037$],
          [$0,083$], [$0,030$], [$0,017$],
          [$0,251$], [$0,253$], [$0,168$],
          [$0,018$], [$0,009$], [$0,006$],

          [SCQ Promedio],
          [$0,324$], [$0,266$], [$0,180$],
          [$0,284$], [$0,235$], [$0,104$],
          [$0,075$], [$0,053$], [$0,032$],
          [$0,178$], [$0,182$], [$0,127$],
          [$0,039$], [$0,014$], [$0,010$],

          [SCQ Máximo],
          [$0,379$], [$0,383$], [$0,269$],
          [$0,310$], [$0,276$], [$0,176$],
          [$0,062$], [$0,089$], [$0,055$],
          [$-0,035$], [$0,012$], [$0,030$],
          [$0,065$], [$0,074$], [$0,051$],

          [WIG],
          [$0,436$], [$0,450$], [$0,305$],
          [$0,295$], [$0,324$], [$0,222$],
          [$0,320$], [$0,278$], [$0,201$],
          [$0,552$], [$0,560$], [$0,406$],
          [$0,079$], [$0,099$], [$0,068$],

          [NQC],
          [$0,524$], [$0,567$], [$0,382$],
          [$0,297$], [$0,384$], [$0,210$],
          [$0,192$], [$0,147$], [$0,093$],
          [*$0,553$*], [*$0,585$*], [*$0,408$*],
          [$0,125$], [$0,166$], [$0,114$],

          [Clarity],
          [$0,452$], [$0,430$], [$0,272$],
          [$-0,025$], [$-0,018$], [$-0,069$],
          [$0,477$], [$0,461$], [$0,320$],
          [$0,093$], [$0,068$], [$0,047$],
          [$0,110$], [$0,146$], [$0,101$],

          [UEF-WIG],
          [$0,333$], [$0,377$], [$0,252$],
          [*$0,388$*], [$0,390$], [$0,233$],
          [$0,170$], [$0,192$], [$0,134$],
          [$0,343$], [$0,380$], [$0,253$],
          [$0,121$], [$0,124$], [$0,086$],

          [UEF-NQC],
          [*$0,553$*], [*$0,596$*], [*$0,427$*],
          [$0,359$], [*$0,458$*], [*$0,258$*],
          [$0,182$], [$0,146$], [$0,108$],
          [$0,552$], [$0,560$], [*$0,408$*],
          [*$0,131$*], [*$0,182$*], [*$0,126$*],

          [UEF-Clarity],
          [$0,463$], [$0,448$], [$0,286$],
          [$0,161$], [$0,181$], [$0,011$],
          [*$0,496$*], [*$0,468$*], [*$0,331$*],
          [$0,190$], [$0,186$], [$0,119$],
          [$0,113$], [$0,152$], [$0,105$],
        ),
      ),
      caption: [Correlaciones (P-ρ, S-ρ y K-τ) entre métodos QPP y nDCG\@10 en los distintos datasets evaluados.]
    ) <Resultados_qpp_ndcg10_multidataset_tabla>]
}

La primera observación que podemos obtener de la @tbl:Resultados_qpp_ndcg10_multidataset_tabla es la significativa heterogeneidad en los "techos de rendimiento" alcanzables. Se evidencia que la dificultad de la tarea de predicción no es uniforme: 

- En colecciones favorables como _Antique_ y _MS MARCO_, los mejores métodos logran correlaciones de _Kendall_ robustas (*τ > 0,40*).

- En escenarios complejos como _CAR_, el rendimiento se desploma drásticamente (*τ ≈ 0,126*).

Este escenario confirma cuantitativamente que la calidad de la predicción está intrínsecamente acotada por las propiedades del conjunto de datos y la capacidad del sistema de recuperación base para satisfacer las necesidades de información planteadas.

Por otra parte, si analizamos el desempeño por familias, se hace evidente la limitación de los métodos _pre-retrieval_:

- *IDF* (Promedio y Máximo) presenta correlaciones consistentemente bajas (*τ < 0,15*), demostrando una capacidad predictiva cercana al azar.

- *SCQ* revela un comportamiento dual interesante: alcanza correlaciones respetables en colecciones pequeñas como *_Antique_* (*τ ≈ 0,269*) y *_Cranfield_* (*τ ≈ 0,176*), pero su rendimiento colapsa en corpus masivos o especializados como *_MS MARCO_* (*τ = 0,030*) y *_TREC-COVID_* (*τ = 0,055*).

Este hallazgo sugiere que la estadística de coherencia de la consulta, que es útil en contextos simples o reducidos, pierde robustez y se diluye como señal predictiva al escalar a _corpus_ que son masivos o con vocabularios técnicos específicos.

Así mismo, esta degradación del rendimiento de _SCQ_ en índices masivos puede atribuirse al fenómeno de saturación del espacio semántico. En colecciones pequeñas como _Cranfield_, la ocurrencia de un término es un evento informativo fuerte, sin embargo, en índices del tamaño de _MS MARCO_ con millones de pasajes, la probabilidad de que exista co-ocurrencia accidental de términos aumenta exponencialmente, lo que provoca que la métrica de "coherencia" de _SCQ_ se vuelva ruidosa, ya que el método no puede distinguir entre una repetición de términos que aporta significado y una que es meramente estadística debido al volumen del _corpus_.

En contraste, los métodos *_post-retrieval_* dominan el espectro de resultados. *_NQC_* se consolida como el predictor base más robusto de este trabajo, superando en la mayoría de los escenarios a *_WIG_* en la mayoría de los escenarios. Esta consistencia de _NQC_ a través de los distintos _datasets_ valida la hipótesis de que la desviación estándar de las puntuaciones de los documentos recuperados es una señal más fiable de la "certeza" del sistema que la simple acumulación de aportes léxicos utilizada por _WIG_.

Otro caso de estudio excepcional es el del método *_Clarity_*, en el que los datos numéricos confirman una dependencia extrema del dominio:

- En conjuntos de datos como *_Cranfield_* fracasa de forma clara (*τ = -0,069*, correlación nula o inversa).

- En *_TREC-COVID_* resurge como uno de los métodos líderes (τ = 0,320), y más aún, su variante _UEF-Clarity_ alcanza en este _dataset_ el valor más alto de la tabla (*τ = 0,331*).

Esto indica que los modelos de lenguaje, base para _Clarity_, son altamente efectivos cuando el _corpus_ posee una homogeneidad temática y terminológica (como son los artículos médicos sobre COVID-19), pero se vuelven inestables e inútiles en colecciones pequeñas o con vocabularios más dispersos.

Respecto a la aplicación del marco *_UEF_* (_Utility Estimation Framework_), los resultados muestran matices que son importantes, si bien el método logra potenciar el rendimiento en _Antique_ y _Cranfield_ (elevando la correlación de NQC de 0,382 a 0,427), se observa un fenómeno de *"saturación"* en _MS MARCO_. 

En este _dataset_, las correlaciones de *NQC* y *UEF-NQC* son idénticas (*τ = 0,408*), lo que sugiere que en _corpus_ de gran escala y diversidad temática, la expansión de consultas, que es el mecanismo central de _UEF_, podría no estar aportando información nueva relevante o, peor aún, podría estar introducción ruido que neutraliza las ganancias de la re-estimación.

Finalmente, el análisis del conjunto de datos *_CAR_* ratifica la dificultad extrema de las tareas de _Complex Answer Retrieval_ para los paradigmas actuales, ya que con una correlación máxima de *τ ≈ 0,126* transversal a todos los métodos probados, se evidencia una barrera estructural, en donde la desconexión semántica entre las consultas (títulos de Wikipedia, en este caso) y los pasajes relevantes, sumada a una escala de relevancia compleja, genera un escenario "ciego" para las señales léxicas y estadísticas tradicionales.

#v(10pt)
== Discusión de los resultados
\

El análisis exhaustivo anteriormente evidenciado sobre los cinco conjunto de datos heterogéneos nos permite no solo evaluar la efectividad puntual de los métodos QPP, sino también establecer principios generales que guíen la investigación futura.

Los resultados confirman que la predicción del rendimiento de consultas es una tarea dependiente de varios factores (multifactorial), cuya dificultad depende tanto de las propiedades estadísticas de la colección como de la naturaleza semántica de la necesidad de información.

En este contexto, si bien los coeficientes de _Pearson_ y _Spearman_ entregan referencias sobre la linealidad y monotonía general respectivamente, la discusión de los resultados se centra principalmente en el coeficiente τ de _Kendall_ respondiendo a la evidencia numérica presentada en la @tbl:Resultados_qpp_ndcg10_multidataset_tabla, donde se observan ciertas discrepancias, como por ejemplo, para el método Clarity en Antique, tanto _Pearson_ (0,452) como _Spearman_ (0,430) sugieren una correlación moderada que disminuye significativamente al evaluar el ordenamiento estricto mediante _Kendall_ (0,272), confirmando que incluso las métricas basadas en rangos como _Spearman_ pueden ser optimistas, mientras que _Kendall_ emerge como un indicador más robusto para interpretar la capacidad real de los predictores en este escenario experimental.

#v(10pt)
=== Contextualización y validación de la línea base
\

Uno de los principales aportes de este trabajo de título es la identificación empírica de una configuración de referencia robusta, en la que los datos demuestran que los métodos _post-retrieval_ basados en la dispersión de puntuaciones, específicamente _NQC_ y su variante _UEF-NQC_, ofrecen el equilibrio más consistente entre rendimiento y estabilidad.

Aunque los valores de correlación obtenidos (con límites superiores cercanos a τ ≈ 0,43) podrían parecer modestos fuera del contexto de la recuperación de información, es crucial interpretarlos bajo los estándares del dominio. Como señala @how-much-correlation-is-good, correlaciones incluso tan bajas como _0,1_ poseen valor práctico en escenarios de predicción de dificultad, y valores en el rango obtenido en este trabajo son considerados significativos. De hecho, resultados como los de _Antique_ se alinean e incluso superan ligeramente los reportados por @zendel2024qpptk, validando la calidad de la implementación.

En consecuencia, se establece que métodos como _UEF-NQC_ constituyen un _baseline_ experimental idóneo para futuras investigaciones, debiendo preferise sobre métodos más débiles como _IDF_, siempre que el costo computacional de la expansión de consultas sea admisible.

Desde una perspectiva de implementación en sistemas reales, estos hallazgos plantean un compromiso (_trade-off_) crítico entre precisión predictiva y latencia, ya que, si bien _UEF-NQC_ se establece como el estándar de calidad, su ejecución implica un costo computacional significativo al requerir una primera recuperación, análisis de puntajes, expansión de consultas y, en ocasiones, una segunda fase de recuperación.

Por lo tanto, en escenarios de alta demanda o tiempo real, este costo podría ser un obstáculo, por ello, la utilidad marginal que ofrecen métodos intermedios como _SCQ_ en colecciones acotadas no debe descartarse totalmente, aunque son menos precisos, su ejecución es mucho más rápida al basarse en tablas pre-calculadas, lo que los convierte en candidatos viables para una primera capa de filtrado en arquitecturas de recuperación en cascada.

#v(10pt)
=== La complejidad inherente y el límite estadístico
\

Los resultados consistentemente bajos en el conjunto de datos _CAR_ (τ < 0,13) exponen no solo una limitación de los métodos evaluados, sino la complejidad intrínseca de la tarea. Estudios previos con expertos humanos como @humans-cant-predict y @user-ratings-vs-system-predictions han demostrado que incluso profesionales con conocimiento del dominio tienen dificultades para predecir el fracaso de una consulta basándose solo en su formulación.

Esto sugiere que los métodos actuales, que operan bajo supuestos léxicos como _IDF_ y _SCQ_ o estadísticos como _NQC_ y _Clarity_ han alcanzado un "techo técnico", ya que asumen que la dificultad se manifiesta en la rareza de los términos o en la divergencia de distribuciones, pero son "ciegos" a la brecha semántica, por lo que en tareas complejas de recuperación donde la relevancia no es literal sino conceptual como en _CAR_, los métodos estadísticos no logran distinguir claramente entre una respuesta diversa pero relevante y una respuesta ruidosa e irrelevante.

Para cuantificar la magnitud del efecto suelo (_floor effect_), la @tbl:tabla_floor_effect presenta una comparación transversal del porcentaje de consultas con rendimiento nulo o muy bajo en cada colección evaluada.

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
      table.header[*Dataset*][*Consultas*][*nDCG\@10 = 0*][*nDCG\@10 ≤ 0.1*][*Media*],
      [Antique/Test], [180], [4,4%], [10,0%], [0,379],
      [Cranfield], [221], [18,1%], [24,9%], [0,320],
      [TREC-COVID], [50], [14,0%], [18,0%], [0,473],
      [CAR], [699], [*28,3%*], [*41,9%*], [*0,203*],
    ),
    caption: [Distribución del efecto suelo por dataset. CAR presenta la mayor concentración de consultas con rendimiento nulo.]
  ) <tabla_floor_effect>]
}
\

Los datos revelan que #emph[CAR] concentra el 28,3% de sus consultas con nDCG\@10 = 0, proporción significativamente mayor que en los demás datasets (Antique: 4,4%, TREC-COVID: 14%). Más aún, el 41,9% de las consultas CAR obtienen un rendimiento igual o inferior a 0,1, evidenciando que el problema no es marginal sino estructural.

Para ilustrar correctamente la naturaleza de la barrera semántica, basta con examinar casos representativos que obtuvieron un rendimiento nulo (nDCG\@10 = 0). Consultas con estructuras jerárquicas profundas, tales como "_Invasive species/Effects/Economic/.../Benefits_", "_Beach nourishment/Nourishment projects/Hawaii/Waikiki_" o "_Drinking water/Health aspects/Well contamination..._" ilustran el problema central al describir un concepto semántico específico (ej., _beneficios económicos de especies invasoras_), pero utilizan una cadena de términos que raramente aparece contigua o literal en los párrafos relevantes.

En estos casos, el modelo BM25, al operar sobre coincidencias léxicas exactas, es incapaz de recuperar documentos pertinentes cuando no existe un solapamiento directo de vocabulario entre la jerarquía de la consulta y el contenido del documento, independientemente de la coherencia conceptual entre ambos.

Es fundamental también reconocer las limitaciones inherentes al estándar de referencia (_Ground Truth_) utilizado para validar estas predicciones, ya que métricas de recuperación como _nDCG_ dependen enteramente de la completitud y calidad de los juicios de relevancia humanos, por lo que, en _datasets_ con escasa profundidad de juicio (_sparse judgments_) o sesgos de anotación, lo que los métodos QPP intentan predecir no es necesariamente la satisfacción real del usuario, sino la coincidencia con un conjunto de etiquetas estáticas, lo que puede ser particularmente crítico en casos como _CAR_, donde la baja correlación podría estar reflejando no solo la incapacidad de los predictores, sino también la desconexión entre la definición teórica de relevancia del _dataset_ y la utilidad real percibida que los métodos estadísticos intentan inferir.

#v(10pt)
=== Análisis de la sensibilidad de Clarity
\

La disparidad observada en el rendimiento del método Clarity entre las colecciones de *Cranfield* y *TREC-COVID* no es accidental, sino que responde a diferencias estructurales profundas en cuanto a escala, riqueza de vocabulario y distribución de frecuencias. Formalmente, Clarity estima la coherencia de los resultados recuperados mediante la divergencia Kullback-Leibler (KL) entre el modelo de lenguaje de la consulta ($P(w|Q)$) y el modelo de lenguaje de la colección ($P(w|C)$), tal como se define en la @eqt:clarity-definition:

\
$ "Clarity" = sum_{w in V} P(w|Q) log_2 (P(w|Q) / P(w|C)) $ <clarity-definition>
\

Donde $P(w|Q)$ es la probabilidad del término $w$ en el modelo de pseudo-relevancia, y $P(w|C) = "cf"_w / N$ su probabilidad en la colección (con $N$ el total de tokens). Dado que $N$ es 129 veces mayor en TREC-COVID (15.7M vs 121K), un término con igual frecuencia de colección tendrá $P(w|C)$ \~129 veces menor, inflando el cociente $P(w|Q)/P(w|C)$ y generando puntajes de Clarity sistemáticamente más altos en colecciones grandes.

\
#{
  show table.cell.where(y: 0): set text(style: "normal", weight: "bold")
  set table(stroke: (x: none))
  set align(center)
  [#figure(
    table(
      columns: 3,
      inset: (x: 10pt, y: 8pt),
      align: (left, center, center),
      table.header[*Métrica*][*Cranfield*][*TREC-COVID*],
      
      // Collection statistics
      [Documentos], [1,400], [171,332],
      [Tokens totales], [121,253], [15,681,547],
      [Vocabulario], [6,054], [251,601],
      [Long. promedio doc], [86.6], [91.5],
      [Términos raros (cf $<=5$)], [70.6%], [78.1%],
      [Terminos unicos (cf = 1)], [43.1%], [46.5%],
      
      // Clarity statistics
      table.hline(),
      [Consultas evaluadas], [225], [50],
      [Términos únicos (queries)], [612], [817],
      [Términos con $P_"coll" approx 0$], [5.7% (contrib. 25.1%)], [24.0% (contrib. 52.6%)],
      [Clarity (media $plus.minus$ std)], [2.387 $plus.minus$ 0.249], [5.612 $plus.minus$ 0.801],
    ),
    caption: [Comparación de estadísticas de colección y Clarity entre Cranfield y TREC-COVID.]
  ) <tabla_comparacion_colecciones>]
}
\

La @tbl:tabla_comparacion_colecciones muestra que ambas colecciones tienen proporciones similares de términos raros (\~70-78%). Dado que la divergencia KL es una suma de contribuciones individuales por término ($"contrib"_w = P(w|Q) dot log_2(P(w|Q) / P(w|C))$), podemos analizar qué fracción del puntaje total proviene de términos con $P(w|C)$ muy bajo. La diferencia en rendimiento predictivo radica en la *naturaleza* de estos términos:

- En *Cranfield*, el 25,1% de la divergencia proviene de un 5,7% de términos con $P(w|C) approx 0$. Estos corresponden principalmente a ruido estadístico propio de colecciones pequeñas, donde cualquier término poco frecuente genera cocientes $P(w|Q)/P(w|C)$ artificialmente altos sin aportar señal semántica útil.

- En *TREC-COVID*, el 52,6% de la divergencia proviene de tecnicismos médicos legítimos (e.g., "sarscov", "merscov", "trial", "drug"). Estos términos son genuinamente discriminativos: indican que la consulta tiene un enfoque temático específico y, por tanto, su alta contribución es informativa.

Cuando la divergencia está dominada por términos semánticamente relevantes, Clarity predice bien; cuando está dominada por ruido de baja frecuencia, la predicción se degrada. La @tbl:tabla_terminos_covid ejemplifica esta distinción en TREC-COVID: términos específicos como "social" o "drug" generan cocientes altos (>17), mientras que términos genéricos de la literatura científica como "result" o "studi" son correctamente atenuados (\~2.2).

\
#{
  show table.cell.where(y: 0): set text(style: "normal", weight: "bold")
  set table(stroke: (x: none))
  set align(center)
  
  grid(
    columns: (1fr, 1fr),
    column-gutter: 16pt,
    
    // Cranfield table
    [#figure(
      table(
        columns: 4,
        inset: (x: 3pt, y: 6pt),
        align: (left, center, center, center),
        table.header[*Término*][*$P(w|Q)$*][*$P(w|C)$*][*Cociente*],
        [flow], [0.031], [0.016], [1.9],
        [number], [0.022], [0.011], [2.0],
        [method], [0.015], [0.007], [2.1],
        [pressur], [0.022], [0.011], [2.1],
        [effect], [0.017], [0.008], [2.1],
      ),
      caption: [Contribución de términos en Cranfield]
    ) <tabla_terminos_cranfield>],
    
    // TREC-COVID table
    [#figure(
      table(
        columns: 4,
        inset: (x: 3pt, y: 6pt),
        align: (left, center, center, center),
        table.header[*Término*][*$P(w|Q)$*][*$P(w|C)$*][*Cociente*],
        [social], [0.019], [0.0008], [23.3],
        [trial], [0.019], [0.0010], [19.9],
        [drug], [0.019], [0.0011], [17.8],
        [sarscov], [0.010], [0.0006], [17.5],
        [peopl], [0.012], [0.0007], [16.4],
      ),
      caption: [Contribución de términos en TREC-COVID]
    ) <tabla_terminos_covid>],
  )
}
\

La evidencia sugiere que Clarity es altamente sensible a la escala del corpus. En colecciones pequeñas, el ruido estadístico domina la divergencia, limitando la utilidad del método; en cambio, en colecciones grandes y temáticamente especializadas, la métrica gana robustez y capacidad predictiva. Para mitigar este sesgo en corpus reducidos, la literatura sugiere normalizaciones sobre el parámetro $mu$ o el filtrado agresivo de términos raros durante el preprocesamiento.

Por otra parte, las limitaciones estructurales observadas, tanto la brecha semántica en _CAR_ como la dependencia de dominio de _Clarity_, sugieren que el futuro inmediato de la predicción del rendimiento de consultas no reside en refinar métricas estadísticas, sino en la integración de Inteligencia Artificial y Modelos de Lenguaje Grandes (_LLMs_), debido a que la capacidad de estos modelos para "entender" el contenido abre nuevas vías para superar las limitaciones observadas:

- *Evaluación de Coherencia Semántica*: En lugar de medir la ambigüedad mediante modelos de lenguaje simples, como _Clarity_, un modelo neuronal podría evaluar directamente la coherencia lógica entre la consulta y los documentos recuperados.

- *Predicción Generativa*: Utilizar _LLMs_ para reformular la consulta y medir la consistencia de los conjuntos de documentos recuperados para cada variación, proporcionando una señal de robustez mucho más valiosa que la expansión léxica de _UEF_.

- *Decisión Híbrida*: Dado que la eficiencia es clave @microsoft-preretrieval, se propone investigar arquitecturas en cascada donde métodos ligeros como _SCQ_ filtren consultas obviamente fáciles, para así reservar el costo computacional de los métodos neuronales solo para aquellas consultas clasificadas como ambiguas o difíciles.

Estos resultados no solo establecen una línea base sólida con métodos como _UEF-NQC_, sino que evidencian la necesidad de evolucionar los paradigmas actuales, en donde, el objetivo próximo de la investigación en QPP exige la evolución de paradigmas que permitan transitar desde la medición estadística hacia la comprensión semántica profunda, capaz de superar las barreras léxicas detectadas.

#v(10pt)
== Síntesis de hallazgos
\

Del análisis comparativo se desprenden tres principales hallazgos que sintetizan el comportamiento de los predictores evaluados frente a la variabilidad de los datos:

- *Degradación de métodos pre-retrieval en índices masivos*: Se observó que los predictores basados en estadísticas globales como _SCQ_, aunque eficaces en colecciones acotadas, reducen drásticamente su rendimiento en índices de gran escala como _MS MARCO_. Esto sugiere que las métricas _pre-retrieval_ pierden capacidad discriminativa al saturarse el espacio semántico, aumentando la probabilidad de colisiones de términos no informativos.
- *Riesgo de ruido en la expansión post-retrieval (UEF)*: Aunque el marco _UEF_ potenció el rendimiento en la mayoría de los escenarios, en _MS MARCO_ no aportó ganancia sobre su base _NQC_, lo que indica que, en colecciones altamente heterogéneas o cuando la recuperación inicial es imprecisa, la expansión ciega de consultas propia de ciertos métodos _post-retrieval_ puede introducir ruido documental (_query drift_), neutralizando los beneficios teóricos de la re-estimación de utilidad.
- *Limitación semántica estructural*: El rendimiento uniformemente bajo en el _dataset CAR_ evidencia una "barrera semántica", en donde los resultados confirman que tanto los métodos _pre-retrieval_ como _post-retrieval_ clásicos presentan dificultades inherentes para capturar la relevancia conceptual profunda requerida en tareas de respuestas complejas, donde la pertinencia no depende exclusivamente de la recurrencia léxica, sino de relaciones semánticas que estos predictores no logran modelar.

Finalmente, la evidencia experimental confirma que no existe un predictor universalmente superior, ya que la eficacia de cada método está intrínsecamente ligada a las proppiedades estructurales de la colección y la naturaleza de la tarea de recuperación. Mientras que la aproximación estadística de _UEF_ sigue siendo el estándar más robusto para tareas léxicas tradicionales, la brecha de rendimiento en escenarios semánticos complejos subraya la urgencia de integrar mecanismos neuronales que trasciendan la coincidencia de términos.