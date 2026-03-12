#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= MARCO TEÓRICO
#v(10pt)
== Sistemas de recuperación de información (IR)
\
El campo de la recuperación de información (IR) se centra en el estudio de métodos y sistemas que permiten localizar, dentro de grandes colecciones de documentos, aquellos que respondan de mejor forma a una necesidad informativa expresada por el usuario a través de una consulta o #emph[query]. Este proceso implica identificar, clasificar y ordenar documentos según su grado de relevancia, apoyándose en modelos matemáticos y estadísticos que describen la relación entre las palabras de la consulta y el contenido del _corpus_. En la práctica, los sistemas de recuperación de información sustentan desde buscadores web hasta repositorios científicos y bases de datos digitales @Query-difficulty-definition.

Cabe mencionar que, en el contexto de IR se entiende por documento cualquier unidad de información almacenada en el sistema, como puede ser un artículo científico, una página web o un informe técnico @laplacian-smoothing. 

El conjunto completo de documentos disponibles para ser buscados se denomina corpus o colección. Por otra parte, la consulta corresponde a la expresión, generalmente breve, con la que el usuario comunica su necesidad de información, esta puede estar compuesta por palabras clave, frases o descripciones más amplias @laplacian-smoothing.

En los sistemas de evaluación, estas consultas se agrupan junto con sus documentos y juicios de relevancia en lo que se conoce como colecciones de referencia, las cuales permiten medir objetivamente el rendimiento de distintos modelos de recuperación @laplacian-smoothing.

Así mismo, en este trabajo la relevancia se entenderá como el grado en que un documento satisface la necesidad informativa planteada en la consulta. De forma complementaria, se denomina ruido a los documentos que, aun siendo recuperados, no aportan información útil respecto al tema consultado. Por lo tanto, un sistema de recuperación efectivo es aquel que maximiza los documentos relevantes y minimiza el ruido, priorizando la calidad de los resultados.

El propósito fundamental de un sistema IR consiste en maximizar la relevancia de los resultados y minimizar el ruido, es decir, la cantidad de documentos menos pertinentes dentro del conjunto de datos recuperado. Esta función se ha vuelto crítica frente al crecimiento exponencial de la información que disponemos en formato digital, donde la eficiencia en las búsquedas y la organización del conocimiento determinan la calidad de la experiencia informativa. Además, como se menciona en @microsoft-preretrieval, la efectividad de un sistema IR no depende únicamente del modelo de recuperación utilizado, sino también de la formulación de la consulta y de la naturaleza del corpus.

El desarrollo de la Recuperación de Información se remonta a mediados del siglo XX, con los primeros sistemas booleanos aplicados en bibliotecas digitales. Con el avance de la informática y el Internet, el volumen de datos textuales creció de forma exponencial, impulsando el surgimiento de modelos estadísticos y probabilísticos capaces de manejar grandes colecciones de documentos @laplacian-smoothing.

Actualmente, el campo ha evolucionado hacia el uso de modelos híbridos, que integran principios clásicos de IR con técnicas de aprendizaje automático y modelos de lenguaje, permitiendo una comprensión más profunda de la intención del usuario @RAG.

En la actualidad, estos modelos se utilizan en motores de búsqueda, asistentes conversacionales y sistemas de recomendación, demostrando que la IR se ha convertido en un componente transversal dentro del procesamiento de la información digital.

En este sentido, la Recuperación de Información no solo constituye la base de los sistemas de búsqueda automatizada, sino también establece un punto de partida para la comprensión del comportamiento de las consultas, el análisis de su dificultad y la estimación del rendimiento, siendo estos los aspectos centrales para la presente investigación, cuyo objetivo se orienta en evaluar distintos métodos de predicción sobre el desempeño de consultas en modelos clásicos de recuperación de información.
#v(10pt)

=== Modelos de recuperación de información
\
Los modelos de recuperación de información constituyen el núcleo de un sistema IR, ya que estos definen cómo se mide la relevancia entre una consulta y los documentos del corpus. Estos modelos, además de definir formalmente la manera en que los términos de una consulta se comparan con las representaciones internas de los documentos, permiten calcular una puntuación o ranking de relevancia @laplacian-smoothing. Es así que, a lo largo de los años, se han desarrollado tres enfoques principales: el modelo booleano, el modelo vectorial y el modelo probabilístico, cada uno con sus propias ventajas y limitaciones @microsoft-preretrieval @zendel2024qpptk.

El modelo booleano fue el primero en ser implementado y se basa en la lógica clásica de operadores como AND, OR y NOT. En este enfoque, un documento es recuperado únicamente si cumple con las condiciones lógicas impuestas por la consulta realizada, sin establecer grados intermedios de relevancia. Este comportamiento se ilustra en la @fig:fig-venn, donde la intersección de los conjuntos representa la operación lógica AND. Si bien, este modelo es eficiente en contextos cerrados debido a su simplicidad, carece de una capacidad para ordenar los resultados, lo que limita su utilidad en escenarios de búsquedas más complejos @Query-difficulty-definition.

\
#import "@preview/cetz:0.3.1" as cetz

#figure(
  cetz.canvas({
    import cetz.draw: *
    
    let r = 2
    let d = 1.2
    
    circle((-d, 0), radius: r, fill: blue.transparentize(50%), stroke: blue)
    
    circle((d, 0), radius: r, fill: green.transparentize(50%), stroke: green)
    
    content((0, 0), [$A sect B$], frame: "rect", fill: white.transparentize(40%), stroke: none, padding: 3pt)
    
    content((-d - 0.5, 0), [Término A])
    content((d + 0.5, 0), [Término B])
  }),
  caption: "Diagrama de Venn del Modelo Booleano.",
)<fig-venn>
\

Por otra parte, el modelo vectorial introdujo una representación algebraica tanto para los documentos como para las consultas, tratándolos como vectores en un espacio multidimensional, en el que cada dimensión corresponde a un término y los pesos asignados reflejan su importancia relativa. La similitud entre consulta y documento se mide, por lo general, mediante el coseno entre los vectores; como se observa en la @fig:vectorial-diagrama, esta medida depende directamente del ángulo $theta$ formado entre ambos vectores en el espacio vectorial.  Este particular enfoque permitió establecer rankings de relevancia y representó un avance significativo en la precisión de los sistemas IR @zendel2024qpptk.

\
#import "@preview/cetz:0.3.1" as cetz

#figure(
  cetz.canvas({
    import cetz.draw: *

    let axis-len = 4.5
    let origin = (0,0)

    line(origin, (axis-len, 0), mark: (end: "stealth"), name: "x")
    line(origin, (0, axis-len), mark: (end: "stealth"), name: "y")

    content("x.end", anchor: "west", padding: .2)[Término 1]
    content("y.end", anchor: "south", padding: .2)[Término 2]

    let vec-d = (3, 3.5)
    line(origin, vec-d, stroke: (paint: blue, thickness: 1.5pt), mark: (end: "stealth", fill: blue), name: "d")
    
    let vec-q = (4, 1.5)
    line(origin, vec-q, stroke: (paint: orange, thickness: 1.5pt), mark: (end: "stealth", fill: orange), name: "q")

    content("d.end", anchor: "south-west", padding: .2)[Documento]
    content("q.end", anchor: "west", padding: .2)[Consulta]

    arc(origin, radius: 1.5, start: 20deg, stop: 49deg, stroke: (dash: "densely-dashed"))
    
    let mid-angle = (20deg + 49deg)/2
    content((mid-angle, 1.8), [$theta$])

  }),
  caption: "Representación geométrica del Modelo Vectorial.",
) <vectorial-diagrama>
\

Por último, el modelo probabilístico se basa en estimar la probabilidad de relevancia de un documento a través de una consulta, en donde su versión más consolidada, el BM25 (abreviatura de "Best Match 25", refiriéndose a la iteración número 25 de la función de ranking), calcula dicha probabilidad a partir de la frecuencia de los términos en el documento y su frecuencia inversa en el corpus, normalizando además por la longitud del texto, como se puede ver en la @fig:bm25-final. En este aspecto, BM25 ofrece equilibrio entre simplicidad, interpretabilidad y desempeño, razón por la cual es el modelo base en la mayoría de los experimentos y benchmarks actuales de IR @zendel2024qpptk.

\
// Importaciones y Definiciones (SOLO UNA VEZ)
#import "@preview/fletcher:0.5.4" as fletcher: diagram, node, edge
#import fletcher.shapes: *

#let component(pos, label, tint: white, ..args) = node(
  pos,
  align(center, label),
  width: 35mm,
  fill: tint.lighten(80%),
  stroke: 1pt + tint.darken(10%),
  corner-radius: 5pt,
  ..args,
)

#figure(
  diagram(
    spacing: 5pt,
    cell-size: (20mm, 12mm), 
    edge-stroke: .8pt,

    // Nodos
    component((0,0), [Consulta], tint: purple, name: "query"),
    component((0,2), [Frecuencia \ Inversa \ *(IDF)*], tint: blue, name: "idf"),

    component((3,0), [Documento], tint: purple, name: "doc"),

    component((2.2, 2), [Frecuencia \ del Término \ *(TF)*], tint: blue, name: "tf"),
    component((3.8, 2), [Normalización \ de Longitud], tint: blue, name: "len"),

    component((1.5, 4), text(1.1em)[*Modelo BM25*], tint: yellow, width: 50mm, name: "bm25"),
    component((1.5, 5.5), [Score de \ Relevancia], tint: green, name: "score"),

    // Conexiones
    edge(<query>, <idf>, "->"),
    edge(<idf>, <bm25>, "->"),

    edge(<doc>, <tf>, "->"),
    edge(<doc>, <len>, "->"),
    
    edge(<tf>, <bm25>, "->"),
    edge(<len>, <bm25>, "->"),

    edge(<bm25>, <score>, "->"),
  ),
  caption: "Componentes estructurales del modelo BM25.",
) <bm25-final>
\

Además de los modelos clásicos, se han desarrollado extensiones que buscan optimizar la precisión y la capacidad de generalización. Entre ellas, el BM25F incorpora información estructural de los documentos, el RM3 introduce retroalimentación mediante expansión de consultas, y los modelos neuronales de recuperación (Neural IR) utilizan representaciones distribuidas del texto para capturar relaciones semánticas más complejas @RAG. Estas variantes reflejan la evolución del campo hacia un paradigma híbrido, donde la caracterización de principios y limitaciones sintetizada en la @tbl:modelos-ir fundamenta por qué los modelos tradicionales siguen siendo la base para experimentos controlados y reproducibles.

\
#show figure: set block(breakable: true)
#figure(
  table(
    columns: (80pt, 160pt, 100pt, 100pt),
    inset: 14pt,
    stroke: (x: none),
    row-gutter: (2.5pt, auto),
    align: left + horizon,
    table.header(
      [*Modelo*], [*Principio de funcionamiento*], [*Ventajas*], [*Limitaciones o uso típico*],
    ),
    [Booleano],
    [Recupera documentos que cumplen exactamente la condición lógica (AND, OR, NOT).],
    [Simple, interpretable, útil en colecciones controladas.],
    [No entrega ranking ni grados de relevancia; poca flexibilidad en consultas reales.],
    [Vectorial],
    [Representa documentos y consultas como vectores ponderados y mide similitud.],
    [Permite ranking, ponderación de términos (TF-IDF) y mejora de precisión.],
    [Sensible al vocabulario y sinónimos; requiere buen preprocesamiento.],
    [Probabilístico / BM25],
    [Estima probabilidad de relevancia según frecuencia de término, rareza en el corpus y longitud del documento.],
    [Equilibrio entre desempeño y simplicidad; estándar en benchmarks.],
    [Requiere calibración de parámetros; asume independencia de términos.],
    [Extensiones (BM25F, RM3, Neural IR)],
    [Incorporan la estructura del documento, retroalimentación o las representaciones distribuidas.],
    [Mejoran recuperación en dominios complejos o semánticos.],
    [Mayor costo computacional; suelen usarse como capa superior o en escenarios específicos.],
  ),
  caption: "Modelos de recuperación de información y su propósito dentro de un sistema IR.",
) <modelos-ir>
\

