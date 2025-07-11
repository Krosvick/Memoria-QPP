#import "../template.typ": *
#import "@preview/fletcher:0.5.4" as fletcher: diagram, node, edge
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}

#let component(pos, label, tint: white, ..args) = node(
  pos,
  align(center, label),
  width: 35mm,
  fill: tint.lighten(90%),
  stroke: 1pt + tint.darken(10%),
  corner-radius: 5pt,
  ..args,
)

= DISEÑO DE LA EVALUACIÓN COMPARATIVA

\
En este capítulo se presenta el diseño experimental desarrollado para llevar a cabo la evaluación comparativa de métodos de Query Performance Prediction (QPP). 

\
El diseño no solo tiene como propósito validar la implementación técnica de los métodos QPP seleccionados, sino también establecer líneas base que permitan analizar sus fortalezas y limitaciones en contextos variados propios de los sistemas de recuperación de información. Para ello, se consideraron criterios sólidos y alineados con las mejores prácticas del estado del arte, garantizando la representatividad y el rigor del análisis comparativo.

\
La necesidad de un diseño comparativo sólido radica en la creciente complejidad de los sistemas de recuperación de información y la diversidad de escenarios en los que estos se aplican, y es en este contexto que es importante métodos QPP adecuados para poder optimizar recursos y mejorar la precisión de los resultados, por lo que adoptar criterios cuidadosamente definidos basados en las mejores prácticas del estado del arte es crucial para garantizar que cada componente del diseño cumpla con los estándares de calidad y reproducibilidad.

\
Además, en el presente proyecto, el diseño de la evaluación comparativa no solo busca responder preguntas específicas sobre el rendimiento de los métodos seleccionados, sino también contribuir al avance del estado del arte en QPP, estableciendo un marco que promueva prácticas experimentales reproducibles, transparentes y aplicables a diversos contextos, garantizando que los hallazgos obtenidos sean relevantes tanto para la comunidad científica como para la práctica en sistemas de recuperación de información.

\
== Selección de métodos de QPP
\
La selección de métodos QPP resulta crucial en el diseño de este proyecto, ya que determina la relevancia y la validez del análisis comparativo.

Para garantizar que los enfoques evaluados sean representativos y estén alineados con los objetivos del estudio, se establecieron criterios rigurosos basados en la literatura científica revisada, los cuales priorizan la inclusión de métodos reconocidos en el estado del arte, con fundamentos estadísticos sólidos y un alto grado de reproducibilidad.

A continuación, se describen los criterios aplicados en el proceso de selección, así como los métodos QPP finalmente escogidos para la posterior evaluación comparativa.

#v(13pt)
=== Criterios de selección
\
Como se ha mencionado, la selección de métodos de Query Performance Prediction (QPP) es un proceso fundamental para garantizar que los métodos evaluados sean representativos, robustos y relevantes en el contexto de los sistemas de recuperación de información. Con este propósito, se definieron criterios específicos que permiten abordar el problema desde una perspectiva teórica sólida y práctica aplicable, los que aseguran la validez de la evaluación comparativa y su alineación con los objetivos del proyecto.

\
#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    stroke: (x: none),
    row-gutter: (2.2pt, auto),
    align: left + horizon,
    table.header(
      [*Criterio*], [*Descripción*], [*Importancia para el proyecto*],
    ),
    [Base estadística y simplicidad],
    [Métodos con fundamentos sólidos y fácilmente comprensibles.],
    [
      Facilita la reproducibilidad y asegura resultados confiables.
    ],
    [Uso en estudios previos],
    [Métodos comúnmente implementados en investigaciones recientes.],
    [Garantiza relevancia científica y comparabilidad con investigaciones previas],
    [Diversidad de enfoques],
    [Cobertura de métodos pre-retrieval y post-retrieval, cada uno enfocado en aspectos distintos del rendimiento.],
    [Permite una evaluación integral que abarca múltiples aspectos del rendimiento de consultas.],
    [Relevancia en el estado del arte],
    [Métodos no basados en inteligencia artificial y ampliamente reconocidos por su efectividad teórica y práctica.],
    [Asegura un marco comparativo que no depende de tecnologías supervisadas y promueve análisis no sesgados.]
    
  ),
  caption: "Criterios de selección de métodos de QPP",
) <tabla-criterios>

\
La @tbl:tabla-criterios resume los criterios definidos para la selección de los métodos de QPP, en donde cada criterio cumple un rol específico para garantizar que los métodos seleccionados no solo sean estadísticamente sólidos, sino también relevantes y diversificados en su enfoque, asegurando que el análisis comparativo resultante sea exhaustivo y útil para evaluar las fortalezas y limitaciones de los métodos elegidos.

