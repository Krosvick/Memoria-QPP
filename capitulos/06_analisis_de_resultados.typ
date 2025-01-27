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
A traves de la literatura se ha establecido de manera casi unanime el análisis del rendimiento de los métodos QPP mediante el uso de métricas de correlación. Seminalmente se puede encontrar el trabajo de Voorhees en la conferencia TREC-6, donde se presenta el primer análisis de la capacidad de expertos en predecir el rendimiento de las consultas, donde se pudo observar que la mayor correlación lineal entre los resultados de los expertos fue de solo 0.26. @trec-6.

El campo de la predicción del rendimiento de consultas se ha desarrollado a lo largo de los años, y se ha establecido el uso de juicios de relevancia y métricas como el tau de Kendall para la evaluación de los predictores. En este sentido, se encuentran dos puntos de interes, por un lado la evaluación del sistema de recuperación subyacente, y por otro la evaluación de los predictores utilizando como pre-requisito la evaluación del sistema de recuperación.

La configuración utilizada para el experimento se presenta en el diagrama @fig:Diagrama_evaluación_resultados
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
    blob((-2,2), [R. de recuperación], shape: chevron, tint: yellow, name: "run"),
    blob((-2,0), [Puntuaciones QPP], shape: chevron, tint: yellow, name: "qpp"),

    // Processing Steps
    blob((0,3), [Evaluación de recuperación], shape: hexagon, tint: orange, name: "eval"),
    blob((0,1), [Análisis de correlación], shape: hexagon, tint: orange, name: "analysis"),
    
    // Metrics & Outputs
    blob((2.3,4), [Métricas nDCG/AP], tint: green, name: "metrics"),
    blob((2.3,2), [Resultados de \
    correlación], tint: green, name: "scores"),
    blob((2.3,0), [Reporte \ estadístico], tint: green, name: "report"),

    // Connections using proper edge syntax
    edge(<qrels>, <eval>, "-|>"),
    edge(<run>, <eval>, "-|>"),
    edge(<eval>, <metrics>, "-|>", label: [Utiliza]),
    
    edge(<qpp>, <analysis>, "-|>"),
    edge(<eval>, <analysis>, "-|>", label: [Resultados]),
    edge(<analysis>, <scores>, "-|>"),
    edge(<analysis>, <report>, "-|>"),
    
  ),
  caption: [Diagrama de flujo del análisis de resultados]
) <Diagrama_evaluación_resultados>

Donde se puede observar que el proceso de evaluación involucra métricas de evaluación de recuperación clasicas como nDCG y AP, y métricas de correlación de predictores como el tau de Kendall, el cual debido a su naturaleza no lineal, se presenta como una metrica más fuerte frente a otras métricas como el coeficiente de Pearson.

\
== Resultados obtenidos en conjuntos de datos
\
Como se menciono anteriormente, previo a la evaluación de los métodos QPP, es necesario evaluar el sistema de recuperación subyacente, en este caso BM25 utilizando el conjunto de datos _antique test_ y sus 4 nivele de juicios de relevancia en sus 200 consultas proporcionadas.
#figure(image("../assets/imagenes/resultados/boxplot_metricas.png"), caption: [Boxplot de las métricas nDCG y AP]) <Boxplot_metricas>

En un primer vistazo a los resultados del experimento tenemos que la @fig:Boxplot_metricas muestra que el sistema de recuperación BM-25 presenta un rendimiento mayor en la métrica nDCG\@10 frente a las métrica AP. Ambos experimentos presentan un rango de resultados similar, desde el 0 y sin sobrepasar el 0.8 en ninguno de los casos.

Es posible observar la existencia de _outliers_ en los resultados de la métrica AP, los cuales sobresalen muy por encima en comparación del ultimo cuartil de los resultados. Esto se puede interpretar a que ciertas consultas consiguen resultados muy altos en comparación a las demás, debido a ser frecuentemente representadas en los juicios de relevancia y en la colección de documentos.

La media de las métricas nDCG y AP se puede observar en la @fig:Media_metricas, donde se puede observar que el sistema de recuperación BM-25 presenta un rendimiento mucho mayor en la métrica nDCG\@10 frente a los resultados de AP. Especificamente tenemos una media de 0.36 para nDCG\@10 y 0.18 para AP, lo que evidencia la capacidad del sistema para rankear documentos en las 10 primeras posiciones sobre la precisión de la completitud de los documentos recuperados.

#figure(image("../assets/imagenes/resultados/media_metricas.png"), caption: [Media de las métricas nDCG y AP]) <Media_metricas>

\
La @fig:Histogramas_metricas sirve para complementar la información anterior dando una perspectiva más detallada de los resultados obtenidos. Se puede observar que para nDCG\@10 tenemos una distribución ligeramente bimodal, una en 0.2-0.3 y otra en 0.5-0.7, esto se puede interpretar como dos grupos intrinsicamente distintos de consultas, el primero de ellos muestra un rendimiento de nuestro sistema de recuperación más bajo, mientras que el segundo es satisfactoriamente rankeado. Estos hallazgos pueden llevar evaluar que caracteristicas de las consultas en estos grupos las hacen más fácil o dificil de rankear.

\
#figure(image("../assets/imagenes/resultados/histogramas_metricas.png"), caption: [Histogramas de las métricas nDCG y AP]) <Histogramas_metricas>

