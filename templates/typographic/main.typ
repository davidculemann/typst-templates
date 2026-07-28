// Typographic CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in EB Garamond. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Derived from typographic-resume (https://typst.app/universe/package/typographic-resume),
// (c) its authors, used under MIT. That licence continues to apply,
// so this file is not MIT-0: keep this notice if you redistribute the template
// itself. A CV you write with it is your own work.
// Modified from the original by JobSprout: restructured for a section registry,
// re-typeset to a fixed size scale, and reworked for empty-field handling.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/typographic
#set page(fill: rgb("#ffffff"))


#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (CV typography standard rule 6). Secondary
// text is muted by COLOUR, never by stacking light weights. Matches manifest
// secondaryTextColor. Module scope so every house macro shares one value.
#let muted = rgb("#5a5750")
#let ink = rgb("#1a1a1a")
#let hairline = rgb("#cfccc4")

// TWO text families only (CV typography standard rule 1). EB Garamond is the
// editorial serif for the masthead, body and the small-caps profession line;
// Inter is the single neutral sans for section labels AND every meta row (dates,
// location, proficiency, contact fine print). The serif is fixed here (not the
// user body font) so the masthead identity holds even when the body font
// changes. (Font Awesome, below, is an icon face, not a text family.)
#let serif-font = "EB Garamond"
#let sans-font = "Inter"

// Fixed 5-step size scale derived from body B = 10pt (standard rule 2), defined
// ONCE and referenced everywhere. Entry titles are body size + bold weight, not
// a bespoke size. Body copy itself is the show function's `font-size` param
// (default B = 10pt); these lets cover everything else.
#let display-size = 24pt // ~2.4 x B - the last-name masthead
#let subhead-size = 12pt // ~1.2 x B - the first-name line
#let body-size = 10pt // B - profession small-caps, contact/body-level sans
#let label-size = 9pt // ~0.9 x B - section labels, contact icon glyph
#let meta-size = 8.2pt // ~0.82 x B - dates, location, level, contact values

// FontAwesome glyph by ligature name; brand names resolve to the Brands face.
// Contact rows use a few small glyphs (phone / envelope / brand marks), matching
// the upstream contact icons. Ligatures are enabled locally (the body disables
// them globally).
#let fa-icon(name) = {
  let brand-icons = (
    "github", "linkedin", "twitter", "x-twitter", "facebook", "instagram",
    "youtube", "discord", "slack", "reddit", "telegram", "whatsapp", "dribbble",
    "behance", "medium", "stack-overflow", "gitlab", "mastodon",
  )
  let is-brand = name in brand-icons
  text(
    font: if is-brand { "Font Awesome 6 Brands" } else { "Font Awesome 6 Free Solid" },
    weight: if is-brand { 400 } else { 900 },
    ligatures: true,
    name,
  )
}

// Document shell (upstream `resume`): only the set-rules and PDF metadata. The
// masthead, bio and contact live INSIDE the left aside column (composed by
// wrapSections and emitted through the house macros below), never full-width
// above the layout, so the name rides at the top of the aside beside the wide
// experience column exactly as upstream renders it.
#let typographic-cv(
  author: "",
  font: "EB Garamond",
  font-size: 10pt,
  paper: "a4",
  margin: 1.6cm,
  leading: 0.62em,
  lang: "en",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(
    font: (font, sans-font),
    size: font-size,
    fill: ink,
    lang: lang,
    ligatures: false,
    hyphenate: false,
  )

  set page(margin: margin, paper: paper)
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  body
}

