#let title-divider = {
  show divider: set line(stroke: (thickness: 0.125em))
  let line-padding = -1.25em
  v(line-padding)
  divider()
  v(line-padding)
}

#let contact(name, email) = [#name #sym.dot #link("mailto:" + email)]

#let apply-common-styles(body) = {
  show ref: it => {
    if it.element != none {
      return strong(emph(it))
    }
    return it
  }

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
  body
}

#let problem(
  title,
  subtitle: none,
  padding: 0.25em,
  radius: 4pt,
  stroke: 1pt,
  body,
) = {
  title = str(title)
  subtitle = if subtitle != none { str(subtitle) } else { none }

  let problem-box = context {
    // Measure bare text height to size vertical line
    let title = strong(title)
    let title-box-height = measure(box(height: 1em + padding)).height

    let title-content = {
      title
      if subtitle != none {
        h(padding)
        box(
          baseline: measure(title).height / 2,
          line(
            length: 100%,
            angle: 90deg,
          ),
        )
        h(padding)
        subtitle
      }
    }

    let height-single-line = (
      measure(body).height < title-box-height
        and measure(box(width: 100% - measure(body).width)).width > 0pt
    )

    // Title box with baseline aligned to inner text
    let title-block-radius = if height-single-line {
      radius
    } else {
      (top-left: radius, bottom-right: radius)
    }
    let title-block = rect(
      height: title-box-height,
      radius: title-block-radius,
      stroke: stroke,
      inset: (
        left: padding,
        right: padding,
        top: if subtitle == none { padding } else { 0pt },
        bottom: 0pt,
      ),
      outset: 0pt,
      title-content,
    )

    box(
      height: if height-single-line {
        title-box-height
      } else { auto },
      width: 100%,
      radius: radius,
      stroke: stroke,
      inset: padding,
      {
        set par(justify: true)
        // Render inline with body. Both share baseline.
        place(dy: -padding, dx: -padding, title-block)
        h(measure(title-block).width)
        body
      },
    )
  }

  [
    #figure(
      kind: "Problem",
      supplement: [Problem],
      [
        #set align(left)
        #set enum(numbering: "(A.1)")
        #show heading: it => {
          set text(size: 0.75em)
          it.body
        }
        #problem-box
      ],
    )
    #label("problem:" + title)
  ]
}
