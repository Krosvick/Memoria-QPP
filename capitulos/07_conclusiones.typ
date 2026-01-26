#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= CONCLUSIONES Y TRABAJO FUTURO

#v(10pt)
== Principales conclusiones
\

El presente trabajo ha abordado la evaluación comparativa de diversos métodos de Predicción del Rendimiento de Consultas (QPP) en el contexto de búsquedas ad-hoc. A través de la implementación y análisis de métodos tanto pre-retrieval como post-retrieval, se ha logrado establecer una línea base robusta que facilita la comprensión de la efectividad y limitaciones de cada enfoque en diferentes escenarios de recuperación de información.

Los resultados obtenidos en el análisis de resultados revelan que los métodos post-retrieval, especialmente aquellos que incorporan el marco de Utility Estimation Framework (UEF) como UEF-NQC, muestran una correlación significativamente mayor con las métricas de rendimiento (nDCG\@10 y AP) en comparación con métodos pre-retrieval tradicionales como IDF. Esto subraya la importancia de utilizar información adicional obtenida después de la recuperación para mejorar la precisión de las predicciones de rendimiento de consultas.

Asimismo, el método Normalized Query Commitment (NQC) demostró una capacidad predictiva considerable, consolidando su posición como uno de los métodos más efectivos dentro de los evaluados. Por otro lado, el método IDF mostró una correlación prácticamente nula, indicando su limitada utilidad en la predicción del rendimiento en el contexto específico de este estudio.

El preprocesado mediante algoritmos de stemming y stopwords, así como la implementación de métodos de normalización de los datos, resultaron ser herramientas con un impacto significativo en la precisión de los métodos QPP. Su implementación en el entorno dio lugar a resultados mixtos, con algunas mejoras significativas (SCQ, NQC, UEF-NQC) y otras que vieron mermada su efectividad (IDF, Clarity).

Finalmente, la evidencia experimental demuestra que los métodos QPP clásicos presentan una capacidad predictiva limitada en el contexto de búsquedas ad-hoc. Los resultados se alinean con investigaciones previas como la de Hauff et al. (2010) @how-much-correlation-is-good, que establece que correlaciones bajas ($τ < 0.1$) pueden ser útiles en Meta-búsquedas, correlaciones medias ($τ >= 0.4$) pueden ser útiles en búsquedas ad-hoc tomando ciertas suposiciones, mientras que correlaciones más altas ($τ >= 0.7$) son necesarias para obtener resultados generalizables y confiables en todos los casos.


#v(10pt)
== Relación entre diseño experimental y objetivos

\
El diseño experimental anteriormente expuesto se encuentra directamente alineado con los objetivos planteados, garantizando que cada etapa contribuya de forma directa al cumplimiento de las metas establecidas. Es por ello que, en esta sección, se describe la relación entre los elementos del diseño experimental y los objetivos general y específicos, resaltando cómo estos interactúan entre sí para alcanzar los resultados de análisis buscados.

#v(10pt)
=== Relación con el objetivo general

\
Como se ha mencionado en capítulos anteriores, el objetivo general del proyecto consiste en evaluar comparativamente métodos de _Query Performance Prediction_ (QPP) para búsquedas _ad-hoc_ utilizando métricas de correlación. En alineación con este objetivo, el diseño se ha organizado en las siguientes etapas:

- *Selección de Métodos QPP*: Se han seleccionado seis métodos QPP no basados en inteligencia artificial (IDF, SCQ, NQC, Clarity Score, WIG y UEF) que son ampliamente reconocidos en la literatura y representan enfoques tanto _pre-retrieval_ como _post-retrieval_.
- *Selección de Datasets*: Se han elegido cinco _datasets_ (Cranfield Collection, ANTIQUE, TREC-COVID, MS MARCO Passage (TREC DL 2020) y TREC CAR) que cubren una amplia gama de dominios y tipos de consultas con juicios de relevancia multi-nivel, asegurando que los resultados sean generalizables.
- *Implementación y Evaluación*: Los métodos QPP se implementan en un entorno controlado utilizando herramientas como PyTerrier, Docker e ir_datasets, por lo que la evaluación se realiza mediante métricas de correlación y juicios de relevancia.
- *Análisis de Resultados*: Los resultados obtenidos se comparan con estudios previos para determinar la efectividad de los métodos y establecer una línea base para futuras investigaciones.

