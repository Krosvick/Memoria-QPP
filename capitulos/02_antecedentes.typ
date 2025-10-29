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
La predicción del rendimiento de consultas (QPP), también conocida como estimación de la dificultad de la consulta (QDE), representa una dirección de investigación fundamental en el campo de la Recuperación de Información (IR). Su propósito principal es predecir la calidad de los resultados de búsqueda para una consulta dada, recuperados por un sistema de recuperación específico, sin necesidad de información de relevancia proporcionada por un operador humano. Este desafío surge de la observación de que los sistemas de búsqueda a menudo fallan en responder eficazmente a ciertas consultas, lo que se asocia directamente con la noción de dificultad de la consulta.

La diversidad en el rendimiento de las consultas y entre diferentes sistemas ha impulsado esta área, buscando mitigar la variabilidad en la efectividad de la recuperación. En este sentido, QPP cumple un rol netamente preventivo: anticipar la dificultad para activar ajustes selectivos (p. ej., expansión, elección de parámetros o flujos alternativos) antes de observar fallos, reduciendo la variabilidad y mejorando la experiencia del usuario.

=== Dificultad y rendimiento de las consultas
La dificultad de una consulta, en el ámbito de la Recuperación de Información (IR), se asocia principalmente con la incapacidad de un sistema para responder de manera efectiva a una necesidad de información específica. Una consulta se considera "difícil" cuando el sistema de búsqueda obtiene un rendimiento deficiente en términos de sus medidas de efectividad. Este concepto es fundamental, ya que los fallos del sistema suelen estar directamente relacionados con la complejidad inherente o contextual de la consulta, lo que subraya la importancia de su predicción en la mejora continua de los sistemas de IR. La noción de dificultad de la consulta no es unívoca, y su interpretación puede variar dependiendo del contexto, la ambigüedad de la consulta y el sistema de recuperación utilizado (@Query-difficulty-definition).

En contraste, el rendimiento de una consulta se define como una forma de estimar la dificultad inherente de la misma, mediante diversos experimentos de recuperación que generan múltiples métricas relacionadas con la calidad de los resultados obtenidos por el sistema. Estas métricas, obtenidas a través de experimentos que evalúan el ranking de documentos recuperados contra juicios de relevancia humana (qrels), incluyen nDCG, Recall, RR y AP, entre otras. Cada experimento de recuperación produce estas métricas simultáneamente sobre la misma lista ordenada de documentos, permitiendo una evaluación multidimensional de la efectividad del sistema. Un alto rendimiento en estas métricas indica una consulta "fácil" con baja dificultad inherente, mientras que valores bajos sugieren una consulta "difícil" que desafía la capacidad del sistema para satisfacer la necesidad informativa del usuario. La predicción de este rendimiento constituye el núcleo de QPP, buscando estimar estas métricas sin requerir juicios humanos de relevancia.

La interdependencia entre la dificultad y el rendimiento de las consultas es crucial. Una consulta inherentemente difícil, ya sea por su ambigüedad, la escasez de documentos relevantes en el corpus, o la formulación ineficaz, tenderá a producir un bajo rendimiento en la mayoría de los sistemas de IR. Por lo tanto, estimar la dificultad de la consulta es, en esencia, un intento de predecir el rendimiento que un sistema específico logrará para esa consulta. Esta predicción permite a los sistemas anticipar posibles fallos y aplicar estrategias correctivas de manera proactiva, mejorando la experiencia del usuario y la eficiencia general del sistema.

Los factores que contribuyen a la dificultad de una consulta son variados y complejos. Pueden estar relacionados con la expresión misma de la consulta, como la ambigüedad léxica o semántica, o con su longitud y especificidad. Otro conjunto de factores se deriva del conjunto de datos o corpus, incluyendo su heterogeneidad, la distribución de términos y la cantidad de documentos relevantes disponibles. Finalmente, el método de recuperación empleado también influye en la dificultad percibida, ya que diferentes algoritmos pueden manejar la misma consulta con distintos niveles de éxito. Esta multifactorialidad hace que la predicción de la dificultad sea un desafío significativo.

La "generalidad" de la dificultad de una consulta es un aspecto clave a considerar. Una consulta puede ser difícil para un sistema de recuperación particular, pero no para otros, o puede ser consistentemente difícil a través de una variedad de sistemas y colecciones. Esta generalidad se mide a menudo promediando el rendimiento predicho de la consulta a través de múltiples métodos de recuperación y diversas colecciones de documentos. Comprender esta variabilidad es esencial para desarrollar predictores que sean robustos y aplicables en diferentes escenarios de búsqueda, más allá de un único contexto sistema-colección.

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
#let component(pos, label, tint: white, ..args) = node(
  pos,
  align(center, label),
  width: 40mm,
  fill: tint.lighten(80%),
  stroke: 1pt + tint.darken(10%),
  corner-radius: 5pt,
  ..args,
)
#v(10pt)
=== Soluciones al Problema de la Dificultad de las Consultas
\
La dificultad inherente de ciertas consultas ha impulsado el desarrollo de técnicas robustas para mejorar la efectividad de los sistemas de recuperación de información. A lo largo del tiempo, las soluciones han evolucionado desde métodos estadísticos clásicos hasta arquitecturas neuronales avanzadas, buscando siempre mitigar los fallos de recuperación asociados a consultas ambiguas, complejas o con desajuste de vocabulario.

