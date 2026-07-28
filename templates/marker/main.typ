// Marker CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Source Sans 3. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/marker
#set page(fill: rgb("#ffffff"))

#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent
// appears as a small filled TAB beside each section label (its distinct placement);
// labels are ink, body ink on white.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale from body B = 10.5pt (standard rule 2), defined ONCE.
#let display-size = 21pt // ~2.0 x B - the name
#let subhead-size = 12pt // ~1.14 x B - the profession line
#let body-size = 10.5pt // B
#let label-size = 10pt // ~0.95 x B - section labels (the one uppercase + tracked role)
#let meta-size = 8.6pt // ~0.82 x B - dates, location, contact, level, fine print

// Document shell: set-rules + PDF metadata. Source Sans 3 is the single family
// (standard rule 1); regular + semibold + bold.
#let marker-cv(
  author: "",
  font: "Source Sans 3",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.65em,
  lang: "en",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: false)
  set page(margin: margin, paper: paper)
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  body
}

// Masthead: name (bold) + profession (muted) + a quiet contact line, then an accent
// rule. Guarded so an empty CV shows no floating rule.
#let masthead(author: "", profession: "", contact: "", accent-color: "#2c5f6e") = {
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof or has-contact {
    block(above: 0pt, below: 1.1em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.45em, justify: false)
      // A short accent TAB to the left of the name, echoing the section-label tabs -
      // the accent's placement. No rule (the tabs carry the accent rhythm).
      if has-name {
        grid(
          columns: (auto, 1fr),
          column-gutter: 10pt,
          align: (left + horizon, left + horizon),
          box(width: 5pt, height: display-size * 0.8, radius: 1pt, fill: rgb(accent-color)),
          text(size: display-size, weight: "bold", fill: ink, author),
        )
      }
      if has-prof {
        if has-name { v(3pt) }
        text(size: subhead-size, weight: "regular", fill: muted, profession)
      }
      if has-contact {
        if has-name or has-prof { v(6pt) }
        text(size: meta-size, fill: muted, contact)
      }
    })
  }
}

// Section label (the signature): a small filled accent TAB to the left of the
// UPPERCASE label, then a faint hairline rule. The tab is the accent's placement;
// the label itself is ink. Sticky.
#let cv-section(title, accent-color: "#2c5f6e") = {
  block(above: 1.25em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    grid(
      columns: (auto, 1fr),
      column-gutter: 8pt,
      align: (left + horizon, left + horizon),
      box(width: 4pt, height: label-size, radius: 1pt, fill: rgb(accent-color)),
      text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: ink, upper(title)),
    )
    v(3pt)
    line(length: 100%, stroke: 0.5pt + rgb(accent-color).lighten(45%))
  })
}

// Entry: semibold-ink title + muted subtitle, dates right; location + optional URL
// meta below; then the body. Title line does not hyphenate; date top-aligned.
#let marker-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    block(sticky: true, breakable: false, {
      set par(justify: false)
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

// Language row: language left, level muted right.
#let marker-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: marker-cv.with(
  author: "Jane Smith",
  font: "Source Sans 3",
  font-size: 10pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.65em,
  lang: "en",
)

#masthead(author: "Jane Smith", profession: "Director of Product", contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] }, accent-color: "#2c5f6e")

#cv-section("Summary", accent-color: "#2c5f6e")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#2c5f6e")

#marker-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)

#marker-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)
#cv-section("Experience", accent-color: "#2c5f6e")

#marker-entry(
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

#marker-entry(
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

#marker-entry(
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

#marker-entry(
  title: "Associate Product Manager",
  subtitle: "Optic Retail Group",
  dates: "August 2013 - May 2015",
  location: "",
  meta: "",
  [
- Managed the roadmap for the loyalty programme, growing enrolled members from 90k to 310k in 18 months.
- Automated weekly reporting with SQL and Looker, saving the team 12 hours a week and improving decision speed.
],
)

#marker-entry(
  title: "Business Analyst",
  subtitle: "Foundry Studio",
  dates: "January 2012 - July 2013",
  location: "",
  meta: "",
  [
- Built financial and demand models informing a \$40M annual budget across three regional markets.
- Delivered an executive dashboard that surfaced margin leakage, recovering \$2.1M in the first year.
],
)
#cv-section("Projects", accent-color: "#2c5f6e")

#marker-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)

#marker-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)
#cv-section("Skills", accent-color: "#2c5f6e")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market

#cv-section("Languages", accent-color: "#2c5f6e")

#marker-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#marker-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#marker-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#2c5f6e")

#marker-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  dates: "January 2020",
  location: "",
  meta: "",
  [],
)

#marker-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  dates: "January 2019",
  location: "",
  meta: "",
  [],
)
#cv-section("Awards", accent-color: "#2c5f6e")

#marker-entry(
  title: "Product Leader of the Year",
  subtitle: "Meridian Labs",
  dates: "January 2023",
  location: "",
  meta: "",
  [],
)
