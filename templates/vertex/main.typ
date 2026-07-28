// Vertex CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in EB Garamond. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/vertex
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is the
// section rules and the masthead rule; body ink, meta muted. A classical centered serif
// masthead over full-width history, with the short sections set two-up. Default accent a
// muted plum.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale from body B = 11pt (standard rule 2; EB Garamond runs small), ONCE.
#let display-size = 25pt // ~2.3 x B - the name (masthead)
#let subhead-size = 13pt // ~1.18 x B - the profession line
#let body-size = 11pt // B
#let label-size = 10.5pt // ~0.95 x B - section labels (uppercase + tracked)
#let meta-size = 9pt // ~0.82 x B - dates, location, contact, level, fine print

// Document shell: set-rules + PDF metadata only. Masthead and sections are composed by
// wrapSections. EB Garamond is the single family (standard rule 1).
#let vertex-cv(
  author: "",
  font: "EB Garamond",
  font-size: 11pt,
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

// Masthead (CENTERED): name (bold) over the profession (accent) and a quiet contact
// line, closed by a thin accent rule. Guarded.
#let masthead(author: "", profession: "", contact: "", accent-color: "#5c3a5f") = {
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof or has-contact {
    block(above: 0pt, below: 1.3em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.4em, justify: false)
      set align(center)
      if has-name { block(spacing: 0pt, text(size: display-size, weight: "bold", fill: ink, author)) }
      if has-prof {
        v(6pt)
        block(spacing: 0pt, text(size: subhead-size, weight: "regular", fill: rgb(accent-color), profession))
      }
      if has-contact {
        v(7pt)
        block(spacing: 0pt, text(size: meta-size, fill: muted, contact))
      }
      if has-name or has-prof or has-contact { v(9pt); line(length: 100%, stroke: 0.6pt + rgb(accent-color)) }
    })
  }
}

// Section label: accent UPPERCASE + tracking over a thin accent rule. Sticky. Used for
// full-width sections and (at half width) inside the two-up band.
#let cv-section(title, accent-color: "#5c3a5f") = {
  block(above: 1.2em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: rgb(accent-color), upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.6pt + rgb(accent-color))
  })
}

// Two-up band: the short sections (skills, languages, certifications, awards) set in two
// balanced columns. Each half receives a set of whole sections (split in TypeScript), so
// no section is ever cut across the divide. A guaranteed top gap keeps it clear of the
// preceding experience; breakable:false moves the whole band to the next page rather than
// splitting it into headerless fragments across a page break.
// Breakable on purpose: `breakable: false` cannot be honoured once the two-up band
// is taller than a page, and Typst then overflows it past the bottom margin rather
// than splitting it. The inner grid breaks column-wise, so a tall band continues on
// the next page with both lanes intact.
#let vertex-twoup(left, right) = {
  block(above: 1.4em, below: 0pt, grid(columns: (1fr, 1fr), column-gutter: 24pt, left, right))
}

// Entry: semibold-ink title leads with a muted subtitle, dates right; location and an
// optional URL meta line below; then the body. No mid-word hyphenation on the title.
#let vertex-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
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

// Credential (certifications / awards, set two-up): compact stacked - name (semibold),
// then issuer + date muted beneath, dot-separated. Fills a half column without cramping.
#let vertex-cred(name: "", issuer: "", date: "") = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    set text(hyphenate: false)
    if not is-blank(name) { text(weight: "semibold", fill: ink, name) }
    let meta = (issuer, date).filter(v => not is-blank(v)).join(text(fill: muted)[ #sym.dot.c ])
    if not is-blank(meta) { v(2pt); text(size: meta-size, fill: muted, meta) }
  })
}

// Language row: language left, level muted right.
#let vertex-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: vertex-cv.with(
  author: "Jane Smith",
  font: "EB Garamond",
  font-size: 11pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.62em,
  lang: "en",
)

#masthead(author: "Jane Smith", profession: "Director of Product", contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] }, accent-color: "#5c3a5f")

#cv-section("Summary", accent-color: "#5c3a5f")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#5c3a5f")

#vertex-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)
#vertex-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)

#cv-section("Experience", accent-color: "#5c3a5f")

#vertex-entry(
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
#vertex-entry(
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
#vertex-entry(
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
#vertex-entry(
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
#vertex-entry(
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

#cv-section("Projects", accent-color: "#5c3a5f")

#vertex-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)
#vertex-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)

#vertex-twoup([
#cv-section("Skills", accent-color: "#5c3a5f")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market, Stakeholder Management, Figma, Python, Experimentation

#cv-section("Certifications", accent-color: "#5c3a5f")

#vertex-cred(
  name: "Certified Scrum Product Owner (CSPO)",
  issuer: "Scrum Alliance",
  date: "January 2020",
)
#vertex-cred(
  name: "Pragmatic Institute Certified (PMC-III)",
  issuer: "Pragmatic Institute",
  date: "January 2019",
)
], [
#cv-section("Languages", accent-color: "#5c3a5f")

#vertex-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#vertex-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#vertex-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Awards", accent-color: "#5c3a5f")

#vertex-cred(
  name: "Product Leader of the Year",
  issuer: "Meridian Labs",
  date: "January 2023",
)
])