Una de las primeras y más influyentes soluciones fue el desarrollo de *modelos de relevancia*. En lugar de depender exclusivamente de los términos de la consulta original, esta técnica utiliza un proceso de dos etapas para refinar la búsqueda. 

Primero, se realiza una recuperación inicial y se asume que los documentos mejor clasificados son relevantes (un concepto conocido como _pseudo-relevance feedback_). A partir de este conjunto de documentos, se construye un modelo probabilístico que estima la distribución de términos que probablemente aparecerían en documentos verdaderamente relevantes. Los términos con alta probabilidad en este modelo, que pueden no haber estado en la consulta original, se utilizan para expandir o reestructurar la consulta. 

Finalmente, esta nueva "consulta expandida" se utiliza para realizar una segunda recuperación, que a menudo produce un ranking de resultados mucho más preciso, abordando eficazmente problemas de sinonimia y polisemia @relevance-models.

#figure(
  diagram(
    spacing: 5pt,
    cell-size: (8mm, 8mm),
    edge-stroke: .8pt,

    component((2,0), [Consulta \ Inicial], tint: purple, name: "query"),
    blob((5,0), [Recuperación \ Inicial (BM25)], shape: hexagon, tint: yellow, name: "retrieval1", width: 40mm, height: 20mm),
    component((8,0), [Top-K \ Documentos], tint: blue, name: "topk"),
    component((8,2), [Estimación del \ Modelo \ de Relevancia], tint: blue, name: "rm"),
    component((8,4), [Consulta \ Expandida], tint: purple, name: "new_query"),
    blob((5,4), [Recuperación \ Final], shape: hexagon, tint: yellow, name: "retrieval2", width: 40mm, height: 20mm),
    component((2,4), [Ranking Final \ de  Documentos], tint: green, name: "final_list"),

    edge(<query>, <retrieval1>, "->"),
    edge(<retrieval1>, <topk>, "->"),
    edge(<topk>, <rm>, "->"),
    edge(<rm>, <new_query>, "->", $"Nuevos términos y pesos"$, label-pos: 0.6, label-side: center),
    edge(<new_query>, <retrieval2>, "->"),
    edge(<retrieval2>, <final_list>, "->"),
  ),
  caption: "Flujo de un sistema de recuperación basado en Modelos de Relevancia.",
) <fig:relevance-model-flow>

\

Más recientemente, la llegada de los *Modelos de Lenguaje Grandes* (LLMs) ha supuesto un avance significativo en el panorama de la recuperación de información. Sin embargo, uno de sus mayores problemas es que su conocimiento se "congela" en el momento del entrenamiento, lo que limita su acceso a información reciente y los hace propensos a "alucinar" o generar contenido incorrecto. 

Para superar estas limitaciones, ha surgido el paradigma de la *Generación Aumentada por Recuperación* (RAG). Los modelos RAG combinan un recuperador de información con un LLM generativo en un proceso de dos fases:

1.  *Recuperación*: Un sistema de recuperación busca en una base de conocimiento (por ejemplo, una colección de documentos) para encontrar fragmentos de texto relevantes para la consulta.
2.  *Generación*: Estos fragmentos recuperados se proporcionan como contexto a un LLM junto con la consulta original. El LLM sintetiza una respuesta coherente y factual, fundamentada en la evidencia extraída.

Este enfoque ancla las respuestas del LLM en información verificable, reduciendo las alucinaciones y permitiendo que el conocimiento del sistema se actualice simplemente actualizando la base de conocimiento documental. Es una técnica especialmente poderosa para consultas de conocimiento intensivo que demandan respuestas precisas y actualizadas @RAG.

A pesar de su efectividad, estas soluciones avanzadas—desde la expansión de consultas hasta los complejos _pipelines_ de RAG—suelen tener un costo computacional elevado. No es eficiente ni necesario aplicarlas a todas las consultas, especialmente a aquellas que son simples y pueden ser respondidas adecuadamente por un sistema de recuperación estándar.

