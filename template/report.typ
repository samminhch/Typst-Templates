#import "@local/templates:0.4.0": lab-report
#show: lab-report.with(
  title: "A Lab Report Title",
  subtitle: "Yippee!",
  authors: (
    (
      name: "John Doe",
      email: "john.doe@email.com",
    ),
    (
      name: "Jane Doe",
      email: "jane.doe@email.com",
    ),
  ),
  instructor: (
    name: "Mister Miss",
    email: "mr.mrs@email.com",
  ),
  teaching-assistants: (
    (
      name: "Johnson Doe",
      email: "johnson.doe@email.com",
    ),
    (
      name: "Jennifer Doe",
      email: "jennifer.doe@email.com",
    ),
  ),
  abstract: lorem(50),
  keywords: ("some", "keywords", "here"),
  styles: (
    text: text.with(size: 12pt, font: "Inter"),
    title: text.with(font: "DM Serif Display", size: 2em),
    heading: text.with(font: "Lora"),
  )
)

// This template isn't strict on header / figure numbering, so feel free to set it as you please!
#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")


= Section
#lorem(150)

$
  x = (-b plus.minus sqrt(b^2 -4 a c)) / (2 a)
$<equation:quadratic-formula>

#figure(
  table(
    columns: 2,
    $x$, $y$,
    $-2$, $1/4$,
    $-1$, $1/2$,
    $0$, $1$,
    $1$, $2$,
    $2$, $4$,
  ),
  caption: [Some table],
)

#figure(
  block(
    stroke: 1pt,
    inset: 0.5em,
  )[Include your own figures!\ Empty captions don't show the semicolon #emoji.face.hearts],
  caption: []
)

@equation:quadratic-formula #lorem(67)

== Sub-Section
#lorem(67)

= Another Section
#lorem(200)

#figure(
  ```c
  #include <stdio.h>
  int main() {
    puts("Hello, world!");
    return 0;
  }
  ```,
  caption: [A hello world `C` program]
)
