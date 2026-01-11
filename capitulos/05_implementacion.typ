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
El entorno experimental se encuentra configurado para ser ejecutado en un variedad de entornos debido a la utilización de Docker, el cual permite la ejecución de entornos virtuales en diferentes sistemas operativos. De manera general y para preservar la reproducibilidad de los resultados, se ha configurado el entorno experimental para ser ejecutado en un sistema operativo Linux, utilizando Python 3.9.21 y PyTerrier 0.13.0.

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

Como se puede apreciar en la @tbl:configuracion, se ha optado por implementar el entorno experimental en componentes de software con versiones especificas y estables, esperando lograr la mayor reproducibilidad posible de los resultados. La ejecución también es posible en sistemas operativos Windows y MacOS, pero estas cuentan con procesos de instalación y configuración mas complejos.

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
    
    [*Configuración UTF-8*], [Establece codificación UTF-8 para el manejo correcto de caracteres especiales y términos en diferentes idiomas presentes en los datasets, esto en la practica es necesario para evitar errores de procesamiento de tokens.],
    
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

Cada dataset cuenta con una cantidad de documentos y consultas disponibles para realizar la evaluación, por otro lado los juicios de relevancia suponen un desafío extra para la implementación de la evaluación, puesto que cada dataset cuenta con distintos niveles de relevancia para las consultas, si estos no se manejan adecuadamente puede alterar drásticamente los resultados de la correlación.

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

Se observó que el tokenizador por defecto de Terrier presentaba inconsistencias significativas en el manejo de términos numéricos. Por ejemplo, términos como "0", "00" y "000" eran indexados como tokens distintos por Terrier, mientras que el pipeline de preprocesamiento basado en NLTK/Snowball los unificaba o eliminaba según su configuración de _stopwords_. Esta discrepancia causaba un grave desajuste de vocabulario (_vocabulary mismatch_), donde términos presentes en la consulta procesada en Python no encontraban correspondencia en el índice de Terrier (resultando en frecuencias de documento igual a 0), lo que a su vez generaba puntajes nulos o incorrectos en predictores sensibles como IDF y SCQ. Al indexar el texto ya procesado por el mismo pipeline que las consultas, se elimina esta fuente de error y se asegura la coherencia del vocabulario.

Adicionalmente, para optimizar el rendimiento de los predictores _pre-retrieval_, se implementó mecanismos de caché estadísticos, el cual pre-calcula y almacena en un archivo JSON las estadísticas globales más consultadas, como la frecuencia de colección (_Collection Frequency_, CF) y la frecuencia de documentos (_Document Frequency_, DF) para cada término. Esta estrategia evita la sobrecarga computacional que implicaría realizar múltiples consultas JNI (_Java Native Interface_) al índice de Terrier o escaneos completos del índice para obtener estadísticas básicas repetitivas, reduciendo significativamente el tiempo de ejecución de los experimentos, especialmente en _datasets_ grandes como MS MARCO.

#v(10pt)
== Implementación de métodos QPP

\
La implementación de los métodos QPP difiere en las dos categorías en la que se dividen los ‟métodos‟, pre-retrieval y post-retrieval, el primer caso solo cuenta con una dependencia para su implementación, la cual es el índice invertido generado a partir de un corpus de documentos. Mientras que en el segundo caso, cuenta con dos, el índice invertido generado a partir de un corpus de documentos y los resultados de un sistema de recuperación de información en respuesta a una consulta.

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

Para el método *IDF (Inverse Document Frequency)*, se implementó un manejo riguroso de términos para asegurar la estabilidad del predictor. Estas modificaciones no son triviales, sino que surgieron tras iteraciones experimentales donde se observó que la implementación estándar producía correlaciones artificialmente bajas (cercanas a cero) debido a inestabilidad numérica.

