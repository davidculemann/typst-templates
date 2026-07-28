// Print CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Nunito Sans. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Derived from clean-print-cv (https://github.com/guillermodotn/clean-print-cv),
// (c) its authors, used under MIT. That licence continues to apply,
// so this file is not MIT-0: keep this notice if you redistribute the template
// itself. A CV you write with it is your own work.
// Modified from the original by JobSprout: restructured for a section registry,
// re-typeset to a fixed size scale, and reworked for empty-field handling.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/print
#set page(fill: rgb("#ffffff"))


#let is-blank(v) = v == none or v == "" or v == []

// Derives the lighter of the two accent tones from the single user accent: the
// same hue lifted toward white. Drives the section underrules and the entry
// dates, so the darker accent (name, section labels, masthead rule) and this
// lighter tone are ONE control, never two. Reads as a mid gray in grayscale, a
// step lighter than the darker tone, so the two-tone hierarchy survives a
// black-and-white print.
#let lighten-tone(hex) = rgb(hex).lighten(32%)

#let print-cv(
  author: "",
  location: "",
  email: "",
  phone: "",
  social-links: (), // Array of (url, display-text) tuples
  accent-color: "#2b4c7e",
  font: "Nunito Sans",
  font-size: 10pt,
  paper: "a4",
  margin: 1.8cm,
  leading: 0.6em,
  lang: "en",
  body,
) = {
  // Handle both string and content for author (content is used for diff preview)
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(
    font: font,
    size: font-size,
    fill: rgb("#1a1a1a"),
    lang: lang,
    ligatures: false,
    hyphenate: false,
  )

  set page(
    margin: margin,
    paper: paper,
  )

  set par(justify: false, leading: leading)

  let heading-tone = rgb(accent-color)
  let muted = rgb("#5e5e5e")

  show link: set text(fill: muted)

  // Glue every entry header (the reading-order title/organisation/date grid) to
  // the bullets that follow it: a sticky block can never be the last thing on a
  // page, so a header at a page bottom is carried to the next page WITH its
  // first bullet instead of being orphaned. Only the entry grids stick; the
  // centred name and contact lines are plain blocks and the bullet lists stay
  // breakable, so long entries still flow across pages normally.
  show grid: it => block(sticky: true, it)

  let contact-items = ()
  if phone != "" and phone != none { contact-items.push(phone) }
  if location != "" and location != none { contact-items.push(location) }
  if email != "" and email != none {
    if type(email) == str {
      contact-items.push(link("mailto:" + email)[#email])
    } else {
      contact-items.push(email)
    }
  }
  for social-link in social-links {
    let (url, display-text) = social-link
    if url != "" and url != none {
      let full-url = if url.starts-with("http") { url } else { "https://" + url }
      contact-items.push(link(full-url)[#display-text])
    }
  }

  // Masthead: a centred uppercase name in the darker accent, a hairline in the
  // same darker tone dividing it from a centred muted contact line. Print-first
  // - the head reads on weight, case and rule alone with no colour needed. Built
  // as one spacing-controlled block: neutralise ambient block/par spacing so the
  // only vertical gaps are the explicit v() (name -> rule, rule -> contact),
  // not those gaps stacked on top of the default 1.2em block flow. When the name
  // is blank the whole name line AND its dividing rule collapse, so an email-only
  // header sits at the top margin with no reserved slot and no rule floating over
  // a lone contact line.
  let contact-text = text(
    size: 8.5pt,
    fill: muted,
    tracking: 0.2pt,
    contact-items.filter(x => x != none).join("  ·  "),
  )
  if is-blank(author) {
    // No name: the block has no full-width child to stretch it, so centre the
    // whole block at the page level rather than align() inside a shrink-wrapped
    // block (which would leave the lone contact line stuck to the left margin).
    align(center, block(above: 0pt, below: 1.15em, breakable: false, contact-text))
  } else {
    // The 100%-width rule stretches this block to full width, so align(center)
    // inside centres the name and contact across the page.
    block(above: 0pt, below: 1.15em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt)
      align(center, text(size: 19pt, weight: "bold", tracking: 1.4pt, fill: heading-tone, upper(author)))
      v(0.45em)
      line(length: 100%, stroke: 0.8pt + heading-tone)
      v(0.55em)
      align(center, contact-text)
    })
  }

  body
}

// Section header: a bold uppercase label in the darker accent sitting directly
// above a hairline in the lighter derived tone - the print "chapter rule"
// rebuilt with hairlines only (no solid bar, so nothing depends on a colour
// fill). Sticky so a label is never orphaned at a page bottom; it travels to
// the next page with the entry that follows it.
#let cv-section(title, accent-color: "#2b4c7e") = {
  block(above: 1.1em, below: 0.9em, sticky: true, {
    // Neutralise ambient block/par spacing so the label -> rule gap is exactly
    // the tight v() below, not v() stacked on the default 1.2em block spacing.
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    text(
      size: 10pt,
      weight: "bold",
      tracking: 1.2pt,
      fill: rgb(accent-color),
      upper(title),
    )
    v(0.3em)
    line(length: 100%, stroke: 0.5pt + lighten-tone(accent-color))
  })
}



#show: print-cv.with(
  author: "Jane Smith",
  email: "jane.smith@example.com",
  phone: "+1 (415) 555 0148",
  location: "San Francisco, CA",
  social-links: (),
  accent-color: "#2b4c7e",
  font: "Nunito Sans",
  font-size: 10pt,
  paper: "a4",
  margin: 1.8cm,
  leading: 0.6em,
  lang: "en",
)