\
- *Base estadística y simplicidad*: Se seleccionan métodos que se basan en conceptos matemáticos fundamentales, como la frecuencia de términos en el corpus y su relación con la consulta, ya que estos métodos son ampliamente reconocidos por su sencillez y su capacidad para ser implementados y replicados sin necesidad de recursos computacionales avanzados. Este criterio asegura que los métodos elegidos puedan ser utilizados como referencia en investigaciones futuras, promoviendo la reproducibilidad de los experimentos y el entendimiento teórico de los predictores.
- *Uso en estudios previos*: Se buscan métodos que han sido recurrentemente evaluados en trabajos recientes que analizan sistemas de recuperación de información, ya que no solo garantiza que los resultados del proyecto sean comparables con investigaciones previas, sino que también asegura que los métodos seleccionados representan soluciones probadas y bien documentadas.
- *Diversidad de enfoques*: Se seleccionan métodos tanto pre-retrieval como post-retrieval para capturar diferentes aspectos del problema, mientras que unos se enfocan en estimar la calidad de una consulta basándose únicamente en estadísticas del corpus, los otros evalúan la calidad considerando los documentos recuperados. Este enfoque integral permite analizar el rendimiento de consultas desde múltiples perspectivas, proporcionando una visión más completa de sus fortalezas y debilidades.
- *Relevancia en el estado del arte*: Se priorizan métodos no basados en inteligencia artificial, ya que estos garantizan un análisis más transparente y menos sesgado en comparación con tecnologías supervisadas, además, de esta forma, los métodos seleccionados han sido ampliamente reconocidos en la literatura por su aplicabilidad en sistemas de recuperación de información y su capacidad para ser implementados sin depender de datasets de entrenamiento o modelos complejos.

Por otra parte, la decisión de priorizar métodos no basados en inteligencia artificial tiene varias razones claves:

-	*Transparencia y simplicidad*: Los métodos no basados en inteligencia artificial, ofrecen interpretaciones claras de cómo se calculan y qué factores influyen en su desempeño, esto contrasta con los métodos supervisados, cuya complejidad en ocasiones dificulta la comprensión de su funcionamiento interno.
-	*Reproducibilidad*: Al no depender de datasets de entrenamiento o modelos complejos, los métodos no basados en IA pueden ser implementados en cualquier entorno sin necesidad de recursos adicionales, lo que asegura que los experimentos realizados sean replicables por otros investigadores.
-	*Independencia del contexto*: Los métodos seleccionados son independientes de los dominios específicos y los cambios en las colecciones de datos, mientras que los métodos supervisados tienden a ser altamente sensibles a las características del dataset de entrenamiento.
-	*Contribución al estado del arte*: Este enfoque se alinea con el objetivo de establecer líneas base sólidas para evaluar nuevos métodos, permitiendo que futuros desarrollos en QPP se comparen con estándares bien establecidos.

\
=== Métodos seleccionados

\
Siguiendo los criterios establecidos en la sección anterior y tras un análisis exhaustivo de la literatura, se seleccionaron seis métodos de Query Performance Prediction (QPP) para la evaluación comparativa, los cuales representan enfoques diversos e incluyen estrategias pre-retrieval y post-retrieval, lo que asegura una cobertura de los aspectos clave del rendimiento de consultas en sistemas de recuperación de información. Además, como se ha mencionado, cada método fue elegido por su relevancia en el estado del arte, su fundamento teórico y su impacto demostrado en investigaciones previas, ofreciendo un marco robusto para analizar su efectividad y aplicabilidad en contextos variados.

\
#figure(
  table(
  columns: (auto, auto, auto),
  inset: 10pt,
  stroke: (x: none),
  row-gutter: (2.2pt, auto),
  align: horizon,
  table.header(
    [*Método QPP*], [*Clasificación*], [*Descripción*],
  ),
  [1. IDF (Inverse Document Frequency)],
  [Pre-retrieval],
  [
    Mide la rareza de los términos en un corpus mediante la frecuencia inversa de documentos.
  ],
  [2. SCQ (Similarity between a Query and a Collection],
  [Pre-retrieval],
  [Calcula la similitud entre los términos de la consulta y la colección basándose en frecuencias y pesos.],
  [3. NQC (Normalized Query Commitment)],
  [Post-retrieval],
  [Evalúa la dispersión de los puntajes de relevancia en los documentos recuperados para predecir la calidad de la consulta.],
  [4. Clarity Score (SC)],
  [Post-retrieval],
  [Mide la divergencia entre el modelo de lenguaje de los documentos recuperados y el modelo de la colección. ],
  [5. WIG (Weighted Information Gain)],
  [Post-retrieval],
  [Estima la calidad de la consulta mediante la ganancia de información ponderada basada en los documentos recuperados.],
  [6. UEF (Utility Estimation Framework)],
  [Post-retrieval],
  [Utiliza modelos de relevancia y teoría de decisión estadística para estimar la utilidad de los rankings generados.]
  ),
  caption: "Métodos de QPP seleccionados",
) <tabla-metodos>

\
En cuanto al análisis de las fortalezas y debilidades de cada método seleccionado en la @tbl:tabla-metodos:

-	IDF (Inverse Document Frequency): Es un método simple, eficiente y ampliamente utilizado, su capacidad para medir la especificidad de los términos lo convierte en una herramienta básica para estimar la calidad de las consultas. Por otra parte, depende exclusivamente de estadísticas del corpus, lo que limita su precisión en escenarios donde la calidad de los documentos recuperados influye de forma significativa.
-	SCQ (Similarity between a Query and a Collection): Proporciona una evaluación más detallada al considerar la similitud entre la consulta y la colección en su conjunto, lo que resulta útil en contextos con consultas de longitud variada. Por otra lado, puede ser menos efectivo en colecciones con alta heterogeneidad temática debido a su dependencia de estadísticas globales.
-	NQC (Normalized Query Commitment): Evalúa la consistencia de los puntajes de relevancia en los documentos recuperados, lo que lo hace efectivo para identificar consultas problemáticas, pero requiere ejecutar consultas y recuperar documentos, lo que implica un costo computacional más alto en comparación con métodos pre-retrieval.
-	Clarity Score (CS): Mide la coherencia del lenguaje de los documentos recuperados, lo que lo hace efectivo en consultas específicas con temas bien definidos, pero es sensible a consultas cortas o ambiguas, donde la divergencia entre el modelo de lenguaje y el corpus puede ser menos clara.
-	WIG (Weighted Information Gain): Integra múltiples características de los documentos recuperados, como términos y proximidad, proporcionando una evaluación integral, aunque puede ser afectado por colecciones con sesgos en los documentos más relevantes, disminuyendo su precisión en escenarios específicos.
-	UEF (Utility Estimation Framework): Ofrece un marco flexible y adaptable, utilizando modelos de relevancia para capturar tanto la utilidad como la precisión de los rankings generados, pero su complejidad estadística puede dificultar su implementación en sistemas con recursos limitados o en contextos donde se prioriza la simplicidad.