El resultado final que entrega un sistema IR se presenta como un ranking de documentos, es decir, una lista ordenada de mayor a menor relevancia estimada. Este refleja la manera en que los usuarios perciben la utilidad del sistema, ya que la mayoría solo revisa los primeros resultados, lo que convierte la posición del documento en un factor crítico de evaluación.

En este trabajo se adopta principalmente el escenario de recuperación clásica, basado en BM25 y colecciones estándar, dado que la mayoría de los métodos de predicción de rendimiento han sido propuestos y validados en este contexto, y porque permite la comparación directa con estudios previos como los reportados en QPP-TK y benchmarks recientes de QPP @zendel2024qpptk.

#v(10pt)
=== Componentes de un sistema de recuperación de información
\
Para que la búsqueda sea eficiente en colecciones grandes, los sistemas IR no recorren todos los documentos cada vez que se hace una consulta, sino que utilizan estructuras de datos especializadas, siendo la más común el índice invertido, que almacena, para cada término, la lista de documentos en los que aparece. De esta forma, el sistema puede ir directamente a los documentos candidatos sin revisar toda la colección @laplacian-smoothing.

Es así que un sistema de recuperación de información se compone de diversas etapas que trabajan de forma conjunta para transformar documentos sin estructura en resultados relevantes para el usuario. En términos generales, estas etapas son la indexación, la representación de los documentos y consultas, el modelo de recuperación y la evaluación del sistema, las cuales configuran la arquitectura operativa detallada en la @fig:ir-components-diagram @query-difficulty-book @predicting-performance.

La indexación constituye el proceso inicial, encargado de convertir los documentos en representaciones internas que se puedan manipular. Para ello, se aplican distintas técnicas de preprocesamiento, como la #emph[tokenización], que consiste en dividir el texto en unidades mínimas llamadas #emph[tokens;] la eliminación de palabras vacías o #emph[stopwords], es decir, términos muy frecuentes que aportan poca información; y el #emph[stemming] o lematización, que reduce las palabras a su forma canónica con el objetivo de unificar variantes morfológicas. El resultado es una estructura conocida como índice invertido, que permite localizar rápidamente qué documentos contienen un término específico y con qué frecuencia. Este componente es esencial para la eficiencia del sistema, ya que permite búsquedas rápidas en grandes volúmenes de información.

La eficiencia de estas estructuras es fundamental para la escalabilidad del sistema, especialmente cuando el corpus crece hasta millones de documentos como ocurre en los benchmarks modernos.

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

\

#figure(
  diagram(
    spacing: 2pt,
    cell-size: (6mm, 10mm),
    edge-stroke: .8pt,

    component((0,2), [Consulta \ del Usuario], tint: purple, name: "query"),

    component((0,0), [Corpus de \ Documentos \ (colección)], tint: purple, name: "corpus"),

    component((3,0), [Preprocesamiento \ e Indexación \ de Documentos], tint: yellow, name: "indexing", width: 42mm),

    component((6,2), [Representación de \ Documentos \ y Consultas], tint: blue, name: "representation", width: 45mm),

    component((6,4), [Modelo de \ Recuperación], tint: yellow, name: "retrieval", width: 38mm),

    component((3,4), [Ranking de \ Resultados], tint: purple, name: "ranking"),

    component((0,4), [Evaluación \ del Sistema], tint: green, name: "evaluation", width: 38mm),

    edge(<corpus>, <indexing>, "->"),
    edge(<indexing>, <representation>, "->"),
    edge(<representation>, <retrieval>, "->"),
    edge(<retrieval>, <ranking>, "->"),
    edge(<ranking>, <evaluation>, "->"),

    edge(<query>, <representation>, "->",
      $"Transformación de la consulta"$,
      label-pos: 0.5,
      label-side: center,
    ),

  ),
  caption: "Componentes fundamentales de un sistema de Recuperación de Información.",
) <ir-components-diagram>

\

Por otra parte, la representación de documentos y consultas determina cómo se describen los textos dentro del sistema, asignando un peso a cada término para indicar su importancia relativa. En los sistemas clásicos, la representación más extendida es el modelo de espacio vectorial, en el cual tanto los documentos como las consultas se representan mediante vectores cuyas dimensiones corresponden a los términos del vocabulario.

El cálculo de estos pesos sigue criterios estadísticos, en donde la técnica estándar es el esquema TF-IDF, que combina dos componentes: la frecuencia del término (TF) que mide cuántas veces aparece un término dentro de un documento y la frecuencia inversa de documento (IDF) que indica cuán raro o discriminativo es el término dentro del corpus completo. De esta forma, se otorga mayor importancia a palabras que son relevantes dentro de un documento pero poco frecuentes en la colección, mejorando la capacidad del sistema para distinguir documentos pertinentes @query-difficulty-book.

Posteriormente, el modelo de recuperación se encarga de comparar las representaciones de las consultas con las de los documentos, generando así una puntuación de similitud o probabilidad de relevancia. Es a partir de estas puntuaciones que el sistema construye un ranking de resultados, donde los documentos se ordenan de mayor a menor relevancia, siendo este ranking la salida final que recibe el usuario @zendel2024qpptk.

Por último, la evaluación del sistema mide el desempeño del proceso de recuperación. En esta etapa, se utilizan juicios de relevancia (#emph[qrels]) para determinar si los documentos recuperados son pertinentes o no. Los qrels son listas que asocian cada consulta con los identificadores de los documentos que fueron marcados como relevantes por evaluadores humanos, funcionando como el estándar de comparación necesario para el cálculo de las métricas de efectividad y asociación sistematizadas en la @tbl:metricas-ir.

\
#show figure: set block(breakable: true)
#figure(
  table(
    columns: (auto, auto, auto, auto),
    inset: 15pt,
    stroke: (x: none),
    row-gutter: (2.5pt, auto),
    align: left + horizon,
    table.header(
      [*Recurso / métrica*], [*Qué mide*], [*Cuándo se usa*], [*Notas*],
    ),
    [Qrels (juicios de relevancia)],
    [Listado de documentos marcados como relevantes para cada consulta.],
    [Base de toda evaluación offline (TREC, Cranfield, Antique).],
    [Pueden ser binarios o graduados; dependen de evaluador humano.],
    [Precision / Recall],
    [Exactitud y cobertura de los documentos recuperados.],
    [Tareas simples o colecciones pequeñas.],
    [No consideran orden del ranking.],
    [MAP (Mean Average Precision)],
    [Precisión promedio sobre todas las posiciones relevantes.],
    [Comparar sistemas en búsqueda ad-hoc.],
    [Promedia sobre consultas; sensible a consultas difíciles.],
    [nDCG],
    [Relevancia graduada ponderada por la posición en el ranking.],
    [Cuando hay distintos niveles de relevancia o se valora el orden.],
    [Muy usada en benchmarks modernos.],
    [Kendall’s τ / Pearson r],
    [Asociación entre valores predichos y rendimiento real.],
    [Evaluar métodos de QPP.],
    [Necesitan pares (predicho, observado) por consulta.],
  ),
  caption: "Recursos y métricas comunes para la evaluación de sistemas IR y de métodos de predicción de rendimiento.",
) <metricas-ir>
\

En la evaluación de sistemas IR suele asumirse que los juicios de relevancia son correctos y completos, sin embargo, distintos estudios demuestran que la calidad de estos juicios depende en gran medida de la experticia del evaluador y del dominio temático de la colección @evaluator-domain-expertise. Cuando los evaluadores no son especialistas en el área o cuando la tarea es muy abierta, pueden aparecer discrepancias entre jueces, lo que introduce ruido en las métricas obtenidas y, por extensión, en la evaluación de los métodos de predicción de rendimiento @correlation-depends-on-quality-of-dataset.

Esta situación es particularmente relevante para trabajos como el presente, donde el objetivo es correlacionar el valor entregado por un predictor con la efectividad real de la consulta, por ende, si los juicios de relevancia son incompletos o poco consistentes, la correlación observada puede reflejar las limitaciones de la colección más que las del método evaluado.

De esta forma, los componentes de un sistema de recuperación de información funcionan como partes de un ciclo continuo, la indexación estructura, la representación abstrae, el modelo de recuperación calcula y la evaluación retroalimenta el proceso.

#v(10pt)
=== Consultas, tópicos y búsquedas ad-hoc
\
Es importante distinguir entre consulta y tópico, la primera es la expresión que el usuario introduce en el sistema, mientras que el tópico representa la necesidad informativa completa, que puede incluir una descripción y una narrativa que detalla qué se considera relevante.

Las consultas son la forma en la cual los usuarios expresan su necesidad de información dentro de un sistema IR. Por lo general, estas son breves, ambiguas o incompletas, lo que genera variabilidad en el rendimiento de los sistemas @Meng2023QPP.

A cada consulta se le asocia un tópico, entendido como el contexto o tema subyacente que representa la intención informativa del usuario. En los benchmarks tradicionales, cada tópico incluye una descripción breve de la necesidad informativa y una lista de documentos considerados relevantes. Esta estructura permite establecer condiciones experimentales controladas para evaluar el rendimiento de distintos sistemas y analizar la variabilidad entre consultas.

Este esquema responde al denominado #emph[paradigma Cranfield], en el cual se define un conjunto fijo de consultas, se construye un conjunto de documentos candidatos y se recolectan juicios de relevancia humanos para cada consulta. A partir de esta configuración es posible comparar distintos modelos de recuperación bajo las mismas condiciones y, sobre todo, repetir los experimentos en el tiempo, lo que explica por qué colecciones como #emph[TREC], #emph[Cranfield] o #emph[Antique] se utilizan de forma recurrente en trabajos de evaluación y en investigaciones sobre QPP @Meng2023QPP @how-much-correlation-is-good.

Dentro del campo de IR, el término búsqueda ad-hoc hace referencia a una tarea en la que se intenta recuperar los documentos más relevantes de un corpus dada una consulta única y sin contexto previo. A diferencia de otras búsquedas, como la interactiva o conversacional, la búsqueda ad-hoc no cuenta con realimentación del usuario ni refinamiento iterativo. Por ello, el desempeño del sistema depende en gran medida de qué tan bien logra interpretar los términos de la consulta y relacionarlos con los documentos del corpus @predicting-performance.

Los estudios sobre rendimiento en sistemas IR han demostrado que la dificultad de una consulta está estrechamente vinculada con su capacidad de discriminar documentos relevantes, por ejemplo, las consultas cortas o con términos frecuentes en el corpus tienden a recuperar documentos menos específicos, reduciendo la efectividad. En contraste, las consultas con términos raros o especializados suelen dar resultados más concentrados y relevantes @query-difficulty-book. Este comportamiento explica la necesidad de métricas y métodos de predicción de la dificultad, que permitan estimar la calidad esperada de la recuperación antes de disponer de juicios humanos.

