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
\
La predicción del rendimiento de consultas (QPP, Query Performance Prediction), también conocida como estimación de la dificultad de la consulta (QDE, Query Difficulty Estimation), representa una rama de investigación en el campo de la Recuperación de Información (IR) que se enfoca en predecir la calidad de los resultados de búsqueda para una consulta dada, recuperados por un sistema de recuperación específico, sin necesidad de información de relevancia proporcionada por un operador humano. Este desafío surge de la observación de que los sistemas de búsqueda a menudo fallan en responder eficazmente a ciertas consultas, lo que se asocia directamente con la noción de dificultad de la consulta. @query-difficulty-book

La diversidad en el rendimiento de las consultas y entre diferentes sistemas ha impulsado esta área, buscando mitigar la variabilidad en la efectividad de la recuperación. En este sentido, QPP cumple un rol netamente preventivo: anticipar la dificultad para activar ajustes selectivos (p. ej., expansión, elección de parámetros o flujos alternativos) antes de observar fallos, reduciendo la variabilidad y mejorando la experiencia del usuario.

#v(10pt)
=== Dificultad y rendimiento de las consultas
\
La dificultad de una consulta, en el ámbito de la Recuperación de Información (IR), se asocia principalmente con la incapacidad de un sistema para responder de manera efectiva a una necesidad de información específica. Una consulta se considera "difícil" cuando el sistema de búsqueda obtiene un rendimiento deficiente en términos de sus medidas de efectividad. Este concepto es fundamental, ya que los fallos del sistema suelen estar directamente relacionados con la complejidad inherente o contextual de la consulta, lo que subraya la importancia de su predicción en la mejora continua de los sistemas de IR. La noción de dificultad de la consulta no es universal, y su interpretación puede variar dependiendo del contexto, el corpus, la ambigüedad de la consulta y el sistema de recuperación utilizado.

En contraste, el rendimiento de una consulta se define como una forma de estimar la dificultad inherente de la misma, mediante diversos experimentos de recuperación que generan múltiples métricas relacionadas con la calidad de los resultados obtenidos por el sistema. Estas métricas, obtenidas a través de experimentos que evalúan el ranking de documentos recuperados contra juicios de relevancia humana (qrels), incluyen nDCG, Recall, RR, AP y MAP, entre otras. Cada experimento de recuperación produce estas métricas simultáneamente sobre la misma lista ordenada de documentos, permitiendo una evaluación multidimensional de la efectividad del sistema. Un alto rendimiento en estas métricas indica una consulta "fácil" con baja dificultad inherente, mientras que valores bajos sugieren una consulta "difícil" que desafía la capacidad del sistema para satisfacer la necesidad informativa del usuario. La predicción de este rendimiento, es por tanto, el núcleo de QPP, buscando estimar estas métricas sin requerir juicios humanos de relevancia.

La interdependencia entre la dificultad y el rendimiento de las consultas es crucial. Una consulta inherentemente difícil, ya sea por su ambigüedad, la escasez de documentos relevantes en el corpus, o la formulación ineficaz, tenderá a producir un bajo rendimiento en la mayoría de los sistemas de IR. Por lo tanto, estimar la dificultad de la consulta es, en esencia, un intento de predecir el rendimiento que un sistema específico logrará para esa consulta. Esta predicción permite a los sistemas anticipar posibles fallos y aplicar estrategias correctivas de manera proactiva, mejorando la experiencia del usuario y la eficiencia general del sistema.

Los factores que contribuyen a la dificultad de una consulta son variados y complejos. Pueden estar relacionados con la expresión misma de la consulta, como la ambigüedad léxica o semántica, o con su longitud y especificidad. Otro conjunto de factores se deriva del conjunto de datos o corpus, incluyendo su heterogeneidad, la distribución de términos y la cantidad de documentos relevantes disponibles. Finalmente, el método de recuperación empleado también influye en la dificultad percibida, ya que diferentes algoritmos pueden manejar la misma consulta con distintos niveles de éxito. Esta fuerte dependencia en multiples factores hace que la predicción de la dificultad sea un desafío significativo incluso cuando se trata de predicciones realizadas por jueces expertos en el area. @Query-difficulty-definition @trec-6

