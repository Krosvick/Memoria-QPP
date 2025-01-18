#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= TRABAJOS RELACIONADOS
\

Como se ha mencionado anteriormente, la predicción del rendimiento de consultas (QPP) es un área importante dentro de los sistemas de recuperación de información, ya que permite anticipar la calidad de los resultados de una consulta sin necesidad de ejecutarla de forma completa. Es así, que a lo largo de los años se han desarrollado numerosos métodos QPP con diferentes características y aptos para distintas situaciones, los que han sido evaluados exhaustivamente en una larga cantidad de estudios. Estos estudios no solo han definido métricas y herramientas para medir la efectividad de los métodos QPP, sino que también han desarrollado análisis comparativos (benchmarks) que sirven como referencia en el estado del arte dentro del área.

\
A continuación, se revisan estudios relevantes relacionados con la predicción del rendimiento de consultas, presentando los principales métodos utilizados en la literatura, para posteriormente, analizar el uso de datasets y entornos de experimentación para la comparación de métodos, destacando investigaciones previas que han servido como base para el diseño experimental de este proyecto.

\

== Metodos de Query Performance Prediction (QPP)

\
En el contexto de este proyecto, se priorizó la revisión de métodos de Query Performance Prediction que no dependen de enfoques basados en inteligencia artificial (IA), los cuales, clasificados como pre-retrieval y post-retrieval, son altamente valorados por su simplicidad y robustez en la predicción del rendimiento de consulta sirviendo como base para métodos QPP más complejos.

\
Es así como, durante la revisión de la literatura, se identificaron trabajos claves que evaluaron y desarrollaron diferentes métodos QPP en diferentes contextos, como búsquedas ad-hoc y benchmarks de recuperación de información, proporcionando métricas importantes para evaluar la calidad de las consultas, los cuales se presentan a continuación.

\
=== IDF (Inverse Document Frequency)

\
El término Inverse Document Frequency (IDF), ampliamente utilizado como predictor pre-retrieval en sistemas de recuperación de información, mide la especificidad de un término dentro de un corpus. En el documento @preretrieval-idf, se profundiza su relevancia como un componente clave en la predicción del rendimiento de consultas (QPP), específicamente su capacidad para identificar términos altamente selectivos, es decir, aquellos que aparecen en pocos documentos (menos comunes) y, por ende, aportan mayor discriminación en la búsqueda. El IDF también es empleado en modelos como MaxIDF, donde el término con la mayor frecuencia inversa dentro de una consulta sirve como indicador principal de su efectividad. Esta metodología, que se basa en heurísticas, se adoptó rápidamente como una herramienta esencial en la predicción del rendimiento de consultas (QPP) pre-retrieval en los sistemas de recuperación de información, siendo incorporada en otros esquemas y modelos probabilísticos de búsqueda. 

La fórmula comúnmente utilizada del IDF en sistemas modernos, debido a su suavizado y estabilidad matemática, se define como:

$ I D F(t) = ln(1 + N/f_t) $ <idf-equation>

Donde N es el número total de documentos en el corpus y f_t es el número de documentos que contienen el término t, y se añade 1 para evitar divisiones por cero o valores indefinidos.

En el artículo @idf-understanding, el autor señala que el IDF asigna pesos más bajos a los términos frecuentes debido a su limitado poder discriminatorio, mientras que otorga pesos más altos a los términos menos comunes, los cuales poseen mayor capacidad para distinguir documentos relevantes, asegurando que los términos poco frecuentes, pero informativos, tengan un mayor impacto en el cálculo de relevancia. Además, se destaca que, aunque la formulación exacta del algoritmo puede variar según los autores, su utilidad general permanece sólida en una amplia gama de aplicaciones prácticas, incluyendo la recuperación de información y otros contextos relacionados con el análisis de datos.

De esta forma, el IDF ha sido ampliamente utilizado debido a su robustez y simplicidad. En el artículo @idf-understanding, el autor argumenta que el IDF equilibra de forma eficaz la especificidad y la relevancia, permitiendo su aplicación en diferentes contextos, tales como recuperación de textos, análisis de lenguaje natural e incluso en recuperación de medios no textuales.