\
La @fig:Scatter_ndcg10_vs_ap muestra el grafico de dispersión de los valores de nDCG\@10 y AP, donde principalmente se puede apreciar la fuerte correlación (r=0.84) que existe entre ambas métricas, lo cual sugiere una calidad de recuperación similar entre ambos experimentos. Sin embargo algo interesante a tener en cunta es el patron "palo de hockey" que se forma entre las dos métricas. Esto sugiere que:

- En el rango inferior(nDCG\@10 < 0.4) tenemos rendimientos mas dispersos, donde una valor de nDCG\@10 alto no necesariamente implica un valor de AP alto.
- En el rango superior(nDCG\@10 > 0.6) la relación se vuelve mas predecible. Cuando nuestro sistema de recuperación presenta un rendimiento alto en nDCG\@10, el rendimiento en AP tiende a ser alto igualmente.

Finalmente el rango intermedio tenemos la ocurrencia de algunos _outliers_, como se menciono anteriormente, nDCG\@10 presenta resultados mayores a AP, y en algunos casos estos pueden llegar a contar una diferencia significativa (0.6 vs 0.1).
\
#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_vs_ap.png"), caption: [Grafico de dispersión de nDCG\@10 vs AP]) <Scatter_ndcg10_vs_ap>

\
== Comparación de métodos QPP
\

Los metodos QPP evaluados en está sección fueron contrastados directamente con los resultados de la evaluación de la sección anterior realizada en el dataset _antique test_ utilizando el coeficiente de correlación tau de Kendall.

La @fig:Correlacion_qpp_kendall muestra el resultado general de la correlación de los métodos QPP a traves de las dos metricas nDCG\@10 y AP. Empezando por el lado izquierdo del mapa de correlación tenemos los dos métodos pre-retrieval IDF y SCQ en sus variantes promedio y máximo, a posteriori, el resto de los métodos son de tipo post-retrieval, terminando por las variantes UEF de estos.

Se observa que la menor de las correlaciones la presenta el método IDF, el cual presenta una correlación no mayor de 0.05 en todas sus variantes. Este resultado viene fuertemente ligado al preprocesado tanto de los documentos como de las consultas, puesto que anteriormente el pipeline de procesado utilizaba el _stemmer_ incorporado por pyterrier, el cual es el clasico _Porter Stemmer_.
Los resultados de este fueron puestos bajo la lupa para corroborar su buen funcionamiento dando los siguientes resultados:

#show table.cell.where(x: 0): set text(style: "italic")
#show table.cell.where(y: 0): set text(style: "normal", weight: "bold")
#set table(stroke: (_, y) => if y > 0 { (top: 0.8pt) })

#set align(center)
#figure(
  table(
    columns: 4,
    align: center + horizon,
    table.header[Porter(pyterrier)][Frecuencia][Snowball(nltk)][Frecuencia],
    [0], [753], [small], [5891],
    [00], [45], [group], [3578],
    [000], [50], [politician], [625],
    [0001], [16], [Believ], [12362],

  ),
  caption: [Muestra de terminos Porter vs Snowball Stemmers]
) <Stemmers_Porter_vs_Snowball>
#set align(left)
Los resultados encontrados en la @tbl:Stemmers_Porter_vs_Snowball muestran que el stemmer de Snowball presenta un rendimiento mayor en la frecuencia de los terminos, esto se puede atribuir a que el stemmer de Snowball es más agresivo en la eliminación de sufijos y prefijos, lo cual puede llevar a una mayor cantidad de terminos que son relevantes para la recuperación de información. Sin embargo la pobre calidad en el procesado entregado por el stemmer de porter justifico su reemplazo por el de Snowball. Sin embargo, este cambio tuvo como consecuencia un impacto directo a la correlación del metodo IDF en ndcg\@10, con una disminución de 0.146 a 0.05. La causa principal de este efecto no ha sido investigada profundamente, pero puede deverse a que el _Stemmer_ original procesaba una mayor gamma de tokens comunes en el dataset pero que no se correspondian con ninguna palabra, sino con números o caracteres especiales, que podrian ser abudantes en el corpus. Un estudio mas profundo sobre la calidad de los conjuntos de datos podria ayudar a entender este efecto.

#figure(image("../assets/imagenes/resultados/correlacion_horizontal_kendall.png"), caption: [Correlación de los métodos QPP - tau de Kendall]) <Correlacion_qpp_kendall>
#figure(image("../assets/imagenes/resultados/correlaciones_qpp_boxplot_kendall.png"), caption: [Boxplot de las correlaciones de los métodos QPP - tau de Kendall]) <Correlaciones_qpp_boxplot_kendall>
#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_idf_avg.png"), caption: [Grafico de dispersión de nDCG\@10 vs IDF-avg]) <Scatter_ndcg10_idf_avg>
#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_idf_max.png"), caption: [Grafico de dispersión de nDCG\@10 vs IDF-max - tau de Kendall]) <Scatter_ndcg10_idf_max_kendall>
#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_nqc.png"), caption: [Grafico de dispersión de nDCG\@10 vs NQC]) <Scatter_ndcg10_nqc>
#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_uef_NQC.png"), caption: [Grafico de dispersión de nDCG\@10 vs UEF-NQC - tau de Kendall]) <Scatter_ndcg10_uef_nqc_kendall>

== Discusión de los resultados
\