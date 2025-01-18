#import "../template.typ": *


#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}

= INTRODUCCIÓN
\

== Contexto del proyecto
\
La predicción del rendimiento de consultas (QPP) ha emergido como una herramienta prometedora en los sistemas de recuperación de información (IR). La capacidad de predecir la calidad de los resultados de búsqueda antes de la ejecución de la consulta permite tanto optimizar los recursos como al mismo tiempo mejorar la experiencia de los usuarios. Sin embargo, la eficacia de los métodos QPP varía significativamente según el dominio, el tipo de consulta, e incluso los modelos de recuperación de información utilizados, algo que se evidencia especialmente en búsquedas ad-hoc. Esta variabilidad subraya la necesidad de evaluaciones robustas y reproducibles, que permitan comparar y contrastar diferentes enfoques de tal forma que se pueda establecer una línea base clara para futuras investigaciones. 

La motivación sobre el campo de Query Performance Prediction (QPP) a aumentado  en los últimos años debido a los avances en el campo de la inteligencia artificial, específicamente en el área del procesado de lenguaje natural (NLP), donde nuevos modelos de lenguaje como BERT, GPT entre otros han demostrado ser muy efectivos en tareas de recuperación de información mediante el uso de técnicas especializadas como RAG (Retrieval augmented generation). Bajo esta premisa se abre un nuevo paradigma de métodos QPP basados en consultas conversacionales, donde la interacción entre el usuario y el sistema de recuperación de información se da de forma más natural. Es por esto por lo que es importante establecer una línea base sobre los enfoques tradicionales para asegurar un avance en las futuras investigaciones de métodos QPP basados en inteligencia artificial.

\
== Objetivo General
\
Evaluar comparativamente métodos de Query Performance Prediction (QPP) para búsquedas Ad-hoc utilizando métricas de correlación.

\
== Objetivos Específicos
\
1. Revisar la literatura sobre métodos de QPP en búsquedas ad-hoc sin el uso de inteligencia artificial.
2. Identificar y describir los principales métodos QPP utilizados en la actualidad.
3. Implementar y evaluar métodos QPP no basados en inteligencia artificial utilizando un conjunto de datos estandarizados y un marco de evaluación común.
4. Analizar y documentar el rendimiento de los métodos QPP implementados para establecer una línea base para futuras comparaciones.
5. Identificar fortalezas y debilidades de diferentes enfoques, proporcionando ideas para futuras investigaciones en métodos QPP.

\
== Estructura del trabajo de titulo