En cuanto a su relevancia para el presente proyecto de evaluación de métodos de QPP, el IDF resulta crucial, ya que su capacidad para capturar la especificidad de los términos es clave para analizar la predictibilidad de las consultas y, además, como se menciona en el artículo @predicting-performance, su integración en distintas métricas proporciona una línea base confiable para la comparación con métodos más avanzados, validando su referencia tanto de forma heurística como de herramienta teórica sólida y bien fundamentada.

=== SCQ (Similarity Between Query and Collection)

\
El método SCQ (Similarity Between a Query and a Collection), es un predictor pre-retrieval propuesto por Ying Zhao, Falk Scholer y Yohannes Tsegay. En el artículo @preretrieval-idf los autores explican que el SCQ calcula un puntaje de similitud entre una consulta y la colección de documentos, utilizando la frecuencia de términos y la frecuencia inversa de documentos como evidencias para determinar la relevancia. Siendo una de sus principales ventajas que se basa en estadísticas disponibles durante el proceso de indexado, eliminando la necesidad de realizar búsquedas previas.

La fórmula matemática que define al SCQ es la siguiente:

$ S C Q = sum_(t in Q) (1+ln(f_(c,t)) dot ln(1+N/f_(t)))  $ <scq-equation>

Donde $Q$ es el conjunto de términos de la consulta, $f_(c,t)$ corresponde a la frecuencia del término $t$ en la colección, $f_t$ es el número de documentos en los que aparece el término $t$, y finalmente $N$ es el número total de documentos de la colección.

Como se menciona, el SCQ mide la similitud mediante una representación vectorial, donde tanto las consultas como los documentos son tratados como vectores. La proximidad entre estos vectores se interpreta como un indicador de relevancia que permite identificar consultas que potencialmente obtendrán un mejor rendimiento en la recuperación de información. Además, este predictor puede ajustarse mediante la normalización por longitud de la consulta o evaluarse en  función del valor máximo de SCQ alcanzado por los términos individuales.

Es así como, gracias a su balance entre la simplicidad y precisión, el SCQ se ha consolidado como una herramienta útil para sistemas de recuperación de información que manejan grandes volúmenes de datos en tiempo real, en donde su capacidad para establecer relaciones entre las características de las consultas y su rendimiento lo convierte en una contribución importante para tareas que involucran una alta variabilidad en las consultas, posicionándose como un estándar en evaluaciones pre-retrieval.

Por lo tanto, para el presente proyecto, el SCQ es particularmente relevante porque permite analizar consultas en dominios complejos y heterogéneos, estableciendo una relación clara entre las características de las consultas y su rendimiento esperado, lo que facilita una evaluación comparativa de métodos.

\
=== NQC (Normalized Query Commitment)

\
El método NQC (Normalized Query Commitment) fue propuesto por Anna Shtok, Oren Kurland y David Carmel como un predictor post-retrieval que evalúa la efectividad de una consulta midiendo la dispersión de los puntajes de recuperación entre los documentos más relevantes. En el artículo @query-drift, los autores destacan que una menor dispersión temática en los documentos recuperados está asociada con una mayor efectividad de las consultas, lo cual se refleja en la distribución de los puntajes de recuperación.

Por lo tanto, el enfoque de NQC se centra en medir la desviación estándar de los puntajes de recuperación normalizados por el promedio del corpus, lo que permite identificar consultas cuyos documentos recuperados son consistentes en términos de relevancia, sugiriendo un buen desempeño de la consulta. Además, los autores explican que los documentos con puntajes significativamente superiores al promedio son menos propensos a exhibir desviaciones temáticas, lo que se traduce en un menor grado de “query drift” y un mejor rendimiento de recuperación.

\
El método NQC se define matemáticamente como:

\
$ N Q C(q, M)= (sqrt(1/k sum_(d in D[k]_q)(S c o r e(d) - mu)^2))/(S c o r e(D)) $

\
En donde $q$ corresponde a la consulta, $M$ al modelo de recuperación, $D[k]_q$ a la lista de los k documentos mejor rankeados, μ al promedio de los puntajes de recuperación en $D[k]_q$ y $S c o r e[D]$ al puntaje de recuperación del corpus considerado como un único documento.

