// Column CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Raleway. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/column
#set page(fill: rgb("#ffffff"))

#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). Uncolored,
// ATS-safe: no filled panels, text is ink on white, the accent tints only the
// masthead rule and the section labels/rules. Default accent a professional blue.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale from body B = 10pt (standard rule 2), defined ONCE.
#let display-size = 20pt // ~2.0 x B - the name (masthead)
#let subhead-size = 11.5pt // ~1.15 x B - the profession line
#let body-size = 10pt // B
#let label-size = 9pt // ~0.9 x B - section labels (the one uppercase + tracked role)
#let meta-size = 8.2pt // ~0.82 x B - dates, location, contact, level, fine print

// Document shell: set-rules + PDF metadata. A full-width masthead sits above an
// uncolored two-column grid (narrow rail + wide main), both composed by wrapSections.
// Raleway is the single family (standard rule 1); regular + semibold + bold.
#let column-cv(
  author: "",
  font: "Raleway",
  font-size: 10pt,
  paper: "a4",
  margin: 1.4cm,
  leading: 0.62em,
  lang: "en",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  // Ragged-right, no hyphenation: the narrow main + rail columns otherwise break words
  // ("architec-ture", "Post-gres") on nearly every line.
  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: false)
  set page(margin: margin, paper: paper)
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  body
}

// Masthead (full width, above the two columns): name (bold) + profession (muted),
// then an accent rule. Guarded so an empty CV shows no floating rule.
#let masthead(author: "", profession: "", accent-color: "#2b4c7e") = {
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  if has-name or has-prof {
    block(above: 0pt, below: 1.1em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.4em, justify: false)
      if has-name { text(size: display-size, weight: "bold", fill: ink, author) }
      if has-prof {
        if has-name { v(3pt) }
        text(size: subhead-size, weight: "regular", fill: muted, profession)
      }
      v(6pt)
      line(length: 100%, stroke: 1pt + rgb(accent-color))
    })
  }
}

// Section label (rail + main share it): accent UPPERCASE + tracking over a thin
// accent rule. Sticky so a label never orphans at a page bottom.
#let cv-section(title, accent-color: "#2b4c7e") = {
  block(above: 1.2em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: rgb(accent-color), upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.6pt + rgb(accent-color))
  })
}

// Rail contact: a CONTACT label then one muted line per item (email, phone,
// location, social), a quiet legible stack.
#let rail-contact(items, accent-color: "#2b4c7e") = {
  cv-section("Contact", accent-color: accent-color)
  // sectionSpacing must not leak into the contact rows (explicit below controls them).
  set block(spacing: 0pt)
  set par(spacing: 0pt)
  for item in items {
    block(above: 0pt, below: 4pt, breakable: false, {
      set text(size: meta-size, fill: muted)
      item
    })
  }
}

// Rail language: language with the proficiency level (muted) STACKED beneath it.
// Stacked, not a two-column row: in the narrow rail a long level would squeeze the
// language onto broken, hyphenated lines. No hyphenation on the language name.
#let column-language(language: "", level: "") = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    set text(hyphenate: false)
    if not is-blank(language) { text(fill: ink, language) }
    if not is-blank(level) {
      if not is-blank(language) { v(1pt) }
      text(size: meta-size, fill: muted, level)
    }
  })
}

// Rail credential (certifications / awards in the narrow rail): compact stacked -
// name (semibold ink), then issuer + date muted beneath on one line, dot-separated.
// No bullets and no wide date grid, so it fills the rail cleanly without cramping.
#let column-rail-cred(name: "", issuer: "", date: "") = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    set text(hyphenate: false)
    if not is-blank(name) { text(weight: "semibold", fill: ink, name) }
    let meta = (issuer, date).filter(v => not is-blank(v)).join(text(fill: muted)[ #sym.dot.c ])
    if not is-blank(meta) { v(2pt); text(size: meta-size, fill: muted, meta) }
  })
}

// Main entry: semibold-ink title leads with a muted subtitle, dates right; location
// and an optional URL meta line below; then the body. No mid-word hyphenation on the
// title line (wraps at spaces); date top-aligned beside the first title line.
#let column-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
  // No explicit above/below: the ENTRY-to-entry gap rides the ambient block spacing,
  // which the sectionSpacing knob scales (tight 0.9em < default 1.2em < relaxed 1.5em).
  // The reset below fixes the INTERNAL header->body gap to the explicit v() so the knob
  // never balloons or inverts it.
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    block(sticky: true, breakable: false, {
      set par(justify: false)
      set text(hyphenate: false)
      grid(
        columns: (1fr, auto),
        align: (left + top, right + top),
        column-gutter: 0.75em,
        {
          if not is-blank(title) { text(weight: "semibold", fill: ink, title) }
          if not is-blank(title) and not is-blank(subtitle) { text(fill: muted)[ #sym.dash.en ] }
          if not is-blank(subtitle) { text(fill: muted, subtitle) }
        },
        if not is-blank(dates) { text(size: meta-size, fill: muted, dates) } else { [] },
      )
      if not is-blank(location) {
        v(3pt)
        text(size: meta-size, fill: muted, location)
      }
      if not is-blank(meta) {
        v(3pt)
        text(size: meta-size, fill: muted, meta)
      }
    })
    if not is-blank(body) {
      v(3.5pt)
      block(spacing: 0pt, { set text(fill: ink); body })
    }
  })
}