La *generalidad* de la dificultad de una consulta es un aspecto clave a considerar. Una consulta puede ser difícil para un sistema de recuperación particular, pero no para otros, o puede ser consistentemente difícil a través de una variedad de sistemas y colecciones. Esta generalidad se mide a menudo promediando el rendimiento predicho de la consulta a través de múltiples métodos de recuperación y diversas colecciones de documentos. Comprender esta variabilidad es esencial para desarrollar predictores que sean robustos y aplicables en diferentes escenarios de búsqueda, más allá de un único contexto sistema-colección. @correlation-depends-on-quality-of-dataset

Recientemente la literatura ha propuesto varias formas de definir la “dificultad” de una consulta a partir de las metricas de efectividad; como se resume en la @definiciones-dificultad:
#v(10pt)
+ Percentiles: particiona la distribución de la métrica por consulta en cuartiles para inducir clases {muy difícil, difícil, fácil, muy fácil}.
+ Umbrales: Fija cortes absolutos sobre la métrica para definir clases de dificultad. Existen dos estrategias principales:
  #v(4pt)
  - *Umbral único:* Se define un solo punto de corte. Por ejemplo, las consultas con `P@10 <= 0.1` se consideran "difíciles" y el resto "no difíciles", creando una clasificación binaria.
  - *Pares de umbrales:* Se usan dos umbrales para aislar los extremos. Por ejemplo, con el par `(0.1, 0.9)`, las consultas con `AP <= 0.1` son "muy difíciles" (VH) y aquellas con `AP >= 0.9` son "muy fáciles" (VE). Las consultas intermedias no se clasifican y se ignoran, creando un margen que facilita la predicción al enfocarse solo en los casos más claros. @Query-difficulty-definition
+ Combinada: intersecta el cuartil inferior (Q1) con un umbral predefinido.
#v(6pt)
Estas estrategias pueden plantearse centradas en un único sistema o promediando la métrica sobre varios sistemas. La evidencia empírica muestra que las definiciones por umbrales con una separación marcada entre clases (p. ej., muy difíciles vs. muy fáciles) suelen producir predicciones más estables y con mayores verdaderos positivos que las definiciones puramente percentilares o combinadas. @Query-difficulty-definition

\
#show figure: set block(breakable: true)
#figure(
  table(
    columns: (auto, auto, auto),
    inset: 15pt,
    stroke: (x: none),
    row-gutter: (2.5pt, auto),
    align: left + horizon,
    table.header(
      [*Definición*], [*Descripción*], [*Notas/Configuración típica*],
    ),
    [Percentiles],
    [Particiona la distribución de la métrica por consulta en cuartiles para inducir clases {muy difícil, difícil, fácil, muy fácil}.],
    [Cuartiles (Q1, Q2, Q3); clases balanceadas; sensibilidad al dataset.],
    [Umbrales],
    [Fija cortes absolutos sobre la métrica para identificar consultas muy difíciles o muy fáciles.],
    [Puede ser un *umbral único* (ej: `P@10 <= 0.1` para "difíciles") o *pares de umbrales* para aislar extremos (ej: con `(0.1, 0.9)`, se define VH como `AP <= 0.1` y VE como `AP >= 0.9`, ignorando el resto).],
    [Combinada],
    [Interseca el cuartil inferior (Q1) con un umbral predefinido.],
    [Menos estable que umbrales con brechas marcadas entre clases.],
    [Ámbito],
    [Puede definirse por sistema o promediando la métrica sobre varios sistemas.],
    [Centrada en un sistema S o sobre S = {S1, …, Sn}.],
    [Observación empírica],
    [Los umbrales con separación marcada entre clases tienden a producir mayores verdaderos positivos y estabilidad.],
    [Recomendable para detectar casos muy difíciles (VH) vs. muy fáciles (VE).],
  ),
  caption: "Formas de definir la dificultad de una consulta.",
) <definiciones-dificultad>
#v(10pt)

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

Finalmente, esta nueva "consulta expandida" se utiliza para realizar una segunda recuperación, que a menudo produce un ranking de resultados mucho más preciso, resolviendo problemas comunes como la sinonimia y la polisemia @relevance-models.

#v(15pt)

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
) <relevance-model-flow>
#v(15pt)
En la @relevance-model-flow se ilustra el flujo típico de expansión mediante modelos de relevancia: una consulta inicial se ejecuta con un ranker léxico (BM25) para obtener los top‑K documentos; a partir de ese conjunto pseudo‑relevante se estima un modelo que induce nuevos términos y pesos; con la consulta expandida resultante se realiza una segunda recuperación, cuyo objetivo es reordenar con mayor precisión y producir un ranking final de documentos más alineado con la intención de la consulta.