En los últimos años, el concepto de búsqueda ad-hoc se ha extendido hacia escenarios más complejos, como la búsqueda conversacional o multiturno, en los que la consulta forma parte de un diálogo progresivo con el sistema. Estas nuevas modalidades introducen desafíos adicionales, como el seguimiento de contexto o la reformulación dinámica de la intención informativa @Meng2023QPP.

No obstante, el paradigma ad-hoc sigue siendo el marco experimental más utilizado para la evaluación de métodos QPP, ya que permite controlar las variables de consulta y corpus, proporcionando resultados comparables entre diferentes modelos de recuperación.

#v(10pt)
== Predicción de rendimiento de consultas (QPP)
\
La predicción del rendimiento de consultas (QPP, Query Performance Prediction), también conocida como estimación de la dificultad de la consulta (QDE, Query Difficulty Estimation), representa una rama de investigación en el campo de la Recuperación de Información (IR) que se enfoca en predecir la calidad de los resultados de búsqueda para una consulta dada, recuperados por un sistema de recuperación específico, sin necesidad de información de relevancia proporcionada por un operador humano. Este desafío surge de la observación de que los sistemas de búsqueda a menudo fallan en responder eficazmente a ciertas consultas, lo que se asocia directamente con la noción de dificultad de la consulta @query-difficulty-book.

La diversidad en el rendimiento de las consultas y entre diferentes sistemas ha impulsado esta área, buscando mitigar la variabilidad en la efectividad de la recuperación. En este sentido, QPP cumple un rol netamente preventivo: anticipar la dificultad para activar ajustes selectivos (expansión, elección de parámetros o flujos alternativos) antes de observar fallos, reduciendo la variabilidad y mejorando la experiencia del usuario.

#v(10pt)
=== Dificultad y rendimiento de las consultas
\
La dificultad de una consulta, en el ámbito de la Recuperación de Información (IR), se asocia principalmente con la incapacidad de un sistema para responder de manera efectiva a una necesidad de información específica. De acuerdo con @Query-difficulty-definition una consulta se considera difícil cuando el sistema de búsqueda obtiene un rendimiento deficiente en términos de sus medidas de efectividad. Este concepto es fundamental, ya que los fallos del sistema suelen estar directamente relacionados con la complejidad inherente o contextual de la consulta, lo que subraya la importancia de su predicción en la mejora continua de los sistemas de IR. La noción de dificultad de la consulta no es universal, y su interpretación puede variar dependiendo del contexto, el corpus, la ambigüedad de la consulta y el sistema de recuperación utilizado.

En contraste, el rendimiento de una consulta se define como una forma de estimar la dificultad inherente de la misma, mediante diversos experimentos de recuperación que generan a la vez múltiples métricas relacionadas con la calidad de los resultados obtenidos por el sistema. Estas métricas, obtenidas a través de experimentos que evalúan el resultado de la recuperación contra juicios de relevancia humana (_Qrels_), incluyen nDCG, _Recall_, AP y MAP, entre otras @query-difficulty-book. Cada experimento de recuperación produce estas métricas simultáneamente sobre la misma lista ordenada de documentos, permitiendo una evaluación multidimensional de la efectividad del sistema. Un alto rendimiento en estas métricas indica una consulta fácil con baja dificultad inherente, mientras que valores bajos sugieren una consulta difícil que desafía la capacidad del sistema para satisfacer la necesidad informativa del usuario. Según @zendel2024qpptk La predicción de este rendimiento es, por tanto, el núcleo de la predicción de rendimiento de consultas, buscando estimar estas métricas sin requerir juicios humanos de relevancia.

La interdependencia entre la dificultad y el rendimiento de las consultas es fundamental. Una consulta inherentemente difícil, ya sea por su ambigüedad, la escasez de documentos relevantes en el corpus, o la formulación ineficaz, tenderá a producir un bajo rendimiento en la mayoría de los sistemas de IR. Por lo tanto, estimar la dificultad de la consulta es, en esencia, un intento de predecir el rendimiento que un sistema específico logrará para esa consulta en el contexto de un corpus específico. Esta predicción permite a los sistemas anticipar posibles fallos y aplicar estrategias correctivas de manera proactiva, mejorando la experiencia del usuario y la eficiencia general del sistema.

Los factores que contribuyen a la dificultad de una consulta son variados y complejos. De acuerdo a @microsoft-preretrieval Pueden estar relacionados con la expresión misma de la consulta, como la ambigüedad léxica o semántica, o con su longitud y especificidad. Otro conjunto de factores se deriva del conjunto de datos o corpus, incluyendo su heterogeneidad, la distribución de términos y la cantidad de documentos relevantes disponibles. Finalmente, el método de recuperación empleado también influye en la dificultad percibida, ya que diferentes algoritmos pueden manejar la misma consulta con distintos niveles de éxito. Esta fuerte dependencia en múltiples factores hace que la predicción de la dificultad sea un desafío significativo incluso cuando se trata de predicciones realizadas por jueces expertos en el área @Query-difficulty-definition @trec-6.

La generalidad de la dificultad de una consulta es un aspecto clave a considerar. Una consulta puede ser difícil para un sistema de recuperación particular, pero no para otros, o puede ser consistentemente difícil a través de una variedad de sistemas y colecciones. Esta generalidad se mide a menudo promediando el rendimiento predicho de la consulta a través de múltiples métodos de recuperación y diversas colecciones de documentos. Comprender esta variabilidad es esencial para desarrollar y evaluar predictores de dificultad que sean robustos y aplicables en diferentes escenarios de búsqueda, más allá de un único contexto sistema-colección @correlation-depends-on-quality-of-dataset.

//estos simbolos son solo espaciadores
#show math.equation: it => {
  show "ü": h(10pt)
  it
}
#show math.equation: it => {
  show "\\": h(-2pt)
  it
}
Recientemente la literatura ha propuesto varias estrategias formales para definir la dificultad de una consulta $q$ en particular. En palabras de @Query-difficulty-definition todas estas parten del valor $m_S_i \\ (q)$; la puntuación que entrega una métrica de efectividad $M$ (p. ej., $n D C G$, $A P$) cuando se evalúa la lista recuperada para $q$ por un sistema de recuperación $S_i$. Este valor sintetiza el rendimiento del sistema en esa consulta (cuanto menor es $m_S_i (q)$, más difícil resultó $q$ para $S_i$), y es la variable base con la que se etiquetan las clases de dificultad. Estas estrategias se resumen en la @tbl:definiciones-dificultad:

1. *Percentiles:* Particiona la distribución de la métrica $M$ por consulta mediante percentiles. En el caso binario, como se muestra en la @eqt:dificultad-percentil-binaria, una consulta $q$ se considera difícil para un sistema $S_i$ si su valor $m_S_i (q)$ es menor o igual que un percentil $p_x$, es decir, si aproximadamente $x\%$ de las consultas tienen un valor inferior. En el caso de desear una dificultad graduada, se utilizan $N-1$ percentiles para definir $N$ clases ordenadas de dificultad, donde la primera clase agrupa las consultas más difíciles y la última las más fáciles.
\
$ p_x : "dificultad"(q) = 1_{m_s_i (q) <= p_x} $ <dificultad-percentil-binaria>
#pad(left:15pt)[
\

En estas expresiones, $"dificultad"(q)$ es una función indicadora que toma el valor 1 cuando la consulta $q$ se etiqueta como difícil y 0 en caso contrario. El parámetro $p_x$ corresponde al percentil $x$‑ésimo de la distribución de $M$ sobre todas las consultas, de modo que $1_{m_{S_i}(q) <= p_x}$ marca como difíciles aquellas cuyo rendimiento cae en el $x\%$ inferior de la distribución.

\
]
$
  q in cases(
     D_1 ü ü ü ü ü ü ü ü ü ü ü "si" m_s_i \\(q) <= p_1,
     D_i"," forall_i = 2"," ... "," N-2 ü ü"si" P_(i-1) < m_s_i \\ (q) <= P_i,
     D_N ü ü ü ü ü ü ü ü ü ü ü \\ \\ "si" m_s_i \\(q) > P_(N-1)
  )
$<dificultad-percentil-graduada>
\

#pad(left:15pt)[
  En el caso graduado @eqt:dificultad-percentil-graduada, los símbolos $D_1, ..., D_N$ representan clases ordenadas de dificultad (por ejemplo, muy difícil, difícil, fácil, muy fácil), mientras que $P_1, ..., P_{N-1}$ son percentiles crecientes que dividen la distribución de $M$ en $N$ segmentos. Cada consulta $q$ se asigna a una clase $D_k$ en función del intervalo en el que cae su valor $m_{S_i}(q)$ con respecto a estos cortes percentilares.    
]
2. *Umbrales:* Fija cortes absolutos sobre la métrica para definir clases de dificultad. En el caso binario, como se expresa en la @eqt:dificultad-umbrales, una consulta $q$ es difícil para $S_i$ si $m_S_i (q)$ es menor o igual que un umbral $T$ (por ejemplo, consultas con $P@10 <= 0.1$). Para el caso graduado, se emplea un conjunto de umbrales $T_1, ..., T_(N-1)$ que inducen $N$ clases de dificultad ordenadas. 

\
$ T : "dificultad"(q) = 1_{m_s_i \\(q) <= T} $ <dificultad-umbrales>
\

#pad(left:15pt)[
Generalmente existen dos configuraciones típicas:
  
En la definición por umbrales, $T$ es un corte absoluto fijado directamente sobre la escala de la métrica $M$. De nuevo, $"dificultad"(q)$ es una función indicadora que vale 1 si el rendimiento $m_{S_i}(q)$ de la consulta cae por debajo o en el propio umbral $T$ (es decir, si la consulta no alcanza un mínimo de efectividad considerado aceptable) y 0 en caso contrario. 
]
 #pad(left:10pt)[
  - *Umbral único:* Se define un solo punto de corte. Por ejemplo, las consultas con $P@10 <= 0.1$ se consideran difíciles y el resto no difíciles, creando una clasificación binaria.
  - *Pares de umbrales:* Se usan dos umbrales para aislar los extremos. Por ejemplo, con el par $(0.1, 0.9)$, las consultas con $A P <= 0.1$ son muy difíciles y aquellas con $A P >= 0.9$ son muy fáciles. Las consultas intermedias se ignoran o se les asigna una clase intermedia, creando un margen que facilita la predicción al enfocarse solo en los casos más claros @Query-difficulty-definition.
 ]
  #pad(left:15pt)[
  En la versión graduada, una secuencia ordenada de umbrales $T_1 < ... < T_{N-1}$ permite definir varias clases de dificultad a partir de rangos absolutos de $M$: por ejemplo, muy difícil para $m_{S_i}(q) <= T_1$, difícil para $T_1 < m_{S_i}(q) <= T_2$, y así sucesivamente, hasta una última clase que agrupa las consultas con mejores valores de la métrica.
  ]
