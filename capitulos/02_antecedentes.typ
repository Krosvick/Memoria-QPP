#import "../template.typ": *
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}
= ANTECEDENTES

== Marco teórico
Conceptos básicos y principios fundamentales...
=== Sistemas de Information Retrieval (IR)
=== Predicción de Rendimiento de Consultas (QPP)
=== Métricas Clásicas de Evaluación en IR
=== Métricas de Correlación para Evaluar Métodos QPP

== Herramientas utilizadas
=== Pyterrier
=== ir_datasets
=== ir_measures
=== Docker
