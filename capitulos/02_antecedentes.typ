#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= MARCO TEÓRICO
\
== Sistemas de Recuperación de Información (IR)
\
El campo de la Recuperación de Información (IR) se centra en el estudio de métodos y sistemas que permiten localizar, dentro de grandes colecciones de documentos, aquellos que respondan de mejor forma a una necesidad informativa expresada por el usuario a través de una consulta o query. Este proceso implica identificar, clasificar y ordenar documentos según su grado de relevancia, apoyándose en modelos matemáticos y estadísticos que describen la relación entre las palabras de la consulta y el contenido del corpus. En la práctica, los sistemas de recuperación de información sustentan desde buscadores web hasta repositorios científicos y bases de datos digitales. @Query-difficulty-definition.

De esta forma, el propósito fundamental de un sistema IR consiste en maximizar la relevancia de los resultados y minimizar el ruido, es decir, la cantidad de documentos menos pertinentes dentro del conjunto de datos recuperado. Esta función se ha vuelto crítica frente al crecimiento exponencial de la información que disponemos en formato digital, donde la eficiencia en las búsquedas y la organización del conocimiento determinan la calidad de la experiencia informativa. Además, como se menciona en el artículo @microsoft-preretrieval, la efectividad de un sistema IR no depende únicamente del modelo de recuperación utilizado, sino también de la formulación de la consulta y de la naturaleza del corpus.

En este sentido, la Recuperación de Información no solo constituye la base de los sistemas de búsqueda automatizada, sino también establece un punto de partida para la comprensión del comportamiento de las consultas, el análisis de su dificultad y la estimación del rendimiento, siendo estos los aspectos centrales para la presente investigación, cuyo objetivo se orienta en evaluar distintos métodos de predicción sobre el desempeño de consultas en modelos clásicos de recuperación de información.

=== Modelos de recuperación de información.
\
Los modelos de recuperación de información constituyen el núcleo de un sistema IR, ya que estos definen cómo se mide la relevancia entre una consulta y los documentos del corpus. Estos modelos, además de definir formalmente la manera en que los términos de una consulta se comparan con las representaciones internas de los documentos, permiten calcular una puntuación o ranking de relevancia. Es así que, a lo largo de los años, se han desarrollado tres enfoques principales: el modelo booleano, el modelo vectorial y el modelo probabilístico, cada uno con sus propias ventajas y limitaciones. @microsoft-preretrieval @zendel2024qpptk.

El modelo booleano fue el primero en ser implementado y se basa en la lógica clásica de operadores como AND, OR y NOT. En este enfoque, un documento es recuperado únicamente si cumple con las condiciones lógicas impuestas por la consulta realizada, sin establecer grados intermedios de relevancia. Si bien, este modelo es eficiente en contextos cerrados debido a su simplicidad, carece de una capacidad para ordenar los resultados, lo que limita su utilidad en escenarios de búsquedas más complejos. @Query-difficulty-definition.

Por otra parte, el modelo vectorial introdujo una representación algebraica tanto para los documentos como para las consultas, tratándolos como vectores en un espacio multidimensional, en el que cada dimensión corresponde a un término y los pesos asignados reflejan su importancia relativa. La similitud entre consulta y documento se mide, por lo general, mediante el coseno entre los vectores. Este particular enfoque permitió establecer rankings de relevancia y representó un avance significativo en la precisión de los sistemas IR. @zendel2024qpptk.

Finalmente, el modelo probabilístico se basa en estimar la probabilidad de relevancia de un documento a través de una consulta, en donde su versión más consolidada, el BM25, calcula dicha probabilidad a partir de la frecuencia de los términos en el documento y su frecuencia inversa en el corpus, normalizando además por la longitud del texto. En este aspecto, BM25 ofrece equilibrio entre simplicidad, interpretabilidad y desempeño, razón por la cual es el modelo base en la mayoría de los experimentos y benchmarks actuales de IR. @zendel2024qpptk.

=== Componentes de un sistema de recuperación de información.
=== Consultas, tópicos y búsquedas Ad-hoc


== Predicción de Rendimiento de Consultas (QPP)
=== Dificultad y rendimiento de las consultas
=== Soluciones al problema de la dificultad de las consultas
=== Taxonomías en QPP
\
La literatura distingue dos categorías principales de predictores de rendimiento de consulta según el momento en que extraen información: métodos pre-retrieval y post-retrieval. Los primeros formalmente se caracterizan por actuar antes de ejecutar la búsqueda utilizando únicamente la consulta y estadísticas del índice; los segundos explotan señales observadas en la lista recuperada a partir de un modelo de recuperación de información (p. ej., patrones en las puntuaciones y funciones de ranking	).@wig-nqc-scored-configuration