Más recientemente, la llegada de los *Modelos extensos del lenguaje* (LLMs) ha supuesto un avance significativo en el panorama de la recuperación de información. Sin embargo, uno de sus mayores problemas es que su conocimiento se "congela" en el momento del entrenamiento, lo que limita su acceso a información reciente y los hace propensos a "alucinar" o generar contenido incorrecto. 

Para superar estas limitaciones, ha surgido el paradigma de la *Generación Aumentada por Recuperación* (RAG). Los modelos RAG combinan un recuperador de información con un LLM generativo en un proceso de dos fases:

1.  *Recuperación*: Un sistema de recuperación busca en una base de conocimiento (por ejemplo, una colección de documentos) para encontrar fragmentos de texto relevantes para la consulta.
2.  *Generación*: Estos fragmentos recuperados se proporcionan como contexto a un LLM junto con la consulta original. El LLM sintetiza una respuesta coherente y factual, fundamentada en la evidencia extraída.

Este enfoque ancla las respuestas del LLM en información verificable, reduciendo las alucinaciones y permitiendo que el conocimiento del sistema se actualice simplemente actualizando la base de conocimiento documental. Es una técnica especialmente poderosa para consultas de conocimiento intensivo que demandan respuestas precisas y actualizadas @RAG.

A pesar de su efectividad, estas soluciones avanzadas—desde la expansión de consultas hasta los complejos _pipelines_ de RAG—suelen tener un costo computacional elevado. No es eficiente ni necesario aplicarlas a todas las consultas, especialmente a aquellas que son simples y pueden ser respondidas adecuadamente por un sistema de recuperación estándar.

Por otro lado la *Predicción del Rendimiento de Consultas* (QPP) busca destacar especialmente en este area. Los predictores funcionan como una herramienta de diagnóstico que estima de antemano la efectividad esperada de un sistema para una consulta dada, sin necesidad de utilizar juicios de relevancia humanos. Al predecir si una consulta será "fácil" o "difícil", un sistema de IR puede tomar decisiones proactivas y selectivas. Para una consulta predicha como "fácil", se puede utilizar un método de recuperación rápido y eficiente. En cambio, si una consulta se predice como "difícil", el sistema puede activar mecanismos más eficaces y costosos, como la expansión de consultas, el uso de modelos de relevancia o la activación de un _pipeline_ de RAG para garantizar una respuesta de alta calidad. Por ende, QPP permite a los sistemas de recuperación gestionar estratégicamente sus recursos, mejorando la robustez y la eficiencia general al tiempo que se mitigan los fallos en las consultas más desafiantes @query-difficulty-book.

#v(10pt)
=== Taxonomías en QPP
\
La literatura distingue dos categorías principales de predictores de rendimiento de consulta según el momento en que extraen información: métodos pre-retrieval y post-retrieval. Los primeros formalmente se caracterizan por actuar antes de ejecutar la búsqueda utilizando únicamente la consulta y estadísticas del índice; los segundos explotan señales observadas en la lista recuperada a partir de un modelo de recuperación de información (p. ej., patrones en las puntuaciones y funciones de ranking	).@wig-nqc-scored-configuration

