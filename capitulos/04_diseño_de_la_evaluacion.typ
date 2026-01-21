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
El diseño de esta evaluación comparativa no solo tiene como propósito validar la implementación técnica de los métodos QPP seleccionados, sino también establecer líneas base que permitan analizar sus fortalezas y limitaciones en contextos variados propios de los sistemas de recuperación de información. Para ello, se consideraron criterios sólidos y alineados con las mejores prácticas del estado del arte, garantizando la representatividad y el rigor del análisis comparativo.

La necesidad de un diseño comparativo sólido radica en la creciente complejidad de los sistemas de recuperación de información y la diversidad de escenarios en los que estos se aplican. Como señala @zendel2024qpptk, uno de los desafíos fundamentales en la investigación de QPP radica en la falta de reproducibilidad y estabilidad de los resultados experimentales, debido en parte a la variabilidad en las configuraciones de los sistemas de recuperación y en los conjuntos de datos utilizados. Esta variabilidad justifica la adopción de un marco experimental que utilice múltiples _datasets_ representativos de diferentes dominios y tipos de consultas, emplee herramientas estandarizadas que garanticen la reproducibilidad, y aplique métricas de evaluación ampliamente aceptadas en la literatura. El diseño experimental propuesto sigue las recomendaciones de estudios recientes que enfatizan la importancia de establecer líneas base estables y reproducibles para futuras comparaciones @zendel2024qpptk @enhanced-evaluation.

En el presente trabajo de título, el diseño de la evaluación comparativa no solo busca responder preguntas específicas sobre el rendimiento de los métodos seleccionados, sino también contribuir al avance del estado del arte en QPP, estableciendo un marco que promueva prácticas experimentales reproducibles, transparentes y aplicables a diversos contextos, garantizando que los hallazgos obtenidos sean relevantes tanto para la comunidad científica como para la práctica en sistemas de recuperación de información.

#v(10pt)
== Protocolo de evaluación experimental

\
En esta sección se describe el protocolo de evaluación desarrollado para llevar a cabo la evaluación comparativa de los métodos de _Query Performance Prediction_ (QPP). A continuación se presenta el flujo general de los experimentos, las métricas empleadas para la evaluación, y las configuraciones técnicas específicas del entorno experimental.

Respecto a esté último, está diseñado para garantizar la reproducibilidad, flexibilidad y transparencia. Para lograrlo, se ha implementado un entorno basado en capas, y reproducible en Docker, que permite ejecutar los experimentos de manera consistente y controlada, sin depender de configuraciones específicas de hardware o software.

#v(10pt)
=== Paradigma de evaluación de métodos QPP
\
Antes de describir el flujo del sistema, es fundamental formalizar el paradigma de evaluación estándar utilizado en la literatura para cuantificar la calidad de los métodos de _Query Performance Prediction_ (QPP). Este marco conceptual constituye la base teórica del diseño experimental.

El paradigma de evaluación se modela a partir de los siguientes componentes fundamentales:

1.  *Contexto de Recuperación*: En la @eqt:contexto-recuperacion, $cal(C)$ es una colección de documentos y $cal(Q) = {q_1, ..., q_n}$ un conjunto de $n$ consultas de evaluación. Dado un sistema de recuperación $S$ (_ranker_), la ejecución de una consulta $q_i in cal(Q)$ sobre el corpus genera una lista ordenada de documentos $L_i$:

\
    $ L_i = S(q_i, cal(C)) $ <contexto-recuperacion>
\

2.  *_Ground Truth_ (Efectividad Real)*: Para cada consulta $q_i$, existe un conjunto de juicios de relevancia $R_i$ (_qrels_). Como se define en la @eqt:ground-truth, la efectividad real del sistema para dicha consulta, denotada como $m_S (q_i)$, se obtiene aplicando una métrica de evaluación $cal(M)$ (como AP o nDCG) sobre la lista recuperada:

\
    $ m_S (q_i) = cal(M)(L_i, R_i) $ <ground-truth>
\

#pad(left:15pt)[
  El conjunto de valores de efectividad para todas las consultas conforma el vector de desempeño real $arrow(m)_S in RR^n$:
]

\
    $ arrow(m)_S = [m_S (q_1), m_S (q_2), dots, m_S (q_n)]^top $
\

3.  *Predicción de Rendimiento*: Un método QPP se define como una función estimadora $phi$ que asigna un puntaje a cada consulta, intentando aproximar su dificultad. Según la @eqt:prediccion, el vector de predicciones $arrow(phi) in RR^n$ se construye calculando:

\
    $ arrow(phi) = [phi(q_1), phi(q_2), dots, phi(q_n)]^top $ <prediccion>
\
#pad(left:15pt)[
Dependiendo del tipo de predictor, la función $phi(q_i)$ puede depender solo de la consulta y el _corpus_ (_pre-retrieval_) o también de la lista recuperada $L_i$ (_post-retrieval_).
]

4.  *Evaluación de la Calidad*: Finalmente, la calidad del predictor $P$ se cuantifica midiendo la asociación estadística entre el desempeño real y el predicho. Esto se formaliza en la @eqt:calidad mediante una función de correlación (típicamente Pearson $rho$ o Kendall $tau$):

\
    $ "Calidad"(P) = "Corr"(arrow(m)_S, arrow(phi)) $ <calidad>
\

#pad(left:15pt)[
El objetivo experimental es, por tanto, encontrar un predictor $phi^*$ tal que maximice esta correlación, tal como se expresa en la @eqt:optimizacion:
]

\
$ phi^* = arg max_phi "Corr"(arrow(m)_S, arrow(phi)) $ <optimizacion>
\

#pad(left:15pt)[
Una alta correlación positiva indica que el predictor es capaz de ordenar las consultas de manera similar a su rendimiento real, permitiendo distinguir fiablemente entre consultas "difíciles" y "fáciles" para el sistema $S$ @query-drift.
]

#v(10pt)
=== Flujo del sistema

\
El diseño experimental sigue un flujo bien definido en el contexto de la recuperación de información, garantizando su entendimiento, reproducibilidad y el análisis riguroso de los resultados, como se puede apreciar en la @fig:diagrama_general.

