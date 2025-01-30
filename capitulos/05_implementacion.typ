#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}

#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *

= IMPLEMENTACIÓN

\
Para iniciar la implementación del entorno de evaluación se precisa de una serie de componentes para realizar tanto el procesado de consultas como el manejo de documentos que respondan y tengan relevancia ante estas. Tradicionalmente esto se ha realizado mediante el uso de sistemas de recuperación de información (IR) que permiten la recuperación de documentos relevantes para una consulta de manera eficiente.

Sin embargo, y debido a la antiguedad del campo, existe una amplia gama de metodos que varian en su grado de complejidad y en su rendimiento, por ende, se opto implementar un sistema de recuperación de información basado en el algoritmo BM25, que es un algoritmo de recuperación de información que se basa en la teoría de la probabilidad, el cual cuenta con un amplio historial, no solo en el campo de la recuperación de información, sino que tambien en la evaluación de métodos de rendimiento de consultas (QPP).

Adicionalmente, y de manera separada se encuentra la necesidad de implementar un sistema de indexación de documentos, que permita la recuperación de documentos relevantes para una consulta de manera eficiente. Estos dos ultimos prerequisitos, justifican la utilización de la libreria Pyterrier, la cual permite la implementación de sistemas de recuperación de información y de indexación de documentos, en un solo entorno unificado e integrado. 

En la se puede observar el diagrama de componentes general del entorno de evaluación propuesto, en el cual se puede apreciar la interacción entre los distintos componentes de recuperación de información clasicos como el BM25, indexación de documentos, procesamiento de consultas y evaluación de métodos de QPP. Es relevante resaltar que el acceso a los conjuntos de datos tambien es realizado mediante la libreria pyTerrier, la cual cuenta con una integración con otra libreria, IR-datasets, la cual permite el acceso a una amplia gama de conjuntos de datos clasicos de recuperación de información junto a sus consultas y respectivos juicios de relevancia.

En si, el protocolo estandar de evaluación de métodos de QPP, como se puede apreciar en la, cuenta de una relativa complejidad, con muchas partes sujetas a modificaciones y ajustes que pueden repercutir en los resultados finales de la evaluación.

\
== Configuración del entorno experimental

\
El entorno experimental se encuentra configurado para ser ejecutado en un variedad de entornos debido a la utilización de Docker, el cual permite la ejecución de entornos virtuales en diferentes sistemas operativos. De manera general y para preservar la reproducibilidad de los resultados, se ha configurado el entorno experimental para ser ejecutado en un sistema operativo Linux, utilizando Python 3.9.21 y PyTerrier 0.13.0.

#figure(
  table(
    columns: (0.6fr, 1.2fr, 1fr),
    rows: (auto, auto, auto, auto),
    inset:10pt,
    stroke: (x: none),
    align: left + horizon,

    [*Componente*], [*Descripción*], [*Versión*],

    [*Docker*], [Contenedor de entornos virtuales], [25.0.5],
    [*Python*], [Lenguaje de programación], [3.9.21],
    [*PyTerrier*], [Libreria de recuperación de información], [0.13.0],
    [*IR-datasets*], [Libreria de conjuntos de datos], [0.5.9],
  ),
  caption: "Configuración del entorno experimental",
) <configuracion>

\
Como se puede apreciar en la @tbl:configuracion, se ha optado por implementar el entorno experimental en componentes de software con versiones especificas y estables, esperando lograr la mayor reproducibilidad posible de los resultados. La ejecución tambien es posible en sistemas operativos Windows y MacOS, pero estas cuentan con procesos de instalación y configuración mas complejos.

\
=== Docker y dependencias
\
Docker es la principal herramienta que permite la ejecución del entorno experimental, esta cuenta con una amplia gama de herramientas que permiten la ejecución de entornos virtuales en diferentes sistemas operativos. Para los propositos de este trabajo, se ha optado por imagenes de docker basados en la versión Slim Buster de Debian, la cual destaca en su ligereza y velocidad de ejecución.

