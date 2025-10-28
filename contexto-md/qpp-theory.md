### Introducción a la Predicción del Rendimiento de Consultas

La gran diversidad en el rendimiento entre consultas, así como entre sistemas, dio lugar a una nueva dirección de investigación denominada **predicción del rendimiento de consultas (QPP)** o **estimación de la dificultad de la consulta (QDE)**. El desafío es predecir de antemano la calidad de los resultados de búsqueda para una consulta dada, recuperados por un sistema de recuperación determinado, cuando no se dispone de información de relevancia proporcionada por un operador humano. Dicha predicción del rendimiento permitirá a los sistemas de RI (Recuperación de Información) atender mejor las consultas "difíciles" y disminuir la variabilidad en el rendimiento.

### Estimación de la Dificultad de la Consulta

La alta variabilidad en el rendimiento de las consultas, así como los *robust tracks* del TREC, han impulsado una nueva dirección de investigación en el campo de la RI sobre la estimación de la calidad de los resultados de búsqueda, es decir, la dificultad de la consulta, cuando no se proporciona retroalimentación de relevancia. Estimar la dificultad de la consulta es un intento de cuantificar la calidad de los resultados devueltos por un sistema dado para la consulta. Un ejemplo de tal medida de calidad es la precisión media (AP) de la consulta.

Estimar la dificultad de la consulta es un desafío significativo debido a los numerosos factores que impactan el rendimiento de la recuperación. Como ya se ha mencionado, hay factores relacionados con la expresión de la consulta (p. ej., ambigüedad), con el conjunto de datos (p. ej., heterogeneidad) y con el método de recuperación. Además, mientras que la investigación en RI tradicionalmente se centra en evaluar la relevancia de cada documento para una consulta de forma independiente de los demás documentos, los nuevos enfoques de predicción del rendimiento intentan evaluar la calidad de toda la lista de resultados para la consulta. Esta complejidad supone una carga para la tarea de predicción en comparación con la tarea de recuperación y exige nuevos métodos de predicción que sean capaces de manejar este desafiante problema.

La noción de dificultad de la consulta suele estar relacionada con una consulta específica que se envía a un método de recuperación concreto mientras se busca en una colección específica. Sin embargo, el rendimiento de la consulta puede variar entre diferentes métodos de recuperación. Del mismo modo, el rendimiento de la consulta depende de la colección en la que se busca. Por lo tanto, la "generalidad" de la dificultad de una consulta depende de si esta será considerada difícil por cualquier método de recuperación, sobre cualquier conjunto de datos. Esta generalidad se mide generalmente promediando el rendimiento predicho de la consulta de varios métodos de recuperación sobre varias colecciones.

### La Tarea de Predicción

Dada la consulta *q* y la lista de resultados *Dq*, la tarea de predicción consiste en estimar la calidad de la recuperación de *Dq* para satisfacer *Iq*, la necesidad de información detrás de *q*. En otras palabras, la tarea de predicción es predecir AP(*q*) cuando no se proporciona información de relevancia (*Rq*).

El predictor de rendimiento puede describirse como un procedimiento que recibe la consulta *q*, la lista de resultados *Dq* y la colección completa *D* y devuelve una predicción de la calidad de *Dq* para satisfacer *Iq*, es decir, la precisión media esperada (AP) para *q*:

AP(q) ← µ(q, Dq, D).

La calidad de un predictor de rendimiento µ puede medirse sobre los mismos benchmarks que se utilizan para la estimación de la calidad de la recuperación. Una alta correlación entre los valores de predicción de rendimiento para un conjunto dado de consultas, con sus valores de precisión reales, refleja la capacidad de µ para predecir con éxito el rendimiento de la consulta. La calidad de la predicción se mide por la correlación entre la precisión media predicha, AP(*q*), y la precisión media real, AP(*q*), sobre un conjunto de consultas de prueba Q = {q1... qn}:

Calidad(µ) = correl ([AP(q1) . . . AP(qn)], [AP(q1) ... AP(qn)]).

### Robustez de la Predicción

La medición de la correlación entre el rendimiento real (AP) y el rendimiento predicho (AP) para un conjunto de consultas de prueba, como indicación de la calidad de la predicción, se ajusta principalmente a un escenario de un solo sistema cuando deseamos estimar la calidad de la predicción de un predictor de rendimiento dado. Esta estimación permite la comparación entre diferentes métodos de predicción cuando se aplican por el mismo sistema de recuperación sobre un conjunto fijo de consultas de prueba y sobre un conjunto de datos fijo. Sin embargo, la calidad de la predicción depende en gran medida del método de recuperación, ya que la variable objetivo (la AP real) depende del enfoque de recuperación específico.

