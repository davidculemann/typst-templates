// Gazette CV, a Typst resume template.
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
// Edit in a browser: https://www.jobsprout.ai/resume-templates/gazette
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is
// the section rules and the masthead rule; dates and meta are muted; body is ink.
// Editorial serif with a hanging left DATE gutter. Default accent a deep burgundy.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale from body B = 10.5pt (standard rule 2), defined ONCE.
#let display-size = 24pt // ~2.3 x B - the name (masthead)
#let subhead-size = 12pt // ~1.14 x B - the profession line
#let body-size = 10.5pt // B
#let label-size = 10pt // ~0.95 x B - section labels (uppercase + tracked)
#let meta-size = 8.6pt // ~0.82 x B - dates, location, contact, level, fine print

// The date gutter: a fixed left column holds the entry dates (right-aligned); every
// section label and every entry aligns to the content edge past it, so the dates hang
// alone in the margin - the signature.
#let GUT = 96pt
#let GAP = 14pt

// Document shell: set-rules + PDF metadata only. Masthead and sections are composed by
// wrapSections. Source Serif 4 is the single family (standard rule 1).
#let gazette-cv(
  author: "",
  font: "Source Serif 4",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.66em,
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

// Masthead (full width, above the gutter body): name (bold) over the profession
// (accent) and a quiet contact line, closed by a thin accent rule. Guarded.
#let masthead(author: "", profession: "", contact: "", accent-color: "#7a3b46") = {
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof or has-contact {
    block(above: 0pt, below: 1.3em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.4em, justify: false)
      if has-name { text(size: display-size, weight: "bold", fill: ink, author) }
      if has-prof {
        if has-name { v(4pt) }
        text(size: subhead-size, weight: "regular", fill: rgb(accent-color), profession)
      }
      if has-contact {
        if has-name or has-prof { v(7pt) }
        text(size: meta-size, fill: muted, contact)
      }
      if has-name or has-prof or has-contact { v(9pt); line(length: 100%, stroke: 0.6pt + rgb(accent-color)) }
    })
  }
}

// Section label: aligned to the content edge (past the date gutter), UPPERCASE accent
// + tracking over a thin accent rule; the gutter stays empty on the label row. Sticky.
#let cv-section(title, accent-color: "#7a3b46") = {
  block(above: 1.4em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    grid(
      columns: (GUT, 1fr),
      column-gutter: GAP,
      [],
      {
        text(size: label-size, weight: "semibold", tracking: 0.9pt, fill: rgb(accent-color), upper(title))
        v(3pt)
        line(length: 100%, stroke: 0.6pt + rgb(accent-color))
      },
    )
  })
}

// Entry: the dates hang right-aligned in the left gutter; the content column carries
// the title (semibold ink) leading with a muted subtitle, location and an optional URL
// meta line, then the body. No mid-word hyphenation on the title.
#let gazette-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    grid(
      columns: (GUT, 1fr),
      column-gutter: GAP,
      align: (right + top, left + top),
      if not is-blank(dates) { text(size: meta-size, fill: muted, dates) } else { [] },
      {
        set par(justify: false)
        set text(hyphenate: false)
        block(sticky: true, breakable: false, {
          if not is-blank(title) { text(weight: "semibold", fill: ink, title) }
          if not is-blank(title) and not is-blank(subtitle) { text(fill: muted)[ #sym.dash.en ] }
          if not is-blank(subtitle) { text(fill: muted, subtitle) }
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
      },
    )
  })
}

// Plain section body (summary / skills / languages): no per-item dates, so the gutter
// stays empty and the content aligns to the same content edge as the entries.
#let gazette-plain(body) = grid(columns: (GUT, 1fr), column-gutter: GAP, [], body)

// Language row: language left, level muted right (within the content column).
#let gazette-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: gazette-cv.with(
  author: "Jane Smith",
  font: "Source Serif 4",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.66em,
  lang: "en",
)

#masthead(author: "Jane Smith", profession: "Director of Product", contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] }, accent-color: "#7a3b46")

#cv-section("Summary", accent-color: "#7a3b46")

#gazette-plain[
Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.
]

#cv-section("Education", accent-color: "#7a3b46")

#gazette-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "Sep 2010 - Jun 2012",
  location: "",
  meta: "",
  [],
)
#gazette-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "Sep 2006 - Jun 2010",
  location: "",
  meta: "",
  [],
)

#cv-section("Experience", accent-color: "#7a3b46")

#gazette-entry(
  title: "Director of Product",
  subtitle: "Meridian Labs",
  dates: "Mar 2021 - Present",
  location: "",
  meta: "",
  [
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
- Built and led a cross-functional org of 24 (PMs, designers, analysts), instituting a quarterly OKR cadence that lifted on-time delivery from 61% to 92%.
],
)
#gazette-entry(
  title: "Senior Product Manager",
  subtitle: "Northwind Technologies",
  dates: "Jan 2018 - Feb 2021",
  location: "",
  meta: "",
  [
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
- Ran continuous discovery with 120+ customer interviews, translating findings into a roadmap that raised NPS from 22 to 48.
],
)

#cv-section("Projects", accent-color: "#7a3b46")

#gazette-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)
#gazette-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)

#cv-section("Skills", accent-color: "#7a3b46")

#gazette-plain[
Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market
]

#cv-section("Languages", accent-color: "#7a3b46")

#gazette-plain[
#gazette-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#gazette-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#gazette-language(
  language: "Mandarin",
  level: "Conversational",
)
]

#cv-section("Certifications", accent-color: "#7a3b46")

#gazette-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  dates: "Jan 2020",
  location: "",
  meta: "",
  [],
)
#gazette-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  dates: "Jan 2019",
  location: "",
  meta: "",
  [],
)

#cv-section("Awards", accent-color: "#7a3b46")

#gazette-entry(
  title: "Product Leader of the Year",
  subtitle: "Meridian Labs",
  dates: "Jan 2023",
  location: "",
  meta: "",
  [],
)