NQC resulta especialmente útil en el ámbito de la recuperación de información debido a su capacidad para capturar la consistencia en documentos relevantes y su adaptabilidad a diferentes modelos de recuperación, siendo su diseño simple lo que permite aplicarlo de manera eficiente, incluso en escenarios complejos donde se requiere alta precisión en los resultados.

Para el presente proyecto, NQC es relevante al proporcionar una métrica que permite evaluar la calidad de las consultas al correlacionar la dispersión de los puntajes con la efectividad esperada, lo que es fundamental para analizar consultas en dominios con alta variabilidad y establecer comparaciones confiables entre los diferentes métodos de predicción.

\
=== Clarity Score (CS)
\
El método Clarity Score (CS) fue desarrollado por Steve Cronen-Townsend, Yun Zhou y W. Bruce Croft como un predictor post-retrieval que analiza la claridad o coherencia de las consultas en sistemas de recuperación de información. En el artículo @predicting-performance, los autores explican que el CS se basa en la comparación entre un modelo de lenguaje generado a partir de una consulta y el modelo de lenguaje global del corpus, utilizando la divergencia de Kullback-Leibler como herramienta matemática que permite calcular la distancia entre ambos modelos. 

Este enfoque permite evaluar la calidad de las consultas antes de realizar una recuperación completa de documentos, lo que es particularmente útil para identificar consultas que podrían resultar problemáticas debido a su ambigüedad.

El cálculo del CS implica que consultas con términos más claros y específicos generarán modelos de lenguaje que se alinean mejor con el modelo del corpus, obteniendo puntajes más altos, estos términos, al estar menos expuestos a interpretraciones ambiguas, tienden a recuperar documentos más relevantes y precisos. Por otro lado, las consultas con puntajes más bajos suelen reflejar una mayor ambigüedad o dispersión temática, lo que puede afectar negativamente la precisión de los resultados recuperados.

Como se menciona, el CS se calcula como la divergencia de Kullback-Leibler entre el modelo de lenguaje de la consulta y el modelo de lenguaje de la colección:

\
$ C S(Q)= sum_(w in V)(P(w | Q)log 2(P(w | Q))/(P c o l l(w))) $

\
En donde $w$ es un término en el vocabulario $V, P(w | Q)$ es la probabilidad del término $w$ en el modelo de lenguaje de la consulta y $P c o l l(w)$ es la probabilidad del término $w$ en el modelo de lenguaje de la colección.

Es así que, en términos prácticos, el CS demuestra ser una herramienta eficaz para predecir el rendimiento de consultas en diversos dominios, desde búsquedas de texto hasta tareas más complejas como recuperación de información en grandes volúmenes de datos. Además, su capacidad para identificar consultas problemáticas antes de que se ejecute la búsqueda completa lo convierte en una solución eficiente y adaptable para optimizar los sistemas de recuperación de información.

Finalmente, en el contexto del presente proyecto, el Clarity Score es relevante por su capacidad para proporcionar un indicador temprano sobre la calidad de las consultas, permitiendo evaluar cómo estas interactúan con el corpus y qué tan bien pueden desempeñarse en términos de recuperación efectiva, resultando crucial en escenarios donde la variabilidad y complejidad de las consultas pueden influir significativamente en los resultados esperados.

\
=== WIG (Weighted Information Gain)
\
El método Weighted Information Gain (WIG) fue desarrollado por Yun Zhou y W. Bruce Croft como un predictor post-retrieval diseñado para abordar los desafíos de la predicción del rendimiento de consultas en entornos de búsqueda web. En el artículo @web-search-qpp, los autores destacan que WIG mide la contribución promedio de los documentos mejor clasificados a la calidad del rendimiento de la consulta, basándose en el análisis de las características individuales de los términos y su proximidad, lo que permite evaluar la efectividad de las consultas en colecciones grandes y heterogéneas.

El cálculo de WIG se realiza comparando el cambio en la información entre un estado inicial, representado por un documento promedio del corpus, y el estado posterior, que corresponde a los resultados obtenidos tras la recuperación de los documentos relevantes. Este enfoque utiliza conceptos como la ganancia de información ponderada y distribuciones de probabilidad para estimar la calidad de la consulta, lo que lo convierte en una herramienta robusta para analizar el desempeño en escenarios complejos.