// The masthead (upstream aside top): the FIRST name in a small serif on its own
// line, then the LAST name large in the same serif below, then the profession as
// serif SMALL-CAPS (upstream's optional profession line, here derived from the
// most-recent experience title by wrapSections). Small-caps keeps the profession
// distinct from the bold uppercase sans section labels without a second
// full-uppercase shout; muteness comes from colour, not weight. Sits at the top
// of the aside column, one spacing-controlled block.
#let masthead(author: "", profession: "", photo: none, photo-radius: 4pt, photo-size: 2.5cm) = {
  block(above: 0pt, below: 1.1em, breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, leading: 0.42em)
    if photo != none {
      box(
        clip: true,
        radius: photo-radius,
        width: photo-size,
        height: photo-size,
        image(photo, width: photo-size, height: photo-size, fit: "cover"),
      )
      v(10pt)
    }
    if type(author) == str {
      let parts = author.split(" ").filter(p => p != "")
      let last = if parts.len() > 0 { parts.at(-1) } else { "" }
      let first = if parts.len() > 1 { parts.slice(0, -1).join(" ") } else { "" }
      if first != "" {
        text(font: serif-font, size: subhead-size, weight: "regular", fill: ink, first)
        linebreak()
      }
      text(font: serif-font, size: display-size, weight: "regular", fill: ink, last)
    } else {
      text(font: serif-font, size: display-size, weight: "regular", fill: ink, author)
    }
    if profession != "" {
      v(0.5em)
      text(font: serif-font, size: body-size, weight: "regular", fill: muted, smallcaps(profession))
    }
  })
}

// The bio (upstream): the summary as unlabelled italic serif directly under the
// masthead at the top of the aside. Regular weight italic (no light); it is the
// primary summary voice. No section rule, matching the upstream `bio` slot that
// replaces the (absent) profile picture.
#let bio(body) = block(above: 0pt, below: 1.2em, breakable: false, {
  set text(weight: "regular", style: "italic", fill: ink)
  set par(leading: 0.72em, justify: false)
  body
})

// Section header (the distinctive upstream move): the title in UPPERCASE,
// RIGHT-ALIGNED, sitting at the right end of a full-width 1pt rule tinted with
// the resolved accent. Uppercase + small tracking is the ONE place caps and
// tracking appear (standard rules 4 + 5). The label is the sans at label-size,
// regular weight. Sticky so a label is never orphaned at a page bottom; it
// travels to the entry that follows. Airy `above` (editorial rhythm); the
// label -> rule gap is the v() below. The leading `above` collapses at the top of
// a column, so the first section in each pane rides flush with the top.
#let cv-section(title, accent-color: "#7b3f3f") = {
  block(above: 1.9em, below: 0.95em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    set align(right)
    text(font: sans-font, weight: "regular", size: label-size, tracking: 1pt, fill: ink, upper(title))
    v(3pt)
    line(length: 100%, stroke: 1pt + rgb(accent-color))
  })
}

// The CONTACT block (upstream aside): a right-aligned ruled "CONTACT" label
// (#cv-section) above icon+text rows, each row an FA glyph gutter and its value,
// rows separated by thin hairline rules. Header-data-driven: wrapSections builds
// the (icon-name, value) item list from the phone/email/location/social fields.
#let contact-section(accent-color: "#7b3f3f", items) = {
  cv-section("Contact", accent-color: accent-color)
  // The sectionSpacing knob sets a global block/par spacing; reset it here so it
  // cannot leak into the contact rows or the hairline rules between them (the
  // explicit v() below fully control the row rhythm). sectionSpacing is for the gaps
  // BETWEEN sections, never inside the contact stack.
  set block(spacing: 0pt)
  set par(spacing: 0pt)
  for (i, item) in items.enumerate() {
    let (icon, value) = item
    if i > 0 {
      v(6pt)
      line(length: 100%, stroke: 0.1pt + hairline)
      v(6pt)
    } else {
      v(2pt)
    }
    // Icon in a fixed-width box gutter, then the value, in ONE flow. A box gutter
    // (not an isolated narrow grid column) keeps the glyph free of width pressure
    // so multi-token FA ligatures (e.g. "location-dot") shape as one glyph instead
    // of wrapping into their sub-tokens.
    block(above: 0pt, below: 0pt, {
      set text(font: sans-font, size: meta-size, fill: muted)
      box(width: 16pt)[#{
        set text(fill: ink, size: label-size)
        fa-icon(icon)
      }]
      value
    })
  }
}