\
Los métodos seleccionados abarcan una gama de enfoques y fundamentos teóricos, lo que garantiza una evaluación comparativa exhaustiva y representativa, en donde la inclusión de métodos tanto pre-retrieval como post-retrieval asegura que se cubran múltiples facetas del problema, proporcionando una base sólida para analizar su desempeño en diferentes contextos, resultando en un diseño experimental robusto que refuerza la validez del estudio y su contribución al avance del estado del arte en predicción de rendimiento de consultas.

\
== Selección de conjuntos de datos
\
La selección de datasets es parte fundamental para garantizar una evaluación comparativa robusta y representativa de los métodos de Query Performance Prediction (QPP), es por ello, que se seleccionaron datasets reconocidos en la literatura, priorizando los que ofrecen juicios de relevancia (Qrels) y métricas estandarizadas, permitiendo así validar el desempeño de los métodos seleccionados en escenarios variados.

Estos datasets fueron cuidadosamente seleccionados para abarcar una amplia diversidad de tipos de consultas y dominios, asegurando que los resultados obtenidos sean aplicables y relevantes para diferentes contextos de recuperación de información. Este enfoque garantiza no solo la robustez de los resultados, sino también su generalización a futuros trabajos relacionados con QPP.

\
=== Criterios de inclusión
\
En la @tbl:tabla-criterios-datasets se presentan los criterios aplicados en la selección de datasets, detallando su importancia en el contexto del proyecto.

\
#show figure: set block(breakable: true)
#figure(
  table(
  columns: (auto, auto, auto),
  inset: 10pt,
  stroke: (x: none),
  row-gutter: (2.2pt, auto),
  align: left + horizon,
  table.header(
    [*Criterio*], [*Descripción*], [*Importancia para el proyecto*],
  ),
  [Disponibilidad pública],
  [Datasets de acceso abierto y bien documentados, sin restricciones para su uso.],
  [
    Garantiza la reproducibilidad y facilita la implementación en diversos contextos.
  ],
  [Diversidad de escenarios],
  [Representación de diferentes tipos de consultas (informacionales, navegacionales y transaccionales) y dominios.],
  [Asegura la evaluación integral de los métodos en múltiples contextos.],
  [Uso en el estado del arte],
  [Amplio uso en investigaciones previas de recuperación de información y QPP.],
  [Respalda la validez y comparabilidad de los resultados obtenidos.],
  [Tamaño adecuado],
  [Incluye tanto datasets pequeños como grandes.],
  [Permite evaluar el comportamiento de los métodos en diferentes escalas de datos.],
  [Relevancias conocidas (Qrels)],
  [Incluyen juicios de relevancia establecidos previamente.],
  [Facilitan la evaluación precisa y objetiva del desempeño de los métodos QPP.]
  ),
  caption: "Criterios de inclusión de datasets",
) <tabla-criterios-datasets>
\

-	Disponibilidad pública: Es fundamental seleccionar datasets de acceso abierto que estén bien documentados, ya que esto garantiza la transparencia y la reproducibilidad de los experimentos, la disponibilidad pública también asegura que los resultados puedan ser validados por otros investigadores, fomentando la colaboración y el avance en el campo del QPP.
-	Diversidad de escenarios: Incluir datasets con diferentes tipos de consultas es crucial para evaluar cómo se desempeñan los métodos QPP en escenarios reales, por ejemplo de consultas informacionales: preguntas abiertas donde el usuario busca adquirir conocimiento general; consultas navegacionales: consultas donde el objetivo es encontrar una página específica; y consultas transaccionales: consultas orientadas a completar una acción. Esta diversidad asegura que los métodos sean efectivos en una variedad de tareas de recuperación, desde búsquedas generales hasta necesidades específicas.
-	Uso en el estado del arte: Seleccionar datasets ampliamente utilizados en investigaciones previas permite que los resultados del proyecto sean comparables con estudios existentes, lo que refuerza la validez del análisis comparativo y asegura que las metodologías empleadas cumplan con estándares científicos.
-	Tamaño adecuado: La inclusión de datasets de diferentes tamaños permite evaluar el comportamiento de los métodos en escenarios con distintos volúmenes de datos, en donde los datasets pequeños son ideales para pruebas controladas y rápidas, mientras que los grandes, son útiles para analizar la escalabilidad y robustez de los métodos. Este enfoque asegura que los métodos QPP seleccionados sean evaluados en condiciones que reflejen tanto la simplicidad como la complejidad de los sistemas de recuperación de información modernos.
-	Relevancias conocidas (qrels): Los juicios de relevancia son esenciales para evaluar el desempeño de los métodos de manera objetiva, al incluir datasets con qrels bien establecidos, se garantiza que los resultados estén basados en un marco estandarizado, facilitando su interpretación y comparación