En cuanto a su fórmula, WIG se define como la diferencia entre la entropía ponderada de los documentos mejor clasificados y la entropía del modelo de lenguaje de la colección, lo que es igual a:

$ W I G(Q)= 1/k sum_(d in D k)(P(Q | d)log (P(Q | d))/(P(Q | C))) $ <wig-equation>

En donde $Q$ es la consulta, $D k$ es el conjunto de los $k$ documentos mejor clasificados, $P(Q ∣ d)$ es la probabilidad de la consulta Q dado el documento d, y $P(Q ∣ C)$ es la probabilidad de la consulta Q dado el modelo de lenguaje de la colección.

Es así que, WIG es especialmente relevante debido a su capacidad para adaptarse a distintos tipos de consultas y colecciones, incluyendo aquellas con gran diversidad en calidad y estilo de los documentos, resultando crucial para evaluar la efectividad de las consultas, proporcionando una métrica sólida para comparar métodos avanzados de predicción del rendimiento y asegurando un análisis confiable en dominios variados.

\
=== UEF (Utility Estimation Framework)

\
El Utility Estimation Framework (UEF) fue desarrollado por Anna Shtok, Oren Kurland y David Carmel como un enfoque post-retrieval que utiliza principios de la teoría estadística de decisiones para predecir el rendimiento de consultas. En el artículo @statistical-decision-theory-uef los autores explican que este método evalúa la calidad de un ranking de documentos basándose en su utilidad estimada con respecto a la necesidad de información representada en la consulta, proceso que se realiza al medir la similitud esperada entre el ranking generado y los rankings incluidos por modelos de relevancia.

El marco UEF permite una gran flexibilidad al emplear diferentes métricas de similitud, como el coeficiente de Pearson, y al estimar modelos de relevancia utilizando pseudo-feedback, lo que proporciona una base sólida para predecir el rendimiento de consultas, ya que combina la precisión de los modelos de relevancia con un enfoque estructurado que captura las características del ranking generado por la consulta.
	
A continuación se observa la fórmula general del UEF:

$ U(pi_M (q;D))= integral_(R_q)S i m(pi_M (R_q ;D))p(R_q | I_q)d R_q $

\
En donde, $pi_M (q;D)$ corresponde al ranking generado por el modelo $M, R_q$ al modelo de relevancia estimado basado en la consulta $q, S i m$ es la medida de similitud entre ranking y $p(R_q ∣I q)$ a la probabilidad de que $R_q$ represente la necesidad de información subyacente $I q$.

El UEF es particularmente útil porque permite integrar diversos paradigmas de predicción, lo que mejora la adaptabilidad a diferentes dominios y tareas específicas, además, enfocarse en la utilidad de los documentos mejor clasificados, permite a este método ofrecer una perspectiva precisa sobre cómo las consultas interactúan con el corpus y qué tan efectivas podrían ser en términos de recuperación de información.

Es así que, finalmente, para este proyecto el UEF es fundamental para analizar y comparar la efectividad de diferentes métodos de predicción del rendimiento de consultas, en donde su diseño flexible y su capacidad para adaptarse a múltiples escenarios lo posicionan como una herramienta clave en la evaluación de consultas en dominios complejos y heterogéneos.

\
== Estudios comparativos similares
\
En cuanto a la investigación de trabajos relacionados, también se identificaron estudios comparativos que evaluaron diferentes métodos QPP en escenarios diversos, los cuales son claves para establecer un marco comparativo que permita validad los resultados finales de este proyecto, además estos trabajos no solo permiten identificar fortalezas y debilidades de cada enfoque, sino que también establecen líneas base estandarizadas para validad nuevos métodos y enfoques más experimentales.

A continuación, se presentan los estudios relevantes que evaluaron métodos QPP como IDF, SCQ, Clarity Score, entre otros, destacando sus aportes al estado del arte del área y su influencia en el diseño de este proyecto.

