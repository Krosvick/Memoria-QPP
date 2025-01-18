## Objetivos específicos

- [x] Revisar la literatura sobre métodos de QPP en búsquedas Ad-hoc sin el uso de inteligencia artificial
     - [x] Identificar y describir los principales métodos QPP utilizados en la actualidad
     - [x] Selección de 5 métodos QPP según relevancia: NQC, IDF, Clarity, WIG y UEF
- [x] Identificar y analizar los procesos estándar de evaluación aplicados a los métodos de QPP
     - [x] Explorar los procesos estándar de evaluación: ir_datasets, ir_measures y PyTerrier
     - [x] Determinar los datasets a utilizar (ir_datasets): BEIR, Cranfield, MS MARCO, Antique y CAR
     - [x] Configurar el entorno experimental
- [x] Implementar métodos QPP en búsquedas Ad-hoc sin inteligencia artificial para su evaluación utilizando métricas estandarizadas
     - [x] Implementación de método pre-retrieval: IDF
     - [x] Implementación de métodos post-retrieval: Clarity, WIG, NQC y UEF.
- [ ] Evaluar los resultados obtenidos de los métodos QPP implementados, determinando su efectividad en función a los resultados descritos en el estado del arte
- [ ] Analizar y documentar el rendimiento de los métodos QPP implementados para establecer una línea base para futuras comparaciones con nuevos enfoques

## Objetivo 
Evaluar comparativamente métodos de Query Performance Prediction (QPP) para búsquedas Ad-hoc utilizando métricas de correlación.

## Contexto
En la actualidad, los métodos de Query Performance Prediction (QPP) son fundamentales en sistemas de recuperación de información (IR) para predecir la calidad de los resultados y optimizar búsquedas. Sin embargo, su eficacia varía según dominios y tipos de consultas, especialmente en búsquedas ad-hoc, derivando en respuestas subóptimas y tiempo desperdiciado en búsquedas poco eficaces. Es así, que se resalta la necesidad de una evaluación robusta y benchmarking a los métodos QPP más utilizados, para asegurar su fiabilidad en diversos entornos a la vez que se establece una base sólida para facilitar el desarrollo de nuevos enfoques.

El presente proyecto se enfocará en implementar y evaluar métodos QPP no basados en inteligencia artificial (IA) para búsquedas ad-hoc utilizando medidas de correlación estandarizadas, como, por ejemplo, tau de Kendall y el coeficiente de correlación de Pearson. Este enfoque implica una revisión exhaustiva de la literatura existente para identificar los métodos QPP claves, seguida de una cuidadosa implementación de ellos, para luego evaluarlos rigurosamente utilizando un conjunto de datos estandarizados y un marco de evaluación común, lo que asegurará la comparabilidad y reproducibilidad de los resultados.


El objetivo del proyecto es evaluar al menos 5 métodos QPP diferentes y lograr un benchmarking que replique el rendimiento de los métodos QPP descritos en el estado del arte. Estos resultados servirán como línea base para comparar nuevos modelos QPP, proporcionando un punto de referencia claro para evaluar las

mejoras de su investigación futura. Además, se busca identificar fortalezas y debilidades de diferentes enfoques, potencialmente descubriendo ideas que podrían guiar futuras direcciones de investigación en métodos QPP.