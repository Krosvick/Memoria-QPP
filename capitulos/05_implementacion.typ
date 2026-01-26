#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}

#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *

= IMPLEMENTACIÓN

\
La implementación del entorno de evaluación representa la materialización del diseño experimental previamente descrito. Este Capítulo detalla los aspectos técnicos y prácticos del desarrollo, abordando desde la configuración del entorno hasta la implementación específica de cada componente del sistema.

El desarrollo se fundamenta en tres pilares principales: el sistema de recuperación de información, la implementación de los métodos QPP, y el framework de evaluación. Como se puede observar en la @tbl:tabla-componentes, cada uno de estos componentes requiere consideraciones técnicas específicas, como el manejo consistente del vocabulario y la optimización de cálculos estadísticos, integrándose para formar un sistema cohesivo y reproducible.

\
#show figure: set block(breakable: true)
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
  caption: "Componentes principales del sistema implementado.",
) <tabla-componentes>
\

La implementación se realizó priorizando la modularidad y la reproducibilidad, utilizando herramientas y bibliotecas ampliamente reconocidas en el campo de la recuperación de información. El sistema se desarrolló completamente en Python, aprovechando un conjunto de bibliotecas especializadas cuyas funciones principales se detallan en la @tbl:tabla-tecnologias. Estas herramientas fueron seleccionadas por su madurez, documentación y amplia adopción en la comunidad de recuperación de información.

\
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
  caption: "Stack tecnológico principal.",
) <tabla-tecnologias>
\

A continuación, se detallan los aspectos específicos de la implementación, comenzando con la configuración del entorno experimental y continuando con la implementación de cada componente del sistema.

#v(10pt)
== Configuración del entorno experimental
\
El entorno experimental se encuentra configurado para ser ejecutado en una variedad de entornos debido a la utilización de Docker, el cual permite la ejecución de entornos virtuales en diferentes sistemas operativos. De manera general y para preservar la reproducibilidad de los resultados, se ha configurado el entorno experimental para ser ejecutado en un sistema operativo Linux, utilizando Python 3.9.21 y PyTerrier 0.13.0.

\
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
  caption: "Configuración del entorno experimental.",
) <configuracion>
\

Como se puede apreciar en la @tbl:configuracion, se ha optado por implementar el entorno experimental en componentes de software con versiones específicas y estables, esperando lograr la mayor reproducibilidad posible de los resultados. La ejecución también es posible en sistemas operativos Windows y MacOS, pero estas cuentan con procesos de instalación y configuración más complejos.

#v(10pt)
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
  caption: "Dockerfile para la configuración del entorno experimental.",
) <dockerfile>
\

La @fig:dockerfile muestra el archivo Docker utilizado para la configuración del entorno experimental, este Dockerfile se encuentra disponible en el repositorio de GitHub del proyecto. En este se especifican las principales dependencias y configuraciones de entorno necesarias para la ejecución del entorno experimental. 

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
    
    [*Configuración UTF-8*], [Establece codificación UTF-8 para el manejo correcto de caracteres especiales y términos en diferentes idiomas presentes en los datasets, esto en la práctica es necesario para evitar errores de procesamiento de tokens.],
    
    [*JDK 11*], [Java Development Kit necesario para PyTerrier, ya que este utiliza componentes Java para el procesamiento e indexación de documentos],
    
    [*Build essentials*], [Herramientas básicas de compilación necesarias para algunas dependencias de Python],
    
  ),
  caption: "Componentes principales del Dockerfile.",
) <tabla_docker>
\

La @tbl:tabla_docker muestra los componentes esenciales para la configuración y ejecución del entorno experimental. Diversos errores fueron enfrentados debido a la codificación de caracteres durante las primeras pruebas del entorno, especialmente al procesar términos con caracteres especiales o diacríticos presentes en los datasets. La configuración explícita de UTF-8 en el contenedor Docker resultó fundamental para asegurar el correcto procesamiento de los documentos y consultas, evitando problemas de codificación que podrían afectar la calidad de la indexación y, por ende, los resultados de la evaluación.

#v(10pt)
=== Integración de conjuntos de datos
\

Como se explicó anteriormente, los conjuntos de datos utilizados en este trabajo se encuentran disponibles en la librería IR-datasets, la cual cuenta con una amplia gama de conjuntos de datos tanto clásicos como modernos de recuperación de información junto a sus consultas y respectivos juicios de relevancia.

Cada dataset cuenta con una cantidad de documentos y consultas disponibles para realizar la evaluación, por otro lado, los juicios de relevancia suponen un desafío extra para la implementación de la evaluación, puesto que cada dataset cuenta con distintos niveles de relevancia para las consultas, si estos no se manejan adecuadamente puede alterar drásticamente los resultados de la correlación.

Esto es así puesto a que la evaluación clásica de métodos IR se basa en el cálculo de métricas como nDCG, AP, etc, las cuales dependen de los juicios de relevancia actuando como _ground truth_ para su cálculo.

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
  caption: "Configuración de formato de dataset.",
) <codigo_formato_dataset>
\

La @fig:codigo_formato_dataset muestra la configuración específica para el dataset antique_test, donde se definen cuatro niveles de relevancia (1-4) con sus respectivas descripciones semánticas. Esta configuración es importante por dos razones principales: primero, establece un umbral binario en 3 para las métricas que requieren juicios binarios (como Precision y Recall), considerando como relevantes solo los documentos con puntuaciones de 3 o 4. Segundo, define valores de ganancia específicos para el cálculo de nDCG, donde se asigna diferentes valores de ganancia en cada nivel.

