// Minimal CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Inter. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/minimal
#set page(fill: rgb("#ffffff"))


#let is-blank(v) = v == none or v == "" or v == []

#let minimal-cv(
  author: "",
  location: "",
  email: "",
  phone: "",
  social-links: (), // Array of (url, display-text) tuples
  accent-color: "#334155",
  font: "Inter",
  font-size: 10pt,
  paper: "a4",
  margin: 3cm,
  leading: 0.65em,
  lang: "en",
  body,
) = {
  // Handle both string and content for author (content is used for diff preview)
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(
    font: font,
    size: font-size,
    fill: rgb("#141414"),
    lang: lang,
    ligatures: false,
    hyphenate: false,
  )

  set page(
    margin: margin,
    paper: paper,
  )

  set par(justify: false, leading: leading)

  let muted = rgb("#5b5b5b")

  show link: set text(fill: muted)

  // Keep an entry header (the reading-order title/organisation/location/date
  // grid) glued to the bullets that follow it: a sticky block can never be the
  // last thing on a page, so it is carried to the next page WITH its first
  // bullet instead of being orphaned. Only the header sticks; the bullet list
  // stays breakable, so long entries still flow across pages normally. Entry
  // headers are the template's only grids (the name and contact lines are
  // plain blocks), so this targets exactly them.
  show grid: it => block(sticky: true, it)

  // Contact line: small, muted, directly beneath the name.
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

  // Masthead built as one spacing-controlled block: neutralise ambient block/par
  // spacing so the only vertical gap is the explicit v() below (name -> contact
  // air). Default block flow collapsed the name/contact gap too tight; control
  // it here. When the name is blank the name line collapses and the header is
  // the lone contact line, no reserved slot.
  let contact-line = text(
    size: 8.5pt,
    fill: muted,
    tracking: 0.2pt,
    contact-items.filter(x => x != none).join("  ·  "),
  )
  if is-blank(author) {
    block(above: 0pt, below: 1.2em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt)
      contact-line
    })
  } else {
    block(above: 0pt, below: 1.2em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt)
      text(
        size: 23pt,
        weight: "semibold",
        tracking: 0.4pt,
        fill: rgb(accent-color),
        author,
      )
      v(0.6em)
      contact-line
    })
  }

  body
}

// Section header: small uppercase tracked label above a thin accent hairline.
// Neutralise ambient block/par spacing so the label -> hairline gap is exactly
// the tight v() below, not v() stacked on top of the default block spacing.
#let cv-section(title, accent-color: "#334155") = {
  block(above: 1.15em, below: 0.9em, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    text(
      size: 8.5pt,
      weight: "semibold",
      tracking: 1.8pt,
      fill: rgb("#141414"),
      upper(title),
    )
    v(0.28em)
    line(length: 100%, stroke: 0.5pt + rgb(accent-color))
  })
}



#show: minimal-cv.with(
  author: "Jane Smith",
  email: "jane.smith@example.com",
  phone: "+1 (415) 555 0148",
  location: "San Francisco, CA",
  social-links: (),
  accent-color: "#334155",
  font: "Inter",
  font-size: 10pt,
  paper: "a4",
  margin: 3cm,
  leading: 0.65em,
  lang: "en",
)


#cv-section("Summary", accent-color: "#334155")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#334155")

#{
  let cells = ([#strong[Stanford University]], [#text(fill: rgb("#5b5b5b"))[M.S. in Management Science & Engineering]], [#text(fill: rgb("#5b5b5b"))[September 2010 - June 2012]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (auto, 1fr),
    align: (left + top, right + top),
    column-gutter: if right-aligned.len() > 0 { 0.6em } else { 0pt },
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

#{
  let cells = ([#strong[University of California, Berkeley]], [#text(fill: rgb("#5b5b5b"))[B.A. in Economics, with Honours]], [#text(fill: rgb("#5b5b5b"))[September 2006 - June 2010]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (auto, 1fr),
    align: (left + top, right + top),
    column-gutter: if right-aligned.len() > 0 { 0.6em } else { 0pt },
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}
#cv-section("Experience", accent-color: "#334155")

#{
  let cells = ([#strong[Director of Product]], [#text(fill: rgb("#5b5b5b"))[Meridian Labs]], [#text(fill: rgb("#5b5b5b"))[March 2021 - Present]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (auto, 1fr),
    align: (left + top, right + top),
    column-gutter: if right-aligned.len() > 0 { 0.6em } else { 0pt },
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.

#{
  let cells = ([#strong[Senior Product Manager]], [#text(fill: rgb("#5b5b5b"))[Northwind Technologies]], [#text(fill: rgb("#5b5b5b"))[January 2018 - February 2021]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (auto, 1fr),
    align: (left + top, right + top),
    column-gutter: if right-aligned.len() > 0 { 0.6em } else { 0pt },
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
#cv-section("Projects", accent-color: "#334155")

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
    columns: (auto, 1fr),
    align: (left + top, right + top),
    column-gutter: if right-aligned.len() > 0 { 0.6em } else { 0pt },
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
    columns: (auto, 1fr),
    align: (left + top, right + top),
    column-gutter: if right-aligned.len() > 0 { 0.6em } else { 0pt },
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.

#block(above: 0.5em)[Analytics, SQL]
#cv-section("Skills", accent-color: "#334155")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research

#cv-section("Languages", accent-color: "#334155")

#strong[English]: Native, #strong[Spanish]: Professional working proficiency, #strong[Mandarin]: Conversational
#cv-section("Certifications", accent-color: "#334155")

#{
  let cells = ([#strong[Certified Scrum Product Owner (CSPO)]], [#text(fill: rgb("#5b5b5b"))[Scrum Alliance]], [#text(fill: rgb("#5b5b5b"))[January 2020]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (auto, 1fr),
    align: (left + top, right + top),
    column-gutter: if right-aligned.len() > 0 { 0.6em } else { 0pt },
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}

#{
  let cells = ([#strong[Pragmatic Institute Certified (PMC-III)]], [#text(fill: rgb("#5b5b5b"))[Pragmatic Institute]], [#text(fill: rgb("#5b5b5b"))[January 2019]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (auto, 1fr),
    align: (left + top, right + top),
    column-gutter: if right-aligned.len() > 0 { 0.6em } else { 0pt },
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
}