\
#figure(
  diagram(
    spacing: 2pt,
    cell-size: (8mm, 8mm),
    edge-stroke: .8pt,

    // Capa de datos e indexación (fila superior)
    component((0,0), [Capa de \ datasets], tint: gray, name: "datasets"),
    component((3,0), [Capa de \ Indexado], tint: purple, name: "index"),
    component((6,0), [Sistema de \ recuperación \ "BM25"], tint: purple, name: "IR"),

    // Métodos QPP (fila intermedia)
    component((2,3), [Métodos \
    Pre-retrieval], tint: blue, name: "pre"),
    component((4,3), [Métodos \
    Post-retrieval], tint: blue, name: "post"),

    // Capa de evaluación (fila inferior)
    component((6,6), [Evaluación \ con Qrels], tint: red, name: "metr"),
    component((3,6), [Capa de \ Evaluación], tint: red, name: "corr"),
    component((0,6), [Resultado de \ correlación], tint: red, name: "puntajes"),

    // Flujo de datos principal: datasets → índice → sistema de recuperación
    edge(<datasets>, <index>, "->", $"Se indexan"$),
    edge(<index>, <IR>, "->", $"Utiliza índice"$),

    // Métodos QPP: entradas desde índice / sistema de recuperación
    edge(<index>, <pre>, "->", $"Estadísticas de colección"$, label-pos: 0.4, label-side: center),
    edge(<IR>, <post>, "->", $"Ranking BM25"$, label-pos: 0.45, label-side: center),
    edge(<index>, <post>, "->"),

    // Evaluación con qrels (métricas IR)
    edge(<IR>, <metr>, "->", $"Resultados BM25"$, label-pos: 0.55, label-side: center),

    // Capa de evaluación: recibe métricas IR y puntajes QPP
    edge(<metr>, <corr>, "->", $"Métricas de efectividad"$),
    edge(<pre>, <corr>, "->", $"Puntajes pre-retrieval"$, label-side: right, label-pos: 0.25),
    edge(<post>, <corr>, "->", $"Puntajes post-retrieval"$,label-side: left, label-pos: 0.25),

    // Resultado final
    edge(<corr>, <puntajes>, "->", $"Guarda correlaciones"$),
  ),
  caption: "Diagrama de componentes del entorno de evaluación.",
) <diagrama_general>
\

El flujo incluye los siguientes pasos principales:

-	*Preparación de _Datasets_:* Los _datasets_ seleccionados, más adelante descritos, se descargan de manera completa utilizando la librería _ir_datasets_  y se preprocesan en el entorno _Docker_, este proceso incluye la extracción de consultas, preparación de los juicios de relevancia (_Qrels_) y el formateo adecuado para su uso con _PyTerrier_.
-	*Indexado de _Datasets_:* Los _datasets_ se indexan utilizando _PyTerrier_, creando estructuras de datos eficientes para la recuperación de información. Es también en este paso donde se guardan metadatos de los _datasets_, como la frecuencia de los términos en los documentos como la frecuencia de estos en la colección. Además, se hace uso del _‟Stemmer"_ de _Snowball_ sobre los documentos y consultas, para conseguir resultados más precisos en la evaluación.
-	*Configuración de Modelos de Recuperación:* Configuración de modelos de recuperación como estándar como _BM25_ en _PyTerrier_ con parámetros predefinidos, asegurando una base consistente para la evaluación de los métodos _QPP_.
-	*Implementación de los métodos _QPP_:* Los métodos seleccionados, como, por ejemplo, _IDF_, _SCQ_ o _NQC_, se implementan mediante scripts en _Python_ dentro del contenedor _Docker_, todos estos utilizan una interfaz similar dentro del sistema, permitiendo una ejecución estandarizada de los métodos.
-	*Ejecución de los métodos de predicción:* Los experimentos se realizan mediante un script principal que realiza múltiples iteraciones por método y dataset, asegurando estabilidad y fiabilidad de los resultados.
-	*Evaluación utilizando juicios de relevancia (_Qrels_):* Se realiza una evaluación del rendimiento de las consultas utilizando la librería de _ir_measures_ sobre el sistema de recuperación implementado, esto es el _‟ground truth”_ del rendimiento de la consulta en el sistema de recuperación implementado. Posteriormente los resultados se almacenan en formato estructurado para su posterior análisis.
-	*Evaluación utilizando métricas de correlación:* Se realiza una evaluación de la correlación entre los puntajes de los predictores y las métricas IR, utilizando la biblioteca de código abierto en Python, _Scipy_, especializada en computación científica y análisis estadístico, para obtener una medida de la efectividad de los predictores QPP con relación al _‟ground truth”_.
-	*Documentación y Almacenamiento:* Los resultados, configuraciones y scripts de ejecución se almacenan en directorios organizados dentro del contenedor _Docker_, garantizando su fácil acceso y análisis.

Entre los componentes de la @fig:diagrama_general, se puede discernir la capa de datos, de indexación y recuperación. Estos componentes funcionan completamente dentro de la librería Pyterrier, el cual funciona como un *_wrapper_* para la librería Terrier, la cual es ampliamente utilizada en la literatura de recuperación de información para la realización de experimentos similares @pyterrier.

#v(10pt)
=== Configuración técnica
\
Para garantizar la fiabilidad, reproducibilidad y comparabilidad de los experimentos, se ha establecido un marco técnico estandarizado que regula desde el entorno de ejecución hasta los parámetros específicos de los algoritmos.

A continuación se detallan los componentes fundamentales de la configuración técnica:

-	*Entorno _Docker_*: Al permitir encapsular todas las dependencias necesarias en un entorno reproducible, se evitan problemas de compatibilidad y configuración entre máquinas, asegurando que los experimentos puedan ser ejecutados de manera uniforme y reproducible. Esta decisión de diseño se alinea con las recomendaciones del QPPTK, cuya arquitectura permite delegar aspectos secundarios como la configuración del sistema de recuperación o el procesamiento del _corpus_ a salidas cacheadas, permitiendo que los investigadores se enfoquen exclusivamente en el desarrollo y evaluación de métodos QPP @zendel2024qpptk.

  El sistema utiliza una imagen base de _Python 3.9_ con _Java 11_ instalado para soportar PyTerrier. 

-	*Parámetros del Modelo de Recuperación*: El sistema utiliza el modelo de recuperación _BM25_ (_Best Match 25_) como método principal de recuperación. La elección de _BM25_ como modelo base sigue la práctica estándar en la literatura de QPP, donde los análisis experimentales comúnmente emplean BM25 para garantizar la comparabilidad con estudios previos @zendel2024qpptk @query-drift. Esta decisión permite que los resultados obtenidos puedan ser directamente contrastados con trabajos anteriores y establece una línea base estable para la evaluación de los predictores. Los parámetros han sido mantenidos en su configuración por defecto, como se observa en la @tbl:tabla_de_parametros.

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
    [Especialmente importante en colecciones heterogéneas como _ANTIQUE_ donde la longitud de los documentos varía significativamente. Impacta el cálculo de NQC al normalizar los scores.],
    [0.75],
  ),
  caption: [Parámetros principales de BM25.],
) <tabla_de_parametros>