La @tbl:tabla-relacion-objetivos resume la relación entre el diseño experimental y cómo contribuye al objetivo general.

\
\
\
#figure(
  table(
    columns: (auto, auto),
    inset: 10pt,
    stroke: (x: none),
    row-gutter: (2.2pt, auto),
    align: left + horizon,
    [*Etapa del diseño experimental*], [*Contribución al objetivo general*],
    [*Selección de Métodos QPP*], [Garantiza que los métodos evaluados sean representativos y relevantes para búsquedas ad-hoc.],
    [*Selección de Datasets*], [Permite evaluar los métodos en diferentes contextos y dominios, asegurando la generalización de los resultados.],
    [*Implementación y Evaluación*], [Proporciona una evaluación comparativa robusta utilizando métricas de correlación estandarizadas.],
    [*Análisis de Resultados*], [Establece una línea base para futuras comparaciones con nuevos enfoques.],
  ),
  caption: "Relación entre diseño experimental y objetivos."
) <tabla-relacion-objetivos>
\

#v(10pt)
=== Alineación con los Objetivos Específicos
\

A continuación, se describe cómo cada objetivo específico se relaciona con el diseño experimental:

*a) Revisar la literatura sobre métodos de QPP en búsquedas ad-hoc sin el uso de inteligencia artificial.*
#pad(left: 1.5em)[
  Este objetivo se aborda mediante una revisión exhaustiva de trabajos y artículos académicos y experimentales relevantes, priorizando métodos no basados en IA que han sido ampliamente estudiados y documentados, lo que asegura que los métodos seleccionados sean representativos y relevantes para el contexto de búsquedas ad-hoc.
]

*b) Comparar los resultados de los métodos QPP con estudios previos.*
#pad(left: 1.5em)[
  Se utilizan métricas de correlación estandarizadas y juicios de relevancia para evaluar el rendimiento de los métodos QPP. Estas métricas son ampliamente aceptadas en la literatura y permiten una comparación directa con estudios previos.
]

*c) Implementar métodos QPP en búsquedas ad-hoc sin inteligencia artificial para su evaluación utilizando métricas estandarizadas.*
#pad(left: 1.5em)[
  La implementación de los métodos se realiza en un entorno experimental controlado utilizando contenedores Docker, que aseguran la replicabilidad y la consistencia en la ejecución de los experimentos con ayuda de scripts en Python, lo que permite una evaluación precisa y reproducible.
]

*d) Evaluar los resultados obtenidos de los métodos QPP implementados, determinando su efectividad en función de los resultados descritos en el estado del arte.*
#pad(left: 1.5em)[
  La evaluación se realiza comparando las predicciones generadas por los métodos seleccionados con los juicios de relevancia (qrels) asociados a cada dataset, utilizando métricas de correlación como Kendall's Tau. Este análisis permite determinar las fortalezas y limitaciones de cada método en contextos específicos.
]

*e) Analizar y documentar el rendimiento de los métodos QPP implementados para establecer una línea base para futuras comparaciones con nuevos enfoques.*
#pad(left: 1.5em)[
  Los resultados obtenidos se documentan detalladamente, incluyendo las métricas de correlación obtenidas para cada método QPP en cada dataset. Esta documentación sirve como una línea base para futuras investigaciones, permitiendo que otros investigadores comparen nuevos métodos con los resultados obtenidos en este proyecto.
]

\
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
  caption: "Relación entre diseño experimental y objetivos."
) <tabla-relacion-resumen>
\

