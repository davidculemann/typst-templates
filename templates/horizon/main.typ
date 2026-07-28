// Horizon CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Roboto. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/horizon
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is used
// as ONE tasteful block: a full-bleed header band (edge-to-edge across the page top). On
// the band, ink/muted become near-white / a muted white tint for legibility (the
// filled-block two-tone secondary logic, not a second colour). Off the band: ink on
// white. Default accent a deep petrol.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")
#let band-ink = rgb("#f5f7f6")
#let band-muted = rgb("#cdd8d2")

// Fixed size scale from body B = 10.5pt (standard rule 2), defined ONCE.
#let display-size = 23pt // ~2.2 x B - the name in the band
#let subhead-size = 12pt // ~1.14 x B - the profession line in the band
#let body-size = 10.5pt // B
#let label-size = 10pt // ~0.95 x B - section labels (uppercase + tracked)
#let meta-size = 8.6pt // ~0.82 x B - dates, location, contact, level, fine print

#let BAND-H = 108pt

// Document shell: set-rules + PDF metadata only. The full-bleed band and the sections
// are composed by wrapSections. Roboto is the single family (standard rule 1); Roboto
// ships regular / medium / bold (no semibold), so labels use medium.
#let horizon-cv(
  author: "",
  font: "Roboto",
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

// Full-bleed header band (the tasteful single block): a fixed-height block reserving
// flow space, whose fill is PLACED to escape the page margins on the top/left/right
// edges (dx/dy = -margin, width = content + 2*margin = page width), so the accent runs
// edge-to-edge across the page top and appears on page one only. The name, profession
// and a contact line sit centred in near-white. Guarded so an empty CV shows no band.
// `margin` is the resolved page margin, passed by wrapSections.
#let horizon-header(author: "", profession: "", contact: "", margin: 1.5cm, accent-color: "#1f4a54") = {
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof {
    block(width: 100%, height: BAND-H, above: 0pt, below: 1.4em, breakable: false, {
      place(
        top + left,
        dx: -margin,
        dy: -margin,
        rect(width: 100% + 2 * margin, height: BAND-H + margin, fill: rgb(accent-color)),
      )
      place(
        center + horizon,
        block(width: 90%, {
          set align(center)
          set par(spacing: 0pt, justify: false, leading: 0.45em)
          show link: set text(fill: band-muted)
          if has-name { block(spacing: 0pt, text(size: display-size, weight: "bold", fill: band-ink, tracking: 0.3pt, author)) }
          if has-prof {
            v(6pt)
            block(spacing: 0pt, text(size: subhead-size, weight: "medium", fill: band-muted, profession))
          }
          if has-contact {
            v(7pt)
            block(spacing: 0pt, text(size: meta-size, fill: band-muted, contact))
          }
        }),
      )
    })
  }
}

// Section label: accent UPPERCASE + tracking over a thin accent rule. Sticky.
#let cv-section(title, accent-color: "#1f4a54") = {
  block(above: 1.25em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "medium", tracking: 1pt, fill: rgb(accent-color), upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.6pt + rgb(accent-color))
  })
}

// Entry: semibold-ink title leads with a muted subtitle, dates right; location and an
// optional URL meta line below; then the body. No mid-word hyphenation on the title.
#let horizon-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
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
          if not is-blank(title) { text(weight: "medium", fill: ink, title) }
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
#let horizon-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: horizon-cv.with(
  author: "Jane Smith",
  font: "Roboto",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.65em,
  lang: "en",
)

#horizon-header(author: "Jane Smith", profession: "Director of Product", contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] }, margin: 1.5cm, accent-color: "#1f4a54")

#cv-section("Summary", accent-color: "#1f4a54")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#1f4a54")

#horizon-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)
#horizon-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)

#cv-section("Experience", accent-color: "#1f4a54")

#horizon-entry(
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
#horizon-entry(
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

#cv-section("Projects", accent-color: "#1f4a54")

#horizon-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)
#horizon-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)

#cv-section("Skills", accent-color: "#1f4a54")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market

#cv-section("Languages", accent-color: "#1f4a54")

#horizon-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#horizon-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#horizon-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#1f4a54")

#horizon-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  dates: "January 2020",
  location: "",
  meta: "",
  [],
)
#horizon-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  dates: "January 2019",
  location: "",
  meta: "",
  [],
)

#cv-section("Awards", accent-color: "#1f4a54")

#horizon-entry(
  title: "Product Leader of the Year",
  subtitle: "Meridian Labs",
  dates: "January 2023",
  location: "",
  meta: "",
  [],
)

