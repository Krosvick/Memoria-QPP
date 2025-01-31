#import "@preview/anti-matter:0.1.1": anti-matter, fence, set-numbering, step
#import "@preview/i-figured:0.2.4"

#let to-roman(num) = {
  let numerals = (
    (1000, "M"), (900, "CM"),
    (500, "D"), (400, "CD"),
    (100, "C"), (90, "XC"),
    (50, "L"), (40, "XL"),
    (10, "X"), (9, "IX"),
    (5, "V"), (4, "IV"),
    (1, "I")
  )
  let result = ""
  let n = num
  for (value, symbol) in numerals {
    while n >= value {
      result += symbol
      n -= value
    }
  }
  result
}

// Global heading style rule
#show heading: it => {
  set text(size: 12pt, weight: "bold")
  it
}

#let proyecto(
  titulo: "",
  autor: "",
  profesor_guia: "",
  fecha: "",
  tipo_ingeniero: "INGENIERO CIVIL EN COMPUTACIÓN E INFORMÁTICA",
  body
) = {
  // Configuración de página para la parte pretextual
  set page(
    width: 21.5cm,
    height: 33cm,
    margin: (
      top: 2.8cm,
      bottom: 2.8cm,
      left: 3.3cm,
      right: 3.0cm,
    ),
  )
  
  // Configuración de texto
  set text(
    font: "Times New Roman",
    size: 13pt,
    lang: "es"
  )
  
  // Configuración de párrafos
  set par(
    justify: true,
    leading: 12pt,
    first-line-indent: 0pt
  )
  
  // Configuración de índice de materias
  set outline(
    indent: 1em,
  )

  set list(
    indent: 20pt,
  )
  
  // Configuración de encabezados
  set heading(
    numbering: (..numbers) => {
      let n = numbers.pos()
      if n.len() == 1 {
        // For chapter headings, wrap the entire text in a single text element
        text(size: 12pt, weight: "bold")[CAPÍTULO #to-roman(n.at(0)): ]
      } else {
        // Para subsecciones usamos numeración decimal empezando con el número del capítulo
        let chapter = numbers.pos().at(0)
        let section = numbers.pos().slice(1)
        text(size: 12pt)[#numbering("1.1   ", chapter, ..section)]
      }
    },
    supplement: none,
  )
  
  // Configuración de figuras y tablas
  set figure(
    placement: none,
  )
  show figure.where(
  kind: table
): set figure.caption(position: top)
  
  set table(
    stroke: 0.75pt,
    align: center,
  )
  
  // Página de título
  [
    #set-numbering(none)
    #grid(
      columns: (100%),
      rows: (33%, 34%, 33%),
      {
        // Top section
        grid(
          columns: (100%),
          rows: (auto),
          gutter: 3em,
          align(center)[#image("assets/logo_unap.png", width: 30%)],
          align(center)[
            #text(weight: "bold")[FACULTAD DE INGENIERÍA Y ARQUITECTURA]
          ],
        )
      },
      {
        // Middle section (title and details)
        grid(
          columns: (100%),
          rows: (auto),
          gutter: 1em,
          par(justify: true, leading: 0.5em)[#set text(hyphenate: false); #text(titulo, weight: "bold", size: 14pt)],
          v(5em),
          align(left)[#text("Trabajo de memoria para obtener el título de:", weight: "bold")],
          align(center)[#text(tipo_ingeniero, weight: "bold")],
          v(10em),
          {
            align(right)[#set par(leading: 0.5em); #text("Alumno:", weight: "bold") #text(autor, weight: "bold")]
            v(1em)
            align(right)[#text("Profesor Patrocinante:", weight: "bold") #text(profesor_guia, weight: "bold")]
          },
        )
      },
      {
        // Bottom section
        align(center + bottom)[
          IQUIQUE - CHILE\
          #fecha
        ]
      }
    )
  ]
  pagebreak()
  show heading: i-figured.reset-counters.with(extra-kinds: ("Anexo",))
  show figure: i-figured.show-figure
  show figure: i-figured.show-figure.with(extra-prefixes: (Anexo: "Anexo:"))
  show math.equation: i-figured.show-equation.with(zero-fill: false)

  body
}

// Función para ecuaciones numeradas por capítulo
#let numbered-equation(equation) = {
  let chapter = counter(heading).at(0)
  let eq_number = counter("equation")
  set math.equation(numbering: n => {
    let chapter_str = chapter.to-string()
    let eq_str = eq_number.at(0).to-string()
    "(" + chapter_str + "." + eq_str + ")"
  })
  block(equation)
}

// Función para referencias ISO 690
#let reference(
  tipo: "libro",
  autores: "",
  titulo: "",
  edicion: none,
  lugar: "",
  editorial: "",
  fecha: "",
  paginas: none,
  isbn: none,
  url: none,
  fecha_consulta: none,
) = {
  let ref = ""
  if tipo == "libro" {
    ref = autores + ". " + titulo + ". "
    if edicion != none { ref += edicion + " ed. " }
    ref += lugar + ": " + editorial + ", " + fecha + "."
    if paginas != none { ref += " pp. " + paginas + "." }
    if isbn != none { ref += " ISBN " + isbn + "." }
  }
  [#ref]
}

#let pretextual-heading(body, is_center: false) = {
  set heading(
    numbering: none,
    outlined: false,
    bookmarked: true
  )
  set text(
    size: 0.714em,
    weight: "bold"
  )
  if is_center {
    align(center)[#heading(body)]
  } else {
    heading(body)
  }
} 