En primer lugar, se implementó una distinción explícita para los términos fuera del vocabulario (OOV). A diferencia de enfoques que simplemente asignan un valor nulo, esta implementación asigna un valor centinela de frecuencia de documento igual a -1 a los términos que no existen en absoluto en el índice. El beneficio crítico de este manejo es prevenir que la presencia de un solo término desconocido (por ejemplo, un error tipográfico) invalide el puntaje de toda una consulta al propagar valores nulos o indefinidos, permitiendo que el sistema degrade suavemente su estimación basándose únicamente en los términos conocidos.

En segundo lugar, se incorporó la técnica de *suavizado Laplaciano* (_add-1 smoothing_) en el cálculo del predictor IDF. Esta técnica consiste en simular que cada término del vocabulario ha sido observado una vez más de lo que realmente aparece en la colección.

\
$ P_("smooth")(w) = ("count"(w) + 1) / (N + V) $ <formula_suavizado>
\

En la @eqt:formula_suavizado $"count"(w)$ es la frecuencia del término $w$, $N$ es el total de tokens y $V$ el tamaño del vocabulario. La justificación técnica para aplicar este suavizado en QPP es debido a que aporta *estabilidad numérica* al evitar divisiones por cero e indefiniciones logarítmicas (como $log(0)$) que invalidarían el cálculo para términos extremadamente raros @laplacian-smoothing.

Por otro lado, la implementación de *SCQ (Collection Query Similarity)* se benefició directamente de la optimización de caché estadística mencionada en la sección de indexación. Dado que SCQ requiere consultar intensivamente las frecuencias CF y DF para cada término de la consulta, el acceso directo a las estadísticas pre-calculadas permite calcular la similitud consulta-colección de manera eficiente. Se implementaron variantes del método que agregan los puntajes de los términos utilizando tanto la suma como el máximo (_max_scq_), permitiendo evaluar qué estrategia de agregación captura mejor la dificultad de la consulta.

#v(10pt)
=== Métodos post-retrieval

\
En esta categoría se consideró una gama más amplia de predictores, abarcando desde métodos basados en divergencia como Clarity, hasta frameworks basados en utilidad como UEF. La implementación de estos métodos implica una complejidad mayor, ya que requieren interactuar tanto con el índice invertido como con la lista de resultados recuperada.

Un aspecto crítico en la implementación del *Clarity Score* fue el suavizado del modelo de lenguaje de la colección. Para estimar la probabilidad $P(w|C)$ de un término en la colección, se utilizó *suavizado de Dirichlet* con un parámetro $mu=1000$. Esta decisión no solo responde a una necesidad de estabilidad numérica, sino que es fundamental para la robustez de los modelos de lenguaje en Recuperación de Información, especialmente en función de la naturaleza de la colección procesada.

En el contexto de colecciones pequeñas o constituidas por documentos breves, como pasajes, *snippets* (fragmentos de texto cortos que resumen el contenido de un documento en la lista de resultados) o el propio dataset Cranfield utilizado, la frecuencia de términos (*term frequency*) es intrínsecamente escasa. Sin un mecanismo de suavizado, los modelos de lenguaje derivados resultantes serían extremadamente ruidosos y estarían sesgados hacia los pocos términos observados, provocando que la divergencia KL diverja artificialmente debido a probabilidades nulas o a picos de frecuencia no representativos. En este contexto, la técnica de suavizado de Dirichlet es una herramienta útil que reduce la varianza de la estimación, evita la sobreestimación de términos raros y estabiliza el modelo de la consulta. Esto permitiría que el puntaje de Clarity correlacione efectivamente con la dificultad real de la consulta y no con el ruido estadístico inherente a la escasez de datos.

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

Para el método *UEF (Utility Estimation Framework)*, la implementación se centró en la robustez del cálculo de correlación. UEF estima la dificultad correlacionando los puntajes de recuperación originales con los obtenidos tras una expansión de consulta (en este caso, utilizando el modelo *RM3*). Para asegurar la validez de esta correlación, se implementó un alineamiento estricto de las listas de resultados basado en identificadores de documento (`docno`), asegurando que la comparación se realice sobre la intersección de documentos recuperados en ambas etapas. Además, se normalizan los puntajes antes del cálculo de correlación para mitigar diferencias de escala entre las pasadas de recuperación.