3. *Combinada:* Combina ambos criterios: percentiles y por umbral. En el caso binario, presentado en la @eqt:dificultad-combinada, una consulta se considera difícil si es clasificada como difícil tanto por la definición basada en percentiles como por la basada en umbrales (es decir, si $m_S_i (q) <= T$ y $m_S_i (q) <= p_x$). Para dificultad graduada, la clase asignada a una consulta corresponde a la intersección de las clases obtenidas con cada una de las dos estrategias anteriores.
\
$
  "dificultad"(q) = 1_{m_s_i \\ (q) ü \\ \\ \\ <= ü \\ \\ \\T ü \\ \\ \\ \\ amp ü \\ \\ \\ \\ m_s_i \\ (q) ü \\ \\ \\ <= ü \\ \\ \\ p_x}
$ <dificultad-combinada>
\

#pad(left:15pt)[
En la definición combinada, la función $"dificultad"(q)$ solo toma el valor 1 cuando simultáneamente se cumplen las dos condiciones anteriores: el rendimiento de la consulta está por debajo del percentil $p_x$ y, al mismo tiempo, por debajo del umbral absoluto $T$. La notación $1_{A \land B}$ indica la función indicadora del evento intersección entre $A$ y $B$: vale 1 únicamente cuando ambas desigualdades se satisfacen, y 0 en cualquier otro caso.
]

Estas estrategias pueden plantearse en un enfoque centrado en un único sistema, donde la dificultad se define respecto de un sistema $S_i$ específico, o bien respecto de un conjunto de sistemas $S = {S_1, ..., S_K}$, reemplazando el conjunto de valores ${m_S_1 (q), ..., m_S_K (q)}$ por su promedio $frac( 1,K ) sum_(i=1)^K m_S_i (q)$ sobre todos los sistemas considerados. La evidencia empírica muestra que las definiciones por umbrales con una separación marcada entre clases (p. ej., muy difíciles vs. muy fáciles) suelen producir sets de entrenamiento más contrastados y por ende, predicciones más estables y con mayores verdaderos positivos que las definiciones puramente percentilares o combinadas @Query-difficulty-definition.

\
#show figure: set block(breakable: true)
#figure(
  table(
    columns: (1fr, 2fr, 2fr),
    inset: 15pt,
    stroke: (x: none),
    row-gutter: (2.5pt, auto),
    align: left + horizon,
    table.header(
      [*Definición*], [*Descripción*], [*Notas/Configuración típica*],
    ),
    [Percentiles],
    [Particiona la distribución de la métrica $M$ por consulta mediante percentiles para inducir clases de dificultad (por ejemplo, de *muy difícil* a *muy fácil*).],
    [Caso binario: difícil si $m_S_i (q) <= p_x$. Caso graduado: $N-1$ percentiles definen $N$ clases ordenadas; sensibilidad fuerte al dataset.],
    [Umbrales],
    [Fija cortes absolutos sobre la métrica para definir clases de dificultad, típicamente enfocadas en consultas muy difíciles o muy fáciles.],
    [Caso binario: difícil si $m_S_i (q) <= T$ (ej: `P@10 <= 0.1`). Caso graduado: umbrales $T_1, ..., T_(N-1)$ inducen $N$ clases; configuraciones habituales con umbral único o pares de umbrales para aislar extremos.],
    [Combinada],
    [Combina criterios percentilares y de umbrales, asignando dificultad sólo cuando ambas definiciones coinciden.],
    [Menos estable empíricamente que los esquemas basados sólo en umbrales con brechas marcadas entre clases.],
    [Ámbito],
    [Definición respecto de un sistema específico o de un conjunto de sistemas de recuperación.],
    [Centrada en un sistema $S_i$ o sobre un conjunto $S$, promediando la métrica entre sistemas.],
  ),
  caption: "Formas de definir la dificultad de una consulta.",
) <definiciones-dificultad>
\

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
=== Soluciones al problema de la dificultad de las consultas
\
La dificultad inherente de ciertas consultas ha impulsado el desarrollo de técnicas robustas para mejorar la efectividad de los sistemas de recuperación de información. A lo largo del tiempo, las soluciones han evolucionado desde métodos estadísticos clásicos hasta arquitecturas neuronales avanzadas, buscando siempre mitigar los fallos de recuperación asociados a consultas ambiguas, complejas o con desajuste de vocabulario.

Una de las primeras y más influyentes soluciones fue el desarrollo de modelos de relevancia. El artículo que introdujo estos modelos @relevance-models con implementaciones como RM3 o implementaciones similares como PRM @PRM, indica que en lugar de depender exclusivamente de los términos de la consulta original, se puede aplicar una técnica que utiliza dos etapas para refinar la búsqueda. En este primer articulo se presenta la arquitectura general de un modelo de relevancia.

Primero, se realiza una recuperación inicial y se asume que los documentos mejor clasificados son relevantes (un concepto conocido como _pseudo-relevance feedback_). A partir de este conjunto de documentos, se construye un modelo probabilístico que estima la distribución de términos que probablemente aparecerían en documentos verdaderamente relevantes. Los términos con alta probabilidad en este modelo, que pueden no haber estado en la consulta original, se utilizan para expandir o reestructurar la consulta. 

Finalmente, esta nueva "consulta expandida" se utiliza para realizar una segunda recuperación, que a menudo produce un ranking de resultados mucho más preciso, resolviendo problemas comunes como la sinonimia y la polisemia.

\
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
\

En la @fig:relevance-model-flow se ilustra el flujo típico de expansión mediante modelos de relevancia: una consulta inicial se ejecuta con un ranker léxico (BM25) para obtener los _top‑K_ documentos; a partir de ese conjunto pseudo‑relevante se estima un modelo que induce nuevos términos y pesos; con la consulta expandida resultante se realiza una segunda recuperación, cuyo objetivo es reordenar con mayor precisión y producir un ranking final de documentos más alineado con la intención de la consulta.

Más recientemente, la llegada de los modelos extensos del lenguaje (LLMs) ha supuesto un avance significativo en el panorama de la recuperación de información. Sin embargo, como menciona @llm-hallucination @llm-reeval, uno de sus mayores problemas es que su conocimiento se "congela" en el momento del entrenamiento, lo que limita su acceso a información reciente, lo que los hace propensos a "alucinar" o generar contenido incorrecto en algunos casos amplificando sesgos existentes dentro de los datos de entrenamiento.

Para superar estas limitaciones, ha surgido el paradigma de la Generación Aumentada por Recuperación (RAG). Los modelos RAG combinan un recuperador de información con un LLM generativo en un proceso de dos fases:
#pad(left:15pt)[
1.  *Recuperación*: Un sistema de recuperación busca en una base de conocimiento (por ejemplo, una colección de documentos) para encontrar fragmentos de texto relevantes para la consulta.
2.  *Generación*: Estos fragmentos recuperados se proporcionan como contexto a un LLM junto con la consulta original. El LLM sintetiza una respuesta coherente y factual, fundamentada en la evidencia extraída.
]
Este enfoque ancla las respuestas del LLM en información verificable, reduciendo las alucinaciones y permitiendo que el conocimiento del sistema se actualice simplemente actualizando la base de conocimiento documental. Es una técnica especialmente poderosa para consultas de conocimiento intensivo que demandan respuestas precisas y actualizadas @RAG.

A pesar de su efectividad, estas soluciones avanzadas (desde la expansión de consultas hasta _pipelines_ LLM + RAG) suelen tener un costo computacional elevado. No es eficiente ni necesario aplicarlas a todas las consultas, especialmente a aquellas que son simples y pueden ser respondidas adecuadamente por un sistema de recuperación estándar.

Por otro lado, la predicción del rendimiento de consultas (_QPP_) busca destacar especialmente en esta área. Los predictores funcionan como una herramienta de diagnóstico que estima de antemano la efectividad esperada de un sistema para una consulta dada, sin necesidad de utilizar juicios de relevancia humanos, otorgando una solución directa  a la problematica anterior para la identificación de consultas que puedan requerir de mecanismos mas complejos para su resolución. Al predecir si una consulta será "fácil" o "difícil", un sistema de IR puede tomar decisiones proactivas y selectivas. Para una consulta predicha como "fácil", se puede utilizar un método de recuperación rápido y eficiente. En cambio, si una consulta se predice como "difícil", el sistema puede activar mecanismos más eficaces y costosos, como la expansión de consultas, el uso de modelos de relevancia o la activación de un pipeline de _RAG_ para garantizar una respuesta de alta calidad. Por ende, QPP permite a los sistemas de recuperación gestionar estratégicamente sus recursos, mejorando la robustez y la eficiencia general al tiempo que se mitigan los fallos en las consultas más desafiantes @query-difficulty-book.

#v(10pt)
=== Taxonomías en QPP
\
La literatura distingue dos categorías principales de predictores de rendimiento de consulta según el momento en que extraen información: métodos _pre-retrieval_ y _post-retrieval_. Los primeros formalmente se caracterizan por actuar antes de ejecutar la búsqueda utilizando únicamente la consulta y estadísticas del índice; los segundos explotan señales observadas en la lista recuperada a partir de un modelo de recuperación de información (p. ej., patrones en las puntuaciones y funciones de ranking) @wig-nqc-scored-configuration.

En paralelo, al adentrarnos en el campo de la inteligencia artificial, podemos encontrar otras categorías de clasificación por ejemplo, régimen de aprendizaje (no supervisados frente a supervisados) y por entorno (búsqueda ad-hoc y conversacional utilizando modelos extensos del lenguaje), cuyas elecciones suponen compromisos entre costo computacional, latencia y capacidad para modelar fenómenos como ambigüedad, variación temática y distribuciones de consultas @Meng2023QPP @web-search-qpp.

#v(10pt)
==== Predictores _pre-retrieval_
\
Los predictores _pre-retrieval_ estiman la dificultad de una consulta a priori, sin ejecutar recuperación. Se apoyan en propiedades intrínsecas de la consulta y en estadísticas globales de la colección disponibles en tiempo de indexación. De forma general, caracterizan la especificidad y ambigüedad de la consulta, así como su potencial discriminativo en la colección, a partir de medidas o estadísticas resumidas que capturan propiedades léxicas de la consulta (longitud, diversidad o concentración de términos) y el patrón con que dichos términos aparecen en la colección (frecuencia y variabilidad entre documentos). Su atractivo radica en el bajo costo computacional y en que permiten decisiones de control (expansión, selección de sistema o ajuste de parámetros) antes de observar una lista recuperada @preretrieval-idf @idf-understanding.

#v(10pt)
- *_Inverse Document Frequency_* (Frecuencia inversa de documentos, IDF), ampliamente utilizado en el área, puede de igual manera funcionar como predictor pre-retrieval en sistemas de recuperación de información, este mide que tan específicos son los términos de una consulta dentro de un corpus. En el documento @preretrieval-idf, se profundiza su relevancia como un componente clave en la predicción del rendimiento de consultas (QPP), específicamente su capacidad para identificar términos altamente selectivos, es decir, aquellos que aparecen en pocos documentos (menos comunes) y, por ende, aportan mayor discriminación en la búsqueda. El IDF también puede ser utilizado en su variante IDF-Max, donde el término con la mayor frecuencia inversa dentro de una consulta sirve como indicador principal de su efectividad. Este indicador, que se basa en estadística, se adoptó rápidamente como una herramienta esencial en la predicción del rendimiento de consultas (QPP) pre-retrieval, siendo incorporada en otros esquemas y modelos probabilísticos de búsqueda. 

\
  $ I D F(t) = ln(1 + N/f_t) $ <idf-equation>
\

#pad(left:30pt)[Como se ve en la @eqt:idf-equation, $N$ es el número total de documentos en el corpus y $f_t$ es el número de documentos que contienen el término $t$, y se añade 1 para evitar divisiones por cero o valores indefinidos.
  