En paralelo, al adentrarnos en el campo de la inteligencia artificial, podemos encontrar otras categorías de clasificación por ejemplo, régimen de aprendizaje (no supervisados frente a supervisados) y por entorno (búsqueda ad-hoc y conversacional), cuyas elecciones implican compromisos entre costo computacional, latencia y capacidad para modelar fenómenos como ambigüedad, deriva temática y distribución de puntuaciones. @Meng2023QPP @web-search-qpp.

==== Predictores pre-retrieval
Los predictores pre-retrieval estiman la dificultad de una consulta a priori, sin ejecutar recuperación. Se apoyan en propiedades intrínsecas de la consulta y en estadísticas globales de la colección disponibles en tiempo de indexación. De forma general, caracterizan la especificidad y ambigüedad de la consulta, así como su potencial discriminativo en la colección, a partir de medidas resumidas que capturan propiedades léxicas de la consulta (longitud, diversidad o concentración de términos) y el patrón con que dichos términos aparecen en la colección (frecuencia y variabilidad entre documentos). Su atractivo radica en el bajo costo computacional y en que permiten decisiones de control (p. ej., expansión, selección de sistema o ajuste de parámetros) antes de observar una lista recuperada.

==== Predictores post-retrieval
Los predictores post-retrieval se calculan tras obtener una lista recuperada para la consulta y se basan en señales observables en dicha lista. En términos generales, explotan: (i) el comportamiento de las puntuaciones devueltas por el ranker (magnitud, dispersión, forma y separabilidad entre tope y cola), (ii) la coherencia y consistencia semántica de los documentos tope, (iii) la estabilidad del ranking ante perturbaciones controladas (robustez), y (iv) el acuerdo con variantes del sistema o de la consulta (consenso entre modelos). Estas familias de señales buscan capturar indicios de “fácil/difícil” al observar cómo responde el sistema para la consulta concreta.

Los enfoques post-retrieval pueden ser no supervisados (agregan señales derivadas de la propia lista devuelta) o supervisados (aprenden a mapear representaciones de consulta-lista a una estimación de rendimiento). Su efectividad depende del tipo de recuperador (léxico o denso), de la profundidad considerada (top-k frente a listas profundas) y de las propiedades de la colección, dado que distintas distribuciones de puntuaciones y estructuras de ranking favorecen señales diferentes. Aunque su costo es mayor que el de los métodos pre-retrieval, suelen proporcionar estimaciones más informadas al incorporar evidencia del resultado concreto de recuperación.

=== Aplicaciones de QPP en IR

=== Supuestos, limitaciones y amenazas a la validez



== Métricas de Evaluación de Rendimiento y Correlación
=== Juicios de relevancia (Qrels)
Los juicios de relevancia (qrels) son las etiquetas que, para cada consulta, indican qué elementos del corpus son relevantes y con qué grado (binario o multigrado). Operan como referencia objetiva para calcular métricas de efectividad a nivel de consulta y de colección y, por tanto, constituyen el “suelo de verdad” frente al cual se contrastan sistemas de recuperación y estimadores de rendimiento. Su definición y disponibilidad condicionan de forma directa la interpretación de resultados y la comparabilidad entre trabajos.

La obtención humana de qrels suele realizarse mediante campañas de evaluación con anotadores expertos o capacitados, frecuentemente apoyadas en pooling: es decir se agregan los top‑k resultantes de múltiples sistemas y se juzga ese subconjunto. Este procedimiento permite cubrir un espacio de resultados amplio con costos controlados, pero introduce incompletitud (no todos los elementos relevantes son juzgados) y sesgos de cobertura ligados a los sistemas incluidos y a la profundidad del pool. La calidad de los juicios depende de guías de anotación, formación y control de calidad (p. ej., acuerdo entre anotadores medido con coeficientes como Cohen’s κ) y de la escala de relevancia empleada; estos factores por ende tienen un impacto directo en la estabilidad de las métricas.

Para la evaluación de métodos de QPP, los qrels son de una gran importancia dado que (i) fijan las métricas objetivo frente a las que se correlacionan las predicciones (por ejemplo, nDCG a profundidad fija o AP a profundidad fija) y (ii) su calidad, cobertura y profundidad de juicio condicionan la magnitud y la estabilidad de las correlaciones (Pearson, Kendall, Spearman). En consecuencia, resulta imprescindible reportar origen de los juicios (humano, automático o mixto), protocolo de obtención, profundidad y escala de relevancia, así como realizar análisis de sensibilidad (variando la profundidad de corte) y pruebas de significancia para mitigar y evidenciar los efectos de incompletitud y sesgos de la extracción.
=== Métricas de evaluación clásicas en IR
=== Protocolos de evaluación de QPP y diseño experimental
=== Métricas de correlación para evaluar métodos QPP