#figure(
  kind:image,
  [
    #codly(languages: codly-languages)
    ```Dockerfile
    # Imagen Debian optimizada para Python
    FROM python:3.9-slim-buster

    # Configuraciones de entorno
    ENV LANG=C.UTF-8
    ENV LC_ALL=C.UTF-8
    ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    ENV PATH="$JAVA_HOME/bin:$PATH"

    # Instalación de Java y otras dependencias
    RUN apt-get update && \
        apt-get install -y openjdk-11-jdk && \
        apt-get install -y --no-install-recommends \
        build-essential \
        && apt-get clean && \
        rm -rf /var/lib/apt/lists/*
    ...
    ```
  ],
  caption: "Dockerfile para la configuración del entorno experimental",
) <dockerfile>

\
La @fig:dockerfile muestra el archivo Docker utilizado para la configuración del entorno experimental, este Dockerfile se encuentra disponible en el repositorio de GitHub del proyecto. En este se especifican las principales dependencies y configuraciones de entorno necesarias para la ejecución del entorno experimental. 

#figure(
  table(
    columns: (auto, 1fr),
    rows: auto,
    stroke: (x: none),
    inset:10pt,
    align: left + horizon,
    
    [*Componente*], [*Descripción*],
    
    [*Imagen base*], [Python 3.9 slim-buster - Versión ligera de Debian optimizada para Python],
    
    [*Configuración UTF-8*], [Establece codificación UTF-8 para el manejo correcto de caracteres especiales y términos en diferentes idiomas presentes en los datasets],
    
    [*JDK 11*], [Java Development Kit necesario para PyTerrier, ya que este utiliza componentes Java para el procesamiento e indexación de documentos],
    
    [*Build essentials*], [Herramientas básicas de compilación necesarias para algunas dependencias de Python],
    
  ),
  caption: "Componentes principales del Dockerfile",
) <tabla_docker>

La @tbl:tabla_docker muestra los componentes esenciales para la configuración y ejecución del entorno experimental. Diversos errores fueron enfrentados debido a la codificación de caracteres durante las primeras pruebas del entorno, especialmente al procesar términos con caracteres especiales o diacríticos presentes en los datasets. La configuración explícita de UTF-8 en el contenedor Docker resultó fundamental para asegurar el correcto procesamiento de los documentos y consultas, evitando problemas de codificación que podrían afectar la calidad de la indexación y, por ende, los resultados de la evaluación.

\
=== Integración de conjuntos de datos
Como se explico anteriormente, los conjuntos de datos utilizados en este trabajo se encuentran disponibles en la libreria IR-datasets, la cual cuenta con una amplia gama de conjuntos de datos tanto clasicos como modernos de recuperación de información junto a sus consultas y respectivos juicios de relevancia.

Cada dataset cuenta con una cantidad de documentos y consultas disponibles para realizar la evaluación, por otro lado los juicios de relevancia o Qrels suponen un desafio extra para la implementación de la evaluación, puesto que cada dataset cuenta con distintos niveles de relevancia para las consultas, lo cual si no se maneja adecuadamente puede alterar drasticamente los resultados de la correlación.

Esto es asi puesto a que la evaluación clasica de metodos IR se basa en el calculo de metricas como nDCG, AP, MAP, etc, las cuales dependen de los juicios de relevancia actuando como _ground truth_ para su calculo.

#figure(
  kind:image,
  [
    #codly(languages: codly-languages)
    ```python
DATASET_FORMATS = {
    "antique_test": {
        "relevance_levels": {
            1: "Out of context/nonsensical",
            2: "Not relevant but on topic",
            3: "Marginally relevant",
            4: "Highly relevant"
        },
        "binary_threshold": 3,  # Puntajes >= 3 son considerados relevantes para las metricas binarias
        "gain_values": {  # Valores de ganancia para nDCG
            1: 0.0,
            2: 0.0,
            3: 0.5,
            4: 1.0
        }
    }
    ```
  ],
  caption: "Configuración de formato de dataset",
) <codigo_formato_dataset>