Como se observa en la @tbl:tabla-relacion-resumen, el diseño experimental del proyecto está cuidadosamente alineado con los objetivos del proyecto, en donde la selección de métodos QPP, la elección de datasets, la implementación en un entorno controlado y el uso de métricas de correlación estandarizadas garantizan que los resultados sean robustos, reproducibles y relevantes para el campo de la predicción del rendimiento de consultas, resultando en un enfoque que no solo cumple con los objetivos del proyecto, sino que también establece una base sólida para futuras investigaciones en QPP.


\
== Recomendaciones para investigaciones futuras
\

Durante el desarrollo de este proyecto, se enfrentaron diversas dificultades, principalmente relacionadas con la gestión de datos y la implementación eficiente de los métodos QPP. La variabilidad en los niveles de relevancia de los datasets y la necesidad de adaptar las configuraciones de los métodos a cada caso específico representaron desafíos técnicos significativos. Además, la complejidad inherente a la implementación de métodos post-retrieval demandó una profundidad de análisis y recursos computacionales que limitaron parcialmente el alcance de las evaluaciones.

Las limitaciones observadas en este estudio incluyen la restricción a métodos no basados en inteligencia artificial, lo que, si bien ha permitido una evaluación transparente y reproducible, ha excluido enfoques que podrían ofrecer mejoras sustanciales en la predicción de rendimiento. Asimismo, la dependencia de ciertos datasets y parámetros específicos configura un marco de evaluación que podría no generalizarse completamente a otros contextos o colecciones de datos.

Por lo tanto, se recomienda que futuras investigaciones consideren la inclusión de métodos basados en inteligencia artificial y aprendizaje automático, los cuales podrían capturar de manera más efectiva las complejidades y matices presentes en las consultas y colecciones de documentos. Además, la ampliación del espectro de datasets utilizados, incorporando colecciones más diversas y de mayor escala, podría proporcionar una evaluación más exhaustiva y generalizable de los métodos QPP.

#v(10pt)
== Trabajo Futuro
\

De cara al futuro, se identifican varias líneas de investigación que podrían enriquecer y ampliar los hallazgos de este estudio:

1. *Integración de Métodos Basados en Inteligencia Artificial:* Incorporar enfoques de aprendizaje supervisado y no supervisado para desarrollar predictores QPP más sofisticados que puedan adaptarse dinámicamente a diferentes tipos de consultas y colecciones de documentos.

2. *Optimización de Parámetros y Configuraciones:* Realizar estudios detallados sobre la influencia de diversos parámetros en los métodos QPP, buscando optimizaciones que puedan mejorar significativamente la correlación con las métricas de rendimiento.

3. *Exploración de Nuevas Métricas de Evaluación:* Ampliar el análisis a métricas adicionales que puedan ofrecer perspectivas complementarias sobre la efectividad de los métodos QPP, tales como MAP, R-Precision o métricas basadas en la satisfacción del usuario.

4. *Impacto del preprocesado en los métodos QPP:* Realizar estudios sobre la influencia del preprocesado en los métodos QPP, buscando identificar las mejores prácticas para mejorar la precisión de los métodos.

5. *Desarrollo de Métodos Híbridos:* Combinar características de métodos pre-retrieval y post-retrieval en un enfoque híbrido que aproveche las fortalezas de ambos, buscando compensar sus respectivas limitaciones.

6. *Estudios de Caso en Dominios Específicos:* Aplicar y evaluar los métodos QPP en dominios especializados como medicina, derecho o e-commerce, donde las características particulares de las consultas y documentos podrían influir de manera distinta en el rendimiento de los predictores.


Este trabajo establece una base sólida para la evaluación comparativa de métodos QPP en búsquedas ad-hoc, al tiempo que abre múltiples avenidas para investigaciones futuras que pueden profundizar y ampliar los conocimientos en este campo dinámico y en constante evolución. 