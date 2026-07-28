// Refined CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Source Serif 4. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/refined
#set page(fill: rgb("#ffffff"))


#let is-blank(v) = v == none or v == "" or v == []

#let refined-cv(
  author: "",
  location: "",
  email: "",
  phone: "",
  social-links: (), // Array of (url, display-text) tuples
  accent-color: "#3a5a63",
  font: "Source Serif 4",
  font-size: 10pt,
  paper: "a4",
  margin: 2cm,
  leading: 0.62em,
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

  let muted = rgb("#5a5a55")
  let c = rgb(accent-color)

  show link: set text(fill: muted)

  // Glue every entry header (the reading-order title/organisation/date grid) to
  // the bullets that follow it: a sticky block can never be the last thing on a
  // page, so a header at a page bottom is carried to the next page WITH its
  // first following line instead of being orphaned. The bullet lists stay
  // breakable, so long entries still flow across pages. Entry headers are the
  // template's only grids (name, contact, masthead rule and section labels are
  // plain blocks), so this targets exactly them.
  show grid: it => block(sticky: true, it)

  // Masthead: name in a confident serif, muted contact line, and a single thin
  // accent rule that divides the head from the body - the editorial signature.
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
  // spacing inside it so the only vertical gaps are the explicit v() below.
  // Relying on default block flow stacked 1.2em onto these gaps (name/contact
  // too tight, rule detached), so control it here. When the name is blank the
  // name line AND its dividing rule collapse, so an email-only header sits at
  // the top with no reserved slot and no rule floating over a lone contact line.
  let contact-line = text(size: 8.5pt, fill: muted, tracking: 0.2pt, contact-items.filter(x => x != none).join("  ·  "))
  if is-blank(author) {
    block(above: 0pt, below: 1em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.5em)
      contact-line
    })
  } else {
    block(above: 0pt, below: 1em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.5em)
      text(size: 23pt, weight: "semibold", tracking: 0.3pt, fill: rgb("#1a1a1a"), author)
      v(0.6em)
      contact-line
      v(0.7em)
      line(length: 100%, stroke: 0.8pt + c)
    })
  }

  body
}

// Section header: serif small-caps in the single accent above a hairline in a
// light neutral. Sticky so a label is never left orphaned at a page bottom -
// it travels to the next page with the entry that follows it.
#let cv-section(title, accent-color: "#3a5a63") = {
  block(above: 1.2em, below: 0.9em, sticky: true, {
    // Neutralise ambient block/par spacing so the label -> rule gap is exactly the
    // v() below, not v() stacked on top of the default 1.2em block spacing.
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    text(
      size: 11pt,
      weight: "semibold",
      tracking: 0.6pt,
      fill: rgb(accent-color),
      smallcaps(title),
    )
    v(0.3em)
    line(length: 100%, stroke: 0.4pt + rgb("#c9c7c0"))
  })
}



#show: refined-cv.with(
  author: "Jane Smith",
  email: "jane.smith@example.com",
  phone: "+1 (415) 555 0148",
  location: "San Francisco, CA",
  social-links: (),
  accent-color: "#3a5a63",
  font: "Source Serif 4",
  font-size: 10pt,
  paper: "a4",
  margin: 2cm,
  leading: 0.62em,
  lang: "en",
)


#cv-section("Summary", accent-color: "#3a5a63")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#3a5a63")

#{
  let cells = ([#strong[Stanford University]], [#text(fill: rgb("#5a5a55"))[M.S. in Management Science & Engineering]], [#text(fill: rgb("#5a5a55"))[September 2010 - June 2012]])
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
  let cells = ([#strong[University of California, Berkeley]], [#text(fill: rgb("#5a5a55"))[B.A. in Economics, with Honours]], [#text(fill: rgb("#5a5a55"))[September 2006 - June 2010]])
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
#cv-section("Experience", accent-color: "#3a5a63")

#{
  let cells = ([#strong[Director of Product]], [#text(fill: rgb("#5a5a55"))[Meridian Labs]], [#text(fill: rgb("#5a5a55"))[March 2021 - Present]])
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

#{
  let cells = ([#strong[Senior Product Manager]], [#text(fill: rgb("#5a5a55"))[Northwind Technologies]], [#text(fill: rgb("#5a5a55"))[January 2018 - February 2021]])
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
#cv-section("Projects", accent-color: "#3a5a63")

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
#cv-section("Skills", accent-color: "#3a5a63")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market

#cv-section("Languages", accent-color: "#3a5a63")

#strong[English]: Native, #strong[Spanish]: Professional working proficiency, #strong[Mandarin]: Conversational
#cv-section("Certifications", accent-color: "#3a5a63")

#{
  let cells = ([#strong[Certified Scrum Product Owner (CSPO)]], [#text(fill: rgb("#5a5a55"))[Scrum Alliance]], [#text(fill: rgb("#5a5a55"))[January 2020]])
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
  let cells = ([#strong[Pragmatic Institute Certified (PMC-III)]], [#text(fill: rgb("#5a5a55"))[Pragmatic Institute]], [#text(fill: rgb("#5a5a55"))[January 2019]])
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
#cv-section("Awards", accent-color: "#3a5a63")

#{
  let cells = ([#strong[Product Leader of the Year]], [#text(fill: rgb("#5a5a55"))[Meridian Labs]], [#text(fill: rgb("#5a5a55"))[January 2023]])
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
