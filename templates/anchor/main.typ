// Anchor CV, a Typst resume template.
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
// Edit in a browser: https://www.jobsprout.ai/resume-templates/anchor
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6), spent unusually:
// the accent appears NOWHERE on the page except the full-bleed band at the foot. Labels,
// rules and entries are all ink and the one muted grey, so the document reads as a black
// and white page with a single bar of colour anchoring it. On the band, ink becomes
// near-white for legibility (the filled-block logic, not a second colour).
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")
#let band-ink = rgb("#f4f7f5")

#let BAND-H = 40pt

// Fixed size scale (standard rule 2), defined ONCE and expressed as em multiples of
// the resolved body size B - the `font-size` parameter, which the user can move between
// 9pt and 13pt. Absolute pt would detach the scale from that knob: at 9pt a 10pt label
// ends up LARGER than the body and meta stops being meta, and at 13pt the subhead falls
// below the body. em keeps every ratio intact at both ends of the range.
#let display-size = 2.3em // ~2.3 x B - the name
#let subhead-size = 1.15em // ~1.15 x B - the profession line
#let label-size = 0.9em // 0.9 x B - section labels (the one uppercase + tracked role)
#let meta-size = 0.82em // 0.82 x B - dates, location, contact, level, fine print

// Document shell + masthead. The signature: the contact line is ANCHORED in a
// full-bleed accent band across the foot of EVERY page rather than crowded under the
// name, so it stays reachable however many pages the CV runs to and the top of the
// page belongs to the name alone. The band is painted by the page background (so it
// bleeds past the margins on all three edges) and suppressed entirely when the
// document carries no contact details, so an empty CV never shows an empty strip.
// Source Sans 3 is the single family (standard rule 1): regular + semibold + bold.
#let anchor-cv(
  author: "",
  profession: "",
  contact: "",
  font: "Source Sans 3",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.6cm,
  leading: 0.65em,
  lang: "en",
  accent-color: "#22423a",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  let has-band = not is-blank(contact)

  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: false)
  set page(
    paper: paper,
    // Extra bottom margin only when the band is painted: the flowing column must clear
    // it. Left/right/top keep the plain margin.
    margin: (top: margin, left: margin, right: margin, bottom: if has-band { margin + BAND-H } else { margin }),
    background: if has-band {
      place(bottom + left, rect(width: 100%, height: BAND-H, fill: rgb(accent-color)))
    },
    // The bottom margin is `margin + BAND-H`; footer-descent lowers the footer from the
    // content edge, so it must clear `margin` before it reaches the band. `margin + 14.5pt`
    // centres the contact line inside the 40pt band at every margin scale.
    footer-descent: margin + 14.5pt,
    footer: if has-band {
      block(width: 100%, {
        set block(spacing: 0pt)
        set par(spacing: 0pt, justify: false)
        set align(center)
        // The whole band line reads as one near-white line: dimming the links here (the
        // usual muted treatment on a light page) would leave the email lower-contrast
        // than the phone beside it for no reason.
        show link: set text(fill: band-ink)
        text(size: meta-size, fill: band-ink, contact)
      })
    },
  )
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  // Masthead: the name and role alone over a thin accent rule - no contact stack, it
  // lives in the band below.
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  if has-name or has-prof {
    block(above: 0pt, below: 1.2em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.4em, justify: false)
      if has-name { text(size: display-size, weight: "bold", fill: ink, author) }
      if has-prof {
        if has-name { v(display-size * 0.38) }
        text(size: subhead-size, weight: "regular", fill: muted, profession)
      }
      v(9pt)
      line(length: 100%, stroke: 0.8pt + ink)
    })
  }

  body
}

// Section label: INK uppercase + tracking over a muted hairline. No accent here - the
// colour budget for this template is spent entirely on the band at the foot.
// `accent-color` stays in the signature so the adapter's call site is uniform.
#let cv-section(title, accent-color: "#22423a", gap: 1.7em) = {
  block(above: gap, below: 1em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 1pt, fill: ink, upper(title))
    v(4pt)
    line(length: 100%, stroke: 0.5pt + muted)
  })
}

// Entry: the whole head is ONE line - title and organisation left, and the location and
// dates folded together into a single right-hand meta cell. Nothing is stacked under the
// title, so an entry head can never crush a subline against its own descenders.
#let anchor-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
  let right-parts = ()
  if not is-blank(location) { right-parts.push(location) }
  if not is-blank(dates) { right-parts.push(dates) }
  block(breakable: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    block(sticky: true, breakable: false, {
      set par(justify: false)
      grid(
        columns: (1fr, auto),
        align: (left + top, right + top),
        column-gutter: 1em,
        {
          if not is-blank(title) { text(weight: "semibold", fill: ink, title) }
          if not is-blank(title) and not is-blank(subtitle) { text(fill: muted)[ #sym.dash.en ] }
          if not is-blank(subtitle) { text(fill: muted, subtitle) }
        },
        if right-parts.len() > 0 {
          text(size: meta-size, fill: muted, right-parts.join([ #sym.dot.c ]))
        } else { [] },
      )
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
#let anchor-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: anchor-cv.with(
  author: "Jane Smith",
  accent-color: "#22423a",
  font: "Source Sans 3",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.6cm,
  leading: 0.65em,
  lang: "en",
  profession: "Director of Product",
  contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] },
)


#cv-section("Summary", accent-color: "#22423a", gap: 1.74em)

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#22423a", gap: 1.74em)

#anchor-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)
#anchor-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)

#cv-section("Experience", accent-color: "#22423a", gap: 1.74em)

#anchor-entry(
  title: "Director of Product",
  subtitle: "Meridian Labs",
  dates: "March 2021 - Present",
  location: "",
  meta: "",
  [
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
],
)
#anchor-entry(
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

#cv-section("Projects", accent-color: "#22423a", gap: 1.74em)

#anchor-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)
#anchor-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)

#cv-section("Skills", accent-color: "#22423a", gap: 1.74em)

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market

#cv-section("Languages", accent-color: "#22423a", gap: 1.74em)

#anchor-language(
  language: "English",
  level: "Native",
)
#anchor-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#anchor-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#22423a", gap: 1.74em)

#anchor-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  dates: "January 2020",
  location: "",
  meta: "",
  [],
)
#anchor-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  dates: "January 2019",
  location: "",
  meta: "",
  [],
)

#cv-section("Awards", accent-color: "#22423a", gap: 1.74em)

#anchor-entry(
  title: "Product Leader of the Year",
  subtitle: "Meridian Labs",
  dates: "January 2023",
  location: "",
  meta: "",
  [],
)

