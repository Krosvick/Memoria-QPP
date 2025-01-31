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

\
Donde se puede observar que el proceso de evaluación involucra métricas de evaluación de recuperación clásicas como nDCG o AP, y más adelante, métricas de correlación de predictores como el tau de Kendall, el cual debido a su naturaleza no lineal, se presenta como una métrica más fuerte frente a otras métricas como el coeficiente de Pearson.

\
== Resultados obtenidos en conjuntos de datos
\
Como se menciono anteriormente, previo a la evaluación de los métodos QPP, es necesario evaluar el sistema de recuperación subyacente, en este caso BM25 utilizando el conjunto de datos _antique test_ y sus 4 niveles de relevancia para sus cerca de 200 consultas proporcionadas.

\
#figure(image("../assets/imagenes/resultados/boxplot_metricas.png"), caption: [Diagrama de caja para las métricas nDCG y AP]) <Boxplot_metricas>

\
En un primer vistazo a los resultados del experimento tenemos que la @fig:Boxplot_metricas muestra que el sistema de recuperación BM-25 presenta un rendimiento mayor en la métrica nDCG\@10 frente a las métrica AP. Ambos experimentos presentan un rango de resultados similar, desde el 0 y sin sobrepasar el 0.8 en ninguno de los casos.

Es posible observar la existencia de _outliers_ en los resultados de la métrica AP, los cuales sobresalen muy por encima en comparación del ultimo cuartil de los resultados. Esto se puede interpretar a que ciertas consultas consiguen resultados muy altos en comparación a las demás, debido a ser frecuentemente representadas en los juicios de relevancia y en la colección de documentos.

La media de las métricas nDCG y AP se puede observar en la @fig:Media_metricas, donde se puede observar que el sistema de recuperación BM-25 presenta un rendimiento mucho mayor en la métrica nDCG\@10 frente a los resultados de AP. Específicamente tenemos una media de 0.36 para nDCG\@10 y 0.18 para AP, lo que evidencia la capacidad del sistema para rankear documentos en las 10 primeras posiciones sobre la precisión de la completitud de los documentos recuperados.

\
#figure(image("../assets/imagenes/resultados/media_metricas.png"), caption: [Media de las métricas nDCG y AP]) <Media_metricas>

\
La @fig:Histogramas_metricas sirve para complementar la información anterior dando una perspectiva más detallada de los resultados obtenidos. Se puede observar que para nDCG\@10 tenemos una distribución ligeramente bimodal, una en 0.2-0.3 y otra en 0.5-0.7, esto se puede interpretar como dos grupos intrínsecamente distintos de consultas, el primero de ellos muestra un rendimiento de nuestro sistema de recuperación más bajo, mientras que el segundo es satisfactoriamente rankeado. Estos hallazgos pueden llevar evaluar que características de las consultas en estos grupos las hacen más fácil o difícil de rankear.

\
#figure(image("../assets/imagenes/resultados/histogramas_metricas.png"), caption: [Histogramas de las métricas nDCG y AP]) <Histogramas_metricas>

\
La @fig:Scatter_ndcg10_vs_ap muestra el gráfico de dispersión de los valores de nDCG\@10 y AP, donde principalmente se puede apreciar la fuerte correlación (r=0.84) que existe entre ambas métricas, lo cual sugiere una calidad de recuperación similar entre ambos experimentos. Sin embargo algo interesante a tener en cuenta es el patrón "palo de hockey" que se forma entre las dos métricas. Esto apunta a que:

- En el rango inferior(nDCG\@10 < 0.4) tenemos rendimientos mas dispersos, donde una valor de nDCG\@10 alto no necesariamente implica un valor de AP alto.
- En el rango superior(nDCG\@10 > 0.6) la relación se vuelve mas predecible. Cuando nuestro sistema de recuperación presenta un rendimiento alto en nDCG\@10, el rendimiento en AP tiende a ser alto igualmente.

Finalmente el rango intermedio tenemos la ocurrencia de algunos _outliers_, como se menciono anteriormente, nDCG\@10 presenta resultados mayores a AP, y en algunos casos estos pueden llegar a contar una diferencia significativa (0.6 vs 0.1).
\
#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_vs_ap.png"), caption: [Gráfico de dispersión de nDCG\@10 vs AP]) <Scatter_ndcg10_vs_ap>

\
== Comparación de métodos QPP
\

Los métodos QPP evaluados en está sección fueron contrastados directamente con los resultados de la evaluación de la sección anterior realizada en el dataset _antique test_ utilizando el coeficiente de correlación tau de Kendall.

