#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= TRABAJOS RELACIONADOS <capitulo-3>
\

La predicción del rendimiento de consultas (QPP) es un área de investigación importante dentro de los sistemas de recuperación de información, puesto que permite anticipar la calidad de los resultados de una consulta sin necesariamente ejecutarla de forma completa. Es así, que a lo largo de los años se han desarrollado numerosos métodos QPP con diferentes características y aptos para distintas situaciones, los que han sido evaluados exhaustivamente en una larga cantidad de estudios. Estos estudios no solo han definido métricas y herramientas para medir la efectividad de los métodos QPP, sino que también han desarrollado análisis comparativos (_benchmarks_) que sirven como referencia en el estado del arte dentro del área.

A continuación, se revisan estudios relevantes relacionados con la predicción del rendimiento de consultas, presentando los principales métodos utilizados en la literatura, para posteriormente, analizar el uso de _datasets_ y entornos de experimentación para la comparación de métodos, destacando investigaciones previas que han servido como base para el diseño experimental de este trabajo de título.

#v(10pt)
== Métodos de Predicción de Rendimiento de Consultas (QPP)

\
En el contexto de este trabajo, se priorizó la revisión de métodos de _Query Performance Prediction_ que no dependen de enfoques basados en inteligencia artificial (IA), los cuales, clasificados como _pre-retrieval_ y _post-retrieval_, son altamente valorados por su simplicidad y robustez en la predicción del rendimiento de consulta sirviendo como base para métodos QPP más complejos.

Es así como, durante la revisión de la literatura, se identificaron trabajos claves que evaluaron y desarrollaron diferentes métodos QPP en diferentes contextos, como búsquedas _ad-hoc_ y _benchmarks_ de recuperación de información, proporcionando métricas importantes para evaluar la calidad de las consultas, los cuales se presentan a continuación.

#v(10pt)
=== IDF (Frecuencia Inversa de Documentos)

\
El predictor _Inverse Document Frequency_ (IDF), ampliamente utilizado en el área, puede de igual manera funcionar como predictor _pre-retrieval_ en sistemas de recuperación de información, este mide que tan específicos son los términos de una consulta dentro de un corpus. En el documento @preretrieval-idf, se profundiza su relevancia como un componente clave en la predicción del rendimiento de consultas (QPP), específicamente su capacidad para identificar términos altamente selectivos, es decir, aquellos que aparecen en pocos documentos (menos comunes) y, por ende, aportan mayor discriminación en la búsqueda. El IDF también puede ser utilizado en su variante IDF-Max, donde el término con la mayor frecuencia inversa dentro de una consulta sirve como indicador principal de su efectividad. Este indicador, que se basa en estadística, se adoptó rápidamente como una herramienta esencial en la predicción del rendimiento de consultas (QPP) _pre-retrieval_, siendo incorporada en otros esquemas y modelos probabilísticos de búsqueda. 

\
$ I D F(t) = ln(1 + N/f_t) $ <idf-equation>
\

Como se ve en la @eqt:idf-equation, $N$ es el número total de documentos en el _corpus_ y $f_t$ es el número de documentos que contienen el término $t$, y se añade 1 para evitar divisiones por cero o valores indefinidos.

En el artículo @idf-understanding, el autor señala que el IDF asigna pesos más bajos a los términos frecuentes debido a su limitado poder discriminatorio, mientras que otorga pesos más altos a los términos menos comunes, los cuales poseen mayor capacidad para distinguir documentos relevantes, asegurando que los términos poco frecuentes, pero informativos, tengan un mayor impacto en el cálculo de relevancia. Además, se destaca que, aunque la formulación exacta del algoritmo puede variar según los autores, su utilidad general permanece sólida en una amplia gama de aplicaciones prácticas, incluyendo la recuperación de información y otros contextos relacionados con el análisis de datos.

