#import "../template.typ": *


#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}

= INTRODUCCIÓN

#v(10pt)
== Contexto del proyecto
\
La predicción del rendimiento de consultas (QPP) ha emergido como una herramienta prometedora en los sistemas de recuperación de información (IR). La capacidad de predecir la calidad de los resultados de búsqueda antes de la ejecución de la consulta permite tanto optimizar los recursos como al mismo tiempo mejorar la experiencia de los usuarios. No obstante, la eficacia de los métodos QPP varía significativamente según el dominio, el tipo de consulta, e incluso los modelos de recuperación utilizados, algo que se evidencia especialmente en búsquedas ad-hoc. Esta variabilidad subraya la necesidad de evaluaciones robustas y reproducibles, que permitan comparar y contrastar diferentes enfoques de tal forma que se pueda establecer una línea base clara para futuras investigaciones.

La complejidad del problema de QPP se magnifica por la diversidad de escenarios de aplicación y la heterogeneidad de los datos en diferentes dominios. Los sistemas de recuperación de información modernos deben manejar consultas que varían desde preguntas simples hasta construcciones complejas en lenguaje natural, cada una con sus propios desafíos de predicción de rendimiento. Además, la calidad de los resultados puede verse afectada por factores como la ambigüedad del lenguaje, la especificidad de la consulta, y la cobertura del tema en la colección de documentos.

La motivación sobre el campo de Query Performance Prediction (QPP) ha aumentado en los últimos años debido a los avances en el campo de la inteligencia artificial, específicamente en el área del procesado de lenguaje natural (NLP), donde nuevos modelos de lenguaje como BERT, GPT entre otros han demostrado ser muy efectivos en tareas de recuperación de información mediante el uso de técnicas especializadas como RAG (Retrieval augmented generation). Bajo esta premisa se abre un nuevo paradigma de métodos QPP basados en consultas conversacionales, donde la interacción entre el usuario y el sistema de recuperación de información se da de forma más natural.

Este trabajo busca establecer una línea base sobre los enfoques tradicionales para asegurar un avance en las futuras investigaciones de métodos QPP, mediante la implementación de un benchmark abierto y reproducible, disponible en GitHub. #footnote[https://github.com/emerssn/QPP-Benchmark]

#v(10pt)
== Objetivo General
\
Evaluar comparativamente métodos de Query Performance Prediction (QPP) para búsquedas Ad-hoc utilizando métricas de correlación.

#v(10pt)
== Objetivos Específicos
\
#pad(left:15pt)[
1. Revisar la literatura sobre métodos de QPP en búsquedas ad-hoc sin el uso de inteligencia artificial.
2. Identificar y describir los principales métodos QPP utilizados en la actualidad.
3. Implementar y evaluar métodos QPP no basados en inteligencia artificial utilizando un conjunto de datos estandarizados y un marco de evaluación común.
4. Analizar y documentar el rendimiento de los métodos QPP implementados para establecer una línea base para futuras comparaciones.
5. Identificar fortalezas y debilidades de diferentes enfoques, proporcionando ideas para futuras investigaciones en métodos QPP.
]

#v(10pt)
== Estructura del trabajo de título
\
El presente trabajo de título se compone de los siguientes siete capítulos:

*Capítulo I: Introducción.* Presenta el contexto y motivación del proyecto, junto con los objetivos general y específicos planteados para su realización. Se describe la importancia de la predicción del rendimiento de consultas (QPP) en sistemas de recuperación de información y la necesidad de una evaluación comparativa robusta.

*Capítulo II: Marco Teórico.* Proporciona el marco teórico necesario para comprender el trabajo, incluyendo conceptos fundamentales sobre sistemas de recuperación de información, predicción del rendimiento de consultas, métricas de evaluación y las herramientas utilizadas en el proyecto.

*Capítulo III: Trabajos Relacionados.* Revisa y analiza los principales métodos QPP desarrollados en la literatura, enfocándose en aquellos no basados en inteligencia artificial. Se examinan sus características, fortalezas y limitaciones, estableciendo el estado del arte en el campo.

*Capítulo IV: Diseño de la Evaluación Comparativa.* Define la metodología experimental, incluyendo la selección de métodos QPP, datasets, métricas de evaluación y el entorno experimental. Se detalla la configuración técnica y los procedimientos para garantizar la reproducibilidad de los experimentos.

*Capítulo V: Implementación.* Describe en detalle la implementación del sistema, la configuración del entorno experimental y los procesos de validación. Se incluyen aspectos técnicos sobre la integración de herramientas y la ejecución de experimentos.

*Capítulo VI: Análisis de Resultados.* Presenta y analiza los resultados obtenidos en la evaluación comparativa, examinando el rendimiento de cada método QPP en diferentes escenarios y datasets. Se discuten las implicaciones de los hallazgos y se comparan con resultados previos de la literatura.

*Capítulo VII: Conclusiones y Trabajo Futuro.* Resume los principales hallazgos y contribuciones del proyecto, estableciendo la línea base para futuras investigaciones en QPP. Se identifican limitaciones del estudio y se proponen direcciones para investigaciones futuras.