Aquí es donde la *Predicción del Rendimiento de Consultas* (QPP) adquiere un rol crucial. QPP funciona como una herramienta de diagnóstico que estima de antemano la efectividad esperada de un sistema para una consulta dada, sin necesidad de juicios de relevancia humanos. Al predecir si una consulta será "fácil" o "difícil", un sistema de IR puede tomar decisiones proactivas y selectivas. Para una consulta predicha como "fácil", se puede utilizar un método de recuperación rápido y eficiente. En cambio, si una consulta se predice como "difícil", el sistema puede activar mecanismos más potentes y costosos, como la expansión de consultas, el uso de modelos de relevancia o la activación de un _pipeline_ de RAG para garantizar una respuesta de alta calidad. De este modo, QPP permite a los sistemas de IR gestionar sus recursos de manera inteligente, mejorando la robustez y la eficiencia general al tiempo que se mitigan los fallos en las consultas más desafiantes @query-difficulty-book.

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

La capacidad de predecir el rendimiento de una consulta abre un amplio abanico de aplicaciones prácticas que permiten a los sistemas de recuperación de información (IR) operar de manera más inteligente, robusta y eficiente. En lugar de tratar todas las consultas de la misma manera, los sistemas pueden utilizar los predictores de QPP para adaptar dinámicamente su comportamiento. Sin embargo, la utilidad de estas aplicaciones depende críticamente de la calidad del predictor: se requiere una correlación moderadamente alta entre el rendimiento predicho y el real para que estas estrategias mejoren de manera fiable la efectividad del sistema @how-much-correlation-is-good.

==== Activación Selectiva de Mecanismos Avanzados
Como se mencionó anteriormente, técnicas como la expansión de consultas mediante modelos de relevancia o el uso de arquitecturas complejas como RAG son computacionalmente costosas. Sobre este punto, QPP funciona como una herramienta de diagnóstico que estima de antemano la efectividad esperada. Si una consulta se predice como "difícil", el sistema puede activar estos mecanismos más potentes para garantizar una respuesta de alta calidad. En cambio, para una consulta predicha como "fácil", se puede utilizar un método de recuperación estándar, optimizando así el uso de recursos sin sacrificar la calidad en los casos necesarios @query-difficulty-book.

==== Expansión Selectiva de Consultas
La retroalimentación de pseudo-relevancia (_pseudo-relevance feedback_, PRF) es una técnica común para expandir consultas, pero su aplicación indiscriminada tiene consecuencias negativas. Si los documentos mejor clasificados iniciales no son relevantes, los términos añadidos pueden desviar el enfoque de la consulta original, un fenómeno conocido como _query drift_. Este desvío a menudo degrada el rendimiento en lugar de mejorarlo.

Los predictores QPP permiten una aplicación más segura de esta técnica. Si se predice que una consulta tendrá un bajo rendimiento, se considera como una buena candidata para la expansión, ya que el potencial de mejora es elevado y el riesgo de empeorar un resultado ya pobre es negligible. Por el contrario, si se predice que una consulta ya es efectiva, aplicar la expansión podría ser innecesario o incluso perjudicial. De este modo, la predicción actúa como un guardián, aplicando la expansión solo cuando es probable que sea beneficiosa @query-drift.

==== Búsqueda Federada y Metabúsqueda
En entornos donde los resultados provienen de múltiples colecciones o motores de búsqueda, la QPP es fundamental para la fusión inteligente de resultados. En la *metabúsqueda*, se consultan varios motores de búsqueda, mientras que en la *búsqueda federada*, se busca en múltiples colecciones con un solo motor. En ambos casos, en lugar de combinar los rankings basándose únicamente en los puntajes de cada fuente, se puede predecir el rendimiento de la consulta en cada una de ellas de forma independiente. Los resultados de las fuentes donde se predice un alto rendimiento pueden recibir una mayor ponderación en el ranking final. Esta estrategia ha demostrado mejorar significativamente la calidad de los resultados combinados, aunque su éxito también depende de la fiabilidad del predictor utilizado @query-difficulty-book, @how-much-correlation-is-good.

==== Retroalimentación al Usuario y al Sistema
La QPP también se utiliza para proporcionar retroalimentación directa. Un sistema puede informar al usuario que su consulta es probablemente "difícil" y que los resultados pueden ser de baja calidad, sugiriendo reformulaciones o términos alternativos. A nivel de administración del sistema, el análisis de las consultas predichas como difíciles en los registros de búsqueda (_query logs_) puede ayudar a identificar *contenido faltante* en la colección, guiando así los esfuerzos para enriquecer la base de conocimiento y cubrir las brechas de información detectadas @query-difficulty-book.

=== Supuestos, limitaciones y amenazas a la validez

A pesar de su potencial, la efectividad y la evaluación de los métodos de QPP se basan en un conjunto de supuestos y están sujetas a limitaciones importantes que deben ser consideradas para interpretar correctamente sus resultados.