Esta diferenciación en el manejo de los niveles de relevancia es fundamental para obtener evaluaciones precisas, ya que un manejo inadecuado de estos valores podría llevar a distorsiones significativas en el cálculo de las métricas de evaluación y, consecuentemente, afectar la correlación con los predictores QPP. Por ejemplo, si no se estableciera el umbral binario adecuadamente o se asignaran valores de ganancia incorrectos, documentos marginalmente relevantes podrían tener el mismo peso que documentos altamente relevantes en el cálculo de las métricas, lo que no reflejaría fielmente la calidad real de los resultados de búsqueda.

#v(10pt)
=== Preprocesamiento, indexación y consultas

\
El proceso de indexación constituye la base sobre la cual operan tanto el sistema de recuperación como los predictores QPP. En esta implementación, se optó por una estrategia de indexación personalizada en lugar de utilizar el pipeline por defecto de PyTerrier. Específicamente, los documentos son pre-procesados utilizando un pipeline unificado basado en la librería NLTK antes de ser ingestados por el indexador integrado de la librería.

Este pipeline de preprocesamiento aplica tokenización, eliminación de _stopwords_ y _stemming_ (utilizando el famoso _SnowballStemmer_) de manera consistente tanto para los documentos como para las consultas. La justificación técnica de esta decisión radica en la necesidad de garantizar una correspondencia exacta entre el vocabulario del índice y los términos generados durante el procesamiento de las consultas lo cual sucede en dos capas distintas dentro del flujo del sistema. 

Durante el desarrollo se observó que el tokenizador por defecto de Terrier presentaba inconsistencias significativas en el manejo de ciertos tipos de términos. Este comportamiento se manifestaba especialmente en secuencias numéricas: términos como "0", "00" y "000" eran indexados como tokens distintos por Terrier, mientras que el pipeline de preprocesamiento basado en NLTK/Snowball los unificaba o eliminaba según su configuración de stopwords. Esta discrepancia causaba un desajuste de vocabulario (_vocabulary mismatch_), donde términos presentes en la consulta procesada en Python no encontraban correspondencia en el índice de Terrier, resultando en frecuencias de documento igual a cero. A su vez, esto generaba puntajes nulos o incorrectos en predictores sensibles como IDF y SCQ. Al indexar el texto ya procesado por el mismo pipeline que las consultas, se elimina esta fuente de error y se asegura la coherencia del vocabulario.

Para cuantificar el impacto de esta discrepancia, se realizó un análisis comparativo de los vocabularios generados por ambos pipelines de tokenización sobre el dataset Antique/test, que comprende 403.666 documentos. Los resultados, presentados en la @tbl:tabla-discrepancia-vocab, revelan diferencias estadísticamente significativas entre ambos enfoques de tokenización.

\
#figure(
  table(
    columns: (1fr, auto, auto),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*Métrica*], [*NLTK (Snowball)*], [*PyTerrier*],
    
    [Términos únicos], [238.298], [218.336],
    [Ocurrencias totales], [8.200.515], [7.295.979],
    
    table.hline(stroke: 0.5pt),
    table.cell(colspan: 3)[*Distribución del vocabulario combinado (Total de 254.530 términos)*],
    
    [Términos compartidos], table.cell(colspan: 2)[202.104 (79.4%)],
    [Términos exclusivos], [36.194 (14.2%)], [16.232 (6.4%)],
  ),
  caption: "Comparación de vocabularios entre tokenizadores.",
) <tabla-discrepancia-vocab>
\

El análisis revela un overlap de vocabulario del 79.4% entre ambos tokenizadores. El 14.2% de términos exclusivos de NLTK corresponde principalmente a secuencias numéricas largas que el stemmer preserva de forma individual, mientras que el 6.4% exclusivo de PyTerrier se compone de concatenaciones de tokens (como "001html" o "10degr") que no fueron separadas correctamente durante el preprocesamiento. Esta discrepancia del 20.6% en el vocabulario total impacta directamente en la capacidad del sistema para procesar consultas, como se cuantifica en la @tbl:tabla-cobertura-queries.

#pagebreak()
#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*Métrica de cobertura*], [*NLTK (Snowball)*], [*PyTerrier*],
    
    [Cobertura de términos en consultas], [*98.98%* (873/882)], [88.44% (780/882)],
    [Queries con términos OOV], [9], [102],
    [Tasa OOV en predictores], [0.69%], [11.56%],
  ),
  caption: "Impacto en la cobertura de consultas.",
) <tabla-cobertura-queries>
\

La diferencia en cobertura de terminos en las consultas fue determinante para la elección del pipeline: NLTK/Snowball alcanza una cobertura del 98.98% de los términos presentes en las consultas, PyTerrier solo cubre el 88.44%. Esta brecha de 10.54 puntos porcentuales significa que, utilizando el tokenizador por defecto de Terrier, un 11.56% de los términos de las consultas no encontrarían correspondencia en el índice, generando valores OOV (_out of vocabulary_) que distorsionan los cálculos de los predictores. En el caso de IDF y SCQ, se identificaron 6 de las 200 queries afectadas por términos problemáticos, incluyendo errores ortográficos ("inspeciton"), nombres propios ("murrieta") y concatenaciones accidentales ("june3"). Estos hallazgos fundamentan la decisión de adoptar un pipeline de preprocesamiento unificado basado en Snowball, garantizando así la coherencia del vocabulario entre el índice y las consultas.