La @fig:Correlacion_qpp_kendall muestra el resultado general de la correlación en el tau de Kendall para los métodos QPP a traves de las dos métricas nDCG\@10 y AP. Empezando por el lado izquierdo del mapa de correlación tenemos los dos métodos pre-retrieval IDF y SCQ en sus variantes promedio y máximo, a posteriori, el resto de los métodos son de tipo post-retrieval, terminando por las variantes UEF de estos.


#figure(image("../assets/imagenes/resultados/correlacion_horizontal_kendall.png"), caption: [Correlación de los métodos QPP - tau de Kendall]) <Correlacion_qpp_kendall>

También fueron computadas las correlaciones con el coeficiente de Pearson y Spearman, pero no se presentan en esta sección debido a que no presentan resultados significativamente distintos a los obtenidos en el tau de Kendall. Estos resultados se encuentran en el Anexo.

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
    caption: [Muestra de terminos Porter vs Snowball Stemmers]
  ) <Stemmers_Porter_vs_Snowball> ]
} 
\

Los resultados encontrados en la @tbl:Stemmers_Porter_vs_Snowball muestran que el stemmer de Snowball presenta un rendimiento mayor en la frecuencia de los términos, esto se puede atribuir a que el stemmer de Snowball es más agresivo en la eliminación de sufijos y prefijos, lo cual puede llevar a una mayor cantidad de términos que son relevantes para la recuperación de información. Sin embargo la pobre calidad en el procesado entregado por el stemmer de porter justifico su reemplazo por el de Snowball. Sin embargo, este cambio tuvo como consecuencia un impacto directo a la correlación del método IDF en nDCG\@10, con una disminución de 0.146 a 0.05. La causa principal de este efecto no ha sido investigada profundamente, pero puede deberse a que el _Stemmer_ original procesaba una mayor gamma de tokens comunes en el dataset pero que no se correspondían con ninguna palabra, sino con números o caracteres especiales, que podrían ser abundantes en el corpus. Un estudio mas profundo sobre la calidad de los conjuntos de datos podría ayudar a comprender este efecto de mejor forma.

#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_scq_max.png"), caption: [Correlación de los métodos QPP - tau de Kendall]) <Correlacion_scq>

Por otro lado, el método SCQ muestra un rendimiento significativamente superior al IDF, presentando correlaciones moderadas positivas en el rango de 0.18-0.26 para ambas métricas de evaluación. Este contraste en el rendimiento entre ambos métodos pre-retrieval resulta particularmente interesante, ya que SCQ incorpora tanto la frecuencia de documentos (df) como la frecuencia en la colección (cf) en su cálculo, mientras que IDF se limita únicamente a la frecuencia de documentos.

La superioridad de SCQ se hace más evidente en su variante máxima, alcanzando correlaciones de 0.2596 con nDCG\@10 y 0.2663 con AP. Estos resultados sugieren que la incorporación de estadísticas adicionales de la colección proporciona una visión más matizada de la importancia de los términos y, por ende, una mejor capacidad predictiva del rendimiento de las consultas. Es notable cómo estos patrones de correlación se mantienen consistentes tanto para nDCG\@10 como para AP, lo que indica que la efectividad de estos predictores no está sesgada hacia una métrica de evaluación particular.

Si bien una correlación de aproximadamente 0.26 no podría considerarse extremadamente fuerte, representa una mejora significativa sobre el método IDF y sugiere que SCQ captura señales más significativas sobre el potencial rendimiento de las consultas. Este hallazgo tiene implicaciones relevantes para el diseño de sistemas de predicción de rendimiento de consultas, indicando que la incorporación de estadísticas más completas de la colección puede conducir a predicciones más confiables.

La @fig:Correlaciones_qpp_boxplot_kendall muestra el diagrama de caja asociado a cada correlación, como se menciono anteriormente, el método IDF es el que presenta una menor correlación, mientras que el método UEF-NQC es el que presenta la mayor correlación del grupo con un valor de 0.42 con respecto a nDCG\@10. Se puede apreciar que pese a que la mayoría de los métodos presentan cajas relativamente planas, lo que indica una estabilidad en sus correlaciones, algunos métodos como WIG y UEF-NQC muestran una mayor variabilidad en sus resultados. Particularmente, UEF-NQC exhibe un rango más amplio de correlaciones, con un valor promedio de 0.4 y un mínimo cercano a 0.39, lo que sugiere que su rendimiento, aunque superior, puede ser menos consistente que otros métodos. Esta variabilidad podría atribuirse a la naturaleza más compleja del método, que al incorporar más factores en su cálculo, puede ser más sensible a las características específicas de las consultas.

\
#figure(image("../assets/imagenes/resultados/correlaciones_qpp_boxplot_kendall.png"), caption: [Diagrama de caja de correlaciones métodos QPP vs nDCG\@10 en tau de Kendall]) <Correlaciones_qpp_boxplot_kendall>
\

