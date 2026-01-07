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

La configuración general utilizada para el experimento se presenta en la @fig:Diagrama_evaluación_resultados:

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
== Resultados obtenidos en conjuntos de datos
\
Como se mencionó anteriormente, previo a la evaluación de los métodos QPP, es necesario evaluar el sistema de recuperación subyacente. En este trabajo se utilizó BM25 sobre los cinco conjuntos de datos seleccionados, todos ellos con juicios de relevancia graduados. Este paso permite asegurar que las correlaciones observadas más adelante se deben principalmente al comportamiento de los predictores y no a fallos graves del sistema de recuperación.

\
#figure(image("../assets/imagenes/resultados/boxplot_metricas.png"), caption: [Diagrama de caja para las métricas nDCG\@10 y MAP en Antique/Test]) <Boxplot_metricas>

\
En un primer vistazo a los resultados del experimento, la @fig:Boxplot_metricas —tomada sobre el conjunto de datos *Antique/Test* como ejemplo representativo— muestra que el sistema de recuperación BM25 presenta un rendimiento mayor en la métrica nDCG\@10 frente a MAP. Ambos experimentos presentan un rango de resultados similar, desde el 0 y sin sobrepasar el 0.8 en ninguno de los casos, patrón que se repite con pequeñas variaciones en el resto de datasets.

Es posible observar la existencia de _outliers_ en los resultados de la métrica MAP, los cuales sobresalen muy por encima en comparación del ultimo cuartil de los resultados. Esto se puede interpretar a que ciertas consultas consiguen resultados muy altos en comparación a las demás, debido a ser frecuentemente representadas en los juicios de relevancia y en la colección de documentos.

La media de las métricas nDCG\@10 y MAP se puede observar en la @fig:Media_metricas, donde se aprecia que el sistema de recuperación BM25 presenta un rendimiento mucho mayor en nDCG\@10 frente a los resultados de MAP. Específicamente, en *Antique/Test* se obtiene una media de 0.36 para nDCG\@10 y 0.18 para MAP, lo que evidencia la capacidad del sistema para rankear documentos en las 10 primeras posiciones sobre la precisión de la completitud de los documentos recuperados. En el resto de colecciones se repite este comportamiento: MAP tiende a ser más conservadora y castiga con mayor fuerza la falta de documentos relevantes.

\
#figure(image("../assets/imagenes/resultados/media_metricas.png"), caption: [Media de las métricas nDCG\@10 y MAP en Antique/Test]) <Media_metricas>

\
La @fig:Histogramas_metricas sirve para complementar la información anterior dando una perspectiva más detallada de los resultados obtenidos en *Antique/Test*. Se puede observar que para nDCG\@10 tenemos una distribución ligeramente bimodal, una en 0.2-0.3 y otra en 0.5-0.7; esto se puede interpretar como dos grupos intrínsecamente distintos de consultas, el primero de ellos muestra un rendimiento de nuestro sistema de recuperación más bajo, mientras que el segundo es satisfactoriamente rankeado. Estos hallazgos motivan analizar qué características de las consultas en estos grupos las hacen más fáciles o difíciles de rankear y son coherentes con las observaciones realizadas en los demás datasets.

\
#figure(image("../assets/imagenes/resultados/histogramas_metricas.png"), caption: [Histogramas de las métricas nDCG\@10 y MAP en Antique/Test]) <Histogramas_metricas>

\
La @fig:Scatter_ndcg10_vs_ap muestra el gráfico de dispersión de los valores de nDCG\@10 y MAP en *Antique/Test*, donde se puede apreciar una fuerte correlación (r=0.84) entre ambas métricas, lo cual sugiere una calidad de recuperación similar entre ambos experimentos. Por otra parte, algo interesante a tener en cuenta es el patrón \"palo de hockey\" que se forma entre las dos métricas. Este patrón también aparece, aunque con distinta intensidad, en el resto de colecciones. En todos los casos apunta a que:

- En el rango inferior (nDCG\@10 < 0.4) tenemos rendimientos más dispersos, donde un valor de nDCG\@10 alto no necesariamente implica un valor de MAP alto.
- En el rango superior (nDCG\@10 > 0.6) la relación se vuelve más predecible. Cuando nuestro sistema de recuperación presenta un rendimiento alto en nDCG\@10, el rendimiento en MAP tiende a ser alto igualmente.