Adicionalmente, para optimizar el rendimiento de los predictores pre-retrieval, se implementó mecanismos de caché estadísticos, el cual pre-calcula y almacena en un archivo JSON las estadísticas globales más consultadas, como la frecuencia de colección (_Collection Frequency_, CF) y la frecuencia de documentos (_Document Frequency_, DF) para cada término. Esta estrategia evita la sobrecarga computacional que implicaría realizar múltiples consultas JNI (_Java Native Interface_) al índice de Terrier o escaneos completos del índice para obtener estadísticas básicas repetitivas, reduciendo significativamente el tiempo de ejecución de los experimentos, especialmente en datasets grandes como MS MARCO.

#v(10pt)
== Implementación de métodos QPP

\
La implementación de los métodos QPP difiere en las dos categorías en la que se dividen los ‟métodos‟, pre-retrieval y post-retrieval, el primer caso solo cuenta con una dependencia para su implementación, la cual es el índice invertido generado a partir de un corpus de documentos. Mientras que, en el segundo caso, cuenta con dos, el índice invertido generado a partir de un corpus de documentos y los resultados de un sistema de recuperación de información en respuesta a una consulta.

\
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
  caption: "Código de implementación del factory de métodos QPP.",
) <codigo_factory>
\

\
#figure(
  pad(
    x: -2cm,
    image(
      "../assets/imagenes/codeviz-diagram-2025-01-09T20-47-14-Copy of System Diagram.drawio.png", 
      width: 100%
    )
  ),
  caption: "Diagrama de la capa de métodos QPP."
)<diagrama-capa-qpp>
\

Para cumplir con los requisitos de los métodos QPP, se ha implementado un factory, el cual se encarga de la creación y computo de los puntajes de los métodos QPP. Este factory se encarga de tomar las dependencias necesarias y entregarlas a los métodos QPP, para que estos puedan ser computados.

Para la implementación de los métodos QPP, se ha utilizado como base código abierto pero con mejoras y modificaciones propias para satisfacer las necesidades de la evaluación a realizar. Todo el código externo utilizado se encuentra disponible en el repositorio de _GitHub_ de _QPP-EnhancedEval_. #footnote[https://github.com/Zendelo/QPP-EnhancedEval/tree/qpptk-dev]

#v(10pt)
=== Métodos pre-retrieval

\
En esta categoría se implementaron dos de los métodos más utilizados en las evaluaciones de la literatura: IDF y SCQ. Si bien conceptualmente son sencillos, su implementación robusta requirió abordar desafíos específicos relacionados con el manejo de términos.

Para el método IDF (Inverse Document Frequency), se implementó un manejo riguroso de términos para asegurar la estabilidad del predictor. Estas modificaciones no son triviales, sino que surgieron tras iteraciones experimentales donde se observó que la implementación estándar producía correlaciones artificialmente bajas (cercanas a cero) debido a inestabilidad numérica.

En primer lugar, se implementó una distinción explícita para los términos fuera del vocabulario (OOV). A diferencia de enfoques que simplemente asignan un valor nulo, esta implementación asigna un valor centinela de frecuencia de documento igual a -1 a los términos que no existen en absoluto en el índice. El beneficio crítico de este manejo es prevenir que la presencia de un solo término desconocido (por ejemplo, un error tipográfico) invalide el puntaje de toda una consulta al propagar valores nulos o indefinidos, permitiendo que el sistema degrade suavemente su estimación basándose únicamente en los términos conocidos.

En segundo lugar, se incorporó la técnica de suavizado Laplaciano (_add-1 smoothing_) en el cálculo del predictor IDF. Esta técnica consiste en simular que cada término del vocabulario ha sido observado una vez más de lo que realmente aparece en la colección.

\
$ P_("smooth")(w) = ("count"(w) + 1) / (N + V) $ <formula_suavizado>
\

En la @eqt:formula_suavizado $"count"(w)$ es la frecuencia del término $w$, $N$ es el total de tokens y $V$ el tamaño del vocabulario. La justificación técnica para aplicar este suavizado en QPP es debido a que aporta estabilidad numérica al evitar divisiones por cero e indefiniciones logarítmicas (como $log(0)$) que invalidarían el cálculo para términos extremadamente raros @laplacian-smoothing.

Por otro lado, la implementación de SCQ (_Collection Query Similarity_) se benefició directamente de la optimización de caché estadística mencionada en la sección de indexación. Dado que SCQ requiere consultar intensivamente las frecuencias CF y DF para cada término de la consulta, el acceso directo a las estadísticas pre-calculadas permite calcular la similitud consulta-colección de manera eficiente. Se implementaron variantes del método que agregan los puntajes de los términos utilizando tanto la suma como el máximo (_max_scq_), permitiendo evaluar qué estrategia de agregación captura mejor la dificultad de la consulta.

#v(10pt)
=== Métodos post-retrieval

\
En esta categoría se consideró una gama más amplia de predictores, abarcando desde métodos basados en divergencia como Clarity, hasta frameworks basados en utilidad como UEF. La implementación de estos métodos implica una complejidad mayor, ya que requieren interactuar tanto con el índice invertido como con la lista de resultados recuperada.

Un aspecto crítico en la implementación del Clarity Score fue el suavizado del modelo de lenguaje de la colección. Para estimar la probabilidad $P(w|C)$ de un término en la colección, se utilizó suavizado de Dirichlet con un parámetro $mu=1000$. Esta decisión no solo responde a una necesidad de estabilidad numérica, sino que es fundamental para la robustez de los modelos de lenguaje en Recuperación de Información, especialmente en función de la naturaleza de la colección procesada.