Los niveles de significancia presentados en la @tbl:Correlaciones_qpp_kendall_table muestran un patrón interesante en cuanto a la confiabilidad estadística de las correlaciones obtenidas. El método IDF, tanto en su variante promedio como máxima, presenta un nivel de significancia $p >= 0.05$, lo que indica que no podemos rechazar la hipótesis nula de que no existe correlación entre las predicciones de IDF y las métricas de rendimiento. Este resultado es consistente con las bajas correlaciones observadas anteriormente y refuerza la conclusión de que IDF, en su implementación actual, no es un predictor confiable del rendimiento de las consultas en nuestro sistema.

#{
  show table.cell.where(y: 0): set text(style: "normal", weight: "bold")
  set align(center)
  [#figure(
    table(
    columns: 3,
    stroke: (x: none),
    inset: (x: 3pt, y: 7pt),
    row-gutter: (2.2pt, auto),

    table.header[][nDCG\@10][AP],

    [*IDF AVG*],[*$>=$0.05*],[*$>=$0.05*],
    [*IDF-Max*],[*$>=$0.05*],[*$>=$0.05*],
    [*SCQ-AVG*],[$<$0.001],[$<$0.001],
    [*SCQ-Max*],[$>$0.001],[$>$0.001],
    [*NQC*],[$>$0.001],[$>$0.001],
    [*UEF-NQC*],[$>$0.001],[$>$0.001],
    [*WIG*],[$<$0.001],[$<$0.001],
    [*UEF-WIG*],[$<$0.001],[$<$0.001],
    [*Clarity*],[$<$0.001],[$<$0.001],
    [*UEF-Clarity*],[$<$0.001],[$<$0.001],
  )
  , caption: [Niveles de significancia de las correlaciones en tau de Kendall]
  ) <Correlaciones_qpp_kendall_table>]
}

\ 
Por otro lado, todos los demás métodos evaluados muestran niveles de significancia $p < 0.001$, lo que indica una muy alta confianza estadística en las correlaciones observadas. Este contraste marcado entre IDF y el resto de los métodos sugiere que la falta de rendimiento de IDF no es un resultado del azar, sino una limitación inherente al método en el contexto específico de nuestro experimento.

Es particularmente notable que incluso SCQ, que también es un método pre-retrieval y comparte algunas características con IDF, logra correlaciones estadísticamente significativas. Esto refuerza la hipótesis de que la incorporación de estadísticas adicionales de la colección (como lo hace SCQ) proporciona una base más sólida para la predicción del rendimiento de las consultas.

Los métodos post-retrieval y sus variantes UEF mantienen niveles de significancia consistentemente altos ($p < 0.001$), lo que valida su superior capacidad predictiva observada en las correlaciones. Este patrón sugiere que el acceso a la información post-recuperación proporciona señales más confiables para la predicción del rendimiento de las consultas.

\
#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_nqc.png"), caption: [Gráfico de dispersión de nDCG\@10 vs NQC]) <Scatter_ndcg10_nqc>

\
La @fig:Scatter_ndcg10_nqc muestra la relación entre las puntuaciones del predictor NQC y los valores reales de nDCG\@10. El gráfico revela una correlación positiva moderada (τ = 0.4007) entre las predicciones y el rendimiento real, lo que indica que NQC posee una capacidad predictiva considerable. Esta correlación se visualiza mediante la línea de tendencia naranja, que muestra una pendiente positiva consistente a lo largo del rango de predicción.

Un aspecto notable es la dispersión de los puntos alrededor de la línea de tendencia, particularmente en el rango medio de puntuaciones QPP (0.2-0.4). Esta variabilidad sugiere que la precisión del predictor no es uniforme para todas las consultas, lo cual es un comportamiento esperado en la predicción del rendimiento de consultas debido a la complejidad inherente de la tarea.

Los valores de nDCG\@10 se concentran principalmente entre 0.2 y 0.6, con algunos casos excepcionales que alcanzan hasta 0.8. Esta distribución refleja la diversidad en la dificultad de las consultas en nuestra colección de prueba. Es importante notar la presencia de puntos con nDCG\@10 = 0, que corresponden a consultas donde no se recuperaron documentos relevantes en las primeras 10 posiciones, casos que el método NQC maneja adecuadamente en su implementación.

#figure(image("../assets/imagenes/resultados/scatter_ndcg@10_uef_NQC.png"), caption: [Gráfico de dispersión de nDCG\@10 vs UEF-NQC - tau de Kendall]) <Scatter_ndcg10_uef_nqc_kendall>

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
== Discusión de los resultados
\

Los resultados obtenidos en este estudio revelan patrones significativos en el rendimiento de los diferentes métodos de predicción de consultas (QPP), proporcionando insights valiosos sobre su efectividad y limitaciones en el contexto de la recuperación de información.