Finalmente, para *NQC (Normalized Query Commitment)* y *WIG*, se incorporaron mecanismos de manejo de excepciones para casos de varianza cero. En situaciones donde todos los documentos recuperados tienen el mismo puntaje (lo cual puede ocurrir con consultas muy cortas o en colecciones con pocos documentos relevantes), la desviación estándar se anula, lo que podría causar errores de división. La implementación detecta estos casos y asigna un puntaje de dificultad predefinido, garantizando la continuidad de la evaluación sin interrupciones.

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
Adicionalmente se puede observar parámetros como el tamaño de la lista de documentos a considerar, el cual fue definido como 5 para WIG y en 200 para NQC bajo la recomendación de la literatura y nuestros propios experimentos @web-search-qpp @wig-nqc-scored-configuration @query-drift. Para finalizar, también cabe mencionar que todas los puntajes fueron considerando el puntaje promedio de los 1000 primeros documentos de la lista de resultados.

#v(10pt)
== Implementación de la evaluación
\

La implementación de la evaluación de los métodos QPP se realiza mediante un analizador de correlaciones que permite calcular y visualizar las relaciones entre los puntajes de predicción y las métricas de rendimiento real del sistema. Este analizador está diseñado para procesar los resultados de múltiples métodos QPP y métricas de recuperación, generando análisis estadísticos y visualizaciones que facilitan la interpretación de los resultados.

#v(10pt)
=== Cálculo de correlaciones
\

El análisis se basa principalmente en el cálculo de coeficientes de correlación entre los puntajes QPP y las métricas de recuperación (nDCG y AP). Se implementaron tres tipos de correlaciones: *Pearson*, que mide la relación lineal entre las variables; *Spearman*, que evalúa la relación monótona entre variables usando rangos; y *Kendall (τ)*, que mide la ordinalidad entre pares de observaciones. Para el cálculo, se utilizan las funciones especializadas la libreria Scipy, las cuales retornan tanto el coeficiente de correlación como los valores p asociados a la prueba de hipótesis.

Un aspecto crítico de la implementación es el *alineamiento de identificadores de consulta (QIDs)* entre los puntajes QPP y las métricas de recuperación. Dado que no todas las consultas pueden tener resultados válidos en ambos conjuntos (por ejemplo, consultas sin documentos relevantes en los _qrels_ o con puntajes QPP indefinidos), el sistema calcula la intersección de QIDs comunes antes de proceder con el análisis. Adicionalmente, se aplica un filtro de *número mínimo de consultas* ($n >= 5$) para garantizar que las correlaciones calculadas tengan suficiente respaldo estadístico, descartando comparaciones que podrían resultar espurias debido a tamaños de muestra insuficientes.

El manejo de *valores nulos y no numéricos* es otro aspecto relevante: los valores faltantes son detectados y excluidos del cálculo de correlación, evitando que contaminen los resultados. La significancia estadística se verifica mediante pruebas de hipótesis, considerando múltiples umbrales: $alpha < 0.05$ (significativo), $alpha < 0.01$ (muy significativo) y $alpha < 0.001$ (altamente significativo). Las correlaciones que no alcanzan el umbral de significancia son registradas pero marcadas apropiadamente en los reportes generados.

#v(10pt)
=== Visualización de resultados

\
Para facilitar la interpretación de los resultados, se implementaron múltiples tipos de visualizaciones organizadas en dos categorías principales, siguiendo la linea de otras evaluaciones @zendel2024qpptk @correlation-depends-on-quality-of-dataset @enhanced-evaluation.

La primera categoría corresponde a las visualizaciones de *análisis de correlación QPP*, como se puede observar en la @tbl:tabla_visualizaciones.