// Two-column layout (upstream aside LEFT / main RIGHT) as a BREAKABLE grid, so a
// long aside flows onto page 2+ alongside the main column.
//
// The aside was previously `place`d at the top-left so it contributed zero flow
// height and the main column alone drove pagination. That kept document height
// growing monotonically with main content, but an aside taller than the page kept
// drawing past the paper edge: entries printed on top of each other and text was
// lost (a 45-language sidebar reached 1510pt on an 842pt page). A grid ties the
// two column heights, which is the correct trade: the name still rides at the top
// beside the experience column, because both cells start at the top of the row.
#let cv-layout(aside: [], main: []) = {
  grid(
    columns: (31%, 1fr),
    column-gutter: 24pt,
    align: (left + top, left + top),
    aside,
    main,
  )
}

// Entry header wrapper: kept intact and glued to the content that follows, so a
// header is never orphaned at a page bottom. Scoped to entries only; the
// two-column layout grid stays a plain breakable grid for multi-page flow (no
// global `show grid` sticky rule).
#let entry-head(body) = block(sticky: true, breakable: false, below: 0.3em, body)

// Work / volunteering entry (main column, upstream `work-entry`): the timeframe
// (left) and location (right) as muted sans meta, then the bold TITLE-CASE role
// and organization, a thin hairline, then the body copy in the serif body font,
// muted. The role leads with weight, not uppercase (standard rule 4).
#let work-entry(
  timeframe: "",
  location: "",
  role: "",
  organization: "",
  body,
) = {
  block(sticky: true, breakable: false, above: 0pt, below: 0pt, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    set text(font: sans-font)
    if not (is-blank(timeframe) and is-blank(location)) {
      grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        text(size: meta-size, fill: muted, timeframe),
        text(size: meta-size, fill: muted, location),
      )
      v(5pt)
    }
    if not is-blank(role) {
      text(weight: "bold", fill: ink, role)
      if not is-blank(organization) {
        [ ]
        sym.dash.en
        [ ]
        organization
      }
    } else if not is-blank(organization) {
      organization
    }
    v(5pt)
    line(length: 100%, stroke: 0.4pt + hairline)
  })
  // The editorial air: a generous gap after each entry's body (upstream fills it
  // with v(1fr)); a fixed 2.8em reproduces that generosity for paginated flow.
  block(above: 7pt, below: 2.8em, {
    set text(fill: muted)
    set par(leading: 0.62em)
    body
  })
}

// Education entry (main column, upstream `education-entry`): bold TITLE-CASE
// degree over the institution in sans, a hairline, then the body copy and the
// timeframe in muted. The degree leads with weight, not uppercase.
#let education-entry(
  timeframe: "",
  degree: "",
  institution: "",
  body,
) = {
  block(sticky: true, breakable: false, above: 0pt, below: 0pt, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    set text(font: sans-font, fill: ink)
    if not is-blank(degree) { text(weight: "bold", degree) }
    if not is-blank(institution) {
      if not is-blank(degree) { linebreak() }
      institution
    }
    v(5pt)
    line(length: 100%, stroke: 0.4pt + hairline)
  })
  block(above: 7pt, below: 2.8em, {
    set text(fill: muted)
    if not is-blank(body) {
      set par(leading: 0.62em)
      body
    }
    if not is-blank(timeframe) {
      if not is-blank(body) { v(3pt) }
      text(font: sans-font, size: meta-size, fill: muted, timeframe)
    }
  })
}

// Language entry (aside, upstream `language-entry`): language name at the left
// (body size), proficiency level right-aligned as muted meta on the same line.
#let cv-language(language: "", level: "") = {
  set text(font: sans-font)
  grid(
    columns: (1fr, auto),
    align: (left, right),
    [#language],
    text(fill: muted, size: meta-size, level),
  )
}



#show: typographic-cv.with(
  author: "Jane Smith",
  font: "EB Garamond",
  font-size: 10pt,
  paper: "a4",
  margin: 1.6cm,
  leading: 0.62em,
  lang: "en",
)