En el artículo @idf-understanding, el autor señala que el IDF asigna pesos más bajos a los términos frecuentes debido a su limitado poder discriminatorio, mientras que otorga pesos más altos a los términos menos comunes, los cuales poseen mayor capacidad para distinguir documentos relevantes, asegurando que los términos poco frecuentes, pero informativos, tengan un mayor impacto en el cálculo de relevancia. Además, se destaca que, aunque la formulación exacta del algoritmo puede variar según los autores, su utilidad general permanece sólida en una amplia gama de aplicaciones prácticas, incluyendo la recuperación de información y otros contextos relacionados con el análisis de datos.

De esta forma, el IDF ha sido ampliamente utilizado debido a su robustez y simplicidad. En el artículo @idf-understanding, el autor argumenta que el IDF equilibra de forma eficaz la especificidad y la relevancia, permitiendo su aplicación en diferentes contextos, tales como recuperación de textos, análisis de lenguaje natural e incluso en recuperación de medios no textuales.
  
En cuanto a su relevancia para el presente trabajo de título de evaluación de métodos de QPP, el IDF resulta relevante, ya que su capacidad para capturar la especificidad de los términos yace de manera tácita en otros predictores QPP, además, como se menciona en el artículo @predicting-performance, su integración en distintas métricas proporciona una línea base confiable para la comparación con métodos más avanzados, validando su referencia tanto de forma heurística como de herramienta teórica sólida y bien fundamentada.
]
#v(10pt)
- *_Similarity between Collection and Query_* (Similitud entre consulta y colección, SCQ), es un predictor pre-retrieval propuesto por Ying Zhao, Falk Scholer y Yohannes Tsegay. En el artículo @preretrieval-idf los autores explican que el SCQ calcula un puntaje de similitud entre una consulta y la colección de documentos, utilizando la frecuencia de términos en la colección y la frecuencia inversa de documentos (IDF) como evidencias para determinar la relevancia. Siendo una de sus principales ventajas que se basa en estadísticas disponibles durante el proceso de indexado, eliminando la necesidad de realizar búsquedas previas.

\
  $ S C Q = sum_(t in Q) ((1+ln(f_(c,t))) dot ln(1+N/f_(t)))  $ <scq-equation>
\
  
#pad(left:30pt)[En la @eqt:scq-equation, podemos ver que $Q$ es el conjunto de términos de la consulta, $f_(c,t)$ corresponde a la frecuencia del término $t$ en la colección, $f_t$ es el número de documentos en los que aparece el término $t$, y finalmente $N$ es el número total de documentos de la colección.
  
Como se menciona, el SCQ mide la similitud mediante una representación vectorial, donde tanto las consultas como los documentos son tratados como vectores. La proximidad entre estos vectores se interpreta como un indicador de relevancia que permite identificar consultas que potencialmente obtendrán un mejor rendimiento en la recuperación de información. Además, este predictor puede ajustarse mediante la normalización por longitud de la consulta o evaluarse en  función del valor máximo de SCQ alcanzado por los términos individuales.

Es así como, gracias a su balance entre la simplicidad y precisión, el SCQ promete ser una herramienta útil para sistemas de recuperación de información que manejan grandes volúmenes de datos en tiempo real, en donde su capacidad para establecer relaciones entre las características de las consultas y su rendimiento lo convierte en una contribución importante para tareas que involucran una alta variabilidad en las consultas, posicionándose como un estándar en evaluaciones pre-retrieval.

Por lo tanto, para el presente trabajo de título, el SCQ es particularmente relevante porque permite analizar consultas en dominios complejos y heterogéneos, estableciendo una relación clara entre las características de las consultas y su rendimiento esperado, lo que facilita una evaluación comparativa de métodos.
]
#v(10pt)
==== Predictores _post-retrieval_
\
Los predictores _post-retrieval_ se estiman una vez disponible la lista recuperada para la consulta determinada y se apoyan en señales observables en dicha lista. En términos generales, se agrupan en cuatro familias:
  #pad(left:15pt)[
+ El comportamiento de las puntuaciones devueltas por el ranker.
+ La coherencia y consistencia semántica de los documentos en la cima del ranking.
+ La estabilidad del ranking ante perturbaciones controladas (robustez).
+ El consenso con variantes del sistema o de la consulta. 
]
Estas familias de señales buscan captar indicios de dificultad a partir de la respuesta del sistema para la consulta concreta, bajo la caracterización de factores y señales sintetizada en la @tbl:tabla-factores-postretrieval.

\
#figure(
  table(
    columns: (1fr, 2fr, 2fr),
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
    [Correlación de rangos entre el ranking original y variantes (por ejemplo, con stemming, con expansión de consulta).]
  ),
  caption: "Factores y señales típicas en predictores post-retrieval.",
) <tabla-factores-postretrieval>
\

Los enfoques post-retrieval pueden ser no supervisados (agregan señales derivadas de la propia lista devuelta) o supervisados (aprenden a mapear representaciones de consulta-lista a una estimación de rendimiento). Su efectividad depende del tipo de recuperador (léxico o denso), de la profundidad considerada (top-k frente a listas profundas) y de las propiedades de la colección, dado que distintas distribuciones de puntuaciones y estructuras de ranking favorecen señales diferentes. Aunque su costo es mayor que el de los métodos pre-retrieval, suelen proporcionar estimaciones más informadas al incorporar evidencia del resultado concreto de recuperación @wig-nqc-scored-configuration @query-drift @statistical-decision-theory-uef.

En el contexto de este trabajo, se priorizó la revisión de métodos post-retrieval que no dependen de enfoques basados en inteligencia artificial (IA), los cuales son altamente valorados por su simplicidad y robustez en la predicción del rendimiento de consulta sirviendo como base para métodos QPP más complejos.

#v(10pt)
\
- *_Normalized Query Commitment_* (Compromiso de consulta normalizado, NQC) fue propuesto por Anna Shtok, Oren Kurland y David Carmel como un predictor post-retrieval que evalúa la efectividad de una consulta midiendo la dispersión de los puntajes de recuperación entre los documentos más relevantes. En el artículo @query-drift, los autores destacan que una menor dispersión temática en los documentos recuperados está directamente asociada con una mayor efectividad de las consultas, lo cual se refleja en la distribución de los puntajes de recuperación.

#pad(left:30pt)[Por lo tanto, el enfoque de NQC se centra en medir la desviación estándar de los puntajes de recuperación normalizados por el promedio del corpus, lo que permite identificar consultas cuyos documentos recuperados son consistentes en términos de relevancia, sugiriendo un buen desempeño de la consulta. Además, los documentos con puntajes significativamente superiores al promedio son menos propensos a exhibir desviaciones temáticas, lo que se traduce en un menor grado de _query drift_ y un mejor rendimiento de recuperación.
]
\
  $ N Q C(q, M)= (sqrt(1/k sum_(d in D[k]_q)(S c o r e(d) - mu)^2))/(S c o r e(D)) $ <nqc-equation>
\
  
#pad(left:30pt)[En la @eqt:nqc-equation, $q$ corresponde a la consulta, $M$ al modelo de recuperación, $D[k]_q$ a la lista de los k documentos mejor rankeados, μ al promedio de los puntajes de recuperación en $D[k]_q$ y $S c o r e[D]$ al puntaje de recuperación del corpus considerado como un único documento concatenado.
  
NQC resulta especialmente útil en el ámbito de la recuperación de información debido a su capacidad para capturar la consistencia en documentos relevantes y su adaptabilidad a diferentes modelos de recuperación, siendo su diseño simple lo que permite aplicarlo de manera eficiente, incluso en escenarios complejos donde se requiere alta precisión en los resultados.

Para el presente trabajo de título, NQC es relevante al proporcionar una métrica que permite evaluar la calidad de las consultas al correlacionar la dispersión de los puntajes con la efectividad esperada, lo que es fundamental para analizar consultas en dominios con alta variabilidad y establecer comparaciones confiables entre los diferentes métodos de predicción.
]
#v(10pt)
- *_Clarity Score_* (Puntuación de claridad, CS) fue desarrollado por Steve Cronen-Townsend, Yun Zhou y W. Bruce Croft como un predictor post-retrieval que analiza la claridad o coherencia de las consultas en sistemas de recuperación de información. En el artículo @predicting-performance, los autores explican que el CS se basa en la comparación entre un modelo de lenguaje generado a partir de una consulta y el modelo de lenguaje global del corpus, utilizando la divergencia de Kullback-Leibler como herramienta matemática que permite calcular la distancia entre ambos modelos. 

#pad(left:30pt)[La lógica detrás de CS implica que consultas con términos más claros y específicos generarán modelos de lenguaje que se diferencian significativamente del modelo del corpus, obteniendo puntajes más altos. Estos términos, al estar menos expuestos a interpretaciones ambiguas, tienden a recuperar documentos más relevantes y precisos. Por otro lado, las consultas con puntajes más bajos suelen reflejar una mayor ambigüedad o dispersión temática, lo que puede afectar negativamente la precisión de los resultados recuperados.

El CS se calcula como la divergencia de Kullback-Leibler entre el modelo de lenguaje de la consulta y el modelo de lenguaje de la colección lo que se puede ver en la @eqt:csq-equation.
]
\
  $ C S(Q)= sum_(w in V)(P(w | Q)log 2(P(w | Q))/(P c o l l(w))) $ <csq-equation>
\

#pad(left:30pt)[En donde $w$ es un término en el vocabulario $V, P(w | Q)$ es la probabilidad del término $w$ en el modelo de lenguaje de la consulta y $P c o l l(w)$ es la probabilidad del término $w$ en el modelo de lenguaje de la colección.
  
En términos prácticos, el CS demuestra ser una herramienta valiosa en el campo de la Recuperación de Información por varias razones fundamentales. En primer lugar, su capacidad para cuantificar la claridad de una consulta a través de la divergencia KL proporciona una medida objetiva de la especificidad de los términos de búsqueda. Además, al basarse en la comparación con el modelo de lenguaje de la colección completa, el método captura efectivamente las peculiaridades y la distribución del vocabulario en el dominio específico. Sin embargo, es importante señalar que su efectividad puede variar según las características del corpus y la naturaleza de las consultas, siendo particularmente útil en colecciones donde la ambigüedad terminológica representa un desafío significativo para la recuperación de información.

Finalmente, en el contexto del presente trabajo de título, el _Clarity Score_ es relevante por su capacidad para proporcionar un indicador temprano sobre la calidad de las consultas, permitiendo evaluar cómo estas interactúan con el corpus y qué tan bien pueden desempeñarse en términos de recuperación efectiva, resultando crucial en escenarios donde la variabilidad y complejidad de las consultas pueden influir significativamente en los resultados esperados.
]
#v(10pt)

- *_Weighted Information Gain_* (Ganancia de información ponderada, WIG) fue desarrollado por Yun Zhou y W. Bruce Croft como un predictor post-retrieval diseñado para abordar los desafíos de la predicción del rendimiento de consultas en entornos de búsqueda web. En el artículo @web-search-qpp, los autores destacan que WIG mide la contribución promedio de los documentos mejor clasificados a la calidad del rendimiento de la consulta, basándose en el análisis de las características individuales de los términos y su proximidad, lo que permite evaluar la efectividad de las consultas en colecciones grandes y heterogéneas.

