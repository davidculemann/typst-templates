// Timeline CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Bitter. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/timeline
#set page(fill: rgb("#ffffff"))

#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is
// the timeline spine + nodes and the section labels/rules; ink on white otherwise.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale from body B = 10.5pt (standard rule 2), defined ONCE.
#let display-size = 20pt // ~1.9 x B - the name (masthead)
#let subhead-size = 12pt // ~1.14 x B - the profession line
#let body-size = 10.5pt // B
#let label-size = 9.5pt // ~0.9 x B - section labels (the one uppercase + tracked role)
#let meta-size = 8.6pt // ~0.82 x B - dates, location, contact, level, fine print

// Document shell: set-rules + PDF metadata. Bitter (a slab serif) is the single
// family (standard rule 1) - unused by our other templates, giving the timeline a
// distinct editorial-technical texture; regular + semibold + bold.
#let timeline-cv(
  author: "",
  font: "Bitter",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.62em,
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

// Masthead (full width): name (bold) + profession (muted) + a quiet contact line,
// then an accent rule. Guarded so an empty CV shows no floating rule.
#let masthead(author: "", profession: "", contact: "", accent-color: "#216b63") = {
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof or has-contact {
    block(above: 0pt, below: 1.1em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.45em, justify: false)
      // Name and role share ONE baseline - name left, role as a muted tagline to its
      // right - an editorial masthead. No rule (the accent spine is the structure).
      if has-name and has-prof {
        grid(
          columns: (auto, 1fr),
          align: (left + bottom, right + bottom),
          column-gutter: 1em,
          text(size: display-size, weight: "bold", fill: ink, author),
          text(size: subhead-size, weight: "regular", fill: muted, profession),
        )
      } else if has-name {
        text(size: display-size, weight: "bold", fill: ink, author)
      } else if has-prof {
        text(size: subhead-size, weight: "regular", fill: muted, profession)
      }
      if has-contact {
        if has-name or has-prof { v(6pt) }
        text(size: meta-size, fill: muted, contact)
      }
    })
  }
}

// Section label: accent UPPERCASE + tracking over a thin accent rule. Sticky.
#let cv-section(title, accent-color: "#216b63") = {
  block(above: 1.2em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: rgb(accent-color), upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.6pt + rgb(accent-color))
  })
}

// The timeline entry (the signature): a narrow left gutter holds a filled accent
// NODE at the top and a thin accent spine down the entry's full height; the content
// sits to the right. The continuous spine is drawn by #timeline-track (one unbroken
// left border for the whole section); each entry only places its node ON that spine,
// so the dots and the line are always connected and aligned.
#let TL-GUTTER = 20pt

// Section track: wraps a section's entries in a single block whose LEFT BORDER is the
// continuous timeline spine (one line for the whole section, no per-entry gaps), with
// a left inset so the entries sit to its right. Every entry places its node at
// -TL-GUTTER (exactly on this border), so the nodes stay centred on the spine.
// The top inset is NEGATIVE by exactly the node's centre offset (NODE-CENTRE below),
// so the left border (the spine) begins at the first node's centre instead of ~4.5pt
// above it. Paired with the node dy so the dots sit on the entry titles AND the spine
// starts at the first dot - no lead into empty space.
#let NODE-CENTRE = 4.5pt
#let timeline-track(accent-color: "#216b63", body) = {
  block(
    width: 100%,
    inset: (left: TL-GUTTER, top: -NODE-CENTRE),
    stroke: (left: 1.4pt + rgb(accent-color).lighten(15%)),
    body,
  )
}

// A single timeline node (filled accent dot), placed exactly on the track's spine
// (its border at -TL-GUTTER) at the first line of the caller's entry block. Used by
// both the house entry and the generic (custom/publications) entry so every entry on
// the track is marked.
// dy: 1pt puts the node's CENTRE at ~4.5pt below the entry's top - the optical centre
// of the title's first line - so the dot sits ON the title, not above it. The track's
// negative top inset (NODE-CENTRE) pulls the spine up to start at this same y, so the
// dots are centred on the titles AND the spine begins at the first dot.
#let timeline-node(accent-color: "#216b63") = place(
  top + left,
  dx: -TL-GUTTER - 3.5pt,
  dy: 1pt,
  circle(radius: 3.5pt, fill: rgb(accent-color), stroke: none),
)

#let timeline-entry(title: "", subtitle: "", dates: "", location: "", meta: "", accent-color: "#216b63", body) = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    timeline-node(accent-color: accent-color)
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
#let timeline-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: timeline-cv.with(
  author: "Jane Smith",
  font: "Bitter",
  font-size: 10pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.62em,
  lang: "en",
)

#masthead(author: "Jane Smith", profession: "Director of Product", contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] }, accent-color: "#216b63")

#cv-section("Summary", accent-color: "#216b63")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#216b63")

#timeline-track(accent-color: "#216b63", [
#timeline-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [],
)

#timeline-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [],
)
])
#cv-section("Experience", accent-color: "#216b63")

#timeline-track(accent-color: "#216b63", [
#timeline-entry(
  title: "Director of Product",
  subtitle: "Meridian Labs",
  dates: "March 2021 - Present",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
- Built and led a cross-functional org of 24 (PMs, designers, analysts), instituting a quarterly OKR cadence that lifted on-time delivery from 61% to 92%.
],
)

#timeline-entry(
  title: "Senior Product Manager",
  subtitle: "Northwind Technologies",
  dates: "January 2018 - February 2021",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
- Ran continuous discovery with 120+ customer interviews, translating findings into a roadmap that raised NPS from 22 to 48.
],
)

#timeline-entry(
  title: "Product Manager",
  subtitle: "Brightwave",
  dates: "June 2015 - December 2017",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [
- Shipped a mobile checkout redesign that lifted conversion 18% and reduced cart abandonment by a third.
- Defined the north-star metric and instrumentation for a 2M-user product, replacing vanity metrics with retention cohorts.
],
)

#timeline-entry(
  title: "Associate Product Manager",
  subtitle: "Optic Retail Group",
  dates: "August 2013 - May 2015",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [
- Managed the roadmap for the loyalty programme, growing enrolled members from 90k to 310k in 18 months.
- Automated weekly reporting with SQL and Looker, saving the team 12 hours a week and improving decision speed.
],
)
])
#cv-section("Projects", accent-color: "#216b63")

#timeline-track(accent-color: "#216b63", [
#timeline-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)

#timeline-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)
])
#cv-section("Skills", accent-color: "#216b63")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market

#cv-section("Languages", accent-color: "#216b63")

#timeline-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#timeline-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#timeline-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#216b63")

#timeline-track(accent-color: "#216b63", [
#timeline-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  dates: "January 2020",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [],
)

#timeline-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  dates: "January 2019",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [],
)
])
#cv-section("Awards", accent-color: "#216b63")

#timeline-track(accent-color: "#216b63", [
#timeline-entry(
  title: "Product Leader of the Year",
  subtitle: "Meridian Labs",
  dates: "January 2023",
  location: "",
  meta: "",
  accent-color: "#216b63",
  [],
)
])
