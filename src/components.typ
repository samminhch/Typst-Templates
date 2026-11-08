#let title-divider = {
  show divider: set line(stroke: (thickness: 0.125em))
  let line-padding = -1.25em
  v(line-padding)
  divider()
  v(line-padding)
}

#let contact(name, email) = [
  #name #sym.dot #link("mailto:" + email)  
]

#let apply-common-styles(body) = {
  show ref: it => {
    if it.element != none {
      return strong(emph(it))
    }
    return it
  }

  show link: it => (styles.link)(it)

  // Only number labeled math equations
  show math.equation: it => {
    if it.block and not it.has("label") and it.numbering != none [
      #counter(math.equation).update(v => v - 1)
      #math.equation(it.body, block: true, numbering: none)
    ] else {
      it
    }
  }

  // Figure caption styling
  show figure.caption: it => context {
    set text(size: 0.75 * text.size)
    box(width: 75%, {
      strong(it.supplement)
      if it.counter != none [ *#it.counter.display()*]
      if measure(it.body).width != 0pt [*:* #it.body]
    })
  }
  show figure.where(kind: table): set figure.caption(position: top)

  // Sectional Heading
  set figure(numbering: (..num) => context {
    let headings = query(selector(heading).before(here()))
    let equation-number = num.pos().first()
    if headings != () and headings.last().numbering != none {
      numbering("1.1", counter(heading).get().first(), equation-number)
    } else {
      numbering("1", equation-number)
    }
  })
  show heading.where(level: 1): it => {
    if it.numbering != none {
      counter(figure.where(kind: table)).update(0)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: raw)).update(0)
    }
    it
  }
}
