#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}

#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *

= IMPLEMENTACIÓN

\
La implementación del entorno de evaluación representa la materialización del diseño experimental previamente descrito. Este capítulo detalla los aspectos técnicos y prácticos del desarrollo, abordando desde la configuración del entorno hasta la implementación específica de cada componente del sistema.

El desarrollo se fundamenta en tres pilares principales: el sistema de recuperación de información, la implementación de los métodos QPP, y el framework de evaluación. Como se puede observar en la @tbl:tabla-componentes, cada uno de estos componentes requiere consideraciones técnicas específicas y se integran para formar un sistema cohesivo y reproducible.

#figure(
  table(
    columns: (auto, 1fr),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*Componente*], [*Consideraciones principales*],
    
    [Sistema de recuperación], [
      - Implementación de BM25 como algoritmo base
      - Indexación eficiente de documentos
      - Procesamiento de consultas
    ],
    
    [Métodos QPP], [
      - Implementación de predictores pre y post-retrieval
      - Manejo de dependencias entre componentes
      - Cálculo eficiente de estadísticas
    ],
    
    [Framework de evaluación], [
      - Procesamiento de juicios de relevancia
      - Cálculo de métricas de evaluación
      - Análisis de correlaciones
      - Generación de visualizaciones
    ],
  ),
  caption: "Componentes principales del sistema implementado",
) <tabla-componentes>

La implementación se realizó priorizando la modularidad y la reproducibilidad, utilizando herramientas y bibliotecas ampliamente reconocidas en el campo de la recuperación de información. El sistema se desarrolló completamente en Python, aprovechando un conjunto de bibliotecas especializadas cuyas funciones principales se detallan en la @tbl:tabla-tecnologias. Estas herramientas fueron seleccionadas por su madurez, documentación y amplia adopción en la comunidad de recuperación de información.

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*Aspecto*], [*Herramienta/Biblioteca*], [*Propósito*],
    
    [Recuperación], [PyTerrier], [Indexación y búsqueda de documentos],
    [Datasets], [ir_datasets], [Acceso a colecciones estándar],
    [Evaluación], [ir_measures], [Cálculo de métricas IR],
    [Estadísticas], [scipy, numpy], [Análisis de correlaciones],
    [Visualización], [matplotlib, seaborn], [Generación de gráficos],
  ),
  caption: "Stack tecnológico principal",
) <tabla-tecnologias>

A continuación, se detallan los aspectos específicos de la implementación, comenzando con la configuración del entorno experimental y continuando con la implementación de cada componente del sistema.

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
    [*PyTerrier*], [Librería de recuperación de información], [0.13.0 más snapshot para el soporte de modelos de relevancia],
    [*IR-datasets*], [Librería de conjuntos de datos], [0.5.9],
  ),
  caption: "Configuración del entorno experimental",
) <configuracion>

\
Como se puede apreciar en la @tbl:configuracion, se ha optado por implementar el entorno experimental en componentes de software con versiones especificas y estables, esperando lograr la mayor reproducibilidad posible de los resultados. La ejecución también es posible en sistemas operativos Windows y MacOS, pero estas cuentan con procesos de instalación y configuración mas complejos.

\
=== Docker y dependencias
\
Docker es la principal herramienta que permite la ejecución del entorno experimental, esta cuenta con una amplia gama de herramientas que permiten la ejecución de entornos virtuales en diferentes sistemas operativos. Para los propósitos de este trabajo, se ha optado por imágenes de docker basados en la versión Slim Buster de Debian, la cual destaca en su ligereza y velocidad de ejecución.

\
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

\
#figure(
  table(
    columns: (auto, 1fr),
    rows: auto,
    stroke: (x: none),
    inset:10pt,
    align: left + horizon,
    
    [*Componente*], [*Descripción*],
    
    [*Imagen base*], [Python 3.9 slim-buster - Versión ligera de Debian optimizada para Python],
    
    [*Configuración UTF-8*], [Establece codificación UTF-8 para el manejo correcto de caracteres especiales y términos en diferentes idiomas presentes en los datasets, esto en la practica es necesario para evitar errores de procesamiento de tokens.],
    
    [*JDK 11*], [Java Development Kit necesario para PyTerrier, ya que este utiliza componentes Java para el procesamiento e indexación de documentos],
    
    [*Build essentials*], [Herramientas básicas de compilación necesarias para algunas dependencias de Python],
    
  ),
  caption: "Componentes principales del Dockerfile",
) <tabla_docker>

\
La @tbl:tabla_docker muestra los componentes esenciales para la configuración y ejecución del entorno experimental. Diversos errores fueron enfrentados debido a la codificación de caracteres durante las primeras pruebas del entorno, especialmente al procesar términos con caracteres especiales o diacríticos presentes en los datasets. La configuración explícita de UTF-8 en el contenedor Docker resultó fundamental para asegurar el correcto procesamiento de los documentos y consultas, evitando problemas de codificación que podrían afectar la calidad de la indexación y, por ende, los resultados de la evaluación.

