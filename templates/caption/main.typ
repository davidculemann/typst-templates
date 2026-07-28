// Caption CV, a Typst resume template.
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
// Edit in a browser: https://www.jobsprout.ai/resume-templates/caption
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is the
// margin section labels and the masthead rule; body ink, meta muted. A slab serif with
// section labels set as marginal captions. Default accent a warm sienna.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale from body B = 10.5pt (standard rule 2), defined ONCE.
#let display-size = 22pt // ~2.1 x B - the name (masthead)
#let subhead-size = 12pt // ~1.14 x B - the profession line
#let body-size = 10.5pt // B
#let label-size = 9.5pt // ~0.9 x B - the marginal section labels (uppercase + tracked)
#let meta-size = 8.6pt // ~0.82 x B - dates, location, contact, level, fine print

// The caption gutter: a fixed left column holds each section label (right-aligned) as a
// marginal caption; the section content flows in the wide column to its right. The label
// is PLACED into the gutter so a long section paginates cleanly (the label stays at the
// section start, page 1). The signature of this template.
#let GUT = 92pt
#let GAP = 16pt
#let SEC-INDENT = GUT + GAP

// Document shell: set-rules + PDF metadata only. Masthead and sections are composed by
// wrapSections. Bitter (a slab serif) is the single family (standard rule 1).
#let caption-cv(
  author: "",
  font: "Bitter",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.64em,
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

// Masthead (full width, above the caption body): name (bold) over the profession
// (accent) and a quiet contact line, closed by a thin accent rule. Guarded.
#let masthead(author: "", profession: "", contact: "", accent-color: "#8a4a2c") = {
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof or has-contact {
    block(above: 0pt, below: 1.3em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.42em, justify: false)
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

// Section: the label is PLACED into the left gutter (right-aligned) as a marginal
// caption; the content flows in the wide right column (a left inset opens the gutter).
// The block is breakable so a long section paginates; the placed label carries zero flow
// height, so it stays at the section start. Body is the trailing positional argument.
#let caption-section(title, accent-color: "#8a4a2c", body) = {
  block(above: 1.4em, below: 0.6em, width: 100%, inset: (left: SEC-INDENT), spacing: 0pt, {
    place(
      top + left,
      dx: -SEC-INDENT,
      dy: 1pt,
      box(width: GUT, align(right, text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: rgb(accent-color), upper(title)))),
    )
    body
  })
}

// Entry: semibold-ink title leads with a muted subtitle, dates right (within the content
// column); location and an optional URL meta line below; then the body. No mid-word
// hyphenation on the title.
#let caption-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
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

// Language row: language left, level muted right.
#let caption-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: caption-cv.with(
  author: "Jane Smith",
  font: "Bitter",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.64em,
  lang: "en",
)

#masthead(author: "Jane Smith", profession: "Director of Product", contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] }, accent-color: "#8a4a2c")

#caption-section("Summary", accent-color: "#8a4a2c")[
Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.
]

#caption-section("Education", accent-color: "#8a4a2c")[
#caption-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)
#caption-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)
]

#caption-section("Experience", accent-color: "#8a4a2c")[
#caption-entry(
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
#caption-entry(
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
#caption-entry(
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
#caption-entry(
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
]

#caption-section("Projects", accent-color: "#8a4a2c")[
#caption-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)
#caption-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)
]

#caption-section("Skills", accent-color: "#8a4a2c")[
Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market
]

#caption-section("Languages", accent-color: "#8a4a2c")[
#caption-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#caption-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#caption-language(
  language: "Mandarin",
  level: "Conversational",
)
]

#caption-section("Certifications", accent-color: "#8a4a2c")[
#caption-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  dates: "January 2020",
  location: "",
  meta: "",
  [],
)
#caption-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  dates: "January 2019",
  location: "",
  meta: "",
  [],
)
]

#caption-section("Awards", accent-color: "#8a4a2c")[
#caption-entry(
  title: "Product Leader of the Year",
  subtitle: "Meridian Labs",
  dates: "January 2023",
  location: "",
  meta: "",
  [],
)
]