De esta forma, el IDF ha sido ampliamente utilizado debido a su robustez y simplicidad. En el artículo @idf-understanding, el autor argumenta que el IDF equilibra de forma eficaz la especificidad y la relevancia, permitiendo su aplicación en diferentes contextos, tales como recuperación de textos, análisis de lenguaje natural e incluso en recuperación de medios no textuales.

En cuanto a su relevancia para el presente trabajo de título de evaluación de métodos de QPP, el IDF resulta relevante, ya que su capacidad para capturar la especificidad de los términos yace de manera tacita en otros predictores QPP, además, como se menciona en el artículo @predicting-performance, su integración en distintas métricas proporciona una línea base confiable para la comparación con métodos más avanzados, validando su referencia tanto de forma heurística como de herramienta teórica sólida y bien fundamentada.

#v(10pt)
=== SCQ (Similitud entre consulta y colección)

\
El método _Similarity Between a Query and a Collection_ (SCQ) , es un predictor pre-retrieval propuesto por Ying Zhao, Falk Scholer y Yohannes Tsegay. En el artículo @preretrieval-idf los autores explican que el SCQ calcula un puntaje de similitud entre una consulta y la colección de documentos, utilizando la frecuencia de términos en la colección y la frecuencia inversa de documentos (IDF) como evidencias para determinar la relevancia. Siendo una de sus principales ventajas que se basa en estadísticas disponibles durante el proceso de indexado, eliminando la necesidad de realizar búsquedas previas.

\
$ S C Q = sum_(t in Q) ((1+ln(f_(c,t))) dot ln(1+N/f_(t)))  $ <scq-equation>
\

En la @eqt:scq-equation, podemos ver que $Q$ es el conjunto de términos de la consulta, $f_(c,t)$ corresponde a la frecuencia del término $t$ en la colección, $f_t$ es el número de documentos en los que aparece el término $t$, y finalmente $N$ es el número total de documentos de la colección.

Como se menciona, el SCQ mide la similitud mediante una representación vectorial, donde tanto las consultas como los documentos son tratados como vectores. La proximidad entre estos vectores se interpreta como un indicador de relevancia que permite identificar consultas que potencialmente obtendrán un mejor rendimiento en la recuperación de información. Además, este predictor puede ajustarse mediante la normalización por longitud de la consulta o evaluarse en  función del valor máximo de SCQ alcanzado por los términos individuales.

Es así como, gracias a su balance entre la simplicidad y precisión, el SCQ promete ser una herramienta útil para sistemas de recuperación de información que manejan grandes volúmenes de datos en tiempo real, en donde su capacidad para establecer relaciones entre las características de las consultas y su rendimiento lo convierte en una contribución importante para tareas que involucran una alta variabilidad en las consultas, posicionándose como un estándar en evaluaciones pre-retrieval.

Por lo tanto, para el presente trabajo de título, el SCQ es particularmente relevante porque permite analizar consultas en dominios complejos y heterogéneos, estableciendo una relación clara entre las características de las consultas y su rendimiento esperado, lo que facilita una evaluación comparativa de métodos.

#v(10pt)
=== NQC (Normalized Query Commitment)
\
El método _Normalized Query Commitment_ (NQC) fue propuesto por Anna Shtok, Oren Kurland y David Carmel como un predictor post-retrieval que evalúa la efectividad de una consulta midiendo la dispersión de los puntajes de recuperación entre los documentos más relevantes. En el artículo @query-drift, los autores destacan que una menor dispersión temática en los documentos recuperados está directamente asociada con una mayor efectividad de las consultas, lo cual se refleja en la distribución de los puntajes de recuperación.

Por lo tanto, el enfoque de NQC se centra en medir la desviación estándar de los puntajes de recuperación normalizados por el promedio del corpus, lo que permite identificar consultas cuyos documentos recuperados son consistentes en términos de relevancia, sugiriendo un buen desempeño de la consulta. Además, los documentos con puntajes significativamente superiores al promedio son menos propensos a exhibir desviaciones temáticas, lo que se traduce en un menor grado de _query drift_ y un mejor rendimiento de recuperación.