\
Es así como la aplicación de estos criterios garantiza que los datasets seleccionados sean adecuados para el análisis comparativo de los métodos QPP, de igual forma, al priorizar la diversidad, relevancia y representatividad, este proyecto establece una base sólida para evaluar el desempeño de los métodos en diferentes contextos y escalas, contribuyendo al avance del estado del arte en predicción del rendimiento de consultas.

\
=== Justificación de los conjuntos de datos seleccionados

\
Como se ha mencionado, los datasets seleccionados para el proyecto fueron escogidos cuidadosamente para garantizar que cubran una amplia gama de escenarios y dominios representativos, por lo que se alinean con los criterios de inclusión previamente establecidos, aportando características únicas que permiten evaluar el rendimiento de QPP en contextos diversos, asegurando resultados generalizables y relevantes para investigaciones futuras, además de contribuir al avance del estado del arte.

A continuación, se presenta la @tbl:tabla-datasets con los datasets seleccionados, seguida de un análisis más detallado de su contribución al presente proyecto.

\
#figure(
  table(
    columns: (auto, auto, auto, auto),
    inset: 10pt,
    stroke: (x: none),
    row-gutter: (2.2pt, auto),
    align: left + horizon,
    table.header(
      [*Dataset*], [*Descripción*], [*Contribución al proyecto*],[*Razón de inclusión*]
    ),
    [Cranfield],
    [Dataset clásico con resúmenes científicos y consultas predeterminadas de tamaño reducido.],
    [
      Facilita pruebas rápidas y controladas para la comparación directa de métodos QPP.
    ],
    [Simplicidad y diseño compacto lo hacen ideal para experimentos iniciales y controlados.],
    [MS MARCO (Passage)],
    [Contiene pasajes derivados de consultas reales con relevancias asignadas por evaluadores humanos.],
    [Proporciona un entorno realista y variado para probar la aplicabilidad práctica de los métodos.],
    [Refleja el contexto de búsqueda cotidiana, crucial para evaluar escenarios reales de recuperación],
    [Antique/Test],
    [Dataset centrado en la recuperación de preguntas y respuestas subjetivas basadas en opiniones.],
    [Evalúa el desempeño de los métodos frente a consultas subjetivas y no factuales.],
    [Introduce complejidad adicional al incorporar preguntas subjetivas difíciles de modelar.],
    [BEIR-TREC-COVID],
    [Parte del benchmark BEIR, centrado en la recuperación de información médica sobre COVID-19.],
    [Permite evaluar los métodos QPP en un dominio altamente especializado y relevante.],
    [Su enfoque en consultas científicas lo hace adecuado para escenarios de alta especificidad.],
    [CAR (Complex Answer Retrieval, Fold 0)],
    [Subconjunto del TREC CAR enfocado en consultas complejas derivadas de la estructura de Wikipedia.],
    [Permite probar los métodos en escenarios con alta complejidad semántica sin sobrecargar el análisis.],
    [Representa consultas avanzadas que requieren modelado detallado, ampliando la diversidad de pruebas.]

  ),
  caption: "Tabla de datasets y sus criterios de inclusión",
) <tabla-datasets>

\
-	*Cranfield*: Este dataset es ideal para experimentos iniciales debido a su tamaño reducido y estructura sencilla, al contener resúmenes científicos y consultas predeterminadas, facilita una evaluación controlada de los métodos QPP, permitiendo identificar rápidamente patrones de comportamiento y limitaciones. Su simplicidad permite analizar la precisión básica de los métodos y sirve como línea base para experimentos más complejos.
-	*MS MARCO (Passage)*: Proporciona un entorno realista donde las consultas derivan de necesidades cotidianas de usuarios reales, sus relevancias asignadas por evaluadores humanos lo convierten en un recurso clave para probar la aplicabilidad práctica de los métodos QPP. Evalúa la capacidad de los métodos para manejar consultas informacionales y transaccionales en contextos cotidianos. @ms-marco-dataset.
-	*Antique/Test*: Este dataset introduce complejidad al centrarse en preguntas y respuestas subjetivas basadas en opiniones, lo que plantea un desafío adicional para los métodos QPP al modelar consultas no factuales. Analiza cómo los métodos manejan preguntas subjetivas y abiertas, evaluando su capacidad para predecir el rendimiento en dominios con alta variabilidad semántica @antique-dataset.
-	*BEIR-TREC-COVID*: Su enfoque en consultas científicas relacionadas con COVID-19 lo hace altamente relevante para escenarios especializados donde la precisión y la especificidad son esenciales. Evalúa el rendimiento de los métodos en un dominio crítico donde la información relevante es escasa y de alta relevancia. @trec-covid-dataset.
-	*CAR (Complex Answer Retrieval)*: Al estar enfocado en consultas complejas derivadas de la estructura de Wikipedia, este dataset permite analizar cómo los métodos QPP manejan escenarios con alta complejidad semántica. Mide la capacidad de los métodos para predecir el rendimiento en consultas que requieren una interpretación profunda y modelado avanzado. @TREC-CAR-dataset.

Además, todos los datasets utilizados son de acceso abierto en repositorios públicos y están bien documentados debido a que son ampliamente reconocidos en la comunidad de recuperación de información, lo que asegura que cualquier investigador pueda acceder a ellos sin restricciones para replicar los experimentos. Es así que, la utilización de datasets de acceso abierto garantiza que los resultados del proyecto sean reproducibles y accesibles para futuras investigaciones, fomentando el entorno colaborativo y transparente, evitando problemas legales o éticos relacionados con el uso de datos restringidos o privados.