#pad(left:30pt)[El cálculo de WIG se realiza comparando el cambio en la información entre un estado inicial, representado por un documento promedio del corpus, y el estado posterior, que corresponde a los resultados obtenidos tras la recuperación de los documentos relevantes. Este enfoque utiliza conceptos como la ganancia de información ponderada y distribuciones de probabilidad para estimar la calidad de la consulta, lo que lo convierte en una herramienta robusta para analizar el desempeño en escenarios complejos.

En la @eqt:wig-equation, podemos ver que WIG se define como la diferencia entre la entropía ponderada de los documentos mejor clasificados y la entropía del modelo de lenguaje de la colección.
]
\
  $ W I G(Q)= 1/k sum_(d in D k)(P(Q | d)log (P(Q | d))/(P(Q | C))) $ <wig-equation>
\
  
#pad(left:30pt)[En donde $Q$ es la consulta, $D k$ es el conjunto de los $k$ documentos mejor clasificados, $P(Q ∣ d)$ es la probabilidad de la consulta Q dado el documento d, y $P(Q ∣ C)$ es la probabilidad de la consulta Q dado el modelo de lenguaje de la colección.
  
Es así que, WIG es especialmente relevante debido a su capacidad para adaptarse a distintos tipos de consultas y colecciones, incluyendo aquellas con gran diversidad en calidad y estilo de los documentos, resultando crucial para evaluar la efectividad de las consultas, proporcionando una métrica sólida para comparar métodos avanzados de predicción del rendimiento y asegurando un análisis confiable en dominios variados.
]
#v(10pt)
- *_Utility Estimation Framework_* (Framework de estimación de utilidad, UEF) fue desarrollado por Anna Shtok, Oren Kurland y David Carmel como un enfoque post-retrieval que utiliza principios de la teoría estadística de decisiones para predecir el rendimiento de consultas. En el artículo @statistical-decision-theory-uef los autores explican que este método evalúa la calidad de un ranking de documentos basándose en su utilidad estimada con respecto a la necesidad de información representada en la consulta, proceso que se realiza al medir la similitud esperada entre el ranking generado y los rankings inducidos por modelos de relevancia.

#pad(left:30pt)[El marco UEF permite una gran flexibilidad al emplear diferentes métricas de similitud, como el coeficiente de correlación de Pearson, y al estimar modelos de relevancia utilizando _pseudo-relevance feedback_. Esta combinación proporciona una base teórica sólida para predecir el rendimiento de consultas, ya que integra la precisión de los modelos de relevancia con un enfoque estructurado que captura las características del ranking generado por la consulta.
]
\
  $ U(pi_M (q;D))= integral_(R_q)S i m(pi_M (R_q ;D))p(R_q | I_q)d R_q $ <uef-equation>
\
  
#pad(left:30pt)[En la @eqt:uef-equation, $pi_M (q;D)$ corresponde al ranking generado por el modelo $M, R_q$ al modelo de relevancia estimado basado en la consulta $q, S i m$ es la medida de similitud entre rankings y $p(R_q ∣I q)$ a la probabilidad de que $R_q$ represente la necesidad de información subyacente $I q$.
  
El UEF destaca por su fundamentación teórica en la teoría estadística de decisiones, lo que le permite estimar de manera robusta la utilidad esperada de un ranking. Su diseño matemático incorpora explícitamente la incertidumbre inherente en la estimación de relevancia a través de la distribución de probabilidad $p(R_q ∣I q)$, mientras que la función de similitud $S i m$ cuantifica la concordancia entre el ranking original y los rankings generados por los modelos de relevancia estimados.

Es así que el UEF representa un avance significativo en la predicción del rendimiento de consultas al proporcionar un marco teórico sólido que unifica diferentes aspectos de la recuperación de información. Su formulación matemática rigurosa, basada en principios estadísticos, permite una evaluación sistemática de la calidad de los rankings, considerando tanto la estructura de los resultados como la incertidumbre en la estimación de relevancia.
]
#v(10pt)
=== Aplicaciones de QPP en IR
\
La capacidad de predecir el rendimiento de una consulta abre un amplio abanico de aplicaciones prácticas que permiten a los sistemas de recuperación de información (IR) operar de manera más inteligente, robusta y eficiente. En lugar de tratar todas las consultas de la misma manera, los sistemas pueden utilizar los predictores de QPP para adaptar dinámicamente su comportamiento. Sin embargo, la utilidad de estas aplicaciones depende críticamente de la calidad del predictor: se requiere una correlación moderadamente alta entre el rendimiento predicho y el real para que estas estrategias mejoren de manera fiable la efectividad del sistema @how-much-correlation-is-good.
- *Activación selectiva de mecanismos avanzados:* Como se mencionó anteriormente, técnicas como la expansión de consultas mediante modelos de relevancia o el uso de arquitecturas complejas como RAG son computacionalmente costosas. Sobre este punto, QPP funciona como una herramienta de diagnóstico que estima de antemano la efectividad esperada. Si una consulta se predice como difícil, el sistema puede activar estos mecanismos más potentes para garantizar una respuesta de alta calidad. En cambio, para una consulta predicha como fácil, se puede utilizar un método de recuperación estándar, optimizando así el uso de recursos sin sacrificar la calidad en los casos necesarios @query-difficulty-book.
- *Expansión selectiva de consultas:* La retroalimentación de pseudo-relevancia (_pseudo-relevance feedback_, PRF) es una técnica común para expandir consultas, pero su aplicación indiscriminada tiene consecuencias negativas. Si los documentos mejor clasificados iniciales no son relevantes, los términos añadidos pueden desviar el enfoque de la consulta original, un fenómeno conocido como _query drift_. Este desvío a menudo degrada el rendimiento en lugar de mejorarlo. Los predictores QPP permiten una aplicación más segura de esta técnica. Si se predice que una consulta tendrá un bajo rendimiento, se considera como una buena candidata para la expansión, ya que el potencial de mejora es elevado y el riesgo de empeorar un resultado ya pobre es negligible. Por el contrario, si se predice que una consulta ya es efectiva, aplicar la expansión podría ser innecesario o incluso perjudicial. De este modo, la predicción actúa como un guardián, aplicando la expansión solo cuando es probable que sea beneficiosa @query-drift.
- *Búsqueda federada y metabúsqueda:* En entornos donde los resultados provienen de múltiples colecciones o motores de búsqueda, la QPP es fundamental para la fusión inteligente de resultados. En la metabúsqueda, se consultan varios motores de búsqueda, mientras que en la búsqueda federada, se busca en múltiples colecciones con un solo motor. En ambos casos, en lugar de combinar los rankings basándose únicamente en los puntajes de cada fuente, se puede predecir el rendimiento de la consulta en cada una de ellas de forma independiente. Los resultados de las fuentes donde se predice un alto rendimiento pueden recibir una mayor ponderación en el ranking final. Esta estrategia ha demostrado mejorar significativamente la calidad de los resultados combinados, aunque su éxito también depende de la fiabilidad del predictor utilizado @query-difficulty-book @how-much-correlation-is-good.
- *Retroalimentación al usuario y al sistema:* La QPP también se utiliza para proporcionar retroalimentación directa. Un sistema puede informar al usuario que su consulta es probablemente "difícil" y que los resultados pueden ser de baja calidad, sugiriendo reformulaciones o términos alternativos. A nivel de administración del sistema, el análisis de las consultas predichas como difíciles en los registros de búsqueda (_query logs_) puede ayudar a identificar contenido faltante en la colección, guiando así los esfuerzos para enriquecer la base de conocimiento y cubrir las brechas de información detectadas @query-difficulty-book.

#v(10pt)
=== Supuestos, limitaciones y amenazas a la validez
\
A pesar de su potencial, la efectividad y la evaluación de los métodos de QPP se basan en un conjunto de supuestos y están sujetas a limitaciones importantes que deben ser consideradas para interpretar correctamente sus resultados.

La evaluación y la aplicación de los métodos de QPP descansan sobre varios supuestos centrales. Un supuesto extendido sostiene que una alta correlación (Pearson, Kendall, Spearman) entre las predicciones y una métrica de efectividad (AP, nDCG) se traduce en utilidad práctica; sin embargo, la evidencia empírica muestra que la correlación, aun siendo estadísticamente significativa, no garantiza por sí sola una mejora operativa, pues la utilidad real depende de cómo la predicción informa decisiones concretas dentro del sistema @how-much-correlation-is-good. 

A ello se suma una fuerte dependencia de los juicios de relevancia (_Qrels_) como “verdad fundamental”. Este supuesto es particularmente frágil, ya que la calidad de los Qrels está sujeta a la variabilidad inherente al juicio humano. La evaluación de la relevancia no es un proceso mecánico; está influenciada por la experiencia y el conocimiento del dominio del evaluador. Se ha demostrado que los evaluadores no expertos ("generalistas") tienden a producir juicios menos precisos y más superficiales en comparación con los expertos del dominio, recurriendo con frecuencia a la simple coincidencia de palabras clave en lugar de a una comprensión profunda de la intención de la consulta. Esta discrepancia introduce una fuente potencialmente significativa de sesgo en los resultados de evaluación, lo que significa que un predictor de QPP puede estar siendo interpretado incorrectamente para replicar los juicios de un tipo particular de evaluador, en lugar de una noción objetiva de relevancia @evaluator-domain-expertise.

La validez de las evaluaciones también está modulada por las características de los conjuntos de datos y de las muestras de consulta empleados. El rendimiento observado de un predictor depende en gran medida del tipo de colección: resultados alentadores en corpus limpios y homogéneos (p. ej., noticias) no necesariamente se sostienen en colecciones provenientes de la web más ruidosas y heterogéneas; por ello, las conclusiones de benchmarks deben interpretarse con cautela y no extrapolarse sin verificación a contextos productivos @correlation-depends-on-quality-of-dataset. A ello se añade la sensibilidad a tamaños muestrales reducidos de consultas, frecuentes en campañas de evaluación: con pocas consultas, las estimaciones son más inestables y los intervalos de confianza se amplían, dificultando discernir si las diferencias entre predictores reflejan efectos genuinos o artefactos de muestreo. La composición de la muestra (por ejemplo, una sobrerrepresentación de consultas fáciles o difíciles) puede, además, sesgar las métricas y favorecer ciertas familias de predictores.

#v(10pt)
== Métricas de evaluación de rendimiento y correlación
\
Las métricas de evaluación cuantifican la calidad de un ranking y permiten contrastar, de forma objetiva, lo que un sistema recupera con lo que se espera encontrar. En el contexto de QPP, operan como punto de comparación para juzgar si las predicciones se alinean con el rendimiento observado a nivel de consulta y de colección. La base de cualquier métrica de evaluación son los juicios de relevancia, que fijan qué documentos del corpus se consideran relevantes para una consulta dada.

Sobre esa referencia se calculan medidas ampliamente utilizadas como _Precision_, AP, MAP y nDCG. Estas métricas capturan distintos aspectos del rendimiento: exactitud en los tope del ranking, cobertura de documentos relevantes, calidad promedio a lo largo de la lista y sensibilidad a las relevancias graduadas. Su valor depende del orden de los resultados y de parámetros como la profundidad de corte (_k_), por lo que deben interpretarse en función del escenario de uso.