En paralelo, al adentrarnos en el campo de la inteligencia artificial, podemos encontrar otras categorías de clasificación por ejemplo, régimen de aprendizaje (no supervisados frente a supervisados) y por entorno (búsqueda ad-hoc y conversacional utilizando modelos extensos del lenguaje), cuyas elecciones suponen compromisos entre costo computacional, latencia y capacidad para modelar fenómenos como ambigüedad, variación temática y distribuciones de consultas. @Meng2023QPP @web-search-qpp.
#v(10pt)
==== Predictores pre-retrieval
#v(10pt)
Los predictores pre-retrieval estiman la dificultad de una consulta a priori, sin ejecutar recuperación. Se apoyan en propiedades intrínsecas de la consulta y en estadísticas globales de la colección disponibles en tiempo de indexación. De forma general, caracterizan la especificidad y ambigüedad de la consulta, así como su potencial discriminativo en la colección, a partir de medidas resumidas que capturan propiedades léxicas de la consulta (longitud, diversidad o concentración de términos) y el patrón con que dichos términos aparecen en la colección (frecuencia y variabilidad entre documentos). Su atractivo radica en el bajo costo computacional y en que permiten decisiones de control (p. ej., expansión, selección de sistema o ajuste de parámetros) antes de observar una lista recuperada. @preretrieval-idf @idf-understanding
#v(10pt)
==== Predictores post-retrieval
\
Los predictores post-retrieval se estiman una vez disponible la lista recuperada para la consulta y se apoyan en señales observables en dicha lista. En términos generales, se agrupan en cuatro familias: 
#v(10pt)
+ El comportamiento de las puntuaciones devueltas por el ranker
+ La coherencia y consistencia semántica de los documentos en la cima del ranking
+ La estabilidad del ranking ante perturbaciones controladas (robustez)
+ El consenso con variantes del sistema o de la consulta. 
#v(10pt)
Estas familias de señales buscan captar indicios de dificultad a partir de la respuesta del sistema para la consulta concreta. @wig-nqc-scored-configuration @query-drift @statistical-decision-theory-uef

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 15pt,
    stroke: (x: none),
    row-gutter: (2.5pt, auto),
    align: left + horizon,
    table.header(
      [*Factor*], [*Descripción*], [*Ejemplos de señales*],
    ),
    [Puntuaciones del ranker],
    [Patrones en las puntuaciones devueltas (magnitud, dispersión, forma y separabilidad entre tope y cola).],
    [Varianza y distribución de puntajes, diferencias en el top-1 vs top-10],
    [Coherencia del tope],
    [Consistencia semántica entre los documentos top-K y con la consulta.],
    [Similaridad promedio entre top-K, comparación de modelos de lenguaje de los resultados y el dataset (clarity score)],
    [Robustez del ranking],
    [Estabilidad del ranking ante perturbaciones controladas del sistema, de los datos y de la consulta.],
    [Sensibilidad a ruido/perturbación, estabilidad al remover/alterar top-K],
    [Consenso entre variantes],
    [Acuerdo con variantes del sistema o de la consulta.],
    [Correlación de rangos entre el ranking original y variantes (p. ej., con stemming, con expansión de consulta).]
  ),
  caption: "Factores y señales típicas en predictores post-retrieval",
) <tabla-factores-postretrieval>

#v(10pt)
Los enfoques post-retrieval pueden ser no supervisados (agregan señales derivadas de la propia lista devuelta) o supervisados (aprenden a mapear representaciones de consulta-lista a una estimación de rendimiento). Su efectividad depende del tipo de recuperador (léxico o denso), de la profundidad considerada (top-k frente a listas profundas) y de las propiedades de la colección, dado que distintas distribuciones de puntuaciones y estructuras de ranking favorecen señales diferentes. Aunque su costo es mayor que el de los métodos pre-retrieval, suelen proporcionar estimaciones más informadas al incorporar evidencia del resultado concreto de recuperación.
#v(10pt)
=== Aplicaciones de QPP en IR
\
La capacidad de predecir el rendimiento de una consulta abre un amplio abanico de aplicaciones prácticas que permiten a los sistemas de recuperación de información (IR) operar de manera más inteligente, robusta y eficiente. En lugar de tratar todas las consultas de la misma manera, los sistemas pueden utilizar los predictores de QPP para adaptar dinámicamente su comportamiento. Sin embargo, la utilidad de estas aplicaciones depende críticamente de la calidad del predictor: se requiere una correlación moderadamente alta entre el rendimiento predicho y el real para que estas estrategias mejoren de manera fiable la efectividad del sistema @how-much-correlation-is-good.
#v(10pt)
==== Activación Selectiva de Mecanismos Avanzados
\
Como se mencionó anteriormente, técnicas como la expansión de consultas mediante modelos de relevancia o el uso de arquitecturas complejas como RAG son computacionalmente costosas. Sobre este punto, QPP funciona como una herramienta de diagnóstico que estima de antemano la efectividad esperada. Si una consulta se predice como "difícil", el sistema puede activar estos mecanismos más potentes para garantizar una respuesta de alta calidad. En cambio, para una consulta predicha como "fácil", se puede utilizar un método de recuperación estándar, optimizando así el uso de recursos sin sacrificar la calidad en los casos necesarios @query-difficulty-book.
#v(10pt)
==== Expansión Selectiva de Consultas
\
La retroalimentación de pseudo-relevancia (_pseudo-relevance feedback_, PRF) es una técnica común para expandir consultas, pero su aplicación indiscriminada tiene consecuencias negativas. Si los documentos mejor clasificados iniciales no son relevantes, los términos añadidos pueden desviar el enfoque de la consulta original, un fenómeno conocido como *_query drift_*. Este desvío a menudo degrada el rendimiento en lugar de mejorarlo.