La @fig:codigo_formato_dataset muestra la configuración específica para el dataset antique_test, donde se definen cuatro niveles de relevancia (1-4) con sus respectivas descripciones semánticas. Esta configuración es importante por dos razones principales: primero, establece un umbral binario en 3 para las métricas que requieren juicios binarios (como Precision y Recall), considerando como relevantes solo los documentos con puntuaciones de 3 o 4. Segundo, define valores de ganancia específicos para el cálculo de nDCG, donde se asigna diferentes valores de ganancia en cada nivel.

Esta diferenciación en el manejo de los niveles de relevancia es fundamental para obtener evaluaciones precisas, ya que un manejo inadecuado de estos valores podría llevar a distorsiones significativas en el cálculo de las métricas de evaluación y, consecuentemente, afectar la correlación con los predictores QPP. Por ejemplo, si no se estableciera el umbral binario adecuadamente o se asignaran valores de ganancia incorrectos, documentos marginalmente relevantes podrían tener el mismo peso que documentos altamente relevantes en el cálculo de las métricas, lo que no reflejaría fielmente la calidad real de los resultados de búsqueda.

\
=== Indexación y consultas
El proceso de indexación utilizado para la evaluación es el estandar de PyTerrier mediante la construcción de un indice invertido a partir de un corpus de documentos. Este indice invertido es utilizado para la recuperación de documentos relevantes para una consulta, utilizando el algoritmo BM25. Durante el tiempo de indexado, se realiza la tokenización de los documentos y consultas, aplicando un algoritmo de stemming y eliminación de stopwords para la normalización de los datos.

\
== Implementación de métodos QPP

\
La implementación de los métodos QPP difiere en las dos categorías en la que se dividen los metodos, pre-retrieval y post-retrieval, el primer caso solo cuenta con una dependencia para su implementación, la cual es el indice invertido generado a partir de un corpus de documentos. Mientras que en el segundo caso, cuenta con dos, el indice invertido generado a partir de un corpus de documentos y los resultados de un sistema de recuperación de información en respuesta a una consulta.

#figure(
  kind:image,
  [
    #codly(languages: codly-languages)
    ```python
    # Creación del factory de métodos QPP
    qpp_factory = QPPMethodFactory(
        index_builder=index_builder,
        retrieval_results=retrieval_results,
        rm_results=rm_results_df,
        dataset_name=dataset_path
    )
    
    # Computo de los puntajes de los métodos QPP
    qpp_scores = qpp_factory.compute_all_scores(
        queries=queries,
        list_size_param=args.list_size
    )
    ```
  ],
  caption: "Código de implementación del factory de métodos QPP",
) <codigo_factory>

#figure(image("../assets/imagenes/codeviz-diagram-2025-01-09T20-47-14-Copy of System Diagram.drawio.png"), caption: "Diagrama de la capa de métodos QPP")<diagrama-capa-qpp>

Para cumplir con los requisitos de los métodos QPP, se ha implementado un factory, el cual se encarga de la creación y computo de los puntajes de los métodos QPP. Este factory se encarga de tomar las dependencias necesarias y entregarlas a los métodos QPP, para que estos puedan ser computados.

Para la implementación de los métodos QPP, se ha utilizado un enfoque mixto, tanto utilizando codigo abierto como propio, para la satisfacer las necesidades de la evaluación a realizar. Todo el codigo utilizado se encuentra disponible en el repositorio de GitHub de este trabajo, el cual se puede encontrar en el repositorio #footnote[https://github.com/Zendelo/QPP-EnhancedEval/tree/qpptk-dev] de el usuario Zendelo en GitHub.
\
=== Métodos pre-retrieval
En esta categoria se implementaron dos de los métodos más utilizados en las evaluaciones de la lituratura, por un lado se encuentra el método IDF, el cual se basa en la frecuencia de los términos en los documentos, y por otro lado se encuentra el método SCQ, el cual se basa en la similitud de la consulta a los documentos de la colección.

Ambos metodos cuentan con variaciones, ya sea el valor promedio de los términos de la consulta, o alternativamente el valor maximo de los términos de la consulta. Estás variaciones son utilizadas en diferentes evaluaciones y se ha optado por implementar ambas en el entorno experimental.