En el contexto de colecciones pequeñas o constituidas por documentos breves, como pasajes, snippets (fragmentos de texto cortos que resumen el contenido de un documento en la lista de resultados) o el propio dataset Cranfield utilizado, la frecuencia de términos (_term frequency_) es intrínsecamente escasa. Sin un mecanismo de suavizado, los modelos de lenguaje derivados resultantes serían extremadamente ruidosos y estarían sesgados hacia los pocos términos observados, provocando que la divergencia KL diverja artificialmente debido a probabilidades nulas o a picos de frecuencia no representativos. En este contexto, la técnica de suavizado de Dirichlet es una herramienta útil que reduce la varianza de la estimación, evita la sobreestimación de términos raros y estabiliza el modelo de la consulta. Esto permitiría que el puntaje de Clarity correlacione efectivamente con la dificultad real de la consulta y no con el ruido estadístico inherente a la escasez de datos.

\
#figure(
  kind:image,
  [
    #codly(languages: codly-languages)
    ```python
  def _get_collection_probabilities(self, terms: Iterable[str]) -> Dict[str, float]:
        """
        Calcula P(w|C) (modelo de lenguaje) con suavización de Dirichlet.
        Fórmula: (cf + mu * p0) / (total_terms + mu), con p0 uniforme.
        """
        total_terms = max(1, self.index_stats['total_terms'])
        mu = self.mu_bg
        p0 = self._uniform_prior

        probs = {}
        for term in terms:
            cf = float(self.index_stats['term_cf'].get(term, 0))
            
            # SIN SUAVIZADO:
            # prob = cf / total_terms
            # En colecciones pequeñas, esta estimación de máxima verosimilitudes altamente sensible a eventos raros y a términos no observados.
            # En particular, cf = 0 induce prob = 0, lo que vuelve inestable el cálculo de divergencias (p. ej., KL).

            # CON SUAVIZADO:
            # Se incorporan 'mu' observaciones virtuales distribuidas según 'p0',
            # lo que reduce la varianza de la estimación y mejora la estabilidad del modelo de lenguaje.
            probs[term] = (cf + mu * p0) / (total_terms + mu)
        return probs
    ```
  ],
  caption: "Implementación del suavizado de Dirichlet en Clarity.",
) <codigo_clarity_dirichlet>
\

Por otra parte, en colecciones masivas o con documentos extensos (como artículos de noticias o páginas web completas), donde las frecuencias de términos son más altas y estadísticamente fiables, el modelo empírico tiende a converger con la distribución real del lenguaje. Si bien el suavizado sigue aportando estabilidad, su impacto relativo es menor. En estos casos, un parámetro $mu$ excesivamente alto podría resultar contraproducente, ya que diluiría la especificidad del documento al acercar su modelo demasiado a la distribución uniforme de la colección, disminuyendo artificialmente el puntaje de Clarity. Dado que esta investigación opera sobre colecciones de tamaño controlado y características específicas, la elección de un $mu$ entre 500 y 1000 resulta un buen equilibrio para asegurar la validez de las predicciones @smoothing-factors.

Para el método UEF (Utility Estimation Framework), la implementación se centró en la robustez del cálculo de correlación. UEF estima la dificultad correlacionando los puntajes de recuperación originales con los obtenidos tras una expansión de consulta (en este caso, utilizando el modelo RM3). Para asegurar la validez de esta correlación, se implementó un alineamiento estricto de las listas de resultados basado en identificadores de documento (`docno`), asegurando que la comparación se realice sobre la intersección de documentos recuperados en ambas etapas. Además, se normalizan los puntajes antes del cálculo de correlación para mitigar diferencias de escala entre las pasadas de recuperación.

Finalmente, para NQC (_Normalized Query Commitment_) y WIG, se incorporaron mecanismos de manejo de excepciones para casos de varianza cero. En situaciones donde todos los documentos recuperados tienen el mismo puntaje (lo cual puede ocurrir con consultas muy cortas o en colecciones con pocos documentos relevantes), la desviación estándar se anula, lo que podría causar errores de división. La implementación detecta estos casos y asigna un puntaje de dificultad predefinido, garantizando la continuidad de la evaluación sin interrupciones.

\
#figure(
  kind:image,
  [
    #codly(languages: codly-languages)
    ```python
        def calc_wig(self, list_size_param):
        """
        Calcula el WIG score siguiendo el método de Zhou y Croft.
        Y. Zhou and W. B. Croft. Query performance prediction in web search environments
        """
        scores_vec = self.scores_vec[:list_size_param]
        if self.corpus_score == 0:
            print("El puntaje del corpus es cero; retornando WIG score como 0.0 para evitar división por cero.")
            return 0.0
        wig_score = (scores_vec.mean() - self.corpus_score) / np.sqrt(len(self.query_terms))
        return wig_score
    ```
  ],
  caption: "Implementación del método WIG.",
) <codigo_wig>
\

La @fig:codigo_wig muestra la implementación del método post-retrieval WIG, en este podemos identificar tanto el uso del indice invertido (_scores_vec_) como el resultado de el puntaje del modelo de recuperación de información frente a toda la colección (_corpus_score_) como se puede apreciar en la @eqt:wig-equation. 
Adicionalmente se puede observar parámetros como el tamaño de la lista de documentos a considerar, el cual fue definido como 5 para WIG y en 200 para NQC bajo la recomendación de la literatura y nuestros propios experimentos @web-search-qpp @wig-nqc-scored-configuration @query-drift. Para finalizar, también cabe mencionar que todas los puntajes fueron considerando el puntaje promedio de los 1.000 primeros documentos de la lista de resultados.

#v(10pt)
== Implementación de la evaluación
\