\
$ N Q C(q, M)= (sqrt(1/k sum_(d in D[k]_q)(S c o r e(d) - mu)^2))/(S c o r e(D)) $ <nqc-equation>
\

En la @eqt:nqc-equation, $q$ corresponde a la consulta, $M$ al modelo de recuperación, $D[k]_q$ a la lista de los k documentos mejor rankeados, μ al promedio de los puntajes de recuperación en $D[k]_q$ y $S c o r e[D]$ al puntaje de recuperación del corpus considerado como un único documento concatenado.

NQC resulta especialmente útil en el ámbito de la recuperación de información debido a su capacidad para capturar la consistencia en documentos relevantes y su adaptabilidad a diferentes modelos de recuperación, siendo su diseño simple lo que permite aplicarlo de manera eficiente, incluso en escenarios complejos donde se requiere alta precisión en los resultados.

Para el presente trabajo de título, NQC es relevante al proporcionar una métrica que permite evaluar la calidad de las consultas al correlacionar la dispersión de los puntajes con la efectividad esperada, lo que es fundamental para analizar consultas en dominios con alta variabilidad y establecer comparaciones confiables entre los diferentes métodos de predicción.

#v(10pt)
=== Clarity Score (CS)
\
El método _Clarity Score_ (CS) fue desarrollado por Steve Cronen-Townsend, Yun Zhou y W. Bruce Croft como un predictor _post-retrieval_ que analiza la claridad o coherencia de las consultas en sistemas de recuperación de información. En el artículo @predicting-performance, los autores explican que el CS se basa en la comparación entre un modelo de lenguaje generado a partir de una consulta y el modelo de lenguaje global del _corpus_, utilizando la divergencia de Kullback-Leibler como herramienta matemática que permite calcular la distancia entre ambos modelos. 

La lógica detrás de CS implica que consultas con términos más claros y específicos generarán modelos de lenguaje que se diferencian significativamente del modelo del corpus, obteniendo puntajes más altos. Estos términos, al estar menos expuestos a interpretaciones ambiguas, tienden a recuperar documentos más relevantes y precisos. Por otro lado, las consultas con puntajes más bajos suelen reflejar una mayor ambigüedad o dispersión temática, lo que puede afectar negativamente la precisión de los resultados recuperados.

El CS se calcula como la divergencia de Kullback-Leibler entre el modelo de lenguaje de la consulta y el modelo de lenguaje de la colección lo que se puede ver en la @eqt:csq-equation.

\
$ C S(Q)= sum_(w in V)(P(w | Q)log 2(P(w | Q))/(P c o l l(w))) $ <csq-equation>
\

En donde $w$ es un término en el vocabulario $V, P(w | Q)$ es la probabilidad del término $w$ en el modelo de lenguaje de la consulta y $P c o l l(w)$ es la probabilidad del término $w$ en el modelo de lenguaje de la colección.

En términos prácticos, el CS demuestra ser una herramienta valiosa en el campo de la Recuperación de Información por varias razones fundamentales. En primer lugar, su capacidad para cuantificar la claridad de una consulta a través de la divergencia KL proporciona una medida objetiva de la especificidad de los términos de búsqueda. Además, al basarse en la comparación con el modelo de lenguaje de la colección completa, el método captura efectivamente las peculiaridades y la distribución del vocabulario en el dominio específico. Sin embargo, es importante señalar que su efectividad puede variar según las características del corpus y la naturaleza de las consultas, siendo particularmente útil en colecciones donde la ambigüedad terminológica representa un desafío significativo para la recuperación de información.

Finalmente, en el contexto del presente trabajo de título, el _Clarity Score_ es relevante por su capacidad para proporcionar un indicador temprano sobre la calidad de las consultas, permitiendo evaluar cómo estas interactúan con el corpus y qué tan bien pueden desempeñarse en términos de recuperación efectiva, resultando crucial en escenarios donde la variabilidad y complejidad de las consultas pueden influir significativamente en los resultados esperados.