#cv-section("Summary", accent-color: "#2b4c7e")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#2b4c7e")

#{
  let cells = ([#strong[Stanford University]], [#text(fill: rgb("#5e5e5e"))[M.S. in Management Science & Engineering]], [#text(fill: lighten-tone("#2b4c7e"))[September 2010 - June 2012]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

#{
  let cells = ([#strong[University of California, Berkeley]], [#text(fill: rgb("#5e5e5e"))[B.A. in Economics, with Honours]], [#text(fill: lighten-tone("#2b4c7e"))[September 2006 - June 2010]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}
#cv-section("Experience", accent-color: "#2b4c7e")

#{
  let cells = ([#strong[Director of Product]], [#text(fill: rgb("#5e5e5e"))[Meridian Labs]], [#text(fill: lighten-tone("#2b4c7e"))[March 2021 - Present]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
- Built and led a cross-functional org of 24 (PMs, designers, analysts), instituting a quarterly OKR cadence that lifted on-time delivery from 61% to 92%.

#{
  let cells = ([#strong[Senior Product Manager]], [#text(fill: rgb("#5e5e5e"))[Northwind Technologies]], [#text(fill: lighten-tone("#2b4c7e"))[January 2018 - February 2021]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
- Ran continuous discovery with 120+ customer interviews, translating findings into a roadmap that raised NPS from 22 to 48.
#cv-section("Projects", accent-color: "#2b4c7e")

#{
  let cells = ([#strong[Activation Engine]],)
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.

#block(above: 0.5em)[Product Strategy, Experimentation]

#{
  let cells = ([#strong[Insights Platform]],)
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.

#block(above: 0.5em)[Analytics, SQL]
#cv-section("Skills", accent-color: "#2b4c7e")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market

#cv-section("Languages", accent-color: "#2b4c7e")

#strong[English]: Native, #strong[Spanish]: Professional working proficiency, #strong[Mandarin]: Conversational
#cv-section("Certifications", accent-color: "#2b4c7e")

#{
  let cells = ([#strong[Certified Scrum Product Owner (CSPO)]], [#text(fill: rgb("#5e5e5e"))[Scrum Alliance]], [#text(fill: lighten-tone("#2b4c7e"))[January 2020]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

#{
  let cells = ([#strong[Pragmatic Institute Certified (PMC-III)]], [#text(fill: rgb("#5e5e5e"))[Pragmatic Institute]], [#text(fill: lighten-tone("#2b4c7e"))[January 2019]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}
#cv-section("Awards", accent-color: "#2b4c7e")

#{
  let cells = ([#strong[Product Leader of the Year]], [#text(fill: rgb("#5e5e5e"))[Meridian Labs]], [#text(fill: lighten-tone("#2b4c7e"))[January 2023]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}