La implementación de la evaluación de los métodos QPP se realiza mediante un analizador de correlaciones que permite calcular y visualizar las relaciones entre los puntajes de predicción y las métricas de rendimiento real del sistema. Este analizador está diseñado para procesar los resultados de múltiples métodos QPP y métricas de recuperación, generando análisis estadísticos y visualizaciones que facilitan la interpretación de los resultados.

#v(10pt)
=== Cálculo de correlaciones
\

El análisis se basa principalmente en el cálculo de coeficientes de correlación entre los puntajes QPP y las métricas de recuperación (nDCG y AP). Se implementaron tres tipos de correlaciones: Pearson, que mide la relación lineal entre las variables; Spearman, que evalúa la relación monótona entre variables usando rangos; y Kendall (τ), que mide la ordinalidad entre pares de observaciones. Para el cálculo, se utilizan las funciones especializadas de la libreria Scipy, las cuales retornan tanto el coeficiente de correlación como los valores p asociados a la prueba de hipótesis.

Un aspecto crítico de la implementación es el alineamiento de identificadores de consulta (QIDs) entre los puntajes QPP y las métricas de recuperación. Dado que no todas las consultas pueden tener resultados válidos en ambos conjuntos (por ejemplo, consultas sin documentos relevantes en los qrels o con puntajes QPP indefinidos), el sistema calcula la intersección de QIDs comunes antes de proceder con el análisis. Adicionalmente, se aplica un filtro de número mínimo de consultas ($n >= 5$) para garantizar que las correlaciones calculadas tengan suficiente respaldo estadístico, descartando comparaciones que podrían resultar espurias debido a tamaños de muestra insuficientes.

El manejo de valores nulos y no numéricos es otro aspecto relevante: los valores faltantes son detectados y excluidos del cálculo de correlación, evitando que contaminen los resultados. La significancia estadística se verifica mediante pruebas de hipótesis, considerando múltiples umbrales: $alpha < 0.05$ (significativo), $alpha < 0.01$ (muy significativo) y $alpha < 0.001$ (altamente significativo). Las correlaciones que no alcanzan el umbral de significancia son registradas pero marcadas apropiadamente en los reportes generados.

#v(10pt)
=== Visualización de resultados

\
Para facilitar la interpretación de los hallazgos experimentales, se implementó un conjunto de visualizaciones organizadas en dos categorías principales: análisis de correlación y análisis de juicios de relevancia. Esta estrategia de representación gráfica sigue los lineamientos metodológicos de evaluaciones recientes en el área @zendel2024qpptk @correlation-depends-on-quality-of-dataset @enhanced-evaluation.

En primera instancia, para el análisis de correlación QPP, se generaron mapas de calor (_heatmaps_) que despliegan la matriz de correlaciones entre los métodos predictivos y las métricas de evaluación. Para ello, se utilizó una escala de colores divergente (_coolwarm_) centrada en cero, lo que permite identificar rápidamente la fuerza y dirección de las asociaciones, además de una variante específica para visualizar la significancia estadística, categorizando los valores _p_ en cuatro niveles jerárquicos (desde no significativo $>=0,05$ hasta altamente significativo $<0,001$).

De forma complementaria, se construyeron diagramas de dispersión con líneas de regresión para examinar la linealidad de las predicciones y facilitar la comparación del comportamiento distributivo de cada método.

Por otro lado, la segunda categoría de visualizaciones se orientó a la caracterización de los juicios de relevancia y la dificulta de las consultas. Se graficó la distribución de niveles de relevancia presente en los qrels, proporcionando contexto sobre la granularidad de cada dataset. Asimismo, se implementaron gráficos para la clasificación de la dificultad, segmentando las consultas en categorías (fáciles, intermedias y difíciles) según percentiles de efectividad establecidos en la literatura.

Finalmente, se generaron histogramas y diagramas de caja para analizar la distribución de las métricas de recuperación (como nDCG y AP), lo que resulta fundamental para detectar patrones de rendimiento del sistema base y la presencia de valores atípicos (_outliers_) que pudiesen influir en la predicción.

#v(10pt)
== Pruebas de validación
\

La validación de la evaluación constituye una etapa del desarrollo necesaria para garantizar la fiabilidad del entorno de evaluación implementado. Su propósito es verificar que cada componente funciona correctamente de forma aislada y en conjunto con los demás. En el contexto de la Recuperación de Información, donde los cálculos numéricos y estadísticos son fundamentales, la validación adquiere especial relevancia ya que un error en el cálculo de frecuencias o en la normalización de puntajes puede propagarse y distorsionar los resultados de correlación, invalidando las conclusiones experimentales.

Para garantizar la fiabilidad del entorno de evaluación implementado, se desarrolló un conjunto de pruebas unitarias utilizando el framework _unittest_ de Python. Las pruebas unitarias constituyen la base de la pirámide de testeo en ingeniería de software, verificando el comportamiento de unidades individuales de código (funciones, métodos o clases) de forma aislada y reproducible. A diferencia de las pruebas de integración o de sistema, las pruebas unitarias permiten identificar con precisión la fuente de un fallo y facilitan la regresión automática ante cambios en el código.

#v(10pt)
=== Datos para las prueba
\

Para ejecutar las pruebas unitarias se requiere un corpus de documentos con sus respectivas consultas y juicios de relevancia. Sin embargo, utilizar datasets completos como Antique o MS MARCO para pruebas unitarias presenta inconvenientes prácticos: tiempos de indexación prolongados, mayor consumo de memoria y dificultad para verificar manualmente los resultados esperados.

