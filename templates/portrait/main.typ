// Portrait CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Nunito Sans. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/portrait
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent runs
// through the three things that identify a role: the ring around the photo, the rule
// under each section label, and the ENTRY TITLES themselves. Section labels stay ink,
// so the accent marks what a reader scans for rather than the furniture.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale (standard rule 2), defined ONCE and expressed as em multiples of
// the resolved body size B - the `font-size` parameter, which the user can move between
// 9pt and 13pt. Absolute pt would detach the scale from that knob: at 9pt a 10pt label
// ends up LARGER than the body and meta stops being meta, and at 13pt the subhead falls
// below the body. em keeps every ratio intact at both ends of the range.
#let display-size = 1.95em // ~1.95 x B - the name
#let subhead-size = 1.15em // ~1.15 x B - the profession line
#let label-size = 0.9em // 0.9 x B - section labels (the one uppercase + tracked role)
#let meta-size = 0.82em // 0.82 x B - dates, location, contact, level, fine print

// The masthead's left gutter, as a FRACTION of the content width rather than a fixed
// length. Fixed, it did not give ground when the page margins widened, and the name
// column lost enough width to break a long double-barrelled surname at its hyphen under
// nothing more exotic than the "wide margins" setting. At 25% it still clears a full
// email at meta size and the 74pt photo above it at every margin.
#let GUTTER = 25%

// Document shell + masthead. The masthead is a two-column IDENTITY BLOCK: a fixed left
// gutter carrying the optional circle-clipped photo above the contact details stacked
// one per line, and the name and role set large in the column beside it. The gutter is
// structural, not photo-dependent - with `photo: none` (the default) the contact stack
// still holds it open, so the photoless document keeps the same two-column masthead
// rather than collapsing into the generic name-over-contact-line every other
// single-column template already uses. The body below is a plain full-width column.
// Nunito Sans is the single family (standard rule 1): regular + semibold + bold.
#let portrait-cv(
  author: "",
  profession: "",
  contact-items: (),
  photo: none,
  photo-radius: 50%,
  photo-size: 74pt,
  font: "Nunito Sans",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.7cm,
  leading: 0.65em,
  lang: "en",
  accent-color: "#2b5566",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: false)
  set page(margin: margin, paper: paper)
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = contact-items.len() > 0

  // Left gutter: the photo, then the contact details stacked one per line. The column is
  // structural - it holds the masthead's two-column shape whether or not a photo exists.
  let gutter = {
    set block(spacing: 0pt)
    set par(spacing: 0pt, leading: 0.42em, justify: false)
    set text(size: meta-size, fill: muted)
    if photo != none {
      box(
        clip: true,
        radius: photo-radius,
        width: photo-size,
        height: photo-size,
        stroke: 0.6pt + rgb(accent-color),
        image(photo, width: photo-size, height: photo-size, fit: "cover"),
      )
      if has-contact { v(10pt) }
    }
    for item in contact-items {
      block(above: 0pt, below: 4pt, item)
    }
  }

  // Right column: the name over the role, set against the gutter's top edge.
  let head-text = {
    set block(spacing: 0pt)
    set par(spacing: 0pt, leading: 0.4em, justify: false)
    if has-name { text(size: display-size, weight: "bold", fill: ink, author) }
    if has-prof {
      if has-name { v(display-size * 0.38) }
      text(size: subhead-size, weight: "regular", fill: muted, profession)
    }
  }

  if has-name or has-prof or has-contact or photo != none {
    block(above: 0pt, below: 1.2em, breakable: false, {
      set block(spacing: 0pt)
      grid(
        columns: (GUTTER, 1fr),
        align: (left + top, left + top),
        column-gutter: 18pt,
        gutter,
        head-text,
      )
      // The rule CLOSES the identity block; with no name and no role there is nothing to
      // close, so a contact-only document gets its contact stack and no floating rule.
      if has-name or has-prof {
        v(12pt)
        line(length: 100%, stroke: 1pt + rgb(accent-color))
      }
    })
  }

  body
}

// Section label: ink UPPERCASE + tracking over a thin accent rule. The label is ink
// because the accent belongs to the entry titles here.
// `gap` is the section separation resolved from the sectionSpacing knob (see the
// adapter): fixing it in the template made section gaps stop scaling while entry
// gaps did, so at "relaxed" the two converged and the label stopped reading as a
// section break. `below` stays fixed at the divider floor.
#let cv-section(title, accent-color: "#2b5566", gap: 1.7em) = {
  block(above: gap, below: 1em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.9pt, fill: ink, upper(title))
    v(4pt)
    line(length: 100%, stroke: 0.5pt + rgb(accent-color))
  })
}

// Entry: the title leads in the ACCENT (the one place colour carries meaning here) with
// a muted subtitle beside it and the dates flush right; location and an optional URL
// below in meta; then the body in ink.
#let portrait-entry(title: "", subtitle: "", dates: "", location: "", meta: "", accent-color: "#2b5566", body) = {
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
          if not is-blank(title) { text(weight: "semibold", fill: rgb(accent-color), title) }
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
#let portrait-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: portrait-cv.with(
  author: "Jane Smith",
  accent-color: "#2b5566",
  font: "Nunito Sans",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.7cm,
  leading: 0.65em,
  lang: "en",
  profession: "Director of Product",
  contact-items: (
  link("mailto:jane.smith@example.com")[jane.smith\@example.com],
  [+1 (415) 555 0148],
  [San Francisco, CA],
),
)


#cv-section("Summary", accent-color: "#2b5566", gap: 1.74em)

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#2b5566", gap: 1.74em)

#portrait-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  accent-color: "#2b5566",
  [],
)
#portrait-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  accent-color: "#2b5566",
  [],
)

#cv-section("Experience", accent-color: "#2b5566", gap: 1.74em)

#portrait-entry(
  title: "Director of Product",
  subtitle: "Meridian Labs",
  dates: "March 2021 - Present",
  location: "",
  meta: "",
  accent-color: "#2b5566",
  [
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
- Built and led a cross-functional org of 24 (PMs, designers, analysts), instituting a quarterly OKR cadence that lifted on-time delivery from 61% to 92%.
],
)
#portrait-entry(
  title: "Senior Product Manager",
  subtitle: "Northwind Technologies",
  dates: "January 2018 - February 2021",
  location: "",
  meta: "",
  accent-color: "#2b5566",
  [
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
- Ran continuous discovery with 120+ customer interviews, translating findings into a roadmap that raised NPS from 22 to 48.
],
)

#cv-section("Projects", accent-color: "#2b5566", gap: 1.74em)

#portrait-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  accent-color: "#2b5566",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)
#portrait-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  accent-color: "#2b5566",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)

#cv-section("Skills", accent-color: "#2b5566", gap: 1.74em)

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market

#cv-section("Languages", accent-color: "#2b5566", gap: 1.74em)

#portrait-language(
  language: "English",
  level: "Native",
)
#portrait-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#portrait-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#2b5566", gap: 1.74em)

#portrait-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  dates: "January 2020",
  location: "",
  meta: "",
  accent-color: "#2b5566",
  [],
)
#portrait-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  dates: "January 2019",
  location: "",
  meta: "",
  accent-color: "#2b5566",
  [],
)

#cv-section("Awards", accent-color: "#2b5566", gap: 1.74em)

#portrait-entry(
  title: "Product Leader of the Year",
  subtitle: "Meridian Labs",
  dates: "January 2023",
  location: "",
  meta: "",
  accent-color: "#2b5566",
  [],
)