\
#figure(
  table(
    columns: (auto, 1fr),
    rows: auto,
    stroke: (x: none),
    align: left + horizon,
    
    [*Tipo de gráfico*], [*Descripción*],
    
    [*Mapas de calor de correlación*], [Muestran la matriz de correlaciones entre todos los métodos QPP y las métricas de evaluación, utilizando una escala de colores divergente (_coolwarm_) centrada en cero para representar la fuerza y dirección de las correlaciones. Se genera una versión horizontal optimizada para el formato del trabajo de titulo],
    
    [*Mapas de calor de significancia*], [Visualizan los valores p de significancia estadística categorizados en cuatro niveles: no significativo ($>=0.05$), significativo ($<0.05$), muy significativo ($<0.01$) y altamente significativo ($<0.001$), utilizando una paleta de colores jerárquica],
    
    [*Diagramas de dispersión QPP*], [Visualizan la relación entre cada método QPP y una métrica específica, incluyendo líneas de regresión para mejor interpretación. Se generan tanto gráficos combinados como individuales para cada método],
    
    [*Diagramas de caja de correlaciones*], [Presentan la distribución de las correlaciones para cada método QPP ordenados por mediana, incluyendo puntos individuales con _jitter_ para visualizar la dispersión real de los datos y una línea de referencia en cero],
  ),
  caption: "Visualizaciones de análisis de correlación QPP.",
) <tabla_visualizaciones>
\

La segunda categoría corresponde a las visualizaciones de *análisis de juicios de relevancia y dificultad de consultas*, como se detalla en la @tbl:tabla_visualizaciones_qrels. Estas visualizaciones permiten comprender la naturaleza de los juicios de relevancia y su relación con el rendimiento del sistema.

\
#figure(
  table(
    columns: (auto, 1fr),
    rows: auto,
    stroke: (x: none),
    align: left + horizon,
    
    [*Tipo de gráfico*], [*Descripción*],
    
    [*Distribución de niveles de relevancia*], [Muestra la frecuencia de cada nivel de relevancia en los _qrels_, proporcionando contexto sobre la granularidad y distribución de los juicios disponibles en el dataset],
    
    [*Clasificación de dificultad*], [Clasifica las consultas en fáciles, intermedias y difíciles según percentiles de una métrica de efectividad, implementando definiciones basadas en umbrales como las descritas en la literatura],

    [*Distribución de métricas de recuperación*], [Boxplots e histogramas que muestran la distribución de las métricas de evaluación (nDCG, AP) por consulta, permitiendo identificar outliers y patrones de rendimiento],
  ),
  caption: "Visualizaciones de análisis de qrels y dificultad.",
) <tabla_visualizaciones_qrels>
\

#v(10pt)
== Pruebas de validación
\

La validación exhaustiva del sistema implementado se realizó mediante una suite completa de pruebas unitarias, diseñada para verificar el correcto funcionamiento de cada componente del entorno de evaluación. Se desarrolló un framework de pruebas automatizado que permite la ejecución sistemática de casos de prueba y la generación de informes detallados.

#v(10pt)
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
  caption: "Módulos principales de pruebas unitarias.",
) <tabla-modulos-prueba>
\

#v(10pt)
=== Metodología de validación
\
La validación se realizó mediante un enfoque sistemático que incluye:

- *Pruebas de casos límite*: Verificación del comportamiento del sistema ante consultas vacías, términos desconocidos y valores extremos.
- *Validación de consistencia*: Comprobación de la coherencia en el procesamiento de términos y el stemming.
- *Pruebas de integración*: Verificación de la correcta interacción entre componentes, especialmente en el análisis de correlaciones.
- *Validación de métricas*: Comprobación de cálculos de nDCG y AP contra valores conocidos.

#v(10pt)
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
  caption: "Resultados de ejecución por componente.",
) <tabla-resultados-pruebas>
\

La validación exhaustiva realizada confirma la fiabilidad y precisión del entorno de evaluación implementado, proporcionando una base sólida para los experimentos subsiguientes. El sistema demostró ser robusto ante diversos escenarios de prueba, manteniendo la consistencia en el procesamiento de consultas y el cálculo de métricas de evaluación.