Los predictores QPP permiten una aplicación más segura de esta técnica. Si se predice que una consulta tendrá un bajo rendimiento, se considera como una buena candidata para la expansión, ya que el potencial de mejora es elevado y el riesgo de empeorar un resultado ya pobre es negligible. Por el contrario, si se predice que una consulta ya es efectiva, aplicar la expansión podría ser innecesario o incluso perjudicial. De este modo, la predicción actúa como un guardián, aplicando la expansión solo cuando es probable que sea beneficiosa @query-drift.
#v(10pt)
==== Búsqueda Federada y Metabúsqueda
\
En entornos donde los resultados provienen de múltiples colecciones o motores de búsqueda, la QPP es fundamental para la fusión inteligente de resultados. En la *metabúsqueda*, se consultan varios motores de búsqueda, mientras que en la *búsqueda federada*, se busca en múltiples colecciones con un solo motor. En ambos casos, en lugar de combinar los rankings basándose únicamente en los puntajes de cada fuente, se puede predecir el rendimiento de la consulta en cada una de ellas de forma independiente. Los resultados de las fuentes donde se predice un alto rendimiento pueden recibir una mayor ponderación en el ranking final. Esta estrategia ha demostrado mejorar significativamente la calidad de los resultados combinados, aunque su éxito también depende de la fiabilidad del predictor utilizado @query-difficulty-book, @how-much-correlation-is-good.
#v(10pt)
==== Retroalimentación al Usuario y al Sistema
\
La QPP también se utiliza para proporcionar retroalimentación directa. Un sistema puede informar al usuario que su consulta es probablemente "difícil" y que los resultados pueden ser de baja calidad, sugiriendo reformulaciones o términos alternativos. A nivel de administración del sistema, el análisis de las consultas predichas como difíciles en los registros de búsqueda (_query logs_) puede ayudar a identificar *contenido faltante* en la colección, guiando así los esfuerzos para enriquecer la base de conocimiento y cubrir las brechas de información detectadas @query-difficulty-book.
#v(10pt)
=== Supuestos, limitaciones y amenazas a la validez
\
A pesar de su potencial, la efectividad y la evaluación de los métodos de QPP se basan en un conjunto de supuestos y están sujetas a limitaciones importantes que deben ser consideradas para interpretar correctamente sus resultados.

La evaluación y la aplicación de los métodos de QPP descansan sobre varios supuestos centrales. Un supuesto extendido sostiene que una alta correlación (e.g., Pearson, Kendall, Spearman) entre las predicciones y una métrica de efectividad (e.g., AP, nDCG) se traduce en utilidad práctica; sin embargo, la evidencia empírica muestra que la correlación, aun siendo estadísticamente significativa, no garantiza por sí sola una mejora operativa, pues la utilidad real depende de cómo la predicción informa decisiones concretas dentro del sistema @how-much-correlation-is-good. 

A ello se suma una fuerte dependencia de los juicios de relevancia (qrels) como “suelo de verdad”. Este supuesto es particularmente frágil, ya que la calidad de los qrels está sujeta a la variabilidad inherente al juicio humano. La evaluación de la relevancia no es un proceso mecánico; está influenciada por la experiencia y el conocimiento del dominio del evaluador. Se ha demostrado que los evaluadores no expertos ("generalistas") tienden a producir juicios menos precisos y más superficiales en comparación con los expertos del dominio, recurriendo con frecuencia a la simple coincidencia de palabras clave en lugar de a una comprensión profunda de la intención de la consulta. Esta discrepancia introduce una fuente potencialmente significativa de sesgo en los resultados de evaluación, lo que significa que un predictor de QPP puede estar siendo interpretado incorrectamente para replicar los juicios de un tipo particular de evaluador, en lugar de una noción objetiva de relevancia @evaluator-domain-expertise.
#v(6pt)
La validez de las evaluaciones también está modulada por las características de los conjuntos de datos y de las muestras de consulta empleados. El rendimiento observado de un predictor depende en gran medida del tipo de colección: resultados alentadores en corpora limpios y homogéneos (p. ej., noticias) no necesariamente se sostienen en colecciones web más ruidosas y heterogéneas; por ello, las conclusiones de benchmarks deben interpretarse con cautela y no extrapolarse sin verificación a contextos productivos @correlation-depends-on-quality-of-dataset. A ello se añade la sensibilidad a tamaños muestrales reducidos de consultas, frecuentes en campañas de evaluación: con pocas consultas, las estimaciones son más inestables y los intervalos de confianza se amplían, dificultando discernir si las diferencias entre predictores reflejan efectos genuinos o artefactos de muestreo. La composición de la muestra (por ejemplo, una sobre‑representación de consultas fáciles o difíciles) puede, además, sesgar las métricas y favorecer ciertas familias de predictores.