\
#pad(left:17pt)[
Otros estudios han propuesto la utilización de otros parámetros para BM25, como el parámetro k1, el cual controla la saturación de términos en los documentos, sobre todo al utilizar métodos de _clustering_, tales experimentos han demostrado que un valor de k1 mayor a 1.2 puede mejorar el rendimiento de la recuperación. Sin embargo, en este estudio se mantendrán los parámetros por defecto de PyTerrier, ya que se ha demostrado que estos proporcionan un rendimiento adecuado para la mayoría de las tareas de recuperación de información, pero se puede realizar un estudio futuro sobre la utilización de estos parámetros en la evaluación de métodos QPP @bm25.
]

#pad(left:-15pt)[
- *Ejecución de los métodos y scripts de evaluación*: La @tbl:tabla-argumentos muestra una configuración flexible de la ejecución de la evaluación a través de diversos parámetros que controlan tanto el proceso de recuperación como la evaluación QPP. La configuración se realiza principalmente mediante argumentos de línea de comandos y variables de entorno.
]

\
#figure(
  table(
    columns: (auto, auto,auto, ),
    inset: 10pt,
    stroke: (x: none),  
    row-gutter: (2.2pt, auto),
    align: left + horizon,
    [*Parámetro*], [*Descripción*], [*Valor por defecto*],
    [--datasets], [Datasets a evaluar (e.g., antique_test, trec_covid, msmarco_dl20_judged)], [Todos los datasets],
    [--max-queries], [Límite de consultas a procesar], [None (todas)],
    [--list-size], [Tamaño de lista para métricas de ranking], [10],
    [--wig-list-size], [Tamaño de lista para el predictor WIG], [5],
    [--nqc-list-size], [Tamaño de lista para el predictor NQC], [200],
    [--num-results], [Número máximo de resultados por consulta], [1000],
    [--metrics], [Métricas de evaluación (e.g., ndcg\@10, ap)], [nDCG\@10, AP],
    [--correlations], [Coeficientes de correlación a calcular (Kendall, Spearman, Pearson)], [kendall],
    [--use-uef], [Habilita las variantes utilizando el marco UEF (Utility Estimation Framework)], [True],
    [--skip-plots], [Omite la generación de visualizaciones], [False],
    [--output-dir], [Directorio de salida para los resultados], [None],
  ),
  caption: "Parámetros principales de configuración."
) <tabla-argumentos>

\
#pad(left:15pt)[
La ejecución se puede realizar tanto directamente a través de Python como mediante contenedores _Docker_, donde los parámetros se configuran a través de variables de entorno. El sistema utiliza valores por defecto seleccionados para garantizar una evaluación robusta incluso con configuración mínima.
]
#pad(left:-15pt)[
-	*Almacenamiento de Resultados*: Los resultados de la evaluación se almacenan en una estructura organizada dentro del directorio del proyecto. Las métricas de IR (nDCG, AP) se guardan por consulta en archivos de texto plano, mientras que las correlaciones entre predictores QPP y métricas se almacenan en formato tabular, acompañadas de visualizaciones (diagramas de caja y de dispersión) generadas automáticamente.
]
#pad(left:15pt)[
La evaluación final integra estos resultados mediante un análisis bidimensional: Primero midiendo la efectividad del sistema de recuperación base, medida a través de las métricas IR por consulta, y luego midiendo la capacidad predictiva de los métodos QPP, cuantificada mediante coeficientes de correlación por rangos entre los puntajes de los predictores y las métricas IR. Una mayor correlación significa que los puntajes de los predictores son confiables para predecir el rendimiento del sistema de recuperación.
]
\
#pad(left:-15pt)[
-	*Métricas Utilizadas*: Para el desarrollo de esta evaluación se optó por el uso de métricas de evaluación que cuentan con una presencia amplia en la literatura, por un lado se decantó por el uso nDCG y MAP, las cuales son ampliamente utilizadas en tareas de ranking y precisión proporcionan una medida del rendimiento del sistema de recuperación. Por otro lado, se decantó por el uso de métricas de correlación para la predicción de rendimiento de consultas, como el coeficiente de correlación de Kendall y Spearman, las cuales son ampliamente utilizadas en la literatura y proporcionan una medida de la efectividad de los predictores QPP @correlation-methods.
]
#pad(left:15pt)[
En el contexto de la evaluación de sistemas de recuperación de información, las métricas binarias como _Average Precision_ (AP) requieren una distinción clara entre documentos relevantes y no relevantes. Para lograr esto, se establece un umbral binario sobre los niveles de relevancia originales del _dataset_, donde los documentos con un nivel de relevancia igual o superior al umbral se consideran relevantes, mientras que aquellos por debajo se consideran no relevantes. Este enfoque permite evaluar el rendimiento del sistema en términos de su capacidad para distinguir entre documentos relevantes y no relevantes.
]
#pad(left:15pt)[
Por otro lado, las métricas graduadas como el _Normalized Discounted Cumulative Gain_ (nDCG) aprovechan la naturaleza multi-nivel de los juicios de relevancia mediante valores de ganancia. Estos valores representan la utilidad o importancia relativa de cada nivel de relevancia, donde un valor más alto indica una mayor relevancia del documento. La asignación de valores de ganancia es crucial ya que influye directamente en cómo la métrica evalúa la calidad del ranking, penalizando más severamente cuando documentos altamente relevantes (con mayor valor de ganancia) aparecen en posiciones más bajas del ranking.
]
Para el análisis de correlación, el sistema implementa tres coeficientes (τ-Kendall, ρ-Spearman, r-Pearson), pero prioriza τ-Kendall por interpretabilidad, ya que mide directamente la proporción de pares concordantes vs discordantes, por robustez al ser menos sensible a valores atípicos y transformaciones monótonas, por normalización, ya que su rango consistente [-1,1] es independiente de la distribución y por su significancia al tener mejor comportamiento con muestras pequeñas.

