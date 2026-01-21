#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= CONCLUSIONES Y TRABAJO FUTURO

#v(10pt)
== Principales conclusiones
\

El desarrollo de este trabajo de título ha permitido evaluar el desempeño de diversos métodos de Predicción del Rendimiento de Consultas (QPP) en escenarios de recuperación Ad-hoc, abarcando desde enfoques estadísticos básicos hasta estrategias de estimación de utilidad. La evidencia experimental, obtenida a través de cinco conjuntos de datos heterogéneos, permite establecer conclusiones fundamentales sobre la aplicabilidad de estas técnicas.

En primer lugar, se concluye la superioridad de los métodos _post-retrieval_ frente a los enfoques _pre-retrieval_, en donde los resultados demuestran que la información contenida en la lista de documentos recuperados, específicamente la dispersión de sus puntuaciones, constituye una señal predictiva más robusta que las estadísticas lingüísticas de la consulta aislada. Mientras métodos _post-retrieval_ como _NQC_ y _UEF-NQC_ lograron correlaciones consistentes, el método _IDF_ (_pre-retrieval_) mostró un comportamiento prácticamente aleatorio, confirmando su ineficacia como predictor de rendimiento bajo este contexto.

En segundo lugar, se ha identificado al método _UEF-NQC_ como el predictor más estable a nivel transversal. La integración del marco _Utility Estimation Framework_ permitió mejorar la capacidad predictiva base de _NQC_ en colecciones con vocabularios dispersos, por lo que se establece que _UEF-NQC_ constituye la línea base experimental recomendada para futuras investigaciones en el área.

Así mismo, un hallazgo crítico es la dependencia del dominio y la existencia de una "barrera semántica" en los métodos estadísticos. La efectividad de los predictores está condicionada por la homogeneidad del _corpus_: el método _Clarity_, por ejemplo, resultó eficaz en dominios técnicos (_TREC-COVID_), pero ineficaz en colecciones dispersas (_Cranfield_). Más aún, el bajo rendimiento generalizado en el conjunto de datos _CAR_ evidencia que los métodos actuales poseen un techo técnico, mostrándose incapaces de modelar relaciones de relevancia semántica compleja que no dependen de la coincidencia léxica.

Adicionalmente, se observó que el preprocesado de datos (mediante algoritmos de _stemming_ y eliminación de _stopwords_) juega un rol no trivial en la estabilidad de los predictores, por lo que su correcta implementación resultó fundamental para reducir el ruido en métodos sensibles a la frecuencia de términos como _SCQ_, aunque su impacto fue marginal en métodos basados en divergencia, lo que sugiere que la limpieza de datos debe ajustarse según la naturaleza algorítmica del predictor seleccionado.

Finalmente, la evidencia experimental demuestra que los métodos QPP clásicos presentan una capacidad predictiva significativa pero acotada en el contexto de búsquedas Ad-hoc. Los resultados obtenidos (con techos de τ ≈ 0,42) se alinean con los criterios establecidos en @how-much-correlation-is-good, quienes postulan que correlaciones medias (τ >= 0,4) poseen utilidad práctica para aplicaciones de recuperación, aunque aún distan del umbral ideal de τ >= 0,7 necesario para una confiabilidad total. Esto valida la calidad de la implementación al replicar exitosamente los resultados de referencia de estudios recientes, confirmando que las herramientas evaluadas ofrecen una capacidad real para estimar la dificultad de las consultas, aunque sujetas a las limitaciones inherentes de los enfoques no neuronales.

#v(10pt)
== Cumplimiento de los objetivos específicos
\

Con respecto al objetivo general del trabajo de título, este se considera cumplido satisfactoriamente, ya que se logró evaluar comparativamente seis métodos QPP en un entorno controlado, estableciendo diferencias claras de rendimiento y generando una línea base técnica para la disciplina. A continuación, se detalla el cumplimiento de cada objetivo específico:

#pad(left:15pt)[
  *a) Revisar la literatura sobre métodos de QPP en búsquedas Ad-hoc sin el uso de inteligencia artificial*: Este objetivo se cumplió mediante la revisión exhaustiva presentada en los _Capítulos II_ y _III_, donde se documentaron y analizaron los fundamentos teóricos de métodos _pre-retrieval_ (_IDF_, _SCQ_) y _post-retrieval_ (_NQC_, _Clarity_, _WIG_, _UEF_), priorizando aquellos enfoques clásicos que no dependen de modelos neuronales.
]

#pad(left:15pt)[
*b) Comparar los resultados de los métodos QPP con estudios previos*: Se logró mediante el análisis cuantitativo del _Capítulo VI_, donde se utilizaron métricas de correlación estandarizadas (_Kendall_, _Pearson_) para contrastar los resultados obtenidos. En particular, los valores alcanzados, por ejemplo, del _dataset_ _Antique_, se alinearon con los benchmarks reportados recientemente en @zendel2024qpptk, validando la consistencia de la evaluación.
]

#pad(left:15pt)[
*c) Implementar métodos QPP en búsquedas Ad-hoc sin inteligencia artificial para su evaluación utilizando métricas estandarizadas*: La implementación fue realizada exitosamente utilizando un entorno contenerizado en _Docker_ y la biblioteca _PyTerrier_, asegurando la reproducibilidad técnica descrita en el _Capítulo V_, lo que permitió la ejecución controlada de los seis métodos seleccionados sobre los cinco conjuntos de datos definidos.
]