#v(10pt)
== Métricas de Evaluación de Rendimiento y Correlación
\
Las métricas de evaluación cuantifican la calidad de un ranking y permiten contrastar, de forma objetiva, lo que un sistema recupera con lo que se espera encontrar. En el contexto de QPP, operan como punto de comparación para juzgar si las predicciones se alinean con el rendimiento observado a nivel de consulta y de colección. La base de todo cualquier métrica de evaluación son los juicios de relevancia, que fijan qué elementos del corpus se consideran relevantes para una consulta dada.

Sobre esa referencia se calculan medidas ampliamente utilizadas como Precisión, AP, MAP y nDCG. Estas métricas capturan distintos aspectos del rendimiento: exactitud en los tope del ranking, cobertura de documentos relevantes, calidad promedio a lo largo de la lista y sensibilidad a relevancias graduadas. Su valor depende del orden de los resultados y de parámetros operativos como la profundidad de corte, por lo que deben interpretarse en función del escenario de uso.

Para evaluar QPP se utiliza un protocolo experimental que utiliza las métricas de efectividad calculadas por consulta (por ejemplo, AP, MAP, nDCG) correlacionadas directamente con el valor del predictor para la misma consulta. La comparación emplea coeficientes de correlación de rangos y se acompaña de pruebas de significancia e intervalos de confianza para estimar la robustez. De este modo, la utilidad del predictor se juzga por la magnitud y la estabilidad de las correlaciones y por su capacidad para guiar decisiones.

#v(10pt)
=== Juicios de relevancia (Qrels)
\
Los juicios de relevancia (qrels) son las etiquetas que, para cada consulta, indican qué elementos del corpus son relevantes y con qué grado (binario o multigrado). Operan como referencia objetiva para calcular métricas de efectividad a nivel de consulta y de colección y, por tanto, constituyen el “suelo de verdad” o _ground truth_ frente al cual se contrastan sistemas de recuperación y estimadores de rendimiento. Su definición y disponibilidad condicionan de forma directa la interpretación de resultados y la comparabilidad entre trabajos.

La obtención humana de qrels suele realizarse mediante campañas de evaluación con anotadores expertos o capacitados, frecuentemente apoyadas en pooling: es decir se agregan los top‑k resultantes de múltiples sistemas y se juzga ese subconjunto. Este procedimiento permite cubrir un espacio de resultados amplio con costos controlados, pero introduce incompletitud (no todos los elementos relevantes son juzgados) y sesgos de cobertura ligados a los sistemas incluidos y a la profundidad del pool. La calidad de los juicios depende de guías de anotación, formación y control de calidad (p. ej., acuerdo entre anotadores medido con coeficientes como Cohen’s κ) y de la escala de relevancia empleada; estos factores por ende tienen un impacto directo en la estabilidad de las métricas. @trec-6 @evaluator-domain-expertise

#v(10pt)
=== Métricas de evaluación clásicas en IR
\
La evaluación del rendimiento en Recuperación de Información se basa en métricas estandarizadas que cuantifican la calidad de una lista de resultados en función de los juicios de relevancia (qrels). Estas métricas no solo miden la efectividad de un sistema, sino que también actúan como el "suelo de verdad" que los predictores de QPP intentan estimar. Las métricas más fundamentales son la Precisión y la Exhaustividad (Recall), sobre las cuales se construyen métricas más complejas como la Precisión Media (AP) y la Ganancia Acumulada Descontada Normalizada (nDCG).