Finalmente, en el rango intermedio se observa la ocurrencia de algunos _outliers_. Como se mencionó anteriormente, nDCG\@10 suele presentar resultados mayores a MAP y, en algunos casos, estas diferencias pueden llegar a ser significativas (por ejemplo, 0.6 frente a 0.1), lo que refleja consultas donde el sistema recupera rápidamente algunos documentos altamente relevantes pero falla en cubrir de forma exhaustiva todos los documentos pertinentes.
\
#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_vs_ap.png"), caption: [Gráfico de dispersión de nDCG\@10 vs MAP]) <Scatter_ndcg10_vs_ap>

\
== Comparación de métodos QPP
\
Los métodos QPP evaluados en esta sección fueron contrastados directamente con los resultados de la evaluación del sistema de recuperación utilizando correlaciones de Pearson, Spearman y tau de Kendall entre las puntuaciones de los predictores y las métricas nDCG\@10 y MAP. La evaluación se realizó sobre cinco conjuntos de datos distintos: _Antique/Test_ (180 consultas), _Cranfield_ (91 consultas), _BEIR-TREC-COVID_ (50 consultas), _MS MARCO (Passage)_ (51 consultas) y _CAR_ (699 consultas). Esta diversidad de colecciones permite evaluar la robustez y generalización de los métodos QPP en diferentes contextos y tamaños de corpus, desde colecciones pequeñas y especializadas hasta grandes colecciones web.

=== Visión general de las correlaciones
\
La @tbl:Resumen_correlaciones_datasets resume, para cada dataset, la correlación de Kendall obtenida por el mejor método QPP respecto a nDCG\@10. Los valores oscilan entre τ = 0.1259 en _CAR_ y τ = 0.4245 en _Antique/Test_, lo que confirma que el nivel de dificultad de la tarea y la calidad de los juicios de relevancia varían significativamente entre colecciones. En general, los mejores métodos alcanzan correlaciones moderadas (τ ≈ 0.3–0.4), coherentes con lo reportado en la literatura para tareas de predicción de rendimiento de consultas.

La tabla rotada de correlaciones multi-dataset que se muestra a continuación (@Resultados_qpp_ndcg10_multidataset_tabla) constituye el núcleo integrador del análisis: en una sola vista recoge, para cada combinación método–dataset, las correlaciones con nDCG\@10 según Pearson (P-ρ), Spearman (S-ρ) y Kendall (K-τ). En ella se aprecia que los métodos post-retrieval, especialmente en sus variantes UEF, tienden a dominar en la mayoría de los datasets, mientras que los métodos pre-retrieval (IDF y SCQ) logran correlaciones más modestas. También se observa el impacto de los juicios multinivel: en _MS MARCO (Passage)_ y _CAR_, donde las ganancias graduadas capturan distintos grados de relevancia, las correlaciones de los métodos más fuertes tienden a ser ligeramente inferiores pero más estables, lo que sugiere que estas colecciones penalizan con mayor severidad los errores de ranking fino.

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
          [$0.164$], [$0.139$], [$0.096$],
          [$0.249$], [$0.186$], [$0.133$],
          [$0.123$], [$0.005$], [$-0.006$],
          [$0.265$], [$0.291$], [$0.209$],
          [$-0.019$], [$-0.007$], [$-0.004$],

          [IDF Máximo],
          [$0.092$], [$0.076$], [$0.051$],
          [$0.117$], [$0.087$], [$0.060$],
          [$0.083$], [$0.030$], [$0.017$],
          [$0.251$], [$0.253$], [$0.168$],
          [$0.018$], [$0.009$], [$0.006$],

          [SCQ Promedio],
          [$0.324$], [$0.266$], [$0.186$],
          [$0.284$], [$0.235$], [$0.162$],
          [$0.074$], [$0.053$], [$0.032$],
          [$0.178$], [$0.182$], [$0.127$],
          [$0.039$], [$0.014$], [$0.010$],

          [SCQ Máximo],
          [$0.379$], [$0.383$], [$0.260$],
          [$0.310$], [$0.276$], [$0.196$],
          [$0.062$], [$0.089$], [$0.055$],
          [$-0.035$], [$0.012$], [$0.030$],
          [$0.065$], [$0.074$], [$0.051$],

          [WIG],
          [$0.436$], [$0.450$], [$0.306$],
          [$0.295$], [$0.324$], [$0.231$],
          [$0.320$], [$0.278$], [$0.201$],
          [$0.552$], [$0.560$], [$0.406$],
          [$0.079$], [$0.099$], [$0.068$],

          [NQC],
          [$0.524$], [$0.567$], [$0.401$],
          [$0.297$], [$0.384$], [$0.269$],
          [$0.192$], [$0.147$], [$0.093$],
          [*$0.553$*], [*$0.585$*], [*$0.408$*],
          [$0.125$], [$0.166$], [$0.114$],

          [Clarity],
          [$0.452$], [$0.430$], [$0.296$],
          [$-0.025$], [$-0.018$], [$-0.015$],
          [$0.477$], [$0.461$], [$0.310$],
          [$0.093$], [$0.068$], [$0.053$],
          [$0.110$], [$0.146$], [$0.101$],

          [UEF-WIG],
          [$0.333$], [$0.377$], [$0.253$],
          [*$0.388$*], [$0.390$], [$0.272$],
          [$0.170$], [$0.192$], [$0.134$],
          [$0.343$], [$0.380$], [$0.253$],
          [$0.121$], [$0.124$], [$0.085$],

          [UEF-NQC],
          [*$0.553$*], [*$0.596$*], [*$0.424$*],
          [$0.359$], [*$0.458$*], [*$0.326$*],
          [$0.182$], [$0.146$], [$0.108$],
          [$0.552$], [$0.560$], [*$0.408$*],
          [*$0.131$*], [*$0.182$*], [*$0.126$*],

          [UEF-Clarity],
          [$0.463$], [$0.448$], [$0.307$],
          [$0.161$], [$0.181$], [$0.120$],
          [*$0.496$*], [*$0.468$*], [*$0.328$*],
          [$0.190$], [$0.186$], [$0.126$],
          [$0.113$], [$0.152$], [$0.105$],
        ),
      ),
      caption: [Correlaciones (P-ρ, S-ρ y K-τ) entre métodos QPP y nDCG\@10 en los distintos datasets evaluados]
    ) <Resultados_qpp_ndcg10_multidataset_tabla>]
}