La elección de estas métricas de correlación está fundamentada en las prácticas estándar del campo de QPP. Como documentan @query-drift, existen dos medidas de evaluación comúnmente utilizadas en el marco de predicción de rendimiento de consultas: el coeficiente de correlación de Pearson (ρ), que se calcula entre los valores de Average Precision reales y los valores asignados por el método de predicción, y el coeficiente de correlación τ de Kendall, que se calcula entre un ranking de consultas ordenadas por su AP real y un ranking inducido por los valores del predictor. Para ambas métricas, valores de correlación más altos indican una mayor calidad de predicción @query-drift.

De igual forma en @wig-nqc-scored-configuration validan este enfoque metodológico al evaluar la calidad de predicción mediante ambos coeficientes: la correlación de Pearson mide la correlación lineal entre dos variables en un rango de [-1,1], mientras que τ de Kendall mide la asociación entre dos cantidades medidas, donde 1 denota que los dos rankings son idénticos y -1 indica que uno es el inverso del otro.

Además, dentro de la literatura se ha discutido sobre el rendimiento e interpretabilidad de otros coeficientes, como el coeficiente de correlación de Pearson, el cual es menos robusto que τ-Kendall y Spearman, y su uso ha sido desestimado en favor de las anteriormente mencionadas @correlation-depends-on-quality-of-dataset. El marco de evaluación mejorado propuesto por @enhanced-evaluation sugiere además modelar el rendimiento de _QPP_ como una distribución en lugar de depender de estimaciones puntuales, lo que proporciona implicaciones estadísticas importantes y supera limitaciones del enfoque tradicional basado únicamente en correlaciones.

La implementación utilizará la librería _ir_measures_ para garantizar cálculos estandarizados de las métricas de recuperación de información, mientras que _Scipy_ proporciona implementaciones eficientes de los coeficientes de correlación. El sistema maneja automáticamente casos especiales como queries sin resultados o scores _QPP_ indefinidos, asegurando una evaluación robusta incluso en condiciones no ideales.  

#v(10pt)
== Selección de conjuntos de datos
\
La selección de _datasets_ es parte fundamental para garantizar una evaluación comparativa robusta y representativa de los métodos _QPP_, es por ello, que se seleccionaron _datasets_ reconocidos en la literatura, priorizando los que ofrecen juicios de relevancia _Qrels_ y métricas estandarizadas, permitiendo así validar el desempeño de los métodos seleccionados en escenarios variados.

Además, investigaciones como @query-drift han validado sus metodologías utilizando colecciones _TREC_  ampliamente reconocidas incluidas en este evaluación, las cuales han sido empleadas en numerosos estudios de predicción de rendimiento de consultas, permitiendo un análisis profundo de la calidad de predicción y el estudio de diversos factores que afectan a los predictores. Este enfoque garantiza no solo la robustez de los resultados, sino también su generalización a futuros trabajos relacionados con QPP.

#v(10pt)
=== Criterios de inclusión
\
La @tbl:tabla-criterios-datasets presentan los criterios aplicados en la selección de _datasets_, detallando su importancia en el contexto del proyecto.

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
  caption: "Criterios de inclusión de datasets.",
) <tabla-criterios-datasets>
\

-	*Disponibilidad pública *: Es fundamental seleccionar _datasets_ de acceso abierto que estén bien documentados, ya que esto garantiza la transparencia y la reproducibilidad de los experimentos, la disponibilidad pública también asegura que los resultados puedan ser validados por otros investigadores, fomentando la colaboración y el avance en el campo del QPP.
-	*Diversidad de escenarios*: Incluir _datasets_ con diferentes tipos de consultas es crucial para evaluar cómo se desempeñan los métodos QPP en escenarios reales, por ejemplo de consultas informacionales: preguntas abiertas donde el usuario busca adquirir conocimiento general; consultas navegacionales: consultas donde el objetivo es encontrar una página específica; y consultas transaccionales: consultas orientadas a completar una acción. Esta diversidad asegura que los métodos sean efectivos en una variedad de tareas de recuperación, desde búsquedas generales hasta necesidades específicas.
-	*Uso en el estado del arte*: Seleccionar _datasets_ ampliamente utilizados en investigaciones previas permite que los resultados del proyecto sean comparables con estudios existentes, lo que refuerza la validez del análisis comparativo y asegura que las metodologías empleadas cumplan con estándares científicos.
-	*Tamaño adecuado*: La inclusión de _datasets_ de diferentes tamaños permite evaluar el comportamiento de los métodos en escenarios con distintos volúmenes de datos, en donde los _datasets_ pequeños son ideales para pruebas controladas y rápidas, mientras que los grandes, son útiles para analizar la escalabilidad y robustez de los métodos. Este enfoque asegura que los métodos QPP seleccionados sean evaluados en condiciones que reflejen tanto la simplicidad como la complejidad de los sistemas de recuperación de información modernos.
-	*Relevancias conocidas (_qrels_)*: Los juicios de relevancia son esenciales para evaluar el desempeño de los métodos de manera objetiva, al incluir _datasets_ con _qrels_ bien establecidos, se garantiza que los resultados estén basados en un marco estandarizado, facilitando su interpretación y comparación

Es así como la aplicación de estos criterios garantiza que los _datasets_ seleccionados sean adecuados para el análisis comparativo de los métodos QPP, de igual forma, al priorizar la diversidad, relevancia y representatividad, este proyecto establece una base sólida para evaluar el desempeño de los métodos en diferentes contextos y escalas, contribuyendo al avance del estado del arte en predicción del rendimiento de consultas.

#v(10pt)
=== Justificación de los conjuntos de datos seleccionados

\
Como se ha mencionado, los datasets seleccionados para el proyecto fueron escogidos cuidadosamente para garantizar que cubran una amplia gama de escenarios y dominios representativos, por lo que se alinean con los criterios de inclusión previamente establecidos, aportando características únicas que permiten evaluar el rendimiento de QPP en contextos diversos, asegurando resultados generalizables y relevantes para investigaciones futuras, además de contribuir al avance del estado del arte.

Un criterio fundamental en la selección fue la preferencia por datasets con juicios de relevancia multi-nivel (_graded relevance judgments_). Esta decisión se fundamenta en las siguientes ventajas:

- *Anotaciones manuales de alta calidad*: Los qrels de múltiples niveles son típicamente anotados por evaluadores expertos o jueces especializados, lo que garantiza una mayor precisión y consistencia en los juicios de relevancia.
- *Significado semántico por nivel*: Cada nivel de relevancia tiene un significado específico y definido (por ejemplo, "no relevante", "parcialmente relevante", "altamente relevante"), lo que permite una evaluación más matizada del rendimiento.
- *Compatibilidad con métricas graduadas*: Los juicios multi-nivel permiten el uso de métricas con factores de ganancia como nDCG que aprovechan la granularidad de las anotaciones, proporcionando una evaluación más completa del sistema de recuperación.

La @tbl:tabla-datasets especifica los datasets seleccionados, seguida de la @tbl:tabla-metadata-datasets que detalla los estadísticos de cada colección, incluyendo el origen de sus consultas y juicios de relevancia.

\
#figure(
  table(
    columns: (2fr, 3fr, 3fr, 3fr),
    inset: 10pt,
    stroke: (x: none),
    row-gutter: (2.2pt, auto),
    align: left + horizon,
    table.header(
      [*Dataset*], [*Descripción*], [*Contribución al proyecto*],[*Razón de inclusión*]
    ),
    [Cranfield Collection],
    [Dataset clásico con resúmenes científicos y consultas predeterminadas de tamaño reducido.],
    [
      Facilita pruebas rápidas y controladas para la comparación directa de métodos QPP.
    ],
    [Simplicidad y diseño compacto lo hacen ideal para experimentos iniciales y controlados.],
    [ANTIQUE],
    [Dataset centrado en la recuperación de preguntas y respuestas subjetivas basadas en opiniones.],
    [Evalúa el desempeño de los métodos frente a consultas subjetivas y no factuales.],
    [Introduce complejidad adicional al incorporar preguntas subjetivas difíciles de modelar.],
    [TREC-
    
    COVID],
    [Parte del benchmark BEIR, centrado en la recuperación de información médica sobre COVID-19.],
    [Permite evaluar los métodos QPP en un dominio altamente especializado y relevante.],
    [Su enfoque en consultas científicas lo hace adecuado para escenarios de alta especificidad.],
    [MS 
    
    MARCO Passage (TREC DL 2020)],
    [Subconjunto del MS MARCO Passage utilizado en TREC Deep Learning 2020 con juicios oficiales.],
    [Proporciona un entorno realista para evaluar la aplicabilidad práctica de los métodos.],
    [Refleja el contexto de búsqueda cotidiana con anotaciones de relevancia detalladas.],
    [TREC CAR],
    [Dataset del TREC CAR v1.5 Year 1 con juicios de relevancia manuales.],
    [Proporciona evaluación con juicios humanos detallados en escala graduada.],
    [Incluye juicios negativos explícitos que permiten un análisis más profundo.]
  ),
  caption: "Tabla de datasets y sus criterios de inclusión.",
) <tabla-datasets>

\
#show figure: set block(breakable: true)
#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    inset: 8pt,
    stroke: (x: none),
    row-gutter: (2.2pt, auto),
    align: left + horizon,
    table.header(
      [*Dataset*], [*Variante ir\_datasets*], [*Documentos*], [*Consultas*], [*Qrels*], [*Origen de Anotaciones*]
    ),
    [Cranfield], [`cranfield`], [1.400], [225], [1.837], [Expertos en aerodinámica (1960s)],
    [ANTIQUE], [`antique/test`], [403.666], [200], [6.589], [Crowdworkers (Amazon MTurk)],
    [TREC-
    
    COVID], [`beir/trec-covid`], [171.332], [50], [66.336], [Asesores NIST (expertos médicos)],
    [MS 
    
    MARCO DL 2020], [`msmarco-passage/trec-dl-2020/judged`], [8.841.823], [54], [11.386], [Asesores NIST (TREC DL 2020)],
    [TREC CAR], [`car/v1.5/trec-y1/manual`], [29.678.367], [2.287], [29.571], [Asesores NIST (juicios manuales)]
  ),
  caption: "Estadísticos de los datasets seleccionados.",
) <tabla-metadata-datasets>
\

*Cranfield Collection*: La colección Cranfield representa uno de los hitos fundacionales en la historia de la recuperación de información. Desarrollada entre 1958 y 1966 en el _Cranfield Institute of Technology_ (actualmente Cranfield University) en el Reino Unido, bajo la dirección de Cyril Cleverdon, constituye el primer intento sistemático de evaluar sistemas de recuperación de información bajo condiciones controladas.

- *Documentos*: La colección consta de 1.400 resúmenes científicos en el dominio de la aerodinámica. Cada documento incluye campos de identificador, título, texto del abstract, autor y referencia bibliográfica.
- *Consultas*: Las 225 consultas fueron formuladas en lenguaje natural por investigadores del área, representando necesidades de información reales del dominio científico.
- *Origen de _Qrels_*: Los juicios de relevancia fueron anotados manualmente por expertos en aerodinámica, estableciendo una escala de 5 niveles (-1 a 4). Estos juicios introdujeron el concepto de "_relevance judgments_" que se convertiría en estándar para la evaluación de IR. La distribución incluye: 225 juicios de nivel -1, 128 de nivel 1, 387 de nivel 2, 734 de nivel 3, y 363 de nivel 4.
- *Importancia histórica*: Los experimentos de Cranfield establecieron el "paradigma Cranfield" que incluye una colección de documentos, un conjunto de consultas con juicios de relevancia asociados, y evaluación basada en _precisión y recall_, metodología que posteriormente adoptaría TREC.
\

*ANTIQUE (_A Non-factoid Question Answering Benchmark_):* ANTIQUE es un benchmark diseñado específicamente para la recuperación de respuestas no factuales, desarrollado por investigadores de la Universidad de Massachusetts Amherst y publicado en 2019 @antique-dataset.

- *Documentos*: La colección contiene 403.666 pasajes cortos de respuestas extraídos de Yahoo! Answers (Webscope L6), un servicio de preguntas y respuestas comunitario donde usuarios formulaban preguntas de diversa índole.
- *Consultas*: El conjunto de test incluye 200 preguntas no factuales de dominio abierto, caracterizadas por ser subjetivas y basadas en opiniones, donde no existe una única respuesta "correcta". Las preguntas provienen de categorías diversas como consejos, recomendaciones y experiencias personales.
- *Origen de Qrels*: Los 6,589 juicios de relevancia del conjunto de test fueron recolectados mediante crowdsourcing en Amazon Mechanical Turk. Los anotadores evaluaron todas las respuestas disponibles para cada pregunta utilizando una escala de 4 niveles: nivel 1 (fuera de contexto), nivel 2 (no relevante), nivel 3 (marginalmente relevante), y nivel 4 (altamente relevante). La distribución incluye: 1.642 juicios de nivel 1, 2.417 de nivel 2, 1.196 de nivel 3, y 1.334 de nivel 4.
- *Objetivo*: Este dataset introduce complejidad adicional para los sistemas de recuperación debido a la naturaleza subjetiva de las consultas, donde la relevancia depende de factores contextuales y de opinión difíciles de modelar estadísticamente.
\

