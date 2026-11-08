#import "components.typ"

/// This is a template for academic laboratory reports, featuring a title page with relevant
/// course information.
///
/// -> content
#let lab-report(
  /// The title of the laboratory report.
  /// -> str | content
  title: none,
  /// An optional subtitle of the laboratory report.
  /// -> str | content
  subtitle: none,
  /// An array of dictionaries of the author(s)' names and emails.
  /// -> array
  authors: none,
  /// An optional dictionary of the instructor's name and email.
  /// -> dictionary
  instructor: none,
  /// An optional array of dictionaries of the teaching assistant(s)' names and emails.
  /// -> array
  teaching-assistants: none,
  /// The date of the report. By default it is the current date.
  /// -> datetime
  date: datetime.today(),
  /// An optional abstract of the report.
  /// -> str | content
  abstract: none,
  /// An optional array of keywords of the report
  /// -> array
  keywords: (),
  /// An optional dictionary of text styles used in this document.
  /// The available styles are: `text`, `title`, `subtitle`, `page-header`, `heading`,
  /// `raw`, `math`, and `link`.
  /// You can define them in ways like such:
  /// + ```typc it => underline(strong(it))```
  /// + ```typc text.with(font: "Comic Relief")```
  /// -> dictionary
  styles: auto,
  body,
) = {
  assert(
    (type(title) == content and title != [])
      or (type(title) == str and title.trim().len() > 0),
    message: "[ERROR] Can't have an empty title",
  )
  assert(
    authors != none,
    message: "[ERROR] Provide authors for this laboratory report",
  )
  assert(
    type(date) == datetime,
    message: "[ERROR] type(" + str(type(date)) + ") != datetime",
  )

  set document(
    title: title,
    author: authors.map(author => author.name),
    keywords: keywords,
    date: date,
  )
  date = date.display("[month repr:long] [day padding:none], [year]")
  // Set default text styles
  let default-styles = (
    text: text.with(),
    title: text.with(size: 2em, weight: "bold"),
    subtitle: text.with(size: 0.85em),
    page-header: text.with(size: 0.75em),
    heading: text.with(),

    raw: text.with(),
    math: text.with(),
    link: it => underline(text(fill: blue, it)),
  )

  styles = if styles == auto { default-styles } else { default-styles + styles }

  show: styles.text

  // [BEGIN] Title Page
  v(1fr)
  (styles.subtitle)(grid(
    columns: (auto, 1fr),
    align: (left, right),
    subtitle, date,
  ))
  components.title-divider
  (styles.title)(title)
  components.title-divider
  grid(
    columns: (1fr, auto),
    align: (left, right),
    {
      show: styles.subtitle
      if instructor != none or teaching-assistants != none {
        underline(strong(if authors.len() > 1 { "Authors" } else { "Author" }))
        linebreak()
      }
      for author in authors {
        components.contact(author.name, author.email)
        linebreak()
      }
    },
    {
      show: styles.subtitle
      if instructor != none {
        underline[*Instructor*]
        linebreak()
        components.contact(instructor.name, instructor.email)
        linebreak()
      }
      if instructor != none and teaching-assistants != none {
        linebreak()
      }

      if teaching-assistants != none {
        underline(strong(
          if teaching-assistants.len() > 1 {
            "Teaching Assistants"
          } else {
            "Teaching Assistant"
          },
        ))
        linebreak()
        for ta in teaching-assistants {
          components.contact(ta.name, ta.email)
          linebreak()
        }
      }
    },
  )
  v(1fr)
  align(center, box(width: 90%, align(left, {
    if abstract != none {
      strong[#underline[Abstract:] ]
      abstract
    }
    if abstract != none and keywords.len() > 0 {
      linebreak()
      linebreak()
    }
    if keywords.len() > 0 {
      strong[#underline[Keywords:] ]
      keywords.map(keyword => emph(keyword)).join(", ")
    }
  })))
  pagebreak()
  // [END] Title Page
  counter(page).update(1)
  set page(
    header: context block(
      width: 100%,
      inset: (bottom: 0.5em),
      stroke: (bottom: 1pt + black),
      {
        (styles.page-header)(grid(
          columns: (auto, 1fr),
          align: (left, right),
          {
            title
            linebreak()
            subtitle
          },
          {
            counter(page).display("1 of 1", both: true)
            linebreak()
            date
          },
        ))
      },
    ),
  )

  set par(justify: true)
  show link: it => (styles.link)(it)
  show math.equation: styles.math
  show heading: styles.heading
  show raw: styles.raw

  components.apply-common-styles(body)
}

/// This is a template for academic assignments.
///
/// -> content
#let assignment(
  /// The title of the laboratory report.
  /// -> str | content
  title: none,
  /// The course that the assignment is for.
  /// -> str | content
  course: none,
  /// The author's name
  /// -> str | content
  author: none,
  /// The instructor's name
  /// -> str | content
  instructor: none,
  /// The date of the report. By default it is the current date.
  /// -> datetime
  date: datetime.today(),
  /// An optional dictionary of text styles used in this document.
  /// The available styles are: `text`, `title`, `page-header`, `heading`,
  /// `raw`, `math`, and `link`.
  /// You can define them in ways like such:
  /// + ```typc it => underline(strong(it))```
  /// + ```typc text.with(font: "Comic Relief")```
  /// -> dictionary
  styles: auto,
  body,
) = {
  let valid-content = it => (
    type(it) != none and (type(it) == content and it != [])
      or (type(it) == str and it.trim().len() > 0)
  )
  assert(
    valid-content(title),
    message: "[ERROR] Provide a title for this assignment",
  )
  assert(
    valid-content(author),
    message: "[ERROR] Provide an author for this assignment",
  )
  assert(
    valid-content(instructor),
    message: "[ERROR] Provide an instructor for this assignment",
  )
  assert(
    valid-content(course),
    message: "[ERROR] Provide a course for this assignment",
  )
  assert(
    type(date) == datetime,
    message: "[ERROR] type(" + str(type(date)) + ") != datetime",
  )

  set document(
    title: title,
    author: author,
    date: date,
  )
  date = date.display("[month repr:long] [day padding:none], [year]")

  // Set default text styles
  let default-styles = (
    text: text.with(),
    title: text.with(size: 1.5em, weight: "bold"),
    page-header: text.with(size: 0.75em),
    heading: text.with(),

    raw: text.with(),
    math: text.with(),
    link: it => underline(text(fill: blue, it)),
  )

  styles = if styles == auto { default-styles } else { default-styles + styles }

  show: styles.text
  show math.equation: styles.math
  show heading: styles.heading
  show raw: styles.raw

  set page(
    numbering: "1 of 1",
    header: block(
      width: 100%,
      inset: (bottom: 0.5em),
      stroke: (bottom: 1pt + black),
      {
        (styles.page-header)(grid(
          columns: (1fr, auto, 1fr),
          align: (left, center, right),
          {
            author
            linebreak()
            date
          },
          if counter(page).get().first() == 1 { (styles.title)(title) } else [],
          {
            instructor
            linebreak()
            course
          },
        ))
      },
    ),
  )

  components.apply-common-styles(body)
}