De esta forma, la selección de datasets con características bien definidas asegura una evaluación diversa y representativa de los métodos QPP seleccionados, ya que este enfoque cubre dominios especializados, tareas cotidianas y casos complejos, estableciendo una base sólida para validad la efectividad y aplicabilidad de los métodos en diferentes contextos de recuperación de información.
#v(10pt)
== Entorno experimental

\
En esta sección se describe la configuración del entorno experimental desarrollado para llevar a cabo la evaluación comparativa de los métodos de Query Performance Prediction (QPP), incluyendo el flujo de los experimentos, las configuraciones técnicas específicas, y las métricas empleadas para la evaluación.

El entorno experimental está diseñado para garantizar la reproducibilidad, flexibilidad y transparencia. Para lograrlo, se ha implementado un entorno basado en capas, y reproducible en Docker, que permite ejecutar los experimentos de manera consistente y controlada, sin depender de configuraciones específicas de hardware o software.

\
=== Flujo del sistema
\
#figure(
  diagram(
  spacing: 1pt,
  cell-size: (8mm, 8mm),
  edge-stroke: .8pt,
  
  // Left column - Analysis components
  component((2.5,0), [Capa de \ Evaluación], tint: red, name: "corr"),
  component((0,0), [Evaluación con Qrels], tint: red, name: "metr"),
  component((5,0), [Resultado de \ correlación], tint: red, name: "puntajes"),
  
  // Middle - QPP Methods
  component((3.7,3), [Métodos \
  Pre-retrieval], tint: blue, name: "pre"),
  component((1.2,3), [Métodos \
  Post-Retrieval], tint: blue, name: "post"),
  
  // Right side components
  component((0,6), [Sistema de \ recuperación "BM25"], tint: purple, name: "IR"),
  component((2.5,6), [Capa de \ Indexado], tint: purple, name: "index"),
  component((5,6), [Capa de datasets], tint: gray, name: "datasets"),
  component((5,8), [Procesador de \ datos], tint: gray, name: "proc"),
  
  // Connections
  edge(<corr>, <pre>, "->", $"Puntajes"$),
  edge( <IR>, <metr>, "->"),
  edge(<corr>, <puntajes>,  "->", $"Guarda"$),
  edge(<corr>, <post>, "->", $"Puntajes"$),
  edge(<IR>, <index>, "->", $"Utiliza"$),
  edge(<IR>, <post>, "->", $"Resultados"$, label-pos:0, label-angle: 90deg ),
  edge(<metr>, <corr>, "->"),
  edge(<pre>, <index>, "->", $"Utilizan"$),
  edge(<post>, <index>, "->"),
  edge(<index>, <datasets>, "->", $"Utiliza"$),
  edge(<datasets>, <proc>, "--"),
),
caption: "Diagrama de componentes del entorno de evaluación",
) <diagrama_general>
\

Como se puede apreciar en la @fig:diagrama_general, el diseño experimental sigue un flujo bien definido para garantizar la reproducibilidad y el análisis riguroso de los resultados. El flujo incluye los siguientes pasos principales:

\
-	*Preparación de Datasets:* Los datasets seleccionados, como Cranfield o Antique, se descargan utilizando la librería ir_datasets y se preprocesan en el entorno Docker, este proceso incluye la extracción de consultas, preparación de los juicios de relevancia (qrels) y el formateo adecuado para su uso con PyTerrier.
-	*Indexado de Datasets:* Los datasets se indexan utilizando PyTerrier, creando estructuras de datos eficientes para la recuperación de información. Es también en este paso donde se guardan metadatos de los datasets, como la frecuencia de los términos en los documentos como la frecuencia de estos en la colección. Además, se hace uso del ‟Stemmer" de Snowball sobre los documentos y consultas, para conseguir resultados más precisos en la evaluación.
-	*Configuración de Modelos de Recuperación:* Configuración de modelos de recuperación como estándar como BM25 en PyTerrier con parámetros predefinidos, asegurando una base consistente para la evaluación de los métodos QPP.
-	*Implementación de los métodos QPP:* Los métodos seleccionados, como, por ejemplo, IDF, SCQ o NQC, se implementan mediante scripts en Python dentro del contenedor Docker, todos estos utilizan una interfaz similar dentro del sistema, permitiendo una ejecución estandarizada de los métodos.
-	*Ejecución de los métodos de predicción:* Los experimentos se realizan mediante un script principal que realiza múltiples iteraciones por método y dataset, asegurando estabilidad y fiabilidad de los resultados.
-	*Evaluación utilizando juicios de relevancia (qrels):* Se realiza una evaluación del rendimiento de las consultas utilizando la librería de ir_measures sobre el sistema de recuperación implementado, esto es el ‟ground truth” o "verdadero valor" del rendimiento de la consulta en el sistema de recuperación implementado. Posteriormente los resultados se almacenan en formato estructurado para su posterior análisis.
-	*Evaluación utilizando métricas de correlación:* Se realiza una evaluación de la correlación entre los puntajes de los predictores y las métricas IR, utilizando la librería de Scipy, para obtener una medida de la efectividad de los predictores QPP con relación al ‟ground truth”.
-	*Documentación y Almacenamiento:* Los resultados, configuraciones y scripts de ejecución se almacenan en directorios organizados dentro del contenedor Docker, garantizando su fácil acceso y análisis.