\
=== Métodos post-retrieval
En esta categoria se considuro una mayor gama de predictores, desde metodos seminales del campo como Clarity, hasta frameworks mas recientes como UEF. Estos metodos requieren de una dependencia extra, la cual es el resultado de un sistema de recuperación de información en respuesta a una consulta.

#figure(
  kind:image,
  [
    #codly(languages: codly-languages)
    ```python
        def calc_wig(self, list_size_param):
        """
        Calculates the WIG score following Zhou and Croft's method.
        Y. Zhou and W. B. Croft. Query performance prediction in web search environments
        """
        scores_vec = self.scores_vec[:list_size_param]
        if self.corpus_score == 0:
            print("Corpus score is zero; returning WIG score as 0.0 to avoid division by zero.")
            return 0.0
        wig_score = (scores_vec.mean() - self.ql_corpus_score) / np.sqrt(len(self.query_terms))
        return wig_score
    ```
  ],
  caption: "Implementación del método WIG",
) <codigo_wig>

La @fig:codigo_wig muestra la implementación del método post-retrieval WIG, en este podemos identificar tanto el uso del indice invertido como el resultado de el puntaje del modelo de recuperación de información frente a toda la colección como se puede apreciar en la @eqt:wig-equation. 
Adicionalmente se puede observar parametros como el tamaño de la lista de documentos a considerar, el cual fue definido como 10 para WIG y en 100 para NQC bajo la recomendación de la literatura. @web-search-qpp @wig-nqc-scored-configuration @query-drift Para finalizar, tambien cabe mencionar que todas los puntajes fueron considerando el puntaje promedio de los 1000 primeros documentos de la lista de resultados.


\
== Implementación de la evaluación
\
La implementación de la evaluación de los métodos QPP se realiza mediante un analizador de correlaciones que permite calcular y visualizar las relaciones entre los puntajes de predicción y las métricas de rendimiento real del sistema. Este analizador está diseñado para procesar los resultados de múltiples métodos QPP y métricas de recuperación, generando análisis estadísticos y visualizaciones que facilitan la interpretación de los resultados.

=== Cálculo de correlaciones
El análisis se basa principalmente en el cálculo de coeficientes de correlación entre los puntajes QPP y las métricas de recuperación (nDCG y AP). Se implementaron tres tipos de correlaciones:

- Correlación de Pearson: Mide la relación lineal entre las variables
- Correlación de Spearman: Evalúa la relación monótona entre variables usando rangos
- Correlación de Kendall (τ): Mide la ordinalidad entre pares de observaciones

La significancia estadística de las correlaciones se verifica mediante pruebas de hipótesis, considerando un nivel de significancia de α = 0.05. Las correlaciones no significativas son registradas pero marcadas apropiadamente en los reportes.

=== Visualización de resultados
Para facilitar la interpretación de los resultados, se implementaron tres tipos principales de visualizaciones como se puede observar en la @tbl:tabla_visualizaciones, siguiendo la linea de otras evaluaciones. @zendel2024qpptk @correlation-depends-on-quality-of-dataset @enhanced-evaluation

#figure(
  table(
    columns: (auto, 1fr),
    rows: auto,
    stroke: (x: none),
    align: left + horizon,
    
    [*Tipo de gráfico*], [*Descripción*],
    
    [*Mapas de calor*], [Muestran la matriz de correlaciones entre todos los métodos QPP y las métricas de evaluación, utilizando una escala de colores para representar la fuerza y dirección de las correlaciones],
    
    [*Diagramas de dispersión*], [Visualizan la relación entre cada método QPP y una métrica específica, incluyendo líneas de regresión para mejor interpretación],
    
    [*Diagramas de caja*], [Presentan la distribución de las correlaciones para cada método QPP, permitiendo comparar su estabilidad y rendimiento general],
  ),
  caption: "Tipos de visualizaciones implementadas",
) <tabla_visualizaciones>

\
== Pruebas de validación
\