#pad(left:15pt)[
*d) Evaluar los resultados obtenidos de los métodos QPP implementados, determinando su efectividad en función de los resultados descritos en el estado del arte*: La evaluación se completó mediante el análisis de correlación entre las predicciones de los métodos y las métricas de recuperación, lo que permitió identificar las fortalezas de los métodos _post-retrieval_ (basados en dispersión de puntajes) y las limitaciones estructurales de los métodos _pre-retrieval_ (basados únicamente en frecuencia de términos).
]

#pad(left:15pt)[
*e) Analizar y documentar el rendimiento de los métodos QPP implementados para establecer una línea base para futuras comparaciones con nuevos enfoques*: Los resultados fueron documentados detalladamente en el _Capítulo VI_, estableciendo a _UEF-NQC_ como la configuración de referencia, por lo que esta documentación proporciona un punto de comparación robusto para futuras investigaciones que deseen contrastar nuevos enfoques, incluidos aquellos basados en inteligencia artificial.
]

#v(10pt)
== Síntesis de hallazgos
\

Del análisis comparativo se desprenden tres principales hallazgos que sintetizan el comportamiento de los predictores evaluados frente a la variabilidad de los datos:

- *Degradación de métodos pre-retrieval en índices masivos*: Se observó que los predictores basados en estadísticas globales como _SCQ_, aunque eficaces en colecciones acotadas, reducen drásticamente su rendimiento en índices de gran escala como _MS MARCO_. Esto sugiere que las métricas _pre-retrieval_ pierden capacidad discriminativa al saturarse el espacio semántico, aumentando la probabilidad de colisiones de términos no informativos.
- *Riesgo de ruido en la expansión post-retrieval (UEF)*: Aunque el marco _UEF_ potenció el rendimiento en la mayoría de los escenarios, en _MS MARCO_ no aportó ganancia sobre su base _NQC_, lo que indica que, en colecciones altamente heterogéneas o cuando la recuperación inicial es imprecisa, la expansión ciega de consultas propia de ciertos métodos _post-retrieval_ puede introducir ruido documental (_query drift_), neutralizando los beneficios teóricos de la re-estimación de utilidad.
- *Limitación semántica estructural*: El rendimiento uniformemente bajo en el _dataset CAR_ evidencia una "barrera semántica", en donde los resultados confirman que tanto los métodos _pre-retrieval_ como _post-retrieval_ clásicos presentan dificultades inherentes para capturar la relevancia conceptual profunda requerida en tareas de respuestas complejas, donde la pertinencia no depende exclusivamente de la recurrencia léxica, sino de relaciones semánticas que estos predictores no logran modelar.

#v(10pt)
== Alcance del trabajo de título
\

Es importante delimitar que el presente estudio se centró exclusivamente en métodos de predicción no supervisados y que no utilizan arquitecturas de Inteligencia Artificial moderna. La evaluación se realizó utilizando BM25 como único modelo de recuperación base, por lo que los resultados están condicionados a las características de este modelo léxico.

Asimismo, aunque se utilizaron cinco conjuntos de datos representativos, el análisis se limitó a documentos en idioma inglés y a tareas de recuperación de pasajes, excluyendo otros tipos de tareas como búsqueda de entidades o sistemas de recomendación. Estas delimitaciones fueron necesarias para garantizar la viabilidad computacional, dado que la complejidad inherente a la implementación de métodos _post-retrieval_ demandó una profundidad de análisis y recursos de procesamiento que acotaron el alcance experimental.

#v(10pt)
== Trabajo futuro
\

A partir de los resultados obtenidos y de las limitaciones identificadas, se proponen las siguientes líneas de investigación para dar continuidad a este trabajo:

- *Integración de Inteligencia Artificial*: Dado el techo de rendimiento observado en tareas semánticas, como en _CAR_, el siguiente paso es incorporar Modelos de Lenguaje Grandes (LLMs) para evaluar la coherencia semántica entre la consulta y los documentos, superando la dependencia léxica de métodos como _Clarity_.
- *Optimización de Parámetros y Configuraciones*: Con el objetivo de mejorar significativamente la correlación con las métricas de rendimiento, se recomienda realizar estudios detallados sobre la influencia de diversos parámetros en los métodos QPP.
- *Estudios de Caso en Dominios Específicos*: Se sugiere aplicar y evaluar los métodos QPP en dominios especializados como medicina, derecho, e-commerce u otros, donde las características particulares de las consultas y documentos podrían influir de manera distinta en el rendimiento de los predictores.
- *Métodos Híbridos en Cascada*: Considerando el compromiso entre costo y efectividad, se sugiere investigar arquitecturas que utilicen métodos ligeros (como SCQ), para filtrar consultas sencillas, reservando el costo computacional de métodos robustos (como UEF-NQC o modelos neuronales) solo para aquellas consultas clasificadas preliminarmente como difíciles.
- *Evaluación sobre Modelos Neuronales*: Sería relevante replicar este protocolo experimental utilizando sistemas de recuperación neuronal como base en lugar de BM25, para determinar si los predictores QPP clásicos mantienen su efectividad cuando la lista de resultados es generada por modelos densos.

De esta forma, este trabajo de título establece una base sólida para la evaluación comparativa de métodos QPP en búsquedas Ad-hoc, al tiempo que abre múltiples avenidas para investigaciones futuras que pueden profundizar y ampliar conocimientos en este campo dinámico y en constante evolución.