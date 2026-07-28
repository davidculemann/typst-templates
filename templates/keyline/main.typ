// Keyline CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in HK Grotesk. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/keyline
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is
// drawn only as the keyline that trails every section label; ink carries the labels
// and titles, the muted grey every secondary line. Nothing else is drawn.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale (standard rule 2), defined ONCE and expressed as em multiples of
// the resolved body size B - the `font-size` parameter, which the user can move between
// 9pt and 13pt. Absolute pt would detach the scale from that knob: at 9pt a 10pt label
// ends up LARGER than the body and meta stops being meta, and at 13pt the subhead falls
// below the body. em keeps every ratio intact at both ends of the range.
#let display-size = 2.3em // ~2.3 x B - the name
#let subhead-size = 1.15em // ~1.15 x B - the profession line
#let label-size = 0.9em // 0.9 x B - section labels (the one uppercase + tracked role)
#let meta-size = 0.82em // 0.82 x B - dates, location, contact, level, fine print

// Document shell + masthead. Two signatures: every section label is followed by a
// KEYLINE - an accent rule running from the label to the right edge at label height -
// and every entry's meta (dates over location) is stacked flush right, so the page
// keeps a clean right-hand column. HK Grotesk is the single family (standard rule 1).
#let keyline-cv(
  author: "",
  profession: "",
  contact: "",
  font: "HK Grotesk",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.7cm,
  leading: 0.65em,
  lang: "en",
  accent-color: "#6d4f3b",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: false)
  set page(margin: margin, paper: paper)
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  // Masthead: the name over one shared baseline carrying the role left and the contact
  // right, so the header occupies two lines and no more. Guarded for the empty CV.
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof or has-contact {
    block(above: 0pt, below: 1.1em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.4em, justify: false)
      if has-name { text(size: display-size, weight: "bold", fill: ink, author) }
      if has-prof or has-contact {
        if has-name { v(display-size * 0.38) }
        grid(
          columns: (auto, 1fr),
          align: (left + bottom, right + bottom),
          column-gutter: 1.2em,
          if has-prof { text(size: subhead-size, fill: muted, profession) } else { [] },
          if has-contact { text(size: meta-size, fill: muted, contact) } else { [] },
        )
      }
    })
  }

  body
}

// Section label + keyline: the label flush left in ink, an accent rule filling the
// rest of the measure at the label's optical centre. The 0.8em column gutter keeps
// the rule clear of the text on the left; it runs to the right margin. 1pt rather than
// a hairline: the keyline is the ONLY drawn mark in the template, so at 0.8pt a dark
// accent read as a neutral line rather than as the accent colour.
// `below: 0.9em` gives the first entry natural air under the keyline.
#let cv-section(title, accent-color: "#6d4f3b", gap: 1.7em) = {
  block(above: gap, below: 1em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    grid(
      columns: (auto, 1fr),
      align: (left + horizon, left + horizon),
      column-gutter: 0.8em,
      text(size: label-size, weight: "bold", tracking: 1.1pt, fill: ink, upper(title)),
      line(length: 100%, stroke: 1pt + rgb(accent-color)),
    )
  })
}

// Entry: title and subtitle on the left, the meta STACKED flush right (dates over
// location over an optional URL), so every entry shares one right-hand column.
#let keyline-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
  // ATOMIC on purpose. Letting an entry break fills the page foot, but it also lets a
  // single trailing bullet start the next page, which the review bar treats as an
  // automatic fail; measured over the fixture matrix the orphans cost more than the
  // whitespace. Same choice as every other template in the fleet.
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    block(sticky: true, breakable: false, {
      set par(justify: false)
      grid(
        columns: (1fr, auto),
        align: (left + top, right + top),
        column-gutter: 1em,
        {
          if not is-blank(title) { text(weight: "bold", fill: ink, title) }
          if not is-blank(title) and not is-blank(subtitle) { linebreak() }
          if not is-blank(subtitle) { text(fill: muted, subtitle) }
        },
        {
          set text(size: meta-size, fill: muted)
          set align(right)
          if not is-blank(dates) { dates }
          if not is-blank(dates) and not is-blank(location) { linebreak() }
          if not is-blank(location) { location }
          if (not is-blank(dates) or not is-blank(location)) and not is-blank(meta) { linebreak() }
          if not is-blank(meta) { meta }
        },
      )
    })
    if not is-blank(body) {
      v(0.85em)
      block(spacing: 0pt, { set text(fill: ink); body })
    }
  })
}

// Language row: language left, level muted right.
#let keyline-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: keyline-cv.with(
  author: "Jane Smith",
  accent-color: "#6d4f3b",
  font: "HK Grotesk",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.7cm,
  leading: 0.65em,
  lang: "en",
  profession: "Director of Product",
  contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] },
)


#cv-section("Summary", accent-color: "#6d4f3b", gap: 1.74em)

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#6d4f3b", gap: 1.74em)

#keyline-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)
#keyline-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)

#cv-section("Experience", accent-color: "#6d4f3b", gap: 1.74em)

#keyline-entry(
  title: "Director of Product",
  subtitle: "Meridian Labs",
  dates: "March 2021 - Present",
  location: "",
  meta: "",
  [
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
],
)
#keyline-entry(
  title: "Senior Product Manager",
  subtitle: "Northwind Technologies",
  dates: "January 2018 - February 2021",
  location: "",
  meta: "",
  [
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
],
)

#cv-section("Projects", accent-color: "#6d4f3b", gap: 1.74em)

#keyline-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)
#keyline-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)

#cv-section("Skills", accent-color: "#6d4f3b", gap: 1.74em)

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market

#cv-section("Languages", accent-color: "#6d4f3b", gap: 1.74em)

#keyline-language(
  language: "English",
  level: "Native",
)
#keyline-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#keyline-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#6d4f3b", gap: 1.74em)

#keyline-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  dates: "January 2020",
  location: "",
  meta: "",
  [],
)
#keyline-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  dates: "January 2019",
  location: "",
  meta: "",
  [],
)

#cv-section("Awards", accent-color: "#6d4f3b", gap: 1.74em)

#keyline-entry(
  title: "Product Leader of the Year",
  subtitle: "Meridian Labs",
  dates: "January 2023",
  location: "",
  meta: "",
  [],
)

