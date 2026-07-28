// Strata CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Inter. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/strata
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). Every drawn rule
// is the accent or a lightened tint of it: the section rules are the full accent, the
// hairlines between entries a 65% tint. No third colour, no hardcoded grey stroke.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale (standard rule 2), defined ONCE and expressed as em multiples of
// the resolved body size B - the `font-size` parameter, which the user can move between
// 9pt and 13pt. Absolute pt would detach the scale from that knob: at 9pt a 10pt label
// ends up LARGER than the body and meta stops being meta, and at 13pt the subhead falls
// below the body. em keeps every ratio intact at both ends of the range.
#let display-size = 2.2em // ~2.2 x B - the name
#let subhead-size = 1.15em // ~1.15 x B - the profession line
#let label-size = 0.9em // 0.9 x B - section labels (the one uppercase + tracked role)
#let meta-size = 0.82em // 0.82 x B - dates, location, contact, level, fine print

// Document shell + masthead. The signature is BANDING: an accent rule closes the
// masthead and opens every section, and a tinted hairline separates each entry from
// the next, so the page reads as a stack of horizontal strata rather than a list.
// Inter is the single family (standard rule 1): regular + semibold + bold.
#let strata-cv(
  author: "",
  profession: "",
  contact: "",
  font: "Inter",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.6cm,
  leading: 0.65em,
  lang: "en",
  accent-color: "#1d5b52",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: false)
  set page(margin: margin, paper: paper)
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  // Masthead: name, role and contact stacked flush left, closed by the first accent
  // band. Guarded so an empty CV shows no floating rule.
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof or has-contact {
    block(above: 0pt, below: 1.2em, breakable: false, {
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
      // The rule CLOSES the name; with no name and no role there is nothing to close,
      // so a contact-only document gets its contact line and no floating rule.
      if has-name or has-prof {
        v(9pt)
        line(length: 100%, stroke: 0.9pt + rgb(accent-color))
      }
    })
  }

  body
}

// Section label: accent UPPERCASE + tracking over the heavy accent band that opens the
// section. The banding is deliberately TWO-LEVEL - a 1.6pt band opens a section, a 0.4pt
// tint hairline closes an entry - so the page reads as strata at a glance rather than as
// a run of same-weight rules.
#let cv-section(title, accent-color: "#1d5b52", gap: 1.7em) = {
  block(above: gap, below: 1em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.9pt, fill: rgb(accent-color), upper(title))
    v(4pt)
    line(length: 100%, stroke: 1.6pt + rgb(accent-color))
  })
}

// The stratum: every entry except the last in its section closes with the hairline
// that separates it from the next, drawn INSIDE the entry's own unbreakable block.
// Keeping the rule in the entry rather than between entries is what stops a page break
// stranding it - as a standalone block it either dangled under the last entry on a page
// or (with `sticky`) landed as the first mark on the next page with nothing above it.
// Here it always sits directly under the entry it closes. A lightened tint of the
// single accent, never a new grey.
#let strata-band(accent-color: "#1d5b52", body) = {
  block(breakable: false, {
    set block(spacing: 0pt)
    body
    v(1.15em)
    line(length: 100%, stroke: 0.4pt + rgb(accent-color).lighten(62%))
  })
}

// Entry: semibold-ink title leading a muted subtitle, dates flush right; location and
// an optional URL below in meta; then the body.
#let strata-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
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
        column-gutter: 0.75em,
        {
          if not is-blank(title) { text(weight: "semibold", fill: ink, title) }
          if not is-blank(title) and not is-blank(subtitle) { text(fill: muted)[ #sym.dash.en ] }
          if not is-blank(subtitle) { text(fill: muted, subtitle) }
        },
        if not is-blank(dates) { text(size: meta-size, fill: muted, dates) } else { [] },
      )
      if not is-blank(location) {
        v(0.68em)
        text(size: meta-size, fill: muted, location)
      }
      if not is-blank(meta) {
        v(0.68em)
        text(size: meta-size, fill: muted, meta)
      }
    })
    // Wider than the 3pt above the location line, so the location binds to its title
    // instead of floating midway between the title and the first bullet.
    if not is-blank(body) {
      v(0.85em)
      block(spacing: 0pt, { set text(fill: ink); body })
    }
  })
}

// Language row: language left, level muted right.
#let strata-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: strata-cv.with(
  author: "Jane Smith",
  accent-color: "#1d5b52",
  font: "Inter",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.6cm,
  leading: 0.65em,
  lang: "en",
  profession: "Director of Product",
  contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] },
)


#cv-section("Summary", accent-color: "#1d5b52", gap: 1.74em)

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#1d5b52", gap: 1.74em)

#strata-band(accent-color: "#1d5b52")[
#strata-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)
]
#strata-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)

#cv-section("Experience", accent-color: "#1d5b52", gap: 1.74em)

#strata-band(accent-color: "#1d5b52")[
#strata-entry(
  title: "Director of Product",
  subtitle: "Meridian Labs",
  dates: "March 2021 - Present",
  location: "",
  meta: "",
  [
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
],
)
]
#strata-entry(
  title: "Senior Product Manager",
  subtitle: "Northwind Technologies",
  dates: "January 2018 - February 2021",
  location: "",
  meta: "",
  [
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
],
)

#cv-section("Projects", accent-color: "#1d5b52", gap: 1.74em)

#strata-band(accent-color: "#1d5b52")[
#strata-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)
]
#strata-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)

#cv-section("Skills", accent-color: "#1d5b52", gap: 1.74em)

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research

#cv-section("Languages", accent-color: "#1d5b52", gap: 1.74em)

#strata-language(
  language: "English",
  level: "Native",
)
#strata-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#strata-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#1d5b52", gap: 1.74em)

#strata-band(accent-color: "#1d5b52")[
#strata-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  dates: "January 2020",
  location: "",
  meta: "",
  [],
)
]
#strata-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  dates: "January 2019",
  location: "",
  meta: "",
  [],
)