Por esta razón, se diseñó un dataset de prueba sintético denominado _IquiqueDataset_, inspirado en información turística e histórica de la ciudad de Iquique en Chile. Este dataset cumple con los requisitos de legibilidad en español del pipeline de preprocesamiento y permite verificar manualmente cada cálculo gracias a su tamaño reducido.

\
#figure(
  table(
    columns: (auto, 1fr),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*Característica*], [*Valor*],
    
    [Número de documentos], [8],
    [Idioma], [Español],
    [Número de consultas], [8],
    [Juicios de relevancia], [22],
    [Niveles de relevancia], [Multinivel (1: marginal, 2: relevante, 3: altamente relevante)],
  ),
  caption: "Características del dataset de prueba IquiqueDataset.",
) <tabla-iquique-dataset>
\


El corpus incluye ocho documentos breves que abarcan temas como la geografía de Iquique, la Zona Franca (ZOFRI), la playa Cavancha, el Museo Regional, el clima desértico costero, la Guerra del Pacífico, la industria del salitre y el patrimonio cultural pampino. Esta diversidad temática permite evaluar el comportamiento de los predictores ante consultas con diferente especificidad y cobertura documental.

\
#figure(
  table(
    columns: (auto, 1fr),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*Doc ID*], [*Contenido*],
    
    [doc0], [Iquique es una ciudad portuaria y comuna del norte de Chile, capital de la provincia homónima y de la región de Tarapacá],
    [doc1], [La Zona Franca de Iquique (ZOFRI) es uno de los centros comerciales más importantes del norte de Chile y Sudamérica],
    [doc2], [Playa Cavancha es la playa urbana más popular de Iquique, ideal para el surf y deportes acuáticos],
    [doc3], [El Museo Regional de Iquique exhibe la historia de la cultura Chinchorro y la época del salitre],
    [doc4], [El clima de Iquique es desértico costero con abundante nubosidad y temperaturas moderadas durante todo el año],
  ),
  caption: "Muestra de documentos del corpus IquiqueDataset (5 de 8).",
) <tabla-iquique-docs>
\

#figure(
  table(
    columns: (auto, 1fr, auto),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*QID*], [*Consulta*], [*Docs. relevantes*],
    
    [0], [playa cavancha iquique], [3],
    [1], [zona franca zofri], [2],
    [2], [museo historia iquique], [4],
    [3], [historia salitre guerra pacifico], [4],
    [4], [clima temperatura iquique], [2],
    [5], [patrimonio cultural pampino], [3],
    [6], [comercio norte chile sudamerica], [3],
    [7], [combate naval peru chile], [2],
  ),
  caption: "Consultas del dataset IquiqueDataset y su cobertura de relevancia.",
) <tabla-iquique-queries>
\

Como se observa en la @tbl:tabla-iquique-queries, las consultas presentan diferentes grados de dificultad inherente. Todas las consultas utilizan juicios de relevancia multinivel, donde el nivel 3 indica alta relevancia, el nivel 2 indica relevancia moderada, y el nivel 1 indica relevancia marginal. Esta gradación permite evaluar métricas como nDCG que consideran la posición y el grado de relevancia de los documentos recuperados.

#v(10pt)
=== Componentes del módulo de pruebas
\

Las pruebas unitarias se organizaron en una estructura jerárquica que refleja la arquitectura del sistema. Se crearon módulos de pruebas para cada capa importante de la evaluación: un módulo para las pruebas del analizador de correlaciones y el evaluador de métricas, y módulos separados para cada uno de los predictores QPP, distinguiendo entre métodos pre-retrieval y post-retrieval según la taxonomía establecida en el marco teórico.

\
#figure(
  table(
    columns: (auto, auto, 1fr),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*Componente*], [*Casos*], [*Aspectos evaluados*],
    
    [Analizador de correlaciones], [10], [Inicialización, cálculo de correlaciones (Pearson, Spearman, Kendall), generación de mapas de calor, diagramas de dispersión, diagramas de caja, reportes y alineamiento de identificadores],
    [Evaluador de métricas], [6], [Cálculo de nDCG\@10 y AP para rankings perfectos e invertidos, evaluación de múltiples métricas simultáneas y manejo de consultas inválidas],
    [Clarity], [8], [Cómputo de frecuencias de términos, probabilidades de colección con suavizado Dirichlet, divergencia KL, consistencia de stemming y manejo de documentos vacíos],
    [NQC], [6], [Inicialización de vectores de puntajes, cálculo de puntaje del corpus, normalización por desviación estándar y manejo de datos vacíos],
    [WIG], [7], [Vectores de puntajes, puntaje del corpus, cálculo WIG con normalización por longitud de consulta y frecuencias de colección],
    [UEF], [8], [Correlación entre rankings original y re-rankeado, límites de correlación, manejo de puntajes base cero, procesamiento por lotes y escenarios de correlación perfecta],
    [IDF], [7], [Cálculo de frecuencia de documento por término, manejo de términos fuera del vocabulario, agregación por promedio y máximo, y procesamiento por lotes],
    [SCQ], [6], [Estadísticas de frecuencia de colección y documento, cálculo de similitud consulta-colección, métodos de agregación (suma, promedio, máximo) y términos desconocidos],
  ),
  caption: "Componentes evaluados mediante pruebas unitarias.",
) <tabla-modulos-prueba>
\

La ejecución de las pruebas se automatizó mediante un sistema de descubrimiento automático que localiza y ejecuta todos los casos de prueba del proyecto. Este sistema genera tres tipos de reportes: un archivo de texto plano con el resumen de ejecución, un archivo estructurado con estadísticas detalladas por componente, y un informe formateado que incluye indicadores visuales de éxito o fallo para cada caso individual.

