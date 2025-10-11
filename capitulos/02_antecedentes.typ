#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= MARCO TEÓRICO
\
Conceptos básicos y principios fundamentales...
== Sistemas de Recuperación de Información (IR)
=== Definición y alcance de los sistemas de recuperación de información
=== Modelos de recuperación de información

== Predicción de Rendimiento de Consultas (QPP)
=== Consultas, tópicos y búsquedas Ad-hoc
=== Variabilidad y dificultad de las consultas
=== Clasificación de métodos QPP
\
La literatura distingue dos familias principales de predictores de rendimiento de consulta según el momento en que extraen información: métodos pre-retrieval y post-retrieval. Los primeros se calculan antes de ejecutar la búsqueda utilizando únicamente la consulta y estadísticas del índice; los segundos explotan señales observadas en la lista recuperada a partir de un modelo de recuperación de información (p. ej., puntuaciones y modelos de los documentos tope).@wig-nqc-scored-configuration

En paralelo, al adentrarnos en el campo de la inteligencia artificial, podemos encontrar otras categorías de clasificación por ejemplo, régimen de aprendizaje (no supervisados frente a supervisados) y por entorno (búsqueda ad-hoc y conversacional), cuyas elecciones implican compromisos entre costo computacional, latencia y capacidad para modelar fenómenos como ambigüedad, deriva temática y distribución de puntuaciones. @Meng2023QPP @web-search-qpp.

==== Métodos pre-retrieval
Los predictores pre-retrieval estiman la dificultad de una consulta a priori, sin ejecutar recuperación. Se apoyan en propiedades intrínsecas de la consulta y en estadísticas globales de la colección disponibles en tiempo de indexación. Entre los indicadores más utilizados se encuentran agregados de especificidad de términos basados en IDF (promedio, máximo) y variantes relacionadas con la evidencia proveniente de los indices construidos y la discriminabilidad léxica; su efectividad se sustenta en teorías probabilísticas y en combinaciones de rasgos de similitud y variabilidad calculados a nivel de colección y documento. @idf-understanding @preretrieval-idf @microsoft-preretrieval.

==== Métodos post-retrieval



== Métricas de Evaluación de Rendimiento y Correlación
=== Juicios de relevancia (Qrels)
=== Métricas de evaluación clásicas en IR
=== Métricas de correlación para evaluar métodos QPP