### Métodos de Predicción del Rendimiento de Consultas

Los enfoques de predicción existentes se clasifican a grandes rasgos en métodos **pre-recuperación** y métodos **post-recuperación**. Los enfoques pre-recuperación predicen la calidad de los resultados de búsqueda antes de que se realice la búsqueda, por lo que solo la consulta en bruto y las estadísticas de los términos de la consulta recopiladas en el momento de la indexación pueden ser explotadas para la predicción. En contraste, los métodos post-recuperación pueden analizar adicionalmente los resultados de la búsqueda.

### Combinación de Predictores

#### Regresión Lineal

Un posible enfoque para la combinación de predicciones utiliza la regresión lineal basada en datos de entrenamiento. Dado un conjunto de *n* consultas de entrenamiento, cada una asociada con un AP conocido, y un vector de *p* valores predichos dados por diferentes predictores, podemos aprender un vector de pesos β que asocia un peso relativo para cada predictor basado en su contribución relativa a la predicción combinada. Un modelo de regresión lineal asume que la relación entre AP(*q*) y el *p*-vector de predicciones *xi* es aproximadamente lineal. Así, el modelo toma la forma de *n* ecuaciones lineales, para las *n* consultas de entrenamiento:

AP(qi) = xiβ + εi, i = 1, . . . , n

donde *xiβ* es el producto interno entre los vectores *xi* y *β*, y *εi* es una variable aleatoria no observada, normalmente distribuida, que añade ruido a la relación lineal.

#### Combinación de Predictores Basada en la Teoría de Decisión Estadística

El marco **UEF (utility-estimation-framework)** se inspira en el marco de minimización de riesgos. En UEF, la lista clasificada de resultados, *Dq*, podría verse como una decisión tomada por el método de recuperación en respuesta a una consulta, *q*, para satisfacer la necesidad de información oculta del usuario, *Iq*. La efectividad de la recuperación de *Dq* refleja la utilidad proporcionada al usuario por el sistema, denotada por U(Dq|Iq).

Por lo tanto, la tarea de predicción en este marco se interpreta como la predicción de la utilidad que el usuario puede obtener de la lista de resultados recuperada *Dq*. Podemos usar la lista clasificada de máxima utilidad para estimar la utilidad de la lista clasificada dada, basándonos en su "similitud".

U(Dq|Iq) ≈ Sim(Dq, π(Dq, RIq)). (6.1)

En la práctica, no tenemos un conocimiento explícito de la necesidad de información subyacente, excepto por la información en *q*. Por lo tanto, usamos estimaciones que se basan en la información en *q* y en el corpus. Usando los principios de la teoría de decisión estadística, podemos aproximar la Ecuación 6.1 por la similitud esperada entre la clasificación dada y las clasificaciones inducidas por estimaciones para RIq:

U(Dq|Iq) ≈ ∫ Sim(π(Dq, Rˆq), Dq)Pr(Rˆq|Iq)dRˆq. (6.2)

donde Rˆq es una estimación del modelo de relevancia "verdadero" RIq.

### Un Modelo General para la Dificultad de la Consulta

Se sugiere un modelo general alternativo para la dificultad de la consulta en el que el objeto principal del modelo es un **Tópico**. Un tópico es la información pertinente a un tema definido. El tópico comprende dos objetos: un conjunto de consultas, *Q*, y un conjunto de documentos relevantes, *R*. El tópico también depende de la colección de documentos específica, *C*, de la cual se elige *R*. Así, un tópico se denota como:

Tópico = (Q, R|C) (7.1)

Para cada tópico, es importante medir cuán amplio es el tópico y cuán bien está separado de la colección. Planteamos la hipótesis de que una gran distancia entre *Q* y *R* se traduce en un tópico difícil, mientras que una distancia pequeña da como resultado un tópico fácil. Las diferentes distancias entre sus elementos son:
1.  **d(Q, C)** - La distancia entre las consultas, *Q*, y la colección, *C*.
2.  **d(Q, Q)** - La distancia entre las consultas, es decir, el diámetro del conjunto *Q*.
3.  **d(R, C)** - La distancia entre los documentos relevantes, *R*, y la colección, *C*.
4.  **d(R, R)** - La distancia entre los documentos relevantes, es decir, el diámetro del conjunto *R*.
5.  **d(Q, R)** - La distancia entre las consultas, *Q*, y los documentos relevantes, *R*.