*TREC-COVID:* TREC-COVID fue una iniciativa colaborativa entre el _Allen Institute for Artificial Intelligence_ (AI2), el _National Institute of Standards and Technology_ (NIST), la _National Library of Medicine_ (NLM), _Oregon Health & Science University_ (OHSU), y la _University of Texas Health Science Center at Houston_ (UTHealth) @trec-covid-dataset.

- *Documentos*: La colección utiliza el corpus CORD-19 (_COVID-19 Open Research Dataset_) mantenido por Semantic Scholar. La versión BEIR contiene 171.332 artículos científicos representados por sus títulos y abstracts, incluyendo campos como identificador, texto, título, URL y PubMed ID.
- *Consultas*: Las 50 consultas representan necesidades de información reales de científicos, clínicos, responsables de políticas públicas y otros profesionales que necesitaban navegar la creciente literatura científica sobre COVID-19 durante la pandemia. Cada consulta incluye un título conciso, una descripción expandida y una narrativa que especifica qué documentos serían considerados relevantes.
- *Origen de Qrels*: Los 66.336 juicios de relevancia fueron creados por asesores de NIST con experiencia biomédica, provenientes de NLM, OHSU y UTHealth. La evaluación se realizó en cinco rondas consecutivas durante 2020, acumulando juicios de relevancia profundos ("_deep relevance judgments_"). La escala incluye: nivel -1 (no evaluado o documento eliminado, 2 juicios), nivel 0 (no relevante, 41.661 juicios), nivel 1 (relevante, 10.456 juicios), y nivel 2 (altamente relevante, 14.217 juicios).
- *Objetivos*: El track buscó evaluar algoritmos de búsqueda para ayudar a gestionar el corpus de literatura científica sobre COVID-19 y descubrir métodos aplicables a futuras crisis biomédicas globales.
\

*MS MARCO Passage (_TREC Deep Learning 2020_):* MS MARCO (_Microsoft MAchine Reading COmprehension_) es una colección a gran escala desarrollada por Microsoft Research, utilizada como base para el _TREC Deep Learning Track_ desde 2019 @ms-marco-dataset.

- *Documentos*: El _corpus_ completo contiene 8.841.823 pasajes extraídos de documentos web reales indexados por Bing. Cada pasaje consiste en un identificador y el texto del pasaje.
- *Consultas*: Las consultas del TREC DL 2020 fueron muestreadas del conjunto de evaluación de MS MARCO. Originalmente, estas consultas provienen de preguntas reales y anónimas formuladas por usuarios del motor de búsqueda Bing, lo que garantiza que representan necesidades de información auténticas y cotidianas. El subconjunto "_judged_" contiene 54 consultas que fueron evaluadas por asesores de NIST.
- *Origen de Qrels*: A diferencia de los juicios de relevancia escasos de MS MARCO original (donde típicamente solo un documento es marcado como relevante por consulta), el TREC DL 2020 proporciona 11.386 juicios de relevancia detallados creados por asesores de NIST. La escala de 4 niveles incluye: nivel 0 (irrelevante, 7.780 juicios), nivel 1 (relacionado, 1,940 juicios), nivel 2 (altamente relevante, 1.020 juicios), y nivel 3 (perfectamente relevante, 646 juicios). El umbral binario oficial de TREC es ≥ 2.
\

*TREC CAR (_Complex Answer Retrieval_):* TREC CAR es una colección de recuperación de pasajes _ad-hoc_ construida a partir de Wikipedia, diseñada para abordar necesidades de información complejas que requieren respuestas extensas y estructuradas @TREC-CAR-dataset.

- *Documentos*: El corpus v1.5 contiene 29.678.367 pasajes extraídos de Wikipedia (_dump_ de diciembre 2016). Cada documento incluye un identificador único y el texto del pasaje.
- *Consultas*: Las 2.287 consultas del _Year 1_ (2017) fueron derivadas de la estructura jerárquica de artículos de Wikipedia. Cada consulta incluye un identificador, texto completo, título del artículo y la jerarquía de encabezados que representa la sección específica. Las consultas fueron seleccionadas manualmente de temas de ciencia popular y medio ambiente, inspiradas en noticias de actualidad y temas de interés general.
- *Origen de Qrels*: La versión "manual" (`car/v1.5/trec-y1/manual`) contiene 29.571 juicios de relevancia creados por seis asesores de NIST utilizando _pools_ de documentos construidos a partir de las entregas de los participantes. La escala graduada de 6 niveles es la más detallada entre los datasets seleccionados:
  - Nivel -2: Basura/spam (42 juicios)
  - Nivel -1: No relevante (12.785 juicios)
  - Nivel 0: No relevante pero tema cercano (9.219 juicios)
  - Nivel 1: Podría mencionarse (3.094 juicios)
  - Nivel 2: Debería mencionarse (1.970 juicios)
  - Nivel 3: Debe mencionarse (2.461 juicios)
- *Diferencia con qrels automáticos*: TREC CAR también ofrece qrels automáticos derivados de la estructura de Wikipedia, pero para este proyecto se utiliza exclusivamente la versión con juicios manuales por su mayor fiabilidad y la inclusión de juicios negativos explícitos.

Además, todos los datasets utilizados son de acceso abierto en repositorios públicos y están bien documentados debido a que son ampliamente reconocidos en la comunidad de recuperación de información, lo que asegura que cualquier investigador pueda acceder a ellos sin restricciones para replicar los experimentos. Todos los datasets son accesibles a través de la librería *_ir\_datasets_*, garantizando un proceso estandarizado de carga y preprocesamiento. Es así que, la utilización de datasets de acceso abierto garantiza que los resultados del proyecto sean reproducibles y accesibles para futuras investigaciones, fomentando el entorno colaborativo y transparente, evitando problemas legales o éticos relacionados con el uso de datos restringidos o privados.