La @fig:Correlacion_qpp_kendall se mantiene como un estudio de caso detallado para el dataset _antique test_, mostrando el mapa de correlaciones de Kendall entre los distintos métodos QPP y las métricas nDCG\@10 y MAP. Empezando por el lado izquierdo del mapa de correlación se sitúan los dos métodos pre-retrieval IDF y SCQ en sus variantes promedio y máximo; a continuación aparecen los métodos post-retrieval clásicos y, finalmente, sus variantes UEF. El patrón observado en esta figura es consistente con el comportamiento general reportado en las tablas multi-dataset.

\
#figure(image("../assets/imagenes/resultados/correlacion_horizontal_kendall.png"), caption: [Correlación de los métodos QPP en Antique/Test (τ de Kendall)]) <Correlacion_qpp_kendall>

Los detalles numéricos de las correlaciones de Pearson y Spearman para cada combinación método–dataset se incluyen en el Anexo, ya que no aportan conclusiones cualitativamente distintas a las derivadas del análisis con tau de Kendall.

Se observa que la menor de las correlaciones la presenta el método IDF, el cual presenta una correlación no mayor de 0.05 en todas sus variantes. Este resultado viene fuertemente ligado al preprocesado tanto de los documentos como de las consultas, puesto que anteriormente el pipeline de procesado utilizaba el _stemmer_ incorporado por pyterrier, el cual es el clásico _Porter Stemmer_.
Los resultados de este fueron puestos bajo la lupa para corroborar su buen funcionamiento dando los siguientes resultados:

\
#{
  show table.cell.where(y: 0): set text(style: "normal", weight: "bold")
  set table(stroke: (_, y) => if y > 0 { (top: 0.8pt) })
  set table(stroke: (_, y) => if y == 0 { (bottom: 1pt) })
  set align(center)
  [#figure(
    table(
      columns: 4,
      //stroke: none,
      table.vline(x: 2, start: 1),
      align: center + horizon,
      table.header[Porter (pyterrier)][Frecuencia][Snowball(nltk)][Frecuencia],
      [0], [753], [small], [5891],
      [00], [45], [group], [3578],
      [000], [50], [politician], [625],
      [0001], [16], [believ], [12362],

    ),
    caption: [Muestra de términos Porter vs Snowball Stemmers]
  ) <Stemmers_Porter_vs_Snowball> ]
} 
\