#v(10pt)
=== Casos de prueba representativos
\

A continuación se describen casos de prueba representativos de cada categoría, ilustrando la metodología de validación empleada y los escenarios cubiertos.

\
*Predictores pre-retrieval (IDF y SCQ)*: Las pruebas del predictor IDF verifican el correcto cálculo de la frecuencia inversa de documento para términos individuales y múltiples. Un caso crítico es el manejo de términos fuera del vocabulario: cuando un término de la consulta no existe en el índice, el sistema debe manejar esta situación de forma robusta, evitando que el puntaje de toda la consulta se invalide. Las pruebas verifican que el IDF calculado para un término conocido coincide con la fórmula teórica $log(N\/d f_t)$ donde $N$ es el número de documentos del corpus, que los términos inexistentes son excluidos del cálculo degradando suavemente la estimación, y que la frecuencia de documento de términos comunes se calcula correctamente.

\
#figure(
  kind:image,
  [
    #codly(languages: codly-languages)
    ```python
    # Preprocesar términos de consulta
    sample_text = "iquique playa"
    processed_terms = preprocess_text(sample_text)
    term1, term2 = processed_terms[0], processed_terms[1]
    
    # Calcular IDF utilizando el predictor
    score = self.idf.compute_score([term1])

    # Calcular IDF utilizando la fórmula teórica
    expected_idf = np.log(self.total_docs / self.term_dfs[term1])
    
    # Verificar que coincide con fórmula teórica con margen de error
    self.assertAlmostEqual(score, expected_idf)
    ```
  ],
  caption: "Prueba de validación del cálculo de IDF para términos individuales.",
) <codigo_test_idf>
\

La @fig:codigo_test_idf ilustra cómo se valida el cálculo del predictor IDF. Primero se preprocesan los términos de una consulta de prueba utilizando la misma función de procesamiento que se emplea durante la indexación, garantizando consistencia en el vocabulario. Luego se calcula el puntaje IDF mediante el predictor implementado y se compara contra el valor esperado según la fórmula teórica. La función `assertAlmostEqual` permite una tolerancia numérica de hasta 7 decimales, acomodando pequeñas diferencias de precisión de punto flotante inherentes a los cálculos logarítmicos.

\
*Predictores post-retrieval (Clarity, NQC, WIG)*: Las pruebas del predictor Clarity validan el flujo completo de cálculo, desde la construcción del modelo de lenguaje del conjunto pseudo-relevante hasta el cómputo de la divergencia KL. Un aspecto fundamental es la verificación del suavizado de Dirichlet: para distribuciones de probabilidad distintas, la divergencia KL debe ser estrictamente positiva, mientras que para distribuciones idénticas debe aproximarse a cero. Adicionalmente, se verifica que el _stemmer_ _Snowball_ produce resultados consistentes entre la indexación y el procesamiento de consultas (por ejemplo, "historia" $arrow.r$ "histori", "iquique" $arrow.r$ "iquiqu").

\
#figure(
  kind:image,
  [
    #codly(languages: codly-languages)
    ```python
    # Obtener probabilidades de colección con suavizado de Dirichlet
    stemmed_terms = ['iquiqu', 'playa', 'museo']
    probs = self.clarity._get_collection_probabilities(stemmed_terms)
    
    # Verificar que todas las probabilidades están en rango válido
    for term, prob in probs.items():
        self.assertGreaterEqual(prob, 0)
        self.assertLessEqual(prob, 1)
    
    # Verificar consistencia de stemming
    stemmer = SnowballStemmer('spanish')
    assert stemmer.stem('historia') == 'histori'
    assert stemmer.stem('iquique') == 'iquiqu'
    ```
  ],
  caption: "Prueba de suavizado de Dirichlet y consistencia de stemming en Clarity.",
) <codigo_test_clarity>
\

La @fig:codigo_test_clarity demuestra la validación del suavizado de Dirichlet implementado en Clarity. El método _get_collection_probabilities_ calcula las probabilidades de colección para un conjunto de términos aplicando la fórmula de suavizado mencionada anteriormente. Las verificaciones garantizan que todas las probabilidades resultantes estén en el rango válido $[0, 1]$, condición necesaria para el cálculo posterior de la divergencia KL. La segunda parte de la prueba valida la consistencia del stemming: los mismos términos deben transformarse de forma idéntica durante la indexación y durante el procesamiento de consultas, asegurando que el vocabulario del índice coincida con el de las probabilidades de colección.

\
*Evaluador de métricas*: Las pruebas del evaluador verifican el cálculo de nDCG y AP contra valores de referencia conocidos. Se construyen dos escenarios extremos: un ranking perfecto donde los documentos relevantes ocupan las primeras posiciones (debiendo producir métricas superiores a 0.8), y un ranking invertido donde los documentos relevantes quedan al final (debiendo producir métricas inferiores a 0.6 para nDCG y 0.5 para AP).

\
#figure(
  kind:image,
  [
    #codly(languages: codly-languages)
    ```python
    # Evaluar ranking perfecto (documentos relevantes primero)
    results = evaluate_results(
        self.qrels,
        self.perfect_run,
        metrics=['ndcg@10'],
        dataset_name="iquique_dataset",
        min_results=1
    )
    
    # Verificar que nDCG es alto para ranking perfecto
    ndcg_score = results['ndcg@10']['mean']
    self.assertGreater(ndcg_score, 0.8)
    
    # Evaluar ranking invertido (documentos relevantes al final)
    reversed_results = evaluate_results(
        self.qrels,
        self.reversed_run,
        metrics=['ndcg@10'],
        dataset_name="iquique_dataset",
        min_results=1
    )
    
    # Verificar que nDCG es bajo para ranking invertido
    reversed_score = reversed_results['ndcg@10']['mean']
    self.assertLess(reversed_score, 0.6)
    ```
  ],
  caption: "Prueba de evaluación de métricas con rankings perfecto e invertido.",
) <codigo_test_evaluator>
\

