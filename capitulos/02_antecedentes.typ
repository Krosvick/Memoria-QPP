#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= MARCO TEÓRICO
\
Conceptos básicos y principios fundamentales...
== Sistemas de Recuperación de Información (IR)
=== Modelos de recuperación de información
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

La obtención humana de qrels suele realizarse mediante campañas de evaluación con anotadores expertos o capacitados, frecuentemente apoyadas en pooling: se agregan los top‑k de múltiples sistemas y se juzga ese subconjunto. Este procedimiento permite cubrir un espacio de resultados amplio con costos controlados, pero introduce incompletitud (no todos los elementos relevantes son juzgados) y sesgos de cobertura ligados a los sistemas incluidos y a la profundidad del pool. La calidad de los juicios depende de guías de anotación, formación y control de calidad (p. ej., acuerdo entre anotadores medido con coeficientes como Cohen’s κ) y de la escala de relevancia empleada; estos factores impactan la estabilidad de las métricas.

Además de la anotación humana, existen alternativas automáticas o semi‑automáticas para derivar qrels. Entre ellas destacan los juicios generados por modelos de lenguaje de propósito general (en esquemas de few‑shot o modelos ajustados), el uso de señales de interacción (clics, tiempo de permanencia) y técnicas de propagación de etiquetas o heurísticas de consenso entre sistemas. Estas vías mejoran cobertura y latencia e incluso facilitan la reutilización de juicios entre múltiples configuraciones (p. ej., mediante cachés de pares consulta–documento ya evaluados), pero requieren validación, trazabilidad y análisis de sesgos; su efectividad depende del dominio, del diseño del prompt o ajuste del modelo y de la profundidad de juicio elegida.

Para la evaluación de métodos de QPP, los qrels son críticos porque (i) fijan las métricas objetivo frente a las que se correlacionan las predicciones (por ejemplo, nDCG a profundidad fija y RR a profundidad fija) y (ii) su calidad, cobertura y profundidad de juicio condicionan la magnitud y la estabilidad de las correlaciones (Pearson, Kendall, Spearman). En consecuencia, resulta imprescindible reportar origen de los juicios (humano, automático o mixto), protocolo de obtención, profundidad y escala de relevancia, así como realizar análisis de sensibilidad (variando la profundidad de corte) y pruebas de significancia para mitigar y evidenciar los efectos de incompletitud y sesgos del pooling.
=== Métricas de evaluación clásicas en IR
=== Protocolos de evaluación de QPP y diseño experimental
=== Métricas de correlación para evaluar métodos QPP