Los resultados encontrados en la @tbl:Stemmers_Porter_vs_Snowball muestran que el stemmer de Snowball presenta un rendimiento mayor en la frecuencia de los términos, esto se puede atribuir a que el stemmer de Snowball es más agresivo en la eliminación de sufijos y prefijos, lo cual puede llevar a una mayor cantidad de términos que son relevantes para la recuperación de información. Por otra parte, la pobre calidad en el procesado entregado por el stemmer de Porter justificó su reemplazo por el de Snowball. En una primera versión del experimento, este cambio provocó que la correlación de IDF con nDCG\@10 disminuyera drásticamente (de τ ≈ 0.15 a valores cercanos a 0.05), debido a un manejo inadecuado de términos fuera de vocabulario (VOO) y tokens numéricos. Tras corregir este aspecto del preprocesado, las correlaciones de IDF se recuperaron parcialmente hasta situarse en torno a τ ≈ 0.10 en *Antique/Test* y *Cranfield* y algo por encima en *MS MARCO (Passage)*, aunque siguen siendo las más bajas del conjunto de métodos evaluados. Un estudio más profundo sobre la calidad de los conjuntos de datos y el tratamiento de vocabulario podría ayudar a comprender este efecto de mejor forma.

#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_scq_max.png"), caption: [Correlación de los métodos QPP - tau de Kendall]) <Correlacion_scq>

Por otro lado, el método SCQ muestra un rendimiento significativamente superior al IDF, presentando correlaciones moderadas positivas en el rango de 0.18-0.26 para ambas métricas de evaluación. Este contraste en el rendimiento entre ambos métodos pre-retrieval resulta particularmente interesante, ya que SCQ incorpora tanto la frecuencia de documentos (df) como la frecuencia en la colección (cf) en su cálculo, mientras que IDF se limita únicamente a la frecuencia de documentos.

La superioridad de SCQ se hace más evidente en su variante máxima, alcanzando correlaciones de 0.2596 con nDCG\@10 y 0.2663 con MAP. Estos resultados sugieren que la incorporación de estadísticas adicionales de la colección proporciona una visión más matizada de la importancia de los términos y, por ende, una mejor capacidad predictiva del rendimiento de las consultas. Es notable cómo estos patrones de correlación se mantienen consistentes tanto para nDCG\@10 como para MAP, lo que indica que la efectividad de estos predictores no está sesgada hacia una métrica de evaluación particular.

Si bien una correlación de aproximadamente 0.26 no podría considerarse extremadamente fuerte, representa una mejora significativa sobre el método IDF y sugiere que SCQ captura señales más significativas sobre el potencial rendimiento de las consultas. Este hallazgo tiene implicaciones relevantes para el diseño de sistemas de predicción de rendimiento de consultas, indicando que la incorporación de estadísticas más completas de la colección puede conducir a predicciones más confiables.

La @fig:Correlaciones_qpp_boxplot_kendall muestra el diagrama de caja asociado a cada correlación, como se mencionó anteriormente, el método IDF es el que presenta una menor correlación, mientras que el método UEF-NQC es el que presenta la mayor correlación del grupo con un valor de 0.42 con respecto a nDCG\@10. Se puede apreciar que pese a que la mayoría de los métodos presentan cajas relativamente planas, lo que indica una estabilidad en sus correlaciones, algunos métodos como WIG y UEF-NQC muestran una mayor variabilidad en sus resultados. Particularmente, UEF-NQC exhibe un rango más amplio de correlaciones, con un valor promedio de 0.4 y un mínimo cercano a 0.39, lo que sugiere que su rendimiento, aunque superior, puede ser menos consistente que otros métodos. Esta variabilidad podría atribuirse a la naturaleza más compleja del método, que al incorporar más factores en su cálculo, puede ser más sensible a las características específicas de las consultas.

\
#figure(image("../assets/imagenes/resultados/correlaciones_qpp_boxplot_kendall.png"), caption: [Diagrama de caja de correlaciones métodos QPP vs nDCG\@10 en tau de Kendall]) <Correlaciones_qpp_boxplot_kendall>
\