#v(6pt)
La *Precisión (Precision)* mide la fracción de documentos recuperados que son relevantes. Responde a la pregunta: "¿Qué proporción de los resultados que mostré son realmente útiles?". Es un indicador de la exactitud de la búsqueda y requiere que los juicios de relevancia sean binarizados (es decir, un documento es relevante o no lo es, sin grados intermedios).
#v(10pt)
$ "Precision@n(R)" = frac( 1,Q ) sum_(i=1)^Q [1/n sum_(i=j)^n "rel"^b (d_j^i)] $
#v(10pt)
Donde $"rel"^b(d_j^i)$ es la relevancia binarizada del documento $d$ en la posición $j$ para la consulta $i$, devolviendo 1 si es relevante y 0 en caso contrario.

Una variante común es la *Precisión en K (Precision@$K$)*, que calcula la precisión considerando únicamente los primeros $K$ resultados del ranking. Es especialmente útil porque refleja la experiencia del usuario, quien raramente explora más allá de la primera página de resultados. @metrics-sensitivity

La *Precisión Media (Average Precision, AP)* es una métrica que evalúa la calidad de un ranking para una única consulta combinando estas dos ideas. Se calcula promediando la precisión en cada posición donde se encuentra un documento relevante. AP favorece a los sistemas que no solo recuperan muchos documentos relevantes (alta exhaustividad), sino que también los clasifican en las primeras posiciones (alta precisión). Para evaluar un sistema en un conjunto de consultas, se utiliza la *Precisión Media Promedio (Mean Average Precision, MAP)*, que es simplemente el promedio de los valores de AP de todas las consultas @query-difficulty-book.
#v(10pt)
$ "MAP@n(R)" = frac( 1,Q ) sum_(i=1)^Q [1/n_i sum_(j=1)^n "rel"^b (d_j^i) * "Precision@j(R, q_i)"] $
#v(10pt)
La *Ganancia Acumulada Descontada Normalizada (Normalized Discounted Cumulative Gain, nDCG)* es una métrica más sofisticada que, a diferencia de la Precisión, sí tiene en cuenta los diferentes niveles de relevancia (por ejemplo, "relevante", "muy relevante"). La idea central es que los documentos altamente relevantes son más valiosos que los marginalmente relevantes, y la relevancia de un documento disminuye cuanto más abajo aparece en la lista de resultados.

Para ello, se asigna una ganancia a cada documento que crece exponencialmente con su nivel de relevancia ($"rel"$). Luego, esta ganancia se descuenta logarítmicamente según la posición del documento ($j$). Finalmente, el valor se normaliza dividiéndolo por un factor $N_i$, que representa la ganancia ideal para esa consulta (IDCG), para obtener una puntuación entre 0 y 1.

La fórmula general para calcular nDCG con un corte en $n$ ($"nDCG"@n$), promediado sobre un conjunto de $Q$ consultas, se define como:
#v(10pt)
$ "nDCG"@n = 1/Q sum_(i=1)^Q [1/N_i sum_(j=1)^n frac(2^("rel"(d_j^i)) - 1, log_2(j+1))] $
#v(10pt)
Donde $N_i$ es el factor de normalización (IDCG) para la consulta $i$. El nDCG es una de las métricas más comunes en la evaluación de IR y QPP debido a su capacidad para manejar juicios de relevancia graduados y su sensibilidad al orden de los resultados @metrics-sensitivity.

#v(10pt)
=== Protocolos de evaluación de QPP y diseño experimental
\
La evaluación de los predictores de QPP sigue un protocolo experimental específico para garantizar que los resultados sean fiables, comparables e interpretables. El objetivo principal de este protocolo es medir qué tan bien las puntuaciones predichas por un método de QPP se correlacionan con el rendimiento real de un sistema de IR, medido por métricas como AP o nDCG.

Un diseño experimental típico implica varios componentes clave. Primero, se utiliza un conjunto de *colecciones de documentos* y *conjuntos de consultas* estandarizados, como los proporcionados por campañas de evaluación como TREC. El uso de múltiples colecciones es crucial, ya que se ha demostrado que el rendimiento de un predictor puede variar significativamente dependiendo de las características del corpus (por ejemplo, su homogeneidad o el nivel de "ruido"). Un predictor que funciona bien en una colección de noticias limpia puede no ser efectivo en una colección web heterogénea, donde el "ruido" (páginas con poco contenido, avisos de copyright, etc.) es común y puede distorsionar las estadísticas en las que se basan los predictores @correlation-depends-on-quality-of-dataset.