De esta forma, la selección de datasets con características bien definidas asegura una evaluación diversa y representativa de los métodos QPP seleccionados, ya que este enfoque cubre dominios especializados, tareas cotidianas y casos complejos, estableciendo una base sólida para validar la efectividad y aplicabilidad de los métodos en diferentes contextos de recuperación de información.

Una vez definidos los conjuntos de datos, es necesario operacionalizar las métricas de evaluación descritas en la _Sección 4.1_ ajustándolas a las escalas de relevancia particulares de cada colección seleccionada, dado que cada _dataset_ posee criterios de juicio distintos, se ha establecido una configuración estandarizada para los umbrales de relevancia y los valores de ganancia.

En la @tbl:tabla-metricas-datasets se detalla la configuración específica de relevancia, umbrales binarios y valores de ganancia para cada _dataset_ seleccionado.

\
#show figure: set block(breakable: true)
#figure(
  table(
    columns: (1fr, 3fr, 2fr),
    inset: 10pt,
    stroke: (x: none),
    row-gutter: (2.2pt, auto),
    align: left,
    [*Dataset*], [*Configuración*], [*Justificación*],
    [Cranfield Collection],
    [- Relevancia: 5 niveles (-1 a 4)
     - Umbral binario: ≥1
     - Valores de ganancia:
       - Nivel -1: 0 (Sin interés)
       - Nivel 1: 1 (Interés mínimo)
       - Nivel 2: 2 (Referencia útil)
       - Nivel 3: 3 (Alta relevancia)
       - Nivel 4: 4 (Respuesta completa)],
    [Escala graduada clásica que permite distinguir desde documentos sin interés hasta respuestas completas. Ideal para experimentos controlados.],
    
    [ANTIQUE],
    [- Relevancia: 4 niveles (1-4)
     - Umbral binario: ≥3
     - Valores de ganancia:
       - Nivel 1: 0 (Fuera de contexto)
       - Nivel 2: 1 (No relevante)
       - Nivel 3: 2 (Marginal)
       - Nivel 4: 3 (Altamente relevante)],
    [Escala granular para preguntas subjetivas. Los niveles 1-2 se consideran no relevantes para métricas binarias.],
    
    [TREC-COVID],
    [- Relevancia: 4 niveles (-1 a 2)
     - Umbral binario: ≥1
     - Valores de ganancia:
       - Nivel -1: 0 (No evaluado/negativo)
       - Nivel 0: 0 (No relevante)
       - Nivel 1: 1 (Relevante)
       - Nivel 2: 2 (Altamente relevante)],
    [Incluye nivel -1 para documentos no evaluados. Permite distinguir información COVID-19 de alta relevancia.],
    
    [MS 
    
    MARCO Passage (TREC DL 2020)],
    [- Relevancia: 4 niveles (0-3)
     - Umbral binario: ≥2
     - Valores de ganancia:
       - Nivel 0: 0 (Irrelevante)
       - Nivel 1: 1 (Relacionado)
       - Nivel 2: 2 (Altamente relevante)
       - Nivel 3: 3 (Perfectamente relevante)],
    [Umbral binario en ≥2 siguiendo la práctica oficial de TREC. Escala graduada para nDCG.],
    
    [TREC CAR],
    [- Relevancia: 6 niveles (-2 a 3)
     - Umbral binario: ≥1
     - Valores de ganancia:
       - Nivel -2: 0 (Basura)
       - Nivel -1: 0 (No relevante)
       - Nivel 0: 0 (No relevante, tema cercano)
       - Nivel 1: 1 (Puede mencionarse)
       - Nivel 2: 2 (Debería mencionarse)
       - Nivel 3: 3 (Debe mencionarse)],
    [Escala detallada con juicios manuales. Incluye niveles negativos para contenido basura o irrelevante.],
  ),
  caption: "Configuración de métricas por dataset."
) <tabla-metricas-datasets>
\

#v(10pt)
== Selección de métodos de QPP
\
La selección de métodos QPP resulta crucial en el diseño de este proyecto, ya que determina la relevancia y la validez del análisis comparativo.

Para garantizar que los enfoques evaluados sean representativos y estén alineados con los objetivos del estudio, se establecieron criterios rigurosos basados en la literatura científica revisada, los cuales priorizan la inclusión de métodos reconocidos en el estado del arte, con fundamentos estadísticos sólidos y un alto grado de reproducibilidad.

A continuación, se describen los criterios aplicados en el proceso de selección, así como los métodos QPP finalmente escogidos para la posterior evaluación comparativa.

#v(10pt)
=== Criterios de selección
\
Como se ha mencionado, la selección de métodos de _Query Performance Prediction_ (QPP) es un proceso fundamental para garantizar que los métodos evaluados sean representativos, robustos y relevantes en el contexto de los sistemas de recuperación de información. Con este propósito, se definieron criterios específicos que permiten abordar el problema desde una perspectiva teórica sólida y práctica aplicable, los que aseguran la validez de la evaluación comparativa y su alineación con los objetivos del proyecto.

\
#figure(
  table(
    columns: (2fr, 3fr, 3fr),
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
  caption: "Criterios de selección de métodos de QPP.",
) <tabla-criterios>
\

La @tbl:tabla-criterios resume los criterios definidos para la selección de los métodos de QPP, en donde cada criterio cumple un rol específico para garantizar que los métodos seleccionados no solo sean estadísticamente sólidos, sino también relevantes y diversificados en su enfoque, asegurando que el análisis comparativo resultante sea exhaustivo y útil para evaluar las fortalezas y limitaciones de los métodos elegidos.

- *Base estadística y simplicidad*: Se seleccionan métodos que se basan en conceptos matemáticos fundamentales, como la frecuencia de términos en el _corpus_ y su relación con la consulta, ya que estos métodos son ampliamente reconocidos por su sencillez y su capacidad para ser implementados y replicados sin necesidad de recursos computacionales avanzados. Este criterio asegura que los métodos elegidos puedan ser utilizados como referencia en investigaciones futuras, promoviendo la reproducibilidad de los experimentos y el entendimiento teórico de los predictores.
- *Uso en estudios previos*: Se buscan métodos que han sido recurrentemente evaluados en trabajos recientes que analizan sistemas de recuperación de información, ya que no solo garantiza que los resultados del proyecto sean comparables con investigaciones previas, sino que también asegura que los métodos seleccionados representan soluciones probadas y bien documentadas.
- *Diversidad de enfoques*: Se seleccionan métodos tanto _pre-retrieval_ como _post-retrieval_ para capturar diferentes aspectos del problema, mientras que unos se enfocan en estimar la calidad de una consulta basándose únicamente en estadísticas del corpus, los otros evalúan la calidad considerando los documentos recuperados. Este enfoque integral permite analizar el rendimiento de consultas desde múltiples perspectivas, proporcionando una visión más completa de sus fortalezas y debilidades.
- *Relevancia en el estado del arte*: Se priorizan métodos no basados en inteligencia artificial, ya que estos garantizan un análisis más transparente y menos sesgado en comparación con tecnologías supervisadas, además, de esta forma, los métodos seleccionados han sido ampliamente reconocidos en la literatura por su aplicabilidad en sistemas de recuperación de información y su capacidad para ser implementados sin depender de datasets de entrenamiento o modelos complejos.