#v(10pt)
=== WIG (Weighted Information Gain)
\
El método _Weighted Information Gain_ (WIG) fue desarrollado por Yun Zhou y W. Bruce Croft como un predictor post-retrieval diseñado para abordar los desafíos de la predicción del rendimiento de consultas en entornos de búsqueda web. En el artículo @web-search-qpp, los autores destacan que WIG mide la contribución promedio de los documentos mejor clasificados a la calidad del rendimiento de la consulta, basándose en el análisis de las características individuales de los términos y su proximidad, lo que permite evaluar la efectividad de las consultas en colecciones grandes y heterogéneas.

El cálculo de WIG se realiza comparando el cambio en la información entre un estado inicial, representado por un documento promedio del _corpus_, y el estado posterior, que corresponde a los resultados obtenidos tras la recuperación de los documentos relevantes. Este enfoque utiliza conceptos como la ganancia de información ponderada y distribuciones de probabilidad para estimar la calidad de la consulta, lo que lo convierte en una herramienta robusta para analizar el desempeño en escenarios complejos.

En la @eqt:wig-equation, podemos ver que WIG se define como la diferencia entre la entropía ponderada de los documentos mejor clasificados y la entropía del modelo de lenguaje de la colección.

\
$ W I G(Q)= 1/k sum_(d in D k)(P(Q | d)log (P(Q | d))/(P(Q | C))) $ <wig-equation>
\

En donde $Q$ es la consulta, $D k$ es el conjunto de los $k$ documentos mejor clasificados, $P(Q ∣ d)$ es la probabilidad de la consulta Q dado el documento d, y $P(Q ∣ C)$ es la probabilidad de la consulta Q dado el modelo de lenguaje de la colección.

Es así que, WIG es especialmente relevante debido a su capacidad para adaptarse a distintos tipos de consultas y colecciones, incluyendo aquellas con gran diversidad en calidad y estilo de los documentos, resultando crucial para evaluar la efectividad de las consultas, proporcionando una métrica sólida para comparar métodos avanzados de predicción del rendimiento y asegurando un análisis confiable en dominios variados.

#v(10pt)
=== UEF (Utility Estimation Framework)
\
El _Utility Estimation Framework_ (UEF) fue desarrollado por Anna Shtok, Oren Kurland y David Carmel como un enfoque post-retrieval que utiliza principios de la teoría estadística de decisiones para predecir el rendimiento de consultas. En el artículo @statistical-decision-theory-uef los autores explican que este método evalúa la calidad de un ranking de documentos basándose en su utilidad estimada con respecto a la necesidad de información representada en la consulta, proceso que se realiza al medir la similitud esperada entre el ranking generado y los rankings inducidos por modelos de relevancia.

El marco UEF permite una gran flexibilidad al emplear diferentes métricas de similitud, como el coeficiente de correlación de Pearson, y al estimar modelos de relevancia utilizando _pseudo-relevance feedback_. Esta combinación proporciona una base teórica sólida para predecir el rendimiento de consultas, ya que integra la precisión de los modelos de relevancia con un enfoque estructurado que captura las características del ranking generado por la consulta.

\
$ U(pi_M (q;D))= integral_(R_q)S i m(pi_M (R_q ;D))p(R_q | I_q)d R_q $ <uef-equation>
\

En la @eqt:uef-equation, $pi_M (q;D)$ corresponde al ranking generado por el modelo $M, R_q$ al modelo de relevancia estimado basado en la consulta $q, S i m$ es la medida de similitud entre rankings y $p(R_q ∣I q)$ a la probabilidad de que $R_q$ represente la necesidad de información subyacente $I q$.

El UEF destaca por su fundamentación teórica en la teoría estadística de decisiones, lo que le permite estimar de manera robusta la utilidad esperada de un ranking. Su diseño matemático incorpora explícitamente la incertidumbre inherente en la estimación de relevancia a través de la distribución de probabilidad $p(R_q ∣I q)$, mientras que la función de similitud $S i m$ cuantifica la concordancia entre el ranking original y los rankings generados por los modelos de relevancia estimados.