Entre los componentes de la @fig:diagrama_general, se puede discernir la capa de datos, de indexación y recuperación. Estos componentes funcionan completamente dentro de la librería Pyterrier, el cual funciona como un "wrapper" para la librería Terrier, la cual es ampliamente utilizada en la literatura de recuperación de información para la realización de experimentos similares. @pyterrier

\
=== Configuración técnica

\
-	*Entorno Docker*: Al permitir encapsular todas las dependencias necesarias en un entorno reproducible, se evitan problemas de compatibilidad y configuración entre máquinas, asegurando que los experimentos puedan ser ejecutados de manera uniforme y reproducible. 

  El sistema utiliza una imagen base de Python 3.9 con Java 11 instalado para soportar PyTerrier. 

-	*Parámetros del Modelo de Recuperación*:
El sistema utiliza el modelo de recuperación BM25 (Best Match 25) como método principal de recuperación. Los parámetros han sido mantenidos en su configuración por defecto. Su definición se puede observar en la @tbl:tabla_de_parametros

\
#figure(
  table(
    columns: (auto, auto, auto, auto),
    inset: 10pt,
    stroke: (x: none),  
    row-gutter: (2.2pt, auto),
    align: left,
    [*Parámetro*], [*Descripción*], [*Justificación de Aplicación*], [*Valor*],
    [k1], 
    [Factor de saturación de término. Controla cómo el score de un documento aumenta con cada ocurrencia adicional de un término de la consulta. Un valor más alto significa que se da más importancia a la frecuencia del término.],
    [Crucial para colecciones con documentos que contienen repeticiones significativas de términos. Afecta directamente el cálculo de scores en métodos QPP post-recuperación como WIG.],
    [1.2],
    
    [b],
    [Factor de normalización de longitud del documento. Determina cuánto se penalizan los documentos más largos. Un valor más alto significa una normalización más agresiva de la longitud.],
    [Especialmente importante en colecciones heterogéneas como ANTIQUE donde la longitud de los documentos varía significativamente. Impacta el cálculo de NQC al normalizar los scores.],
    [0.75],
  ),
  caption: [Parámetros principales de BM25],
) <tabla_de_parametros>

\
Otros estudios han propuesto la utilización de otros parámetros para BM25, como el parámetro k1, el cual controla la saturación de términos en los documentos, sobretodo al utilizar métodos de clustering, tales experimentos han demostrado que un valor de k1 mayor a 1.2 puede mejorar el rendimiento de la recuperación. Sin embargo, en este estudio se mantendrán los parámetros por defecto de PyTerrier, ya que se ha demostrado que estos proporcionan un rendimiento adecuado para la mayoría de las tareas de recuperación de información, pero se puede realizar un estudio futuro sobre la utilización de estos parámetros en la evaluación de métodos QPP. @bm25

-	*Ejecución de los métodos y scripts de evaluación*:
La @tbl:tabla-argumentos sistema permite una configuración flexible de la ejecución de la evaluación a través de diversos parámetros que controlan tanto el proceso de recuperación como la evaluación QPP. La configuración se realiza principalmente mediante argumentos de línea de comandos y variables de entorno.

\
#figure(
  table(
    columns: (auto, auto,auto, ),
    inset: 10pt,
    stroke: (x: none),  
    row-gutter: (2.2pt, auto),
    align: left + horizon,
    [*Parámetro*], [*Descripción*], [*Valor por defecto*],
    [--datasets], [Datasets a evaluar (e.g., antique_test, iquique_small)], [Todos los datasets],
    [--max-queries], [Límite de consultas a procesar], [None (todas)],
    [--list-size], [Tamaño de lista para métricas de ranking], [10],
    [--wig-list-size], [Tamaño de lista para el predictor WIG], [5],
    [--nqc-list-size], [Tamaño de lista para el predictor NQC], [200],
    [--num-results], [Número máximo de resultados por consulta], [1000],
    [--metrics], [Métricas de evaluación (e.g., ndcg\@10, ap)], [nDCG\@10, AP],
    [--correlations], [Coeficientes de correlación a calcular (Kendall, Spearman, Pearson)], [kendall],
    [--use-uef], [Habilita las variantes utilizando el marco UEF (Utility Estimation Framework)], [False],
    [--skip-plots], [Omite la generación de visualizaciones], [False],
    [--output-dir], [Directorio de salida para los resultados], [None],
  ),
  caption: "Parámetros principales de configuración"
) <tabla-argumentos>

\
La ejecución se puede realizar tanto directamente a través de Python como mediante contenedores Docker, donde los parámetros se configuran a través de variables de entorno. El sistema utiliza valores por defecto seleccionados para garantizar una evaluación robusta incluso con configuración mínima.

-	*Almacenamiento de Resultados*:
Los resultados de la evaluación se almacenan en una estructura organizada dentro del directorio del proyecto. Las métricas de IR (nDCG, AP) se guardan por consulta en archivos de texto plano, mientras que las correlaciones entre predictores QPP y métricas se almacenan en formato tabular, acompañadas de visualizaciones (diagramas de caja y de dispersión) generadas automáticamente.