Para la evaluación de QPP se utiliza un protocolo experimental que utiliza las métricas de efectividad calculadas por consulta (por ejemplo, AP, MAP, nDCG) correlacionándolas directamente con el valor del predictor para la misma consulta. La comparación emplea coeficientes de correlación de rangos y se acompaña de pruebas de significancia e intervalos de confianza para estimar la robustez. De este modo, la utilidad del predictor se juzga por la magnitud y la estabilidad de las correlaciones y por su capacidad para guiar decisiones.

#v(10pt)
=== Juicios de relevancia (_Qrels_)
\
Los juicios de relevancia (_Qrels_) son las etiquetas que, para cada consulta, indican qué elementos del corpus son relevantes y con qué grado (binario o multigrado). Operan como referencia objetiva para calcular métricas de efectividad a nivel de consulta y de colección y, por tanto, constituyen el “verdad fundamental” o “_ground truth_” frente al cual se contrastan sistemas de recuperación y estimadores de rendimiento. Su definición y disponibilidad condicionan de forma directa la interpretación de resultados y la comparabilidad entre trabajos.

La obtención humana de Qrels suele realizarse mediante campañas de evaluación con anotadores expertos o capacitados, frecuentemente apoyadas en la técnica de _pooling_: es decir se agregan los resultados _top‑k_ resultantes de múltiples sistemas y se juzga ese subconjunto. Este procedimiento permite cubrir un espacio de resultados amplio con costos controlados, pero introduce incompletitud (no todos los elementos relevantes son juzgados) y sesgos de cobertura ligados a los sistemas incluidos y a la profundidad del _pool_. La calidad de los juicios depende de guías de anotación, formación y control de calidad (p. ej., acuerdo entre anotadores medido con coeficientes como el K de Cohen) y de la escala de relevancia empleada; estos factores por ende tienen un impacto directo en la estabilidad de las métricas @trec-6 @evaluator-domain-expertise @query-specific-variable-depth-pooling.

#v(10pt)
=== Métricas de evaluación clásicas en IR
\
En términos formales, una métrica de evaluación asigna a cada consulta un valor escalar que resume el rendimiento de un sistema a partir del ranking devuelto y de los juicios de relevancia asociados a sus documentos. A partir de estas puntuaciones por consulta se definen luego versiones agregadas a nivel de sistema, promediando sobre un conjunto de consultas: por ejemplo, _Precision\@n(R)_ corresponde a la media de las precisiones por consulta al corte $n$ para el sistema $R$. 

Entre las métricas más utilizadas se encuentran la _Precision_ y la Exhaustividad (_Recall_), sobre las cuales se construyen medidas más complejas como la Precisión Media (AP), su promedio sobre consultas (MAP) y la Ganancia Acumulada Descontada Normalizada (nDCG), que difieren en si asumen relevancia binaria o graduada y en la forma en que penalizan posiciones más profundas en el ranking @metrics-sensitivity.

La Precisión (_Precision_), definida en la @eqt:metricas-precision, mide la fracción de documentos recuperados que son relevantes. Responde a la pregunta: "¿Qué proporción de los resultados que mostré son realmente útiles?". Es un indicador de la exactitud de la búsqueda y requiere que los juicios de relevancia sean binarizados (es decir, un documento es relevante o no lo es, sin grados intermedios).

\
$ "Precision@n(R)" = frac( 1,Q ) sum_(i=1)^Q [1/n sum_(i=j)^n "rel"^b (d_j^i)] $ <metricas-precision>
\

Donde $Q$ es el número de consultas del conjunto de evaluación, $R$ denota el sistema o algoritmo de recuperación evaluado, $n$ es la profundidad de corte (el número de primeras posiciones consideradas en el ranking) y $d_j^i$ es el documento en la posición $j$ de la lista devuelta por $R$ para la consulta $q_i$; finalmente, $"rel"^b(d_j^i)$ es la relevancia binarizada del documento $d_j^i$, devolviendo 1 si es relevante y 0 en caso contrario.

Una variante común es la Precisión en K (Precision@$K$), que calcula la precisión considerando únicamente los primeros $K$ resultados del ranking. Es especialmente útil porque refleja la experiencia del usuario, quien raramente explora más allá de la primera página de resultados @metrics-sensitivity.

La Precisión Media (_Average Precision_, _AP_) es una métrica que evalúa la calidad de un ranking para una única consulta combinando estas dos ideas. Se calcula promediando la precisión en cada posición donde se encuentra un documento relevante. _AP_ favorece a los sistemas que no solo recuperan muchos documentos relevantes (alta exhaustividad), sino que también los clasifican en las primeras posiciones (alta precisión). Para evaluar un sistema en un conjunto de consultas, se utiliza la _Precisión Media Promedio_ (_Mean Average Precision_, _MAP_), que es simplemente el promedio de los valores de _AP_ de todas las consultas @query-difficulty-book.

\
$ "MAP@n(R)" = frac( 1,Q ) sum_(i=1)^Q [1/n_i sum_(j=1)^n "rel"^b (d_j^i) * "AP@"j(R, q_i)] $ <metricas-map>
\

En la @eqt:metricas-map, $n_i$ corresponde al número de documentos relevantes para la consulta $q_i$ según los Qrels y $"AP@"j(R, q_i)$ denota el valor de AP calculado hasta la posición $j$ del ranking para la consulta $q_i$, manteniendo la misma convención de índices $i$ (consulta) y $j$ (posición) y la misma función de relevancia binarizada $"rel"^b (d_j^i)$ empleadas en la fórmula de Precisión.

La Ganancia Acumulada Descontada Normalizada (_Normalized Discounted Cumulative Gain_, nDCG) definida en la @eqt:ndcg_eq, es una métrica más sofisticada que, a diferencia de la Precisión, sí tiene en cuenta los diferentes niveles de relevancia (por ejemplo, "relevante", "muy relevante"). A nivel de consulta, puede verse como la razón entre la DCG obtenida por el sistema y la mejor DCG posible para esa misma consulta (IDCG).

\
$ "nDCG"_i = frac("DCG"_i, "IDCG"_i) $ <ndcg_eq>
\

La idea central es que los documentos altamente relevantes son más valiosos que los marginalmente relevantes, y la relevancia de un documento disminuye cuanto más abajo aparece en la lista de resultados.

Para ello, se asigna una ganancia a cada documento que crece exponencialmente con su nivel de relevancia ($"rel"$) derivado de los juicios de relevancia. Luego, esta ganancia se descuenta logarítmicamente según la posición del documento ($j$). Finalmente, el valor se normaliza dividiéndolo por un factor $N_i$, que representa la ganancia ideal para esa consulta (IDCG), para obtener una puntuación entre 0 y 1.

La fórmula general para calcular nDCG con un corte en $n$ ($"nDCG"@n$), promediado sobre un conjunto de $Q$ consultas, se define en la @eqt:metricas-ndcg como:

\
$ "nDCG"@n = 1/Q sum_(i=1)^Q [1/N_i sum_(j=1)^n frac(2^("rel"(d_j^i)) - 1, log_2(j+1))] $ <metricas-ndcg>
\

Donde $"rel"(d_j^i)$ es ahora la relevancia graduada asignada al documento $d_j^i$ (por ejemplo, 0, 1, 2, ... según el nivel de relevancia) y $log_2(j+1)$ es el factor de descuento logarítmico que penaliza posiciones más profundas en el ranking, manteniendo la misma notación anterior para $Q$, $n$, $i$ y $j$. En esta formulación, $N_i$ cumple exactamente el papel de la DCG ideal para la consulta $q_i$: se corresponde con la máxima DCG posible dada la información disponible en los _Qrels_, obtenida ordenando idealmente los documentos conocidos como relevantes antes de calcular la suma interna; por tanto, $N_i$ coincide con la IDCG clásica y permite escribir $"nDCG"_i = frac("DCG"_i, "IDCG"_i)$ en el rango $[0,1]$. El nDCG es una de las métricas más comunes en la evaluación de IR y QPP debido a su capacidad para manejar juicios de relevancia graduados y su sensibilidad al orden de los resultados @metrics-sensitivity.

#v(10pt)
=== Protocolos de evaluación de QPP y diseño experimental
\
La evaluación de los predictores de QPP sigue por lo general un protocolo experimental específico para garantizar que los resultados sean fiables, comparables e interpretables. El objetivo principal de este protocolo es medir qué tan bien las puntuaciones predichas por un método de QPP se correlacionan con el rendimiento real de un sistema de IR, medido por métricas como AP o nDCG.

Un diseño experimental típico implica varios componentes clave. Primero, se utiliza un conjunto de colecciones de documentos y conjuntos de consultas estandarizados, como los proporcionados por campañas de evaluación como TREC. Como se discutió anteriormente, el rendimiento de un predictor depende fuertemente del tipo de colección y de su nivel de “ruido” @correlation-depends-on-quality-of-dataset .Las consultas se ejecutan utilizando uno o más sistemas de recuperación de información (o rankers), como BM25 o modelos neuronales. La efectividad real de cada consulta se calcula utilizando los juicios de relevancia (Qrels) disponibles y, en paralelo, se obtiene la puntuación predicha por el método de QPP.

Esta necesidad de estandarización y reproducibilidad en los componentes del diseño experimental se materializa en el trabajo de Zendel, Fröbe y Faggioli @zendel2024qpptk (2024), quienes proporcionan una referencia fundamental al implementar y evaluar un marco de predicción del rendimiento de consultas utilizando el _Query Performance Prediction Toolkit_ (QPPTK) dentro de la plataforma TIREx.

#v(10pt)
==== QPPTK en TIREx
\
En este trabajo @zendel2024qpptk, los autores analizaron el desempeño de 12 métodos de predicción en combinación con diversos modelos de recuperación de información y 23 conjuntos de datos, incluyendo benchmarks reconocidos como TREC Robust04 y MS MARCO, por lo que, la amplitud de la evaluación y su enfoque en la reproducibilidad de los experimentos lo convierten en un recurso valioso para este trabajo de título.

Como se menciona, el estudio incluye una evaluación exhaustiva de métodos pre-retrieval, como IDF y SCQ, y post-retrieval, como NQC y Clarity Score, además, se demuestra cómo la evaluación cruzada en múltiples benchmarks permite identificar patrones de rendimiento y validar la generalización de los métodos seleccionados, enfoque que se destaca por la importancia de utilizar plataformas estandarizadas, como TIREx (_The Information Retrieval Experiment Platform_). Esta plataforma se define como una infraestructura diseñada para fomentar experimentos de recuperación de información que sean reproducibles, escalables y estandarizados mediante la integración de herramientas como _ir_datasets_ y _PyTerrier_, lo que no solo permite configurar entornos experimentales reproducibles, sino que también minimiza los sesgos potenciales en los resultados al estandarizar la configuración y los parámetros de los experimentos.

Una de las contribuciones clave del trabajo es la integración de una biblioteca que agrupa y estandariza las implementaciones de los distintos algoritmos de predicción (QPPTK) en TIREx, lo que facilita la realización de experimentos reproducibles, lo que se logra mediante la utilización de índices preconstruidos y configuraciones consistentes que garantizan estabilidad en las pruebas. Así mismo, los resultados generados son compartidos abiertamente, promoviendo su reutilización en futuros estudios, enfoque que resulta relevante para este trabajo, donde la reproducibilidad y la estandarización son fundamentales para garantizar la validez de las comparaciones entre métodos.