Los niveles de significancia presentados en la @tbl:Correlaciones_qpp_kendall_table permiten resumir, de forma agregada, los tests de significancia de Kendall obtenidos en el análisis de correlaciones a lo largo de los cinco datasets. Para cada método se promediaron los valores $p$ sobre todas las correlaciones calculadas entre sus puntuaciones y nDCG\@10 o MAP. Se observa que las variantes de IDF y SCQ presentan valores medios de $p$ relativamente altos (en el rango 0.2–0.5), lo que indica que, aunque algunas de sus correlaciones individuales puedan ser significativas en determinados datasets, en promedio su capacidad predictiva es débil y cercana al ruido estadístico. Por el contrario, métodos como WIG, NQC y las variantes UEF tienden a mostrar $p$ medios muy bajos (en torno a 0.01 o inferiores), especialmente en MAP, lo que refuerza la conclusión de que la señal que capturan es sistemáticamente distinta de cero y, por tanto, estadísticamente sólida.

#{
  show table.cell.where(y: 0): set text(style: "normal", weight: "bold")
  set align(center)
  [#figure(
    table(
    columns: 3,
    stroke: (x: none),
    inset: (x: 3pt, y: 7pt),
    row-gutter: (2.2pt, auto),

    table.header[][nDCG\@10][MAP],

    [*IDF AVG*],[$0.4$],[$0.3$],
    [*IDF-Max*],[$0.5$],[$0.5$],
    [*SCQ-AVG*],[$0.3$],[$0.3$],
    [*SCQ-Max*],[$0.3$],[$0.2$],
    [*NQC*],[$0.07$],[$0.05$],
    [*UEF-NQC*],[$0.05$],[$0.04$],
    [*WIG*],[$0.010$],[$0.008$],
    [*UEF-WIG*],[$0.04$],[$0.01$],
    [*Clarity*],[$0.3$],[$0.4$],
    [*UEF-Clarity*],[$0.06$],[$0.1$],
  )
  , caption: [Niveles de significancia de las correlaciones en tau de Kendall]
  ) <Correlaciones_qpp_kendall_table>]
}

\ 

Es particularmente notable que incluso SCQ, que también es un método pre-retrieval y comparte algunas características con IDF, logra en promedio valores de $p$ menores (del orden de 0.2–0.3), lo que indica que sus correlaciones son más frecuentemente significativas que las de IDF, aunque no tan contundentes como las de los métodos post-retrieval. Esto refuerza la hipótesis de que la incorporación de estadísticas adicionales de la colección (como lo hace SCQ) proporciona una base más sólida para la predicción del rendimiento de las consultas.

Los métodos post-retrieval y sus variantes UEF mantienen valores medios de $p$ mucho más bajos (en muchos casos por debajo de 0.05 e incluso cercanos a 0.01), lo que valida su superior capacidad predictiva observada en las correlaciones. Este patrón sugiere que el acceso a la información post-recuperación proporciona señales más confiables para la predicción del rendimiento de las consultas, no solo en términos de magnitud de las correlaciones, sino también en su estabilidad estadística a través de distintos datasets y métricas.

\
#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_nqc.png"), caption: [Gráfico de dispersión de nDCG\@10 vs NQC]) <Scatter_ndcg10_nqc>

\
La @fig:Scatter_ndcg10_nqc muestra la relación entre las puntuaciones del predictor NQC y los valores reales de nDCG\@10. El gráfico revela una correlación positiva moderada (τ = 0.4007) entre las predicciones y el rendimiento real, lo que indica que NQC posee una capacidad predictiva considerable. Esta correlación se visualiza mediante la línea de tendencia naranja, que muestra una pendiente positiva consistente a lo largo del rango de predicción.

Un aspecto notable es la dispersión de los puntos alrededor de la línea de tendencia, particularmente en el rango medio de puntuaciones QPP (0.2-0.4). Esta variabilidad sugiere que la precisión del predictor no es uniforme para todas las consultas, lo cual es un comportamiento esperado en la predicción del rendimiento de consultas debido a la complejidad inherente de la tarea.

Los valores de nDCG\@10 se concentran principalmente entre 0.2 y 0.6, con algunos casos excepcionales que alcanzan hasta 0.8. Esta distribución refleja la diversidad en la dificultad de las consultas en nuestra colección de prueba. Es importante notar la presencia de puntos con nDCG\@10 = 0, que corresponden a consultas donde no se recuperaron documentos relevantes en las primeras 10 posiciones, casos que el método NQC maneja adecuadamente en su implementación.