\
=== Integración de conjuntos de datos
\
Como se explico anteriormente, los conjuntos de datos utilizados en este trabajo se encuentran disponibles en la librería IR-datasets, la cual cuenta con una amplia gama de conjuntos de datos tanto clásicos como modernos de recuperación de información junto a sus consultas y respectivos juicios de relevancia.

Cada dataset cuenta con una cantidad de documentos y consultas disponibles para realizar la evaluación, por otro lado los juicios de relevancia o ‟Qrels” suponen un desafío extra para la implementación de la evaluación, puesto que cada dataset cuenta con distintos niveles de relevancia para las consultas, lo cual si no se maneja adecuadamente puede alterar drásticamente los resultados de la correlación.

Esto es asi puesto a que la evaluación clásica de métodos IR se basa en el calculo de métricas como nDCG, AP, MAP, etc, las cuales dependen de los juicios de relevancia actuando como _ground truth_ para su calculo.

\
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
        "binary_threshold": 3,  # Puntajes >= 3 son considerados relevantes para las métricas binarias
        "gain_values": {  # Valores de ganancia para nDCG
            1: 0,
            2: 1,
            3: 2,
            4: 3
        }
    }
    ```
  ],
  caption: "Configuración de formato de dataset",
) <codigo_formato_dataset>

\
La @fig:codigo_formato_dataset muestra la configuración específica para el dataset antique_test, donde se definen cuatro niveles de relevancia (1-4) con sus respectivas descripciones semánticas. Esta configuración es importante por dos razones principales: primero, establece un umbral binario en 3 para las métricas que requieren juicios binarios (como Precision y Recall), considerando como relevantes solo los documentos con puntuaciones de 3 o 4. Segundo, define valores de ganancia específicos para el cálculo de nDCG, donde se asigna diferentes valores de ganancia en cada nivel.

Esta diferenciación en el manejo de los niveles de relevancia es fundamental para obtener evaluaciones precisas, ya que un manejo inadecuado de estos valores podría llevar a distorsiones significativas en el cálculo de las métricas de evaluación y, consecuentemente, afectar la correlación con los predictores QPP. Por ejemplo, si no se estableciera el umbral binario adecuadamente o se asignaran valores de ganancia incorrectos, documentos marginalmente relevantes podrían tener el mismo peso que documentos altamente relevantes en el cálculo de las métricas, lo que no reflejaría fielmente la calidad real de los resultados de búsqueda.

\
=== Indexación y consultas

\
El proceso de indexación utilizado para la evaluación es el estándar de PyTerrier mediante la construcción de un índice invertido a partir de un corpus de documentos. Este índice invertido es utilizado para la recuperación de documentos relevantes para una consulta, utilizando el algoritmo BM25. Durante el tiempo de indexado, se realiza la tokenización de los documentos y consultas, aplicando un algoritmo de stemming y eliminación de ‟stopwords‟ para la normalización de los datos.

\
== Implementación de métodos QPP

\
La implementación de los métodos QPP difiere en las dos categorías en la que se dividen los ‟métodos‟, pre-retrieval y post-retrieval, el primer caso solo cuenta con una dependencia para su implementación, la cual es el índice invertido generado a partir de un corpus de documentos. Mientras que en el segundo caso, cuenta con dos, el índice invertido generado a partir de un corpus de documentos y los resultados de un sistema de recuperación de información en respuesta a una consulta.

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

Para la implementación de los métodos QPP, se ha utilizado un enfoque mixto, tanto utilizando código abierto como propio, para la satisfacer las necesidades de la evaluación a realizar. Todo el código utilizado se encuentra disponible en el repositorio de GitHub de este trabajo, el cual se puede encontrar en el repositorio #footnote[https://github.com/Zendelo/QPP-EnhancedEval/tree/qpptk-dev] de el usuario *Zendelo* en GitHub.

\
=== Métodos pre-retrieval

\
En esta categoría se implementaron dos de los métodos más utilizados en las evaluaciones de la literatura, por un lado se encuentra el método IDF, el cual se basa en la frecuencia de los términos en los documentos, y por otro lado se encuentra el método SCQ, el cual se basa en la similitud de la consulta a los documentos de la colección.

Ambos métodos cuentan con variaciones, ya sea el valor promedio de los términos de la consulta, o alternativamente el valor máximo de los términos de la consulta. Estás variaciones son utilizadas en diferentes evaluaciones y se ha optado por implementar ambas en el entorno experimental.


\
=== Métodos post-retrieval

\
En esta categoría se considero una mayor gama de predictores, desde métodos seminales del campo como Clarity, hasta frameworks mas recientes como UEF. Estos métodos requieren de una dependencia extra, la cual es el resultado de un sistema de recuperación de información en respuesta a una consulta.

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
Adicionalmente se puede observar parámetros como el tamaño de la lista de documentos a considerar, el cual fue definido como 5 para WIG y en 200 para NQC bajo la recomendación de la literatura y nuestros propios experimentos. @web-search-qpp @wig-nqc-scored-configuration @query-drift Para finalizar, también cabe mencionar que todas los puntajes fueron considerando el puntaje promedio de los 1000 primeros documentos de la lista de resultados.


\
== Implementación de la evaluación
\
La implementación de la evaluación de los métodos QPP se realiza mediante un analizador de correlaciones que permite calcular y visualizar las relaciones entre los puntajes de predicción y las métricas de rendimiento real del sistema. Este analizador está diseñado para procesar los resultados de múltiples métodos QPP y métricas de recuperación, generando análisis estadísticos y visualizaciones que facilitan la interpretación de los resultados.

=== Cálculo de correlaciones

\
El análisis se basa principalmente en el cálculo de coeficientes de correlación entre los puntajes QPP y las métricas de recuperación (nDCG y AP). Se implementaron tres tipos de correlaciones:

- Correlación de Pearson: Mide la relación lineal entre las variables
- Correlación de Spearman: Evalúa la relación monótona entre variables usando rangos
- Correlación de Kendall (τ): Mide la ordinalidad entre pares de observaciones

La significancia estadística de las correlaciones se verifica mediante pruebas de hipótesis, considerando un nivel de significancia de $α <= 0.05$. Las correlaciones no significativas son registradas pero marcadas apropiadamente en los reportes.

\
=== Visualización de resultados

\
Para facilitar la interpretación de los resultados, se implementaron tres tipos principales de visualizaciones como se puede observar en la @tbl:tabla_visualizaciones, siguiendo la linea de otras evaluaciones. @zendel2024qpptk @correlation-depends-on-quality-of-dataset @enhanced-evaluation

\
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

La validación exhaustiva del sistema implementado se realizó mediante una suite completa de pruebas unitarias, diseñada para verificar el correcto funcionamiento de cada componente del entorno de evaluación. Se desarrolló un framework de pruebas automatizado que permite la ejecución sistemática de casos de prueba y la generación de informes detallados.

\
=== Estructura de las pruebas
\

Las pruebas unitarias se organizaron en siete módulos principales, cada uno enfocado en un componente específico del sistema:

\
#figure(
  table(
    columns: (auto, 1fr),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*Módulo de prueba*], [*Aspectos evaluados*],
    
    [QPPCorrelationAnalyzer], [Análisis de correlaciones, generación de visualizaciones y reportes estadísticos],
    [Evaluator], [Cálculo de métricas de evaluación (nDCG, AP)],
    [Clarity], [Implementación del predictor Clarity, incluyendo cálculos de KL-divergence],
    [NQC], [Funcionalidad del predictor NQC y cálculos de scores normalizados],
    [WIG], [Implementación del predictor WIG y procesamiento de scores],
    [IDF], [Cálculos de IDF y variantes de agregación],
    [SCQ], [Implementación del predictor SCQ y manejo de términos],
  ),
  caption: "Módulos principales de pruebas unitarias",
) <tabla-modulos-prueba>

\

=== Metodología de validación

\
La validación se realizó mediante un enfoque sistemático que incluye:

- *Pruebas de casos límite*: Verificación del comportamiento del sistema ante consultas vacías, términos desconocidos y valores extremos.
- *Validación de consistencia*: Comprobación de la coherencia en el procesamiento de términos y el stemming.
- *Pruebas de integración*: Verificación de la correcta interacción entre componentes, especialmente en el análisis de correlaciones.
- *Validación de métricas*: Comprobación de cálculos de nDCG y AP contra valores conocidos.

\
=== Resultados de la validación

\
La ejecución completa de la suite de pruebas, que comprende 50 casos de prueba distribuidos entre los diferentes módulos, demostró la robustez del sistema implementado. Como se evidencia en los resultados:

- Tasa de éxito del 100% en todos los módulos de prueba
- Tiempo total de ejecución de 11.27 segundos
- Cobertura completa de todos los componentes críticos del sistema

\
#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*Componente*], [*Pruebas ejecutadas*], [*Tiempo de ejecución (s)*],
    
    [QPPCorrelationAnalyzer], [10], [8.25],
    [Evaluator], [6], [0.05],
    [Clarity], [8], [0.03],
    [NQC], [6], [0.01],
    [WIG], [7], [0.01],
    [IDF], [7], [0.01],
    [SCQ], [6], [0.01],
  ),
  caption: "Resultados de ejecución por componente",
) <tabla-resultados-pruebas>
\

La validación exhaustiva realizada confirma la fiabilidad y precisión del entorno de evaluación implementado, proporcionando una base sólida para los experimentos subsiguientes. El sistema demostró ser robusto ante diversos escenarios de prueba, manteniendo la consistencia en el procesamiento de consultas y el cálculo de métricas de evaluación.