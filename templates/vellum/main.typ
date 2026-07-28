// Vellum CV, a Typst resume template.
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
// Edit in a browser: https://www.jobsprout.ai/resume-templates/vellum
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). This template
// draws NO rules and aligns nothing right, so the accent appears only as the section
// labels and the date line under each entry title.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale (standard rule 2), defined ONCE and expressed as em multiples of
// the resolved body size B - the `font-size` parameter, which the user can move between
// 9pt and 13pt. Absolute pt would detach the scale from that knob: at 9pt a 10pt label
// ends up LARGER than the body and meta stops being meta, and at 13pt the subhead falls
// below the body. em keeps every ratio intact at both ends of the range.
#let display-size = 2.3em // ~2.3 x B - the name
#let subhead-size = 1.2em // ~1.2 x B - the profession line
#let label-size = 0.9em // 0.9 x B - section labels (the one uppercase + tracked role)
#let meta-size = 0.82em // 0.82 x B - dates, location, contact, level, fine print

// Document shell + masthead. The signature is what is ABSENT: no rules, no boxes and
// nothing set flush right. Every line starts on the same left edge and the dates sit
// on their own line under each title in the accent, so the page is carried by
// whitespace and one colour instead of ruled furniture. Bitter is the single family
// (standard rule 1): regular + semibold + bold.
#let vellum-cv(
  author: "",
  profession: "",
  contact: "",
  font: "Bitter",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.9cm,
  leading: 0.7em,
  lang: "en",
  accent-color: "#6f6049",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: false)
  set page(margin: margin, paper: paper)
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  // Masthead: name, role, contact - three left-aligned lines and no rule to close them.
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof or has-contact {
    block(above: 0pt, below: 1.5em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.4em, justify: false)
      if has-name { text(size: display-size, weight: "bold", fill: ink, author) }
      if has-prof {
        if has-name { v(display-size * 0.38) }
        text(size: subhead-size, weight: "regular", fill: muted, profession)
      }
      if has-contact {
        if has-name or has-prof { v(subhead-size * 0.7) }
        text(size: meta-size, fill: muted, contact)
      }
    })
  }

  body
}

// Section label: accent UPPERCASE + tracking, no rule. The generous `above` is what
// separates sections here; with no rule to mark the label, `below` runs a shade over
// the 0.9em floor so the first entry never reads as part of the label.
#let cv-section(title, accent-color: "#6f6049", gap: 1.55em) = {
  block(above: gap, below: 1em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 1.2pt, fill: rgb(accent-color), upper(title))
  })
}

// Entry: title line, then a single accent meta line carrying the dates, the location
// and any URL separated by middots - all left-aligned, nothing pushed to the margin.
#let vellum-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body, accent-color: "#6f6049") = {
  let meta-parts = ()
  if not is-blank(dates) { meta-parts.push(dates) }
  if not is-blank(location) { meta-parts.push(location) }
  if not is-blank(meta) { meta-parts.push(meta) }
  // ATOMIC on purpose. Letting an entry break fills the page foot, but it also lets a
  // single trailing bullet start the next page, which the review bar treats as an
  // automatic fail; measured over the fixture matrix the orphans cost more than the
  // whitespace. Same choice as every other template in the fleet.
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    block(sticky: true, breakable: false, {
      set par(justify: false)
      if not is-blank(title) { text(weight: "semibold", fill: ink, title) }
      if not is-blank(title) and not is-blank(subtitle) { text(fill: muted)[ #sym.dash.en ] }
      if not is-blank(subtitle) { text(fill: muted, subtitle) }
      if meta-parts.len() > 0 {
        if not is-blank(title) or not is-blank(subtitle) { v(0.68em) }
        text(size: meta-size, fill: rgb(accent-color), meta-parts.join([ #sym.dot.c ]))
      }
    })
    if not is-blank(body) {
      v(0.85em)
      block(spacing: 0pt, { set text(fill: ink); body })
    }
  })
}

// Language row: language then the level in muted meta on the same line, left-aligned
// (nothing in this template is set flush right).
#let vellum-language(language: "", level: "") = {
  block(breakable: false, {
    language
    if not is-blank(level) {
      text(fill: muted)[ #sym.dot.c ]
      text(size: meta-size, fill: muted, level)
    }
  })
}



#show: vellum-cv.with(
  author: "Jane Smith",
  accent-color: "#6f6049",
  font: "Bitter",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.9cm,
  leading: 0.7em,
  lang: "en",
  profession: "Director of Product",
  contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] },
)


#cv-section("Summary", accent-color: "#6f6049", gap: 1.74em)

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#6f6049", gap: 1.74em)

#vellum-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  accent-color: "#6f6049",
  [],
)
#vellum-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  accent-color: "#6f6049",
  [],
)

#cv-section("Experience", accent-color: "#6f6049", gap: 1.74em)

#vellum-entry(
  title: "Director of Product",
  subtitle: "Meridian Labs",
  dates: "March 2021 - Present",
  location: "",
  meta: "",
  accent-color: "#6f6049",
  [
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
],
)
#vellum-entry(
  title: "Senior Product Manager",
  subtitle: "Northwind Technologies",
  dates: "January 2018 - February 2021",
  location: "",
  meta: "",
  accent-color: "#6f6049",
  [
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
],
)

#cv-section("Projects", accent-color: "#6f6049", gap: 1.74em)

#vellum-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  accent-color: "#6f6049",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)
#vellum-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  accent-color: "#6f6049",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)

#cv-section("Skills", accent-color: "#6f6049", gap: 1.74em)

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research

#cv-section("Languages", accent-color: "#6f6049", gap: 1.74em)

#vellum-language(
  language: "English",
  level: "Native",
)
#vellum-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#vellum-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#6f6049", gap: 1.74em)

#vellum-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  dates: "January 2020",
  location: "",
  meta: "",
  accent-color: "#6f6049",
  [],
)
#vellum-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  dates: "January 2019",
  location: "",
  meta: "",
  accent-color: "#6f6049",
  [],
)