Es así que el UEF representa un avance significativo en la predicción del rendimiento de consultas al proporcionar un marco teórico sólido que unifica diferentes aspectos de la recuperación de información. Su formulación matemática rigurosa, basada en principios estadísticos, permite una evaluación sistemática de la calidad de los rankings, considerando tanto la estructura de los resultados como la incertidumbre en la estimación de relevancia.

#v(10pt)
== Estudios comparativos similares
\
En cuanto a la investigación de trabajos relacionados, también se identificaron estudios comparativos que evaluaron diferentes métodos QPP en escenarios diversos, los cuales son claves para establecer un marco comparativo que permita validar los resultados finales de este trabajo, además estos trabajos no solo permiten identificar fortalezas y debilidades de cada enfoque, sino que también establecen líneas base estandarizadas para validar nuevos métodos y enfoques más experimentales.

A continuación, se presentan los estudios relevantes que evaluaron métodos QPP como IDF, SCQ, Clarity Score, entre otros, destacando sus aportes al estado del arte del área y su influencia en el diseño de este trabajo.

#v(10pt)
=== QPPTK en TIREx
\
Un reciente estudio relevante para el presente trabajo de título es el desarrollado por Zendel, Fröbe y Faggioli @zendel2024qpptk en 2024, que proporciona una referencia fundamental al implementar y evaluar un marco de predicción del rendimiento de consultas (QPP) utilizando el _Query Performance Prediction Toolkit_ (QPPTK) dentro de la plataforma TIREx. En este trabajo @zendel2024qpptk, los autores analizaron el desempeño de 12 métodos de predicción en combinación con diversos modelos de recuperación de información y 23 conjuntos de datos, incluyendo _benchmarks_ reconocidos como TREC Robust04 y MS MARCO, por lo que, la amplitud de la evaluación y su enfoque en la reproducibilidad de los experimentos lo convierten en un recurso valioso para este trabajo de título.

Como se menciona, el estudio incluye una evaluación exhaustiva de métodos _pre-retrieval_, como IDF y SCQ, y _post-retrieval_, como NQC y Clarity Score, además, se demuestra cómo la evaluación cruzada en múltiples _benchmarks_ permite identificar patrones de rendimiento y validar la generalización de los métodos seleccionados, enfoque que se destaca por la importancia de utilizar plataformas estandarizadas, como TIREx (_The Information Retrieval Experiment Platform_). Esta plataforma se define como una infraestructura diseñada para fomentar experimentos de recuperación de información que sean reproducibles, escalables y estandarizados mediante la integración de herramientas como _ir_datasets_ y _PyTerrier_, lo que no solo permite configurar entornos experimentales reproducibles, sino que también minimiza los sesgos potenciales en los resultados al estandarizar la configuración y los parámetros de los experimentos.

Una de las contribuciones clave del trabajo es la integración de una biblioteca que agrupa y estandariza las implementaciones de los distintos algoritmos de predición (QPPTK) en TIREx, lo que facilita la realización de experimentos reproducibles, lo que se logra mediante la utilización de índices preconstruidos y configuraciones consistentes que garantizan estabilidad en las pruebas. Así mismo, los resultados generados son compartidos abiertamente, promoviendo su reutilización en futuros estudios, enfoque que resulta relevante para este trabajo, donde la reproducibilidad y la estandarización son fundamentales para garantizar la validez de las comparaciones entre métodos.

Es así que, los hallazgos de los autores, proporcionan métricas clave, como correlaciones entre predictores y métricas clásicas de recuperación, esenciales para validar los métodos implementados en este trabajo, además, su metodología y diseño experimental sirven como referencia directa para configurar los experimentos, asegurando que las evaluaciones sigan estándares establecidos en la literatura.

