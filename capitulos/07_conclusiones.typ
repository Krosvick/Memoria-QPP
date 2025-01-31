#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= CONCLUSIONES Y TRABAJO FUTURO
\

== Principales conclusiones
\

El presente trabajo ha abordado la evaluación comparativa de diversos métodos de Predicción del Rendimiento de Consultas (QPP) en el contexto de búsquedas Ad-hoc. A través de la implementación y análisis de métodos tanto pre-retrieval como post-retrieval, se ha logrado establecer una línea base robusta que facilita la comprensión de la efectividad y limitaciones de cada enfoque en diferentes escenarios de recuperación de información.

Los resultados obtenidos en el análisis de resultados revelan que los métodos post-retrieval, especialmente aquellos que incorporan el marco de Utility Estimation Framework (UEF) como UEF-NQC, muestran una correlación significativamente mayor con las métricas de rendimiento (nDCG\@10 y AP) en comparación con métodos pre-retrieval tradicionales como IDF. Esto subraya la importancia de utilizar información adicional obtenida después de la recuperación para mejorar la precisión de las predicciones de rendimiento de consultas.

Asimismo, el método Normalized Query Commitment (NQC) demostró una capacidad predictiva considerable, consolidando su posición como uno de los métodos más efectivos dentro de los evaluados. Por otro lado, el método IDF mostró una correlación prácticamente nula, indicando su limitada utilidad en la predicción del rendimiento en el contexto específico de este estudio.

El preprocesado mediante algoritmos de stemming y stopwords, así como la implementación de métodos de normalización de los datos, resultaron ser herramientas con un impacto significativo en la precisión de los métodos QPP. Su implementación en el entorno dio lugar a resultados mixtos, con algunas mejoras significativas (SCQ, NQC, UEF-NQC) y otras que vieron mermada su efectividad (IDF, Clarity).

Finalmente, la evidencia experimental demuestra que los métodos QPP clásicos presentan una capacidad predictiva limitada en el contexto de búsquedas Ad-hoc. Los resultados se alinean con investigaciones previas como la de Hauff et al. (2010) @how-much-correlation-is-good, que establece que correlaciones bajas ($τ < 0.1$) pueden ser útiles en Meta-búsquedas, correlaciones medias ($τ >= 0.4$) pueden ser útiles en búsquedas Ad-hoc tomando ciertas suposiciones, mientras que correlaciones más altas ($τ >= 0.7$) son necesarias para obtener resultados generalizables y confiables en todos los casos.


\
== Recomendaciones para investigaciones futuras
\

Durante el desarrollo de este proyecto, se enfrentaron diversas dificultades, principalmente relacionadas con la gestión de datos y la implementación eficiente de los métodos QPP. La variabilidad en los niveles de relevancia de los datasets y la necesidad de adaptar las configuraciones de los métodos a cada caso específico representaron desafíos técnicos significativos. Además, la complejidad inherente a la implementación de métodos post-retrieval demandó una profundidad de análisis y recursos computacionales que limitaron parcialmente el alcance de las evaluaciones.

Las limitaciones observadas en este estudio incluyen la restricción a métodos no basados en inteligencia artificial, lo que, si bien ha permitido una evaluación transparente y reproducible, ha excluido enfoques que podrían ofrecer mejoras sustanciales en la predicción de rendimiento. Asimismo, la dependencia de ciertos datasets y parámetros específicos configura un marco de evaluación que podría no generalizarse completamente a otros contextos o colecciones de datos.

Por lo tanto, se recomienda que futuras investigaciones consideren la inclusión de métodos basados en inteligencia artificial y aprendizaje automático, los cuales podrían capturar de manera más efectiva las complejidades y matices presentes en las consultas y colecciones de documentos. Además, la ampliación del espectro de datasets utilizados, incorporando colecciones más diversas y de mayor escala, podría proporcionar una evaluación más exhaustiva y generalizable de los métodos QPP.

\
== Trabajo Futuro
\

De cara al futuro, se identifican varias líneas de investigación que podrían enriquecer y ampliar los hallazgos de este estudio:

1. *Integración de Métodos Basados en Inteligencia Artificial:* Incorporar enfoques de aprendizaje supervisado y no supervisado para desarrollar predictores QPP más sofisticados que puedan adaptarse dinámicamente a diferentes tipos de consultas y colecciones de documentos.

2. *Optimización de Parámetros y Configuraciones:* Realizar estudios detallados sobre la influencia de diversos parámetros en los métodos QPP, buscando optimizaciones que puedan mejorar significativamente la correlación con las métricas de rendimiento.

3. *Exploración de Nuevas Métricas de Evaluación:* Ampliar el análisis a métricas adicionales que puedan ofrecer perspectivas complementarias sobre la efectividad de los métodos QPP, tales como MAP, R-Precision o métricas basadas en la satisfacción del usuario.

4. *Impacto del preprocesado en los métodos QPP:* Realizar estudios sobre la influencia del preprocesado en los métodos QPP, buscando identificar las mejores prácticas para mejorar la precisión de los métodos.

5. *Desarrollo de Métodos Híbridos:* Combinar características de métodos pre-retrieval y post-retrieval en un enfoque híbrido que aproveche las fortalezas de ambos, buscando compensar sus respectivas limitaciones.

6. *Estudios de Caso en Dominios Específicos:* Aplicar y evaluar los métodos QPP en dominios especializados como medicina, derecho o e-commerce, donde las características particulares de las consultas y documentos podrían influir de manera distinta en el rendimiento de los predictores.


Este trabajo establece una base sólida para la evaluación comparativa de métodos QPP en búsquedas Ad-hoc, al tiempo que abre múltiples avenidas para investigaciones futuras que pueden profundizar y ampliar los conocimientos en este campo dinámico y en constante evolución. 