Es así que, los hallazgos de los autores, proporcionan métricas clave, como correlaciones entre predictores y métricas clásicas de recuperación, esenciales para validar los métodos implementados en este trabajo, además, su metodología y diseño experimental sirven como referencia directa para configurar los experimentos, asegurando que las evaluaciones sigan estándares establecidos en la literatura. En resumen, este estudio no solo se destaca por la profundidad de su análisis, sino también por su contribución al establecimiento de prácticas experimentales reproducibles, que es en donde radica su relevancia para el trabajo de título presentado, ya que propone un diseño experimental y proporciona un marco sólido para evaluar métodos de predicción del rendimiento de consultas en entornos complejos.

No obstante, al ejecutar estos protocolos, se debe considerar que, como señala @microsoft-preretrieval, el rendimiento observado para una consulta no se debe a una única causa, sino a la interacción de varios efectos. Por una parte, influye la tarea o necesidad informativa asociada al tópico: hay temas que, por la abundancia y claridad de los documentos relevantes, resultan intrínsecamente más fáciles que otros. También interviene la formulación concreta de la consulta, ya que dos variantes que expresan la misma necesidad pueden producir listas de resultados muy distintas según la elección de términos, su longitud o su ambigüedad. A su vez, el propio sistema de recuperación introduce su efecto, puesto que distintos rankers responden de forma diferente ante la misma combinación de tarea y consulta. Si no se tienen en cuenta estos componentes, un predictor de QPP puede aparentar funcionar bien simplemente porque discrimina tareas fáciles y difíciles, sin capturar realmente la dificultad específica de una formulación de consulta para un sistema dado.

Finalmente, se comparan las dos listas de puntuaciones (la real y la predicha) utilizando métricas de correlación. Un marco de evaluación robusto no se basa en estimaciones puntuales, sino que a menudo utiliza técnicas como los análisis de significancia también como el análisis de varianza (_ANOVA_) para modelar el rendimiento del predictor como una distribución, lo que permite un análisis estadístico más detallado y conclusiones más fiables @enhanced-evaluation.

Este enfoque estadístico avanzado y la necesidad de superar las limitaciones de las métricas tradicionales son los pilares de la investigación de Guglielmo Faggioli et al. @enhanced-evaluation (2021), quienes desarrollaron un marco de evaluación mejorado para la predicción del rendimiento de consultas.

#v(10pt)
==== _An Enhanced Evaluation Framework for Query Performance Prediction_ (2021)
\
Este marco aborda limitaciones clave de los enfoques tradicionales mediante la integración de análisis estadísticos avanzados y métricas diseñadas para evaluar, no solo la precisión, sino también la variabilidad y robustez de los métodos QPP en diferentes escenarios. Este marco supera las limitaciones de las evaluaciones basadas únicamente en correlaciones, como la dificultad para interpretar valores agregados únicos y la incapacidad para identificar consultas específicas donde los métodos fallan.

Es así como, en el artículo @enhanced-evaluation, los autores proponen un enfoque innovador que incluye métricas basadas en errores, como el _Scaled Absolute Rank Error_ (SARE) y el _Scaled Mean Absolute Rank Error_ (sMARE), las cuales permiten medir el error de predicción de manera distribuida por consulta. Además, incorporan técnicas estadísticas avanzadas, como el análisis de varianza (ANOVA) y pruebas _post hoc_ para evaluar las diferencias entre métodos con mayor detalle. Estas herramientas permiten no solo comparar la precisión de los predictores, sino también analizar la influencia de factores como el tema de la consulta, el método de recuperación y la configuración de _stemming_ en el rendimiento del QPP.

Como se menciona, el artículo se destaca por su enfoque en la medición de errores distribuidos por consulta, lo que permite un análisis más granular del desempeño de los métodos, en donde se realizaron experimentos en conjuntos de datos estándar como TREC Robust-04, utilizando métodos pre-retrieval, como MaxIDF y SCQ, y post-retrieval, como NQC y Clarity Score, cuyos resultados revelaron que factores como el modelo de recuperación, la configuración de stemming y _stoplists_, y la naturaleza de las consultas influyen significativamente en el rendimiento del QPP. Por ejemplo, se observó que los métodos post-retrieval, como NQC y Clarity, tienden a tener una correlación más alta con la precisión promedio (AP), mientras que los métodos pre-retrieval, como MaxIDF, pueden ser más robustos en ciertos escenarios. Estos hallazgos proporcionan información valiosa para optimizar estos sistemas y seleccionar el método más adecuado según la situación.

En el contexto del presente trabajo de título, el marco propuesto por los autores es importante, ya que introduce prácticas de evaluación reproducibles y detalladas, alineadas con estándares modernos, además de que, sus hallazgos sobre la interacción de factores experimentales y el rendimiento del QPP sirven como guía directa para configurar experimentos que sean estadísticamente sólidos y representativos en escenarios reales. Por ejemplo, el uso de ANOVA y pruebas _post hoc_ permite identificar no solo qué métodos son superiores en general, sino también en qué condiciones específicas (como ciertos tipos de consultas o configuraciones) un método puede ser mejor que otro, lo que es particularmente útil en aplicaciones prácticas donde la variabilidad de las consultas y los documentos es alta, como en motores de búsqueda web y sistemas de recomendación.

En resumen, no solo se proporciona un marco metodológico avanzado para la evaluación de QPP, sino que también ofrece _insights_ prácticos sobre cómo optimizar estos sistemas en función de factores contextuales, lo que lo convierte en una referencia clave para el presente trabajo de título, especialmente en la fase de diseño experimental y evaluación de métodos de predicción de rendimiento de consultas.



#v(10pt)
=== Métricas de correlación para evaluar métodos QPP
\
El método estándar para cuantificar la efectividad de un predictor de QPP es medir la correlación entre la lista de puntuaciones de rendimiento predichas y la lista de puntuaciones de rendimiento reales (por ejemplo, AP o nDCG) para un conjunto de consultas. Dado que no se puede asumir que estas puntuaciones sigan una relación lineal o una distribución de probabilidad específica, se prefieren los coeficientes de correlación de rangos. Estos miden el grado de acuerdo entre dos ordenamientos, respondiendo a la pregunta: "¿si el predictor A es mejor que el predictor B, ¿se corresponde esto con un mejor rendimiento real?".

Los tres coeficientes más comunes en la literatura de QPP son:

1.  *Coeficiente de correlación de Pearson ($r$)*: Es el único coeficiente paramétrico de los tres. De acuerdo a @correlation-methods, mide la fuerza de la relación lineal entre dos variables cuantitativas. Aunque es muy conocido, su uso en QPP debe ser cuidadoso. Es sensible a la magnitud de las diferencias y a los valores atípicos (_outliers_), y asume que los datos siguen una distribución normal bivariada. Como las métricas de rendimiento raramente cumplen con este supuesto, su aplicación requiere pruebas de normalidad previas para validar su aplicación. En términos formales, para un conjunto de $n$ pares $(x_i, y_i)$ con $i = 1, ..., n$, se define en la @eqt:correlacion-pearson como:

\
$ r = frac( sum_(i=1)^n (x_i - m_x)(y_i - m_y), sqrt( sum_(i=1)^n (x_i - m_x)^2 sum_(i=1)^n (y_i - m_y)^2 ) ) $ <correlacion-pearson>
\

#pad(left:15pt)[
Aquí, $x_i$ y $y_i$ representan las observaciones emparejadas de dos variables aleatorias (por ejemplo, altura y peso de una misma persona), mientras que $m_x$ y $m_y$ corresponden a sus medias muestrales.
]

2.  *Coeficiente de correlación de rangos de Spearman ($rho$)*: Es una alternativa no paramétrica a Pearson. En lugar de usar los valores brutos, primero los convierte en rangos y luego calcula el coeficiente de Pearson sobre esos rangos. Por ello, mide la fuerza de una relación monotónica (es decir, si una variable tiende a aumentar cuando la otra lo hace, sin que la relación tenga que ser lineal). Es menos sensible a los _outliers_ que Pearson, pero puede ser afectado por la presencia de muchos rangos empatados. En la práctica, $rho$ se implementa @2020SciPy-NMeth aplicando la misma fórmula de Pearson sobre los rangos $(R(x_i), R(y_i))$; cuando no hay empates, admite además la forma cerrada clásica presentada en la @eqt:correlacion-spearman:

\
$ rho = 1 - frac( 6 sum_(i=1)^n d_i^2, n (n^2 - 1) ) $ <correlacion-spearman>
\
#pad(left:15pt)[
donde $d_i$ representa, para cada observación $i$, la diferencia entre los rangos asignados a $x_i$ e $y_i$, es decir, cuánto se desplaza la posición relativa del elemento $i$ entre ambos ordenamientos. Cuando las dos listas coinciden perfectamente en su orden (máxima concordancia), todas las diferencias de rango valen cero y la suma de $d_i^2$ es nula, lo que produce $rho = 1$; a medida que las posiciones relativas divergen, las diferencias de rango crecen, aumenta la suma de $d_i^2$ y el valor de $rho$ disminuye, reflejando menor acuerdo entre los rankings @correlation-methods.
]

3.  *Coeficiente de correlación de rangos de Kendall ($tau$)*: Es una medida no paramétrica que se considera la más robusta de las tres para la evaluación de QPP. En lugar de considerar la magnitud o el rango, $tau$ se basa en el número de pares concordantes y discordantes entre los dos rankings. Un par de observaciones $(x_i, y_i)$ y $(x_j, y_j)$ es concordante si el orden relativo de $x_i$ y $x_j$ coincide con el de $y_i$ y $y_j$, y discordante si dicho orden se invierte. Debido a que se basa en conteos, no asume ninguna distribución de los datos, es robusta frente a valores atípicos y maneja bien los empates en los rankings. Su interpretación también es más directa: representa la diferencia entre la probabilidad de que dos elementos estén en el mismo orden y la probabilidad de que estén en órdenes diferentes. La variante $tau_b$ de Kendall implementada por @2020SciPy-NMeth, que corrige por empates en ambas listas y es la que se utiliza habitualmente en QPP, se define en la @eqt:correlacion-kendall como:

\
$ tau_b = frac( P - Q, sqrt((P + Q + T)(P + Q + U)) ) $ <correlacion-kendall>
\

#pad(left:15pt)[
Aquí, $P$ y $Q$ denotan el número de pares concordantes y discordantes entre los dos rankings, mientras que $T$ y $U$ cuentan los pares empatados solo en la primera o solo en la segunda lista, respectivamente. De este modo, $tau_b$ mide el balance neto entre concordancias y discordancias, normalizado para corregir el efecto de los empates y mantener el coeficiente en el intervalo $[-1, 1]$.
]

En la práctica, Spearman y Kendall son generalmente preferidos sobre Pearson en la investigación de QPP por su naturaleza no paramétrica. Kendall's $tau$ es a menudo el preferido por su robustez y su interpretación probabilística, aunque Spearman's $rho$ también se reporta comúnmente @correlation-methods.

Finalmente, es crucial entender que una correlación estadísticamente significativa no siempre implica una mejora práctica. La investigación ha demostrado que una correlación, aunque sea alta (p. ej., > 0.5), puede no ser suficiente para que una aplicación como la expansión selectiva de consultas mejore de manera fiable el rendimiento del sistema. La utilidad real depende de la magnitud de esa correlación y del contexto de la aplicación, y muchos predictores existentes no alcanzan el umbral de fiabilidad necesario en escenarios reales @correlation-methods @how-much-correlation-is-good.