=== QPPTK en TIREx
\
Un reciente estudio relevante para el presente proyecto es el desarrollado por Zendel, Fröbe y Faggioli en 2024, que proporciona una referencia fundamental al implementar y evaluar un marco de predicción del rendimiento de consultas (QPP) utilizando el Query Performance Prediction Toolkit (QPPTK) dentro de la plataforma TIREx. En este trabajo @zendel2024qpptk, los autores analizaron el desempeño de 12 métodos de predicción en combinación con diversos modelos de recuperación de información y 23 conjuntos de datos, incluyendo benchmarks reconocidos como TREC Robust04 y MS MARCO, por lo que, la amplitud de la evaluación y su enfoque en la reproducibilidad de los experimentos lo convierten en un recurso valioso para este proyecto.

\
Como se menciona, el estudio incluye una evaluación exhaustiva de métodos pre-retrieval, como IDF y SCQ, y post-retrieval, como NQC y Clarity Score, además, se demuestra cómo la evaluación cruzada en múltiples benchmarks permite identificar patrones de rendimiento y validar la generalización de los métodos seleccionados, enfoque que se destaca por la importancia de utilizar plataformas estandarizadas, como TIREx, que no solo permiten configurar entornos experimentales reproducibles, sino que también minimizan los sesgos potenciales en los resultados al estandarizar la configuración y los parámetros de los experimentos.

\
Una de las contribuciones clave del trabajo es la integración de QPPTK en TIREx, lo que facilita la realización de experimentos reproducibles, lo que se logra mediante la utilización de índices preconstruidos y configuraciones consistentes que garantizan estabilidad en las pruebas. Así mismo, los resultados generados son compartidos abiertamente, promoviendo su reutilización en futuros estudios, enfoque que resulta relevante para este proyecto, donde la reproducibilidad y la estandarización son fundamentales para garantizar la validez de las comparaciones entre métodos.

\
Es así que, los hallazgos de los autores, proporcionan métricas clave, como correlaciones entre predictores y métricas clásicas de recuperación, esenciales para validar los métodos implementados en este proyecto, además, su metodología y diseño experimental sirven como referencia directa para configurar los experimentos, asegurando que las evaluaciones sigan estándares establecidos en la literatura.

\
En resumen, este estudio no solo se destaca por la profundidad de su análisis, sino también por su contribución al establecimiento de prácticas experimentales reproducibles, que es en donde radica su relevancia para el proyecto presentado, ya que propone un diseño experimental y proporciona un marco sólido para evaluar métodos de predicción del rendimiento de consultas en entornos complejos.

=== An Enhanced Evaluation Framework for Query Performance Prediction (2021)

\
Otro estudio destacado y relevante para el presente proyecto es el realizado por Guglielmo Faggioli et al. en 2021, quienes desarrollaron un marco de evaluación mejorado para la predicción del rendimiento de consultas (QPP), el cual aborda limitaciones clave de los enfoques tradicionales mediante la integración de análisis estadísticos avanzados y métricas diseñadas para evaluar, no solo la precisión, sino también la variabilidad y robustez de los métodos QPP en diferentes escenarios.

Es así que, en el artículo @enhanced-evaluation, los autores proponen un enfoque innovador que incluye métricas basadas en errores, análisis de varianza y pruebas post hoc para evaluar las diferencias entre métodos con mayor detalle.

Como se menciona, el artículo se destaca por su enfoque en la medición de errores distribuidos por consulta, lo que permite un análisis más granular del desempeño de los métodos, en donde se realizaron experimentos en conjuntos de datos estándar como TREC Robust-04, utilizando métodos pre-retrieval, como MaxIDF y SCQ, y post-retrieval, como NQC y Clarity Score, cuyos resultados revelaron que factores como el modelo de recuperación, la configuración y otros factores influyen significativamente en el rendimiento del QPP, proporcionando información valiosa para optimizar estos sistemas.

En el contexto del presente proyecto, el marco propuesto por los autores es importante, ya que introduce prácticas de evaluación reproducibles y detalladas, alineadas con estándares modernos, además de que, sus hallazgos sobre la interacción de factores experimentales y el rendimiento del QPP sirven como guía directa para configurar experimentos que sean estadísticamente sólidos y representativos en escenarios reales.