// Two-column body: a narrow rail (contact, skills, languages) beside the wide main
// column (summary, experience, ...). A breakable grid so a long main paginates. A
// thin full-height divider (grid.vline, redrawn on every page the grid spans) makes
// the rail read as a deliberate column, so when it empties on page 2+ the left is a
// clean empty rail rather than a stranded dead margin.
#let cv-layout(rail: [], main: [], gap: 20pt, accent-color: "#2b4c7e") = {
  grid(
    columns: (30%, 1fr),
    column-gutter: gap,
    rail,
    // The divider is the LEFT BORDER of the main column - a lightened tint of the
    // single accent (never a separate grey), with a left inset so it never touches the
    // text. It spans the main content height and repaints on every page, so when the
    // rail empties on page 2+ the divider still reads as a deliberate column edge.
    block(
      width: 100%,
      inset: (left: 16pt),
      stroke: (left: 0.8pt + rgb(accent-color).lighten(55%)),
      main,
    ),
  )
}



#show: column-cv.with(
  author: "Jane Smith",
  font: "Raleway",
  font-size: 10pt,
  paper: "a4",
  margin: 1.4cm,
  leading: 0.62em,
  lang: "en",
)

#masthead(author: "Jane Smith", profession: "Director of Product", accent-color: "#2b4c7e")
#cv-layout(
  rail: [
#rail-contact((
  link("mailto:jane.smith@example.com")[jane.smith\@example.com],
  [+1 (415) 555 0148],
  [San Francisco, CA],
), accent-color: "#2b4c7e")

#cv-section("Skills", accent-color: "#2b4c7e")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market, Stakeholder Management, Figma, Python, Experimentation

#cv-section("Languages", accent-color: "#2b4c7e")

#column-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#column-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#column-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#2b4c7e")

#column-rail-cred(
  name: "Certified Scrum Product Owner (CSPO)",
  issuer: "Scrum Alliance",
  date: "January 2020",
)

#column-rail-cred(
  name: "Pragmatic Institute Certified (PMC-III)",
  issuer: "Pragmatic Institute",
  date: "January 2019",
)
#cv-section("Awards", accent-color: "#2b4c7e")

#column-rail-cred(
  name: "Product Leader of the Year",
  issuer: "Meridian Labs",
  date: "January 2023",
)],
  main: [
#cv-section("Summary", accent-color: "#2b4c7e")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#2b4c7e")

#column-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)

#column-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)
#cv-section("Experience", accent-color: "#2b4c7e")

#column-entry(
  title: "Director of Product",
  subtitle: "Meridian Labs",
  dates: "March 2021 - Present",
  location: "",
  meta: "",
  [
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
- Built and led a cross-functional org of 24 (PMs, designers, analysts), instituting a quarterly OKR cadence that lifted on-time delivery from 61% to 92%.
],
)

#column-entry(
  title: "Senior Product Manager",
  subtitle: "Northwind Technologies",
  dates: "January 2018 - February 2021",
  location: "",
  meta: "",
  [
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
- Ran continuous discovery with 120+ customer interviews, translating findings into a roadmap that raised NPS from 22 to 48.
],
)

#column-entry(
  title: "Product Manager",
  subtitle: "Brightwave",
  dates: "June 2015 - December 2017",
  location: "",
  meta: "",
  [
- Shipped a mobile checkout redesign that lifted conversion 18% and reduced cart abandonment by a third.
- Defined the north-star metric and instrumentation for a 2M-user product, replacing vanity metrics with retention cohorts.
],
)

#column-entry(
  title: "Associate Product Manager",
  subtitle: "Optic Retail Group",
  dates: "August 2013 - May 2015",
  location: "",
  meta: "",
  [
- Managed the roadmap for the loyalty programme, growing enrolled members from 90k to 310k in 18 months.
- Automated weekly reporting with SQL and Looker, saving the team 12 hours a week and improving decision speed.
- Ran 30+ pricing and merchandising experiments, standardising the win/loss review that became company practice.
],
)

#column-entry(
  title: "Business Analyst",
  subtitle: "Foundry Studio",
  dates: "January 2012 - July 2013",
  location: "",
  meta: "",
  [
- Built financial and demand models informing a \$40M annual budget across three regional markets.
- Delivered an executive dashboard that surfaced margin leakage, recovering \$2.1M in the first year.
- Supported the design of a post-merger integration plan spanning operations, data, and reporting.
],
)
#cv-section("Projects", accent-color: "#2b4c7e")

#column-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)

#column-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)],
  accent-color: "#2b4c7e",
)