Por otra parte, la decisión de priorizar métodos no basados en inteligencia artificial tiene varias razones claves:

-	*Transparencia y simplicidad*: Los métodos no basados en inteligencia artificial, ofrecen interpretaciones claras de cómo se calculan y qué factores influyen en su desempeño, esto contrasta con los métodos supervisados, cuya complejidad en ocasiones dificulta la comprensión de su funcionamiento interno.
-	*Reproducibilidad*: Al no depender de datasets de entrenamiento o modelos complejos, los métodos no basados en IA pueden ser implementados en cualquier entorno sin necesidad de recursos adicionales, lo que asegura que los experimentos realizados sean replicables por otros investigadores.
-	*Independencia del contexto*: Los métodos seleccionados son independientes de los dominios específicos y los cambios en las colecciones de datos, mientras que los métodos supervisados tienden a ser altamente sensibles a las características del dataset de entrenamiento.
-	*Contribución al estado del arte*: Este enfoque se alinea con el objetivo de establecer líneas base sólidas para evaluar nuevos métodos, permitiendo que futuros desarrollos en QPP se comparen con estándares bien establecidos.

#v(10pt)
=== Métodos seleccionados
\
Siguiendo los criterios establecidos en la sección anterior y tras un análisis exhaustivo de la literatura, se seleccionaron seis métodos de _Query Performance Prediction_ (QPP) para la evaluación comparativa, los cuales representan enfoques diversos e incluyen estrategias _pre-retrieval_ y _post-retrieval_, lo que asegura una cobertura de los aspectos clave del rendimiento de consultas en sistemas de recuperación de información. Además, como se ha mencionado, cada método fue elegido por su relevancia en el estado del arte, su fundamento teórico y su impacto demostrado en investigaciones previas, ofreciendo un marco robusto para analizar su efectividad y aplicabilidad en contextos variados.

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
  [1. IDF (_Inverse Document Frequency_)],
  [_Pre-retrieval_],
  [
    Mide la rareza de los términos en un _corpus_ mediante la frecuencia inversa de documentos.
  ],
  [2. SCQ (_Similarity between a Query and a Collection_],
  [_Pre-retrieval_],
  [Calcula la similitud entre los términos de la consulta y la colección basándose en frecuencias y pesos.],
  [3. NQC (_Normalized Query Commitment_)],
  [_Post-retrieval_],
  [Evalúa la dispersión de los puntajes de relevancia en los documentos recuperados para predecir la calidad de la consulta.],
  [4. _Clarity Score_ (SC)],
  [_Post-retrieval_],
  [Mide la divergencia entre el modelo de lenguaje de los documentos recuperados y el modelo de la colección. ],
  [5. WIG (_Weighted Information Gain_)],
  [_Post-retrieval_],
  [Estima la calidad de la consulta mediante la ganancia de información ponderada basada en los documentos recuperados.],
  [6. UEF (_Utility Estimation Framework_)],
  [_Post-retrieval_],
  [Utiliza modelos de relevancia y teoría de decisión estadística para estimar la utilidad de los rankings generados.]
  ),
  caption: "Métodos de QPP seleccionados.",
) <tabla-metodos>
\

En cuanto al análisis de las fortalezas y debilidades de cada método seleccionado en la @tbl:tabla-metodos:

-	*IDF (_Inverse Document Frequency_) :* Es un método simple, eficiente y ampliamente utilizado, su capacidad para medir la especificidad de los términos lo convierte en una herramienta básica para estimar la calidad de las consultas. Por otra parte, depende exclusivamente de estadísticas del corpus, lo que limita su precisión en escenarios donde la calidad de los documentos recuperados influye de forma significativa.
-	*SCQ (_Similarity between a Query and a Collection_):* Proporciona una evaluación más detallada al considerar la similitud entre la consulta y la colección en su conjunto, lo que resulta útil en contextos con consultas de longitud variada. Por otra lado, puede ser menos efectivo en colecciones con alta heterogeneidad temática debido a su dependencia de estadísticas globales.
-	*NQC (_Normalized Query Commitment_):* Evalúa la consistencia de los puntajes de relevancia en los documentos recuperados, lo que lo hace efectivo para identificar consultas problemáticas, pero requiere ejecutar consultas y recuperar documentos, lo que implica un costo computacional más alto en comparación con métodos pre-retrieval.
-	*_Clarity Score_ (CS):* Mide la coherencia del lenguaje de los documentos recuperados, lo que lo hace efectivo en consultas específicas con temas bien definidos, pero es sensible a consultas cortas o ambiguas, donde la divergencia entre el modelo de lenguaje y el corpus puede ser menos clara.
-	*WIG (_Weighted Information Gain_):* Integra múltiples características de los documentos recuperados, como términos y proximidad, proporcionando una evaluación integral, aunque puede ser afectado por colecciones con sesgos en los documentos más relevantes, disminuyendo su precisión en escenarios específicos.
-	*UEF (_Utility Estimation Framework_):* Ofrece un marco flexible y adaptable, utilizando modelos de relevancia para capturar tanto la utilidad como la precisión de los rankings generados, pero su complejidad estadística puede dificultar su implementación en sistemas con recursos limitados o en contextos donde se prioriza la simplicidad.

Los métodos seleccionados abarcan una gama de enfoques y fundamentos teóricos, lo que garantiza una evaluación comparativa exhaustiva y representativa, en donde la inclusión de métodos tanto _pre-retrieval_ como _post-retrieval_ asegura que se cubran múltiples facetas del problema, proporcionando una base sólida para analizar su desempeño en diferentes contextos, resultando en un diseño experimental robusto que refuerza la validez del estudio y su contribución al avance del estado del arte en predicción de rendimiento de consultas.