La evaluación final integra estos resultados mediante un análisis bidimensional: (1), midiendo la efectividad del sistema de recuperación base, medida a través de las métricas IR por consulta, y (2), midiendo la capacidad predictiva de los métodos QPP, cuantificada mediante coeficientes de correlación por rangos entre los puntajes de los predictores y las métricas IR. Una mayor correlación significa que los puntajes de los predictores son confiables para predecir el rendimiento del sistema de recuperación.

\
-	*Métricas Utilizadas*:
Para el desarrollo de esta evaluación se optó por el uso de métricas de evaluación que cuentan con una presencia amplia en la literatura, por un lado se decantó por el uso nDCG y AP, las cuales son ampliamente utilizadas en tareas de ranking y precisión proporcionan una medida del rendimiento del sistema de recuperación. Por otro lado, se decantó por el uso de métricas de correlación para la predicción de rendimiento de consultas, como el coeficiente de correlación de Kendall y Spearman, las cuales son ampliamente utilizadas en la literatura y proporcionan una medida de la efectividad de los predictores QPP. @correlation-methods

En el contexto de la evaluación de sistemas de recuperación de información, las métricas binarias como Average Precision (*AP*) requieren una distinción clara entre documentos relevantes y no relevantes. Para lograr esto, se establece un umbral binario sobre los niveles de relevancia originales del dataset, donde los documentos con un nivel de relevancia igual o superior al umbral se consideran relevantes, mientras que aquellos por debajo se consideran no relevantes. Este enfoque permite evaluar el rendimiento del sistema en términos de su capacidad para distinguir entre documentos relevantes y no relevantes.

Por otro lado, las métricas graduadas como el Normalized Discounted Cumulative Gain (nDCG) aprovechan la naturaleza multi-nivel de los juicios de relevancia mediante valores de ganancia. Estos valores representan la utilidad o importancia relativa de cada nivel de relevancia, donde un valor más alto indica una mayor relevancia del documento. La asignación de valores de ganancia es crucial ya que influye directamente en cómo la métrica evalúa la calidad del ranking, penalizando más severamente cuando documentos altamente relevantes (con mayor valor de ganancia) aparecen en posiciones más bajas del ranking. En la @tbl:tabla-metricas-datasets se detalla la configuración específica de relevancia y valores de ganancia para cada dataset:

\
#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    stroke: (x: none),
    row-gutter: (2.2pt, auto),
    align: left,
    [*Dataset*], [*Configuración*], [*Justificación*],
    [ANTIQUE],
    [- Relevancia: 4 niveles (1-4)
     - Umbral binario: ≥3
     - Valores de ganancia:
       - Nivel 1: 0.0
       - Nivel 2: 0.0  
       - Nivel 3: 0.5
       - Nivel 4: 1.0],
    [Escala más granular que permite distinguir entre documentos marginalmente relevantes (3) y altamente relevantes (4). Los niveles 1-2 se consideran no relevantes para métricas binarias.],
    
    [Iquique Dataset],
    [- Relevancia: 3 niveles (0-2)
     - Umbral binario: ≥1
     - Valores de ganancia:
        - Nivel 0: 0.0
        - Nivel 1: 1.0
        - Nivel 2: 2.0],
    [Escala más simple que diferencia entre no relevante (0), relevante (1) y altamente relevante (2). Utiliza una escala lineal para el cálculo de nDCG.],
  ),
  caption: "Configuración de métricas por dataset"
) <tabla-metricas-datasets>

\
Para el análisis de correlación, el sistema implementa tres coeficientes (τ-Kendall, ρ-Spearman, r-Pearson), pero prioriza τ-Kendall por:

- *Interpretabilidad*: Mide directamente la proporción de pares concordantes vs discordantes
- *Robustez*: Menos sensible a valores atípicos y transformaciones monótonas
- *Normalización*: Rango consistente [-1,1] independiente de la distribución
- *Significancia*: Mejor comportamiento con muestras pequeñas

Además dentro de la literatura se ha discutido sobre el rendimiento e interpretabilidad de otros coeficientes, como el coeficiente de correlación de Pearson, el cual es menos robusto que τ-Kendall y Spearman, y su uso ha sido desestimado en favor de las anteriormente mencionadas. @correlation-depends-on-quality-of-dataset

La implementación utilizará la librería ir_measures para garantizar cálculos estandarizados de las métricas IR, mientras que Scipy proporciona implementaciones eficientes de los coeficientes de correlación. El sistema maneja automáticamente casos especiales como queries sin resultados o scores QPP indefinidos, asegurando una evaluación robusta incluso en condiciones no ideales.  


== Relación entre diseño experimental y objetivos

El diseño experimental anteriormente expuesto se encuentra directamente alineado con los objetivos planteados, garantizando que cada etapa contribuya de forma directa al cumplimiento de las metas establecidas. Es por ello que, en esta sección, se describe la relación entre los elementos del diseño experimental y los objetivos general y específicos, resaltando cómo estos interactúan entre sí para alcanzar los resultados de análisis buscados.

=== Relación con el objetivo general

Como se ha mencionado en capítulos anteriores, el objetivo general del proyecto consiste en evaluar comparativamente métodos de Query Performance Prediction (QPP) para búsquedas Ad-hoc utilizando métricas de correlación. En alineación con este objetivo, el diseño se ha organizado en las siguientes etapas:

- Selección de Métodos QPP: Se han seleccionado seis métodos QPP no basados en inteligencia artificial (IDF, SCQ, NQC, Clarity Score, WIG y UEF) que son ampliamente reconocidos en la literatura y representan enfoques tanto pre-retrieval como post-retrieval.
- Selección de Datasets: Se han elegido cinco datasets (Cranfield, MS MARCO Passage, Antique/Test, BEIR-TREC-COVID y CAR Fold 0) que cubren una amplia gama de dominios y tipos de consultas, asegurando que los resultados sean generalizables.
- Implementación y Evaluación: Los métodos QPP se implementan en un entorno controlado utilizando herramientas como PyTerrier, Docker e ir_datasets, por lo que la evaluación se realiza mediante métricas de correlación y juicios de relevancia.
- Análisis de Resultados: Los resultados obtenidos se comparan con estudios previos para determinar la efectividad de los métodos y establecer una línea base para futuras investigaciones.

La @tbl:tabla-relacion-objetivos resume la relación entre el diseño experimental y cómo contribuye al objetivo general.

\
#figure(
  table(
    columns: (auto, auto),
    inset: 10pt,
    stroke: (x: none),
    row-gutter: (2.2pt, auto),
    align: left + horizon,
    [*Etapa del diseño experimental*], [*Contribución al objetivo general*],
    [*Selección de Métodos QPP*], [Garantiza que los métodos evaluados sean representativos y relevantes para búsquedas Ad-hoc.],
    [*Selección de Datasets*], [Permite evaluar los métodos en diferentes contextos y dominios, asegurando la generalización de los resultados.],
    [*Implementación y Evaluación*], [Proporciona una evaluación comparativa robusta utilizando métricas de correlación estandarizadas.],
    [*Análisis de Resultados*], [Establece una línea base para futuras comparaciones con nuevos enfoques.],
  ),
  caption: "Relación entre diseño experimental y objetivos"
) <tabla-relacion-objetivos>

\
=== Alineación con los Objetivos Específicos

\
A continuación, se describe cómo cada objetivo específico se relaciona con el diseño experimental.

El primer objetivo específico del proyecto corresponde a:

#{
  set enum(numbering: "a)")
  [a) *Revisar la literatura sobre métodos de QPP en búsquedas Ad-hoc sin el uso de inteligencia artificial.*
    
   Este objetivo se aborda mediante una revisión exhaustiva de trabajos y artículos académicos y experimentales relevantes, priorizando métodos no basados en IA que han sido ampliamente estudiados y documentados, lo que asegura que los métodos seleccionados sean representativos y relevantes para el contexto de búsquedas Ad-hoc.

    
    El segundo objetivo específico del proyecto corresponde a:

   b) *Comparar los resultados de los métodos QPP con estudios previos.*
   
   Se utilizan métricas de correlación estandarizadas y juicios de relevancia para evaluar el rendimiento de los métodos QPP. Estas métricas son ampliamente aceptadas en la literatura y permiten una comparación directa con estudios previos.

   El tercer objetivo específico del proyecto corresponde a:

   c) *Implementar métodos QPP en búsquedas Ad-hoc sin inteligencia artificial para su evaluación utilizando métricas estandarizadas*
   
   La implementación de los métodos se realiza en un entorno experimental controlado utilizando contenedores Docker, que aseguran la replicabilidad y la consistencia en la ejecución de los experimentos con ayuda de scripts en Python, lo que permite una evaluación precisa y reproducible.

   El cuarto objetivo específico del proyecto corresponde a:

   d) *Evaluar los resultados obtenidos de los métodos QPP implementados, determinando su efectividad en función de los resultados descritos en el estado del arte.*
   
   La evaluación se realiza comparando las predicciones generadas por los métodos seleccionados con los juicios de relevancia (qrels) asociados a cada dataset, utilizando métricas de correlación como Kendall's Tau. Este análisis permite determinar las fortalezas y limitaciones de cada método en contextos específicos.
  
  El quinto y último objetivo corresponde a:

  e) *Analizar y documentar el rendimiento de los métodos QPP implementados para establecer una línea base para futuras comparaciones con nuevos enfoques*
  
  Los resultados obtenidos se documentan detalladamente, incluyendo las métricas de correlación obtenidas para cada método QPP en cada dataset. Esta documentación sirve como una línea base para futuras investigaciones, permitiendo que otros investigadores comparen nuevos métodos con los resultados obtenidos en este proyecto.
  ]
  
}
#pagebreak()
#figure(
  table(
    columns: (auto, auto),
    inset: 10pt,
    stroke: (x: none),
    row-gutter: (2.2pt, auto),
    align: left + horizon,
    [*Objetivo específico*], [*Elemento del diseño experimental*],
    [a)], [Revisión de literatura y selección de métodos representativos],
    [b)], [Selección de datasets reconocidos y herramientas de evaluación estandarizadas.],
    [c)], [Implementación de métodos QPP en entornos replicables.],
    [d)], [Evaluación de predicciones mediante métricas de correlación y juicios de relevancia.],
    [e)], [Documentación y análisis de resultados en función de los objetivos del proyecto.],
  ),
  caption: "Relación entre diseño experimental y objetivos"
) <tabla-relacion-resumen>

\
Como se observa en la @tbl:tabla-relacion-resumen, el diseño experimental del proyecto está cuidadosamente alineado con los objetivos del proyecto, en donde la selección de métodos QPP, la elección de datasets, la implementación en un entorno controlado y el uso de métricas de correlación estandarizadas garantizan que los resultados sean robustos, reproducibles y relevantes para el campo de la predicción del rendimiento de consultas, resultando en un enfoque que no solo cumple con los objetivos del proyecto, sino que también establece una base sólida para futuras investigaciones en QPP.


