#import "@preview/anti-matter:0.1.1": anti-matter, fence, set-numbering, step
#import "template.typ": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()


#show: anti-matter.with(
  alignments: (center, right, center),
  header: none,
  numbering: ("i", "1", "i")
)
// Empezamos sin numeración para la portada

#show: proyecto.with(
  titulo: "EVALUACIÓN COMPARATIVA DE MÉTODOS QUERY PERFORMANCE PREDICTION (QPP) PARA BÚSQUEDAS AD-HOC UTILIZANDO MÉTRICAS DE CORRELACIÓN.",
  autor: "José Emmanuel Raúl Sandoval Vega.
  Luis Emersson Brain Fredes.",
  profesor_guia: "Dr. Mauricio Andrés Oyarzún Silva.",
  fecha: "2025",
  tipo_ingeniero: "INGENIERO CIVIL EN COMPUTACIÓN E INFORMÁTICA"
)

// Empezamos con numeración romana para las secciones pretextuales
#set-numbering("i")

#align(right + bottom)[
  #set text(style: "italic")
  [Dedicatoria...]
]

#pagebreak()

// Agradecimientos (opcional)
#pretextual-heading("AGRADECIMIENTOS", is_center: true)
#v(2em)
#align(center)[
  [Agradezco...]
]
#pagebreak()


// Índices
#pretextual-heading("ÍNDICE DE MATERIAS", is_center: true)
#v(1.5em)
#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  it
}
#par(leading:1em)[
#outline(
  title: none,
  target: heading.where(outlined: true) // solo mostrar los capítulos principales en el índice
)
]
#pagebreak()

#pretextual-heading("ÍNDICE DE TABLAS", is_center: true)
#v(2em)
#i-figured.outline(target-kind: table, title: none)

#pagebreak()

#pretextual-heading("ÍNDICE DE FIGURAS", is_center: true)
#v(2em)
#i-figured.outline(target-kind: image, title: none)

#pagebreak()

#pretextual-heading("NOMENCLATURA", is_center: true)
#v(2em)
// Lista de símbolos y abreviaturas en orden alfabético

#pagebreak()

#pretextual-heading("RESUMEN", is_center: true)
#v(2em)
#include "capitulos/resumen.typ"

#fence()
#pagebreak()

// Capítulos (now with arabic numbers)
#include "capitulos/01_introduccion.typ"

#pagebreak()

#include "capitulos/02_antecedentes.typ"

#pagebreak()

#include "capitulos/03_trabajos_relacionados.typ"

#pagebreak()

#include "capitulos/04_diseño_de_la_evaluacion.typ"

#pagebreak()

#include "capitulos/05_implementacion.typ"

#pagebreak()

#include "capitulos/06_analisis_de_resultados.typ"

#pagebreak()

#include "capitulos/07_conclusiones.typ"

#pagebreak()

#include "capitulos/referencias.typ"
#fence()