En resumen, este estudio no solo se destaca por la profundidad de su análisis, sino también por su contribución al establecimiento de prácticas experimentales reproducibles, que es en donde radica su relevancia para el trabajo de título presentado, ya que propone un diseño experimental y proporciona un marco sólido para evaluar métodos de predicción del rendimiento de consultas en entornos complejos.

#v(10pt)
=== _An Enhanced Evaluation Framework for Query Performance Prediction_ (2021)

\
Otro estudio destacado y relevante para el presente trabajo de título es el realizado por Guglielmo Faggioli et al. @enhanced-evaluation en 2021, quienes desarrollaron un marco de evaluación mejorado para la predicción del rendimiento de consultas (QPP), el cual aborda limitaciones clave de los enfoques tradicionales mediante la integración de análisis estadísticos avanzados y métricas diseñadas para evaluar, no solo la precisión, sino también la variabilidad y robustez de los métodos QPP en diferentes escenarios. Este marco supera las limitaciones de las evaluaciones basadas únicamente en correlaciones, como la dificultad para interpretar valores agregados únicos y la incapacidad para identificar consultas específicas donde los métodos fallan.

Es así que, en el artículo @enhanced-evaluation, los autores proponen un enfoque innovador que incluye métricas basadas en errores, como el _Scaled Absolute Rank Error_ (SARE) y el _Scaled Mean Absolute Rank Error_ (sMARE), las cuales permiten medir el error de predicción de manera distribuida por consulta. Además, incorporan técnicas estadísticas avanzadas, como el análisis de varianza (ANOVA) y pruebas _post hoc_ para evaluar las diferencias entre métodos con mayor detalle. Estas herramientas permiten no solo comparar la precisión de los predictores, sino también analizar la influencia de factores como el tema de la consulta, el método de recuperación y la configuración de _stemming_ en el rendimiento del QPP.

Como se menciona, el artículo se destaca por su enfoque en la medición de errores distribuidos por consulta, lo que permite un análisis más granular del desempeño de los métodos, en donde se realizaron experimentos en conjuntos de datos estándar como TREC Robust-04, utilizando métodos _pre-retrieval_, como MaxIDF y SCQ, y _post-retrieval_, como NQC y Clarity Score, cuyos resultados revelaron que factores como el modelo de recuperación, la configuración de _stemming_ y _stoplists_, y la naturaleza de las consultas influyen significativamente en el rendimiento del QPP. Por ejemplo, se observó que los métodos _post-retrieval_, como NQC y Clarity, tienden a tener una correlación más alta con la precisión promedio (AP), mientras que los métodos _pre-retrieval_, como MaxIDF, pueden ser más robustos en ciertos escenarios. Estos hallazgos proporcionan información valiosa para optimizar estos sistemas y seleccionar el método más adecuado según la situación.

En el contexto del presente trabajo de título, el marco propuesto por los autores es importante, ya que introduce prácticas de evaluación reproducibles y detalladas, alineadas con estándares modernos, además de que, sus hallazgos sobre la interacción de factores experimentales y el rendimiento del QPP sirven como guía directa para configurar experimentos que sean estadísticamente sólidos y representativos en escenarios reales. Por ejemplo, el uso de ANOVA y pruebas _post hoc_ permite identificar no solo qué métodos son superiores en general, sino también en qué condiciones específicas (como ciertos tipos de consultas o configuraciones) un método puede ser mejor que otro, lo que es particularmente útil en aplicaciones prácticas donde la variabilidad de las consultas y los documentos es alta, como en motores de búsqueda web y sistemas de recomendación.

En resumen, el trabajo de los autores, no solo proporciona un marco metodológico avanzado para la evaluación de QPP, sino que también ofrece _insights_ prácticos sobre cómo optimizar estos sistemas en función de factores contextuales, lo que lo convierte en una referencia clave para el presente trabajo de título, especialmente en la fase de diseño experimental y evaluación de métodos de predicción de rendimiento de consultas.