#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_uef_nqc.png"), caption: [Gráfico de dispersión de nDCG\@10 vs UEF-NQC - tau de Kendall]) <Scatter_ndcg10_uef_nqc_kendall>

\
La @fig:Scatter_ndcg10_uef_nqc_kendall presenta la versión mejorada del predictor NQC mediante el marco UEF, mostrando un incremento en la correlación ($τ = 0.4245$) respecto a su versión base ($τ = 0.4007$). Esta mejora es particularmente significativa ya que refleja un patrón consistente observado en casi todos los predictores post-retrieval al aplicar el marco UEF, con la notable excepción del método WIG, el cual mostró ser más sensible a la cantidad de documentos recuperados.

La mejora en el rendimiento se puede atribuir a la capacidad del marco UEF para incorporar información de la expansión de consultas en el modelo de predicción. Esto se evidencia en la línea de tendencia ligeramente más pronunciada y en bandas de confianza más ajustadas en ciertas regiones del gráfico. El mecanismo subyacente se basa en la correlación entre las puntuaciones de recuperación originales y las de la consulta expandida, donde una alta correlación sugiere una consulta bien formulada y probablemente efectiva.

Es notable cómo UEF-NQC maneja mejor los casos extremos, particularmente en el rango superior de puntuaciones QPP (0.5-0.7), y muestra una predicción más consistente en el rango medio (0.2-0.4). Esta mejora en la capacidad predictiva sugiere que la incorporación del comportamiento de reformulación de consultas en QPP puede conducir a predicciones más confiables, especialmente en consultas desafiantes donde los predictores tradicionales podrían tener dificultades.

\
#figure(
  grid(
    columns: 2,
    image("../assets/imagenes/resultados/scatter_ndcg@10_idf_avg.png"),
    image("../assets/imagenes/resultados/scatter_ndcg@10_idf_max.png")
  ),
  caption: [Gráficos de dispersión de nDCG\@10 vs IDF]
) <Scatter_ndcg10_idf>
\
La @fig:Scatter_ndcg10_idf presenta los gráficos de dispersión para las dos variantes del predictor IDF: promedio y máximo, los cuales presentan la mayor anomalía dentro de los resultados. Ambos gráficos revelan correlaciones extremadamente débiles con los valores de nDCG\@10, con $τ = 0.0451$ para IDF promedio y $τ = -0.0100$ para IDF máximo. Estos resultados son consistentes con los niveles de significancia previamente discutidos ($p >= 0.05$) y refuerzan visualmente la limitada capacidad predictiva del método IDF en nuestro experimento.

Un aspecto notable en ambas variantes es la presencia de heterocedasticidad, es decir, una variación no constante en la dispersión de los valores nDCG\@10 a lo largo del rango de puntuaciones IDF. En el caso de IDF máximo, esta heterogeneidad es particularmente pronunciada en el rango medio (6-8), donde se observa una dispersión en forma de abanico que sugiere una mayor incertidumbre en las predicciones. La variante de IDF promedio muestra un patrón de varianza más estable en el rango medio (4.5-6.5), pero exhibe un incremento notable en la variabilidad alrededor de las puntuaciones 6-7.

Esta variabilidad no uniforme tiene implicaciones importantes para la fiabilidad de las predicciones: sugiere que la capacidad predictiva de IDF no es consistente a través de diferentes tipos de consultas y que la confianza en las predicciones debería ajustarse según el rango de puntuación IDF en que se encuentre la consulta. La presencia de estas regiones de alta incertidumbre, junto con las correlaciones cercanas a cero, indica que el uso directo de IDF como predictor de rendimiento podría no ser apropiado sin modificaciones sustanciales o la incorporación de características adicionales.

Estos resultados apuntan que, a pesar de ser un concepto fundamental en recuperación de información, el uso directo de IDF para la predicción del rendimiento de consultas podría requerir ser complementado con características adicionales o transformado de manera que capture mejor los aspectos cualitativos de las consultas. Esta observación se alinea con el mejor rendimiento observado en SCQ, que extiende el concepto de IDF incorporando estadísticas adicionales de la colección.

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