Segundo, las consultas se ejecutan utilizando uno o más *sistemas de recuperación de información* (o rankers), como BM25 o modelos neuronales. La efectividad real de cada consulta se calcula utilizando los juicios de relevancia (qrels) disponibles. Al mismo tiempo, se calcula la puntuación predicha por el método de QPP para cada consulta. Es importante separar el "efecto del sistema" del "efecto de la consulta", ya que un predictor podría estar simplemente midiendo la dificultad inherente de la tarea informativa en lugar de la dificultad de una consulta específica para un sistema concreto @microsoft-preretrieval.

Finalmente, se comparan las dos listas de puntuaciones (la real y la predicha) utilizando métricas de correlación. Un marco de evaluación robusto no se basa en estimaciones puntuales, sino que a menudo utiliza técnicas como los análisis de significancia también como análisis de varianza (ANOVA) para modelar el rendimiento del predictor como una distribución, lo que permite un análisis estadístico más detallado y conclusiones más fiables @enhanced-evaluation.
#v(10pt)
=== Métricas de correlación para evaluar métodos QPP
\
El método estándar para cuantificar la efectividad de un predictor de QPP es medir la correlación entre la lista de puntuaciones de rendimiento predichas y la lista de puntuaciones de rendimiento reales (por ejemplo, AP o nDCG) para un conjunto de consultas. Dado que no se puede asumir que estas puntuaciones sigan una relación lineal o una distribución de probabilidad específica, se prefieren los *coeficientes de correlación de rangos*. Estos miden el grado de acuerdo entre dos ordenamientos, respondiendo a la pregunta: "¿si el predictor A es mejor que el predictor B, ¿se corresponde esto con un mejor rendimiento real?".

Los tres coeficientes más comunes en la literatura de QPP son:

1.  *Correlación de Pearson ($r$)*: Es el único coeficiente paramétrico de los tres. Mide la *fuerza de la relación lineal* entre dos variables cuantitativas. Aunque es muy conocido, su uso en QPP es delicado. Es sensible a la magnitud de las diferencias y a los valores atípicos (_outliers_), y asume que los datos siguen una distribución normal bivariada. Como las métricas de rendimiento raramente cumplen con este supuesto, su aplicación requiere tests de normalidad previos para validar su aplicación.

2.  *Correlación de rangos de Spearman ($rho$)*: Es una alternativa no paramétrica a Pearson. En lugar de usar los valores brutos, primero los convierte en rangos y luego calcula el coeficiente de Pearson sobre esos rangos. Por ello, mide la *fuerza de una relación monotónica* (es decir, si una variable tiende a aumentar cuando la otra lo hace, sin que la relación tenga que ser lineal). Es menos sensible a los _outliers_ que Pearson, pero puede ser afectado por la presencia de muchos rangos empatados.

3.  *Correlación de rangos de Kendall ($tau$)*: Es una medida no paramétrica que se considera la más robusta de las tres para la evaluación de QPP. En lugar de considerar la magnitud o el rango, $tau$ se basa en el número de *pares concordantes* y *discordantes* entre los dos rankings. Un par de consultas es concordante si su orden es el mismo en ambas listas (la predicha y la real) y discordante si el orden se invierte. Debido a que se basa en conteos, no asume ninguna distribución de los datos, es robusta frente a valores atípicos y maneja bien los empates en los rankings. Su interpretación también es más directa: representa la diferencia entre la probabilidad de que dos consultas estén en el mismo orden y la probabilidad de que estén en órdenes diferentes.

En la práctica, Spearman y Kendall son generalmente preferidos sobre Pearson en la investigación de QPP por su naturaleza no paramétrica. Kendall's $tau$ es a menudo el preferido por su robustez y su interpretación probabilística, aunque Spearman's $rho$ también se reporta comúnmente.

Finalmente, es crucial entender que una correlación estadísticamente significativa no siempre implica una mejora práctica. La investigación ha demostrado que una correlación, aunque sea alta (p. ej., > 0.5), puede no ser suficiente para que una aplicación como la expansión selectiva de consultas mejore de manera fiable el rendimiento del sistema. La utilidad real depende de la magnitud de esa correlación y del contexto de la aplicación, y muchos predictores existentes no alcancan el umbral de fiabilidad necesario en escenarios reales @correlation-methods, @how-much-correlation-is-good.