#cv-layout(
  aside: [#masthead(author: "Jane Smith", profession: "Director of Product")

#bio[
Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.
]

#contact-section(accent-color: "#7b3f3f", (
  ("phone", [+1 (415) 555 0148]),
  ("envelope", link("mailto:jane.smith@example.com")[jane.smith\@example.com]),
  ("location-dot", [San Francisco, CA]),
))

#cv-section("Skills", accent-color: "#7b3f3f")

#text(font: "Inter")[Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market]

#cv-section("Languages", accent-color: "#7b3f3f")

#cv-language(
  language: "English",
  level: "Native",
)
#v(4pt)
#cv-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(4pt)
#cv-language(
  language: "Mandarin",
  level: "Conversational",
)
],
  main: [
#cv-section("Education", accent-color: "#7b3f3f")

#education-entry(
  timeframe: "September 2010 - June 2012",
  degree: "M.S. in Management Science & Engineering",
  institution: "Stanford University",
  [],
)

#education-entry(
  timeframe: "September 2006 - June 2010",
  degree: "B.A. in Economics, with Honours",
  institution: "University of California, Berkeley",
  [],
)
#cv-section("Experience", accent-color: "#7b3f3f")

#work-entry(
  timeframe: "March 2021 - Present",
  location: "",
  role: "Director of Product",
  organization: "Meridian Labs",
  [
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
- Built and led a cross-functional org of 24 (PMs, designers, analysts), instituting a quarterly OKR cadence that lifted on-time delivery from 61% to 92%.
],
)

#work-entry(
  timeframe: "January 2018 - February 2021",
  location: "",
  role: "Senior Product Manager",
  organization: "Northwind Technologies",
  [
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
- Ran continuous discovery with 120+ customer interviews, translating findings into a roadmap that raised NPS from 22 to 48.
],
)

#work-entry(
  timeframe: "June 2015 - December 2017",
  location: "",
  role: "Product Manager",
  organization: "Brightwave",
  [
- Shipped a mobile checkout redesign that lifted conversion 18% and reduced cart abandonment by a third.
- Defined the north-star metric and instrumentation for a 2M-user product, replacing vanity metrics with retention cohorts.
],
)
#cv-section("Projects", accent-color: "#7b3f3f")

#entry-head({
  let cells = ([#text(weight: "bold")[Activation Engine]],)
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
})

#block(above: 6pt, below: 0.9em)[- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.

#block(above: 0.5em)[Product Strategy, Experimentation]]

#entry-head({
  let cells = ([#text(weight: "bold")[Insights Platform]],)
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
})

#block(above: 6pt, below: 0.9em)[- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.

#block(above: 0.5em)[Analytics, SQL]]
#cv-section("Certifications", accent-color: "#7b3f3f")

#entry-head({
  let cells = ([#text(weight: "bold")[Certified Scrum Product Owner (CSPO)]], [#text(fill: rgb("#5a5750"))[Scrum Alliance]], [#text(fill: rgb("#5a5750"))[January 2020]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
})

#entry-head({
  let cells = ([#text(weight: "bold")[Pragmatic Institute Certified (PMC-III)]], [#text(fill: rgb("#5a5750"))[Pragmatic Institute]], [#text(fill: rgb("#5a5750"))[January 2019]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
})
#cv-section("Awards", accent-color: "#7b3f3f")

#entry-head({
  let cells = ([#text(weight: "bold")[Product Leader of the Year]], [#text(fill: rgb("#5a5750"))[Meridian Labs]], [#text(fill: rgb("#5a5750"))[January 2023]])
  let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
  let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
  let left-aligned = ()
  let right-aligned = ()
  for (i, cell) in grid-cells.enumerate() {
    if calc.even(i) { left-aligned.push(cell) } else { right-aligned.push(cell) }
  }
  grid(
    columns: (1fr, auto),
    align: (left + top, right + top),
    [#left-aligned.join(linebreak())],
    [#right-aligned.join(linebreak())],
  )
  for line in overflow { block(above: 0.3em)[#line] }
})],
)