La @fig:codigo_test_evaluator valida el evaluador de métricas mediante la construcción de escenarios controlados. En el ranking perfecto, los documentos con mayor relevancia aparecen en las primeras posiciones, lo que debe producir valores de nDCG cercanos a 1.0 (el test verifica $> 0.8$). Por el contrario, en el ranking invertido los documentos relevantes se posicionan al final de la lista, degradando significativamente la métrica. Esta prueba no solo valida la correcta implementación de nDCG, sino también la sensibilidad de la métrica a la posición de los documentos relevantes. El parámetro `min_results=1` se configura específicamente para el dataset de prueba pequeño, ya que el valor por defecto de 1000 resultados mínimos no es aplicable a colecciones de validación.

\
*Analizador de correlaciones*: Las pruebas del analizador de correlaciones validan tanto la lógica de cálculo como la generación de visualizaciones. Se verifica que los coeficientes de Pearson, Spearman y Kendall están siempre en el rango $[-1, 1]$ para cualquier par de variables, que solo los identificadores de consulta presentes simultáneamente en los puntajes QPP y las métricas de recuperación se conservan para el análisis, y que los puntajes vacíos o con valores indefinidos generan excepciones apropiadas o son manejados de forma robusta.

\
#figure(
  kind:image,
  [
    #codly(languages: codly-languages)
    ```python
    # Calcular correlaciones entre puntajes QPP y métricas
    correlations = self.analyzer.calculate_correlations(
        correlation_types=['pearson', 'spearman', 'kendall']
    )
    
    # Verificar que todos los coeficientes están en rango válido
    for corr_type in ['pearson', 'spearman', 'kendall']:
        for value in correlations[corr_type].values.flatten():
            if not np.isnan(value):
                self.assertTrue(-1 <= value <= 1)
    
    # Verificar alineamiento de identificadores de consulta
    aligned_qids = self.analyzer._align_qids(
        qpp_scores={'0': 0.5, '1': 0.7},
        metrics={'0': 0.8, '2': 0.6}
    )
    # Solo '0' está presente en ambos conjuntos
    self.assertEqual(set(aligned_qids), {'0'})
    ```
  ],
  caption: "Prueba de cálculo de correlaciones y alineamiento de identificadores.",
) <codigo_test_correlation>
\

La @fig:codigo_test_correlation muestra dos aspectos fundamentales del análisis de correlaciones. Primero, se valida que todos los coeficientes de correlación calculados (Pearson, Spearman y Kendall) permanezcan dentro de su rango teórico $[-1, 1]$. Los valores fuera de este rango indicarían errores numéricos graves en la implementación. Segundo, se verifica el alineamiento de identificadores de consulta: solo aquellas consultas que poseen tanto puntajes QPP como métricas de recuperación deben incluirse en el análisis. En el ejemplo mostrado, aunque los puntajes QPP contienen las consultas '0' y '1', y las métricas contienen '0' y '2', solo la consulta '0' queda alineada para el cálculo de correlaciones. Este alineamiento correcto es fundamental para evitar correlaciones espurias causadas por datos faltantes.


#v(10pt)
=== Resultados de la validación
\

La ejecución completa del framework de pruebas, que comprende 58 casos distribuidos entre los ocho módulos, demostró la robustez del sistema implementado. Los resultados se resumen en la @tbl:tabla-resultados-pruebas.

\
#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    stroke: (x: none),
    align: left + horizon,
    
    [*Componente*], [*Pruebas ejecutadas*], [*Tiempo de ejecución (s)*],
    
    [Analizador de correlaciones], [10], [8,25],
    [Evaluador de métricas], [6], [0,05],
    [Clarity], [8], [0,03],
    [NQC], [6], [0,01],
    [WIG], [7], [0,01],
    [UEF], [8], [0,02],
    [IDF], [7], [0,01],
    [SCQ], [6], [0,01],
    table.hline(stroke: 0.5pt),
    [*Total*], [*58*], [*8,40*],
  ),
  caption: "Resultados de ejecución de pruebas unitarias por componente.",
) <tabla-resultados-pruebas>
\

Todos los casos de prueba finalizaron exitosamente, alcanzando una tasa de éxito del 100%. El tiempo total de ejecución de aproximadamente 8,4 segundos resulta adecuado dado el tamaño reducido del dataset de validación, permitiendo obtener resultados rápidos e interpretables.

El analizador de correlaciones concentra la mayor parte del tiempo de ejecución debido a la generación de múltiples visualizaciones en formatos gráficos. Los predictores QPP muestran tiempos de ejecución mínimos gracias a la reutilización del índice y las estadísticas pre-calculadas, lo cual valida las estrategias de optimización mencionadas en secciones anteriores.

La validación exhaustiva realizada confirma la fiabilidad y precisión del entorno de evaluación implementado, proporcionando una base sólida para los experimentos de correlación analizados en el siguiente Capítulo. El sistema demostró ser robusto ante diversos escenarios de prueba, manteniendo la consistencia en el procesamiento de consultas, el cálculo de puntajes QPP y la evaluación de métricas de recuperación.