=== Importancia de las correlaciones observadas
\
La evaluación de los métodos QPP mostró un rango de correlaciones que van desde valores cercanos a 0 (IDF) hasta aproximadamente 0.42 (UEF-NQC). Aunque estas correlaciones podrían parecer modestas a primera vista, es importante contextualizarlas dentro del campo de la predicción del rendimiento de consultas. Como se señala en @how-much-correlation-is-good, correlaciones incluso tan bajas como 0.1 pueden tener valor práctico en ciertos contextos, siendo particularmente útiles cuando superan el umbral de 0.5. En este sentido, los resultados obtenidos por métodos como UEF-NQC (τ = 0.4245) y NQC (τ = 0.4007) se acercan a niveles de correlación que pueden considerarse prácticamente significativos.


\
=== Rendimiento de métodos pre-retrieval
\
Un hallazgo particularmente interesante emerge al analizar el comportamiento de los métodos pre-retrieval. Como señala @microsoft-preretrieval, estos métodos son especialmente atractivos debido a su eficiencia computacional, ya que no requieren ejecutar el proceso de recuperación. Sin embargo, nuestros resultados muestran una marcada diferencia entre los dos métodos pre-retrieval evaluados: mientras que IDF mostró correlaciones prácticamente nulas $(τ ≈ 0.05)$, SCQ alcanzó correlaciones moderadas $(τ ≈ 0.26)$.

Esta disparidad sugiere que, si bien los métodos pre-retrieval pueden ser prometedores por su eficiencia, su efectividad depende crucialmente de la sofisticación de sus métricas. El mejor rendimiento de SCQ puede atribuirse a su capacidad para incorporar tanto la frecuencia de documentos como la frecuencia en la colección, proporcionando una vista más completa de la importancia de los términos.

Por ultimo cabe mencionar que el método SCQ presenta mejores resultados en su variante máxima y promedio frente a los benchmarks disponibles en la literatura en el mismo conjunto de datos. @zendel2024qpptk Poniendo en evidencia la importancia del preprocesado de consultas y documentos en la predicción del rendimiento de las consultas.

\
=== Rendimiento de métodos post-retrieval
\
Los resultados demuestran consistentemente que los métodos post-retrieval, particularmente en sus variantes UEF, superan a los métodos pre-retrieval. El método UEF-NQC, con una correlación de τ = 0.4245, representa una mejora significativa sobre los métodos pre-retrieval más efectivos. Esta superioridad sugiere que la información adicional disponible después de la recuperación proporciona señales más confiables para la predicción del rendimiento.

En cuanto a la comparación con otras evaluaciones en la literatura, los métodos se encuentran generalmente en linea o un poco por encima de los resultados de Zendel et al. @zendel2024qpptk, con la única excepción de Clarity, el cual presenta un rendimiento inferior probablemente debido a su enfoque de lenguaje natural y el preprocesado utilizado.

\
=== Complejidad Inherente de la Tarea
\
La dificultad fundamental de predecir el rendimiento de las consultas se evidencia en estudios previos con expertos humanos @humans-cant-predict @user-ratings-vs-system-predictions, donde incluso profesionales con conocimiento profundo de la terminología y sus ambigüedades mostraron una capacidad limitada para predecir el rendimiento de las consultas. Este contexto hace que los resultados obtenidos por los métodos automáticos, particularmente UEF-NQC, sean más apreciables, ya que logran correlaciones moderadas en una tarea inherentemente compleja.

\
=== Implicaciones sobre una linea base experimental
\
Los resultados sugieren varias implicaciones importantes. Primero, la elección entre métodos pre y post-retrieval debe considerar el balance entre eficiencia y efectividad. Mientras que SCQ ofrece un compromiso razonable, logrando correlaciones moderadas sin el costo computacional de la recuperación, los métodos post-retrieval como UEF-NQC proporcionan predicciones significativamente más confiables cuando el tiempo de procesamiento no es una limitación crítica.

Segundo, la variabilidad en el rendimiento observada en el análisis de dispersión sugiere que podría ser beneficioso desarrollar métodos híbridos que combinen las fortalezas de diferentes predictores, potencialmente adaptando la estrategia de predicción según las características específicas de la consulta.

En tercer lugar, aun con los resultados prometedores obtenidos en ciertos casos como NQC y UEF-NQC, cabe recalcar que las correlaciones siguen siendo aun bajas para la mayoría de los métodos, lo cual sugiere que la tarea de predecir el rendimiento de las consultas sigue siendo una tarea compleja y que el desarrollo de métodos más sofisticados que puedan capturar mejor los matices que afectan el rendimiento de la recuperación de información sigue siendo una tarea pendiente.