La evaluación y la aplicación de los métodos de QPP descansan sobre varios supuestos centrales. Un supuesto extendido sostiene que una alta correlación (e.g., Pearson, Kendall, Spearman) entre las predicciones y una métrica de efectividad (e.g., AP, nDCG) se traduce en utilidad práctica; sin embargo, la evidencia empírica muestra que la correlación, aun siendo estadísticamente significativa, no garantiza por sí sola una mejora operativa, pues la utilidad real depende de cómo la predicción informa decisiones concretas dentro del sistema @how-much-correlation-is-good. 

A ello se suma una fuerte dependencia de los juicios de relevancia (qrels) como “suelo de verdad”. Este supuesto es particularmente frágil, ya que la calidad de los qrels está sujeta a la variabilidad inherente al juicio humano. La evaluación de la relevancia no es un proceso mecánico; está influenciada por la experiencia y el conocimiento del dominio del evaluador. Se ha demostrado que los evaluadores no expertos ("generalistas") tienden a producir juicios menos precisos y más superficiales en comparación con los expertos del dominio, recurriendo con frecuencia a la simple coincidencia de palabras clave en lugar de a una comprensión profunda de la intención de la consulta. Esta discrepancia introduce una fuente potencialmente significativa de sesgo en los resultados de evaluación, lo que significa que un predictor de QPP puede estar siendo interpretado incorrectamente para replicar los juicios de un tipo particular de evaluador, en lugar de una noción objetiva de relevancia @evaluator-domain-expertise.

La validez de las evaluaciones también está modulada por las características de los conjuntos de datos y de las muestras de consulta empleados. El rendimiento observado de un predictor depende en gran medida del tipo de colección: resultados alentadores en corpora limpios y homogéneos (p. ej., noticias) no necesariamente se sostienen en colecciones web más ruidosas y heterogéneas; por ello, las conclusiones de benchmarks deben interpretarse con cautela y no extrapolarse sin verificación a contextos productivos @correlation-depends-on-quality-of-dataset. A ello se añade la sensibilidad a tamaños muestrales reducidos de consultas, frecuentes en campañas de evaluación: con pocas consultas, las estimaciones son más inestables y los intervalos de confianza se amplían, dificultando discernir si las diferencias entre predictores reflejan efectos genuinos o artefactos de muestreo. La composición de la muestra (por ejemplo, una sobre‑representación de consultas fáciles o difíciles) puede, además, sesgar las métricas y favorecer ciertas familias de predictores, por lo que resulta recomendable complementar el análisis con particiones, validación cruzada y estudios de sensibilidad.

== Métricas de Evaluación de Rendimiento y Correlación
=== Juicios de relevancia (Qrels)
Los juicios de relevancia (qrels) son las etiquetas que, para cada consulta, indican qué elementos del corpus son relevantes y con qué grado (binario o multigrado). Operan como referencia objetiva para calcular métricas de efectividad a nivel de consulta y de colección y, por tanto, constituyen el “suelo de verdad” frente al cual se contrastan sistemas de recuperación y estimadores de rendimiento. Su definición y disponibilidad condicionan de forma directa la interpretación de resultados y la comparabilidad entre trabajos.

La obtención humana de qrels suele realizarse mediante campañas de evaluación con anotadores expertos o capacitados, frecuentemente apoyadas en pooling: es decir se agregan los top‑k resultantes de múltiples sistemas y se juzga ese subconjunto. Este procedimiento permite cubrir un espacio de resultados amplio con costos controlados, pero introduce incompletitud (no todos los elementos relevantes son juzgados) y sesgos de cobertura ligados a los sistemas incluidos y a la profundidad del pool. La calidad de los juicios depende de guías de anotación, formación y control de calidad (p. ej., acuerdo entre anotadores medido con coeficientes como Cohen’s κ) y de la escala de relevancia empleada; estos factores por ende tienen un impacto directo en la estabilidad de las métricas.

Para la evaluación de métodos de QPP, los qrels son de una gran importancia dado que (i) fijan las métricas objetivo frente a las que se correlacionan las predicciones (por ejemplo, nDCG a profundidad fija o AP a profundidad fija) y (ii) su calidad, cobertura y profundidad de juicio condicionan la magnitud y la estabilidad de las correlaciones (Pearson, Kendall, Spearman). En consecuencia, resulta imprescindible reportar origen de los juicios (humano, automático o mixto), protocolo de obtención, profundidad y escala de relevancia, así como realizar análisis de sensibilidad (variando la profundidad de corte) y pruebas de significancia para mitigar y evidenciar los efectos de incompletitud y sesgos de la extracción.
=== Métricas de evaluación clásicas en IR
=== Protocolos de evaluación de QPP y diseño experimental
=== Métricas de correlación para evaluar métodos QPP
