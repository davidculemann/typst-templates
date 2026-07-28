// Ledger CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Libertinus Serif, which ships with Typst, so it renders as
// intended with nothing to install.
//
// Derived from finely-crafted-cv (https://typst.app/universe/package/finely-crafted-cv),
// (c) its authors, used under MIT. That licence continues to apply,
// so this file is not MIT-0: keep this notice if you redistribute the template
// itself. A CV you write with it is your own work.
// Modified from the original by JobSprout: restructured for a section registry,
// re-typeset to a fixed size scale, and reworked for empty-field handling.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/ledger
#set page(fill: rgb("#ffffff"))

#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). Ledger is
// monochrome-editorial: the default accent is near-black and only tints the
// rules; muteness of secondary text comes from colour, never from light weights.
#let ink = rgb("#1a1a1a")
#let muted = rgb("#5a5750")

// Fixed size scale from body B = 11pt (standard rule 2), defined ONCE and reused.
// Entry text is body size (the show's `font-size`); these cover everything else.
#let display-size = 20pt // ~1.8 x B - the small-caps name (restrained bold masthead)
#let lead-size = 12.5pt // ~1.15 x B - entry organisation/institution + its dot-leader date
#let body-size = 11pt // B - the tagline, secondary role line
#let label-size = 9.5pt // ~0.86 x B - roman-numeral section labels (the one uppercase + tracked role)
#let meta-size = 9pt // ~0.82 x B - contact line, location, secondary timeframe

// Sequential roman numerals for section labels (upstream `set heading(numbering)`).
#let ledger-section-counter = counter("ledger-section")

// Document shell: set-rules + PDF metadata only. The masthead and every section
// are composed full-width in document order by wrapSections. Libertinus Serif is
// the single text family (standard rule 1) - upstream finely-crafted-cv's font,
// unused by our other templates; regular + bold weights only, italic reserved for
// the tagline and the entry role line. Justified body is the editorial identity.
#let ledger-cv(
  author: "",
  font: "Libertinus Serif",
  font-size: 11pt,
  paper: "a4",
  margin: 0.5in,
  leading: 0.6em,
  lang: "en",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: true)
  set page(margin: margin, paper: paper)
  set par(justify: true, leading: leading)

  show link: set text(fill: muted)

  ledger-section-counter.update(0)
  body
}

// Masthead (upstream headline): the name in bold SMALL-CAPS at display size on the
// left, an italic tagline (a derived profession) at the bottom-right, then a
// full-width accent-tinted rule, then a muted plain contact line. Upstream's
// top-right icon contact header is dropped per the brand bar (no icon spam); the
// contact reads as one quiet line under the rule. Small-caps appears on this ONE
// element; uppercase on the section labels only (standard rule 4).
#let masthead(author: "", tagline: "", contact: "", accent-color: "#1a1a1a") = {
  let has-name = not is-blank(author)
  let has-tag = not is-blank(tagline)
  let has-contact = not is-blank(contact)
  // Nothing to show -> emit nothing (no floating rule over an empty name slot).
  if has-name or has-tag or has-contact {
    block(above: 0pt, below: 1em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, justify: false)
      if has-name or has-tag {
        grid(
          columns: (1fr, auto),
          align: (left + bottom, right + bottom),
          column-gutter: 1em,
          if has-name { text(size: display-size, weight: "bold", fill: ink, smallcaps(author)) } else { [] },
          if has-tag { text(size: body-size, style: "italic", fill: muted, tagline) } else { [] },
        )
        v(5pt)
        line(length: 100%, stroke: 1pt + rgb(accent-color))
        if has-contact {
          v(5pt)
          text(size: meta-size, fill: muted, contact)
        }
      } else {
        // Contact only (no name/tagline): the quiet line alone, no floating rule.
        text(size: meta-size, fill: muted, contact)
      }
    })
  }
}

// Section label (upstream numbered heading): a sequential ROMAN numeral + the label
// in UPPERCASE with small tracking - the one place caps and tracking appear
// (standard rules 4 + 5) - then a light hairline that is a lightened tint of the
// accent. Sticky so a label never orphans at a page bottom; it travels to the
// entry below. The leading `above` collapses at the top of the flow.
#let cv-section(title, accent-color: "#1a1a1a") = {
  ledger-section-counter.step()
  block(above: 1.4em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "bold", fill: ink, tracking: 0.6pt)[
      #context ledger-section-counter.display("I.")#h(0.5em)#upper(title)
    ]
    v(3pt)
    line(length: 100%, stroke: 0.75pt + rgb(accent-color).lighten(35%))
  })
}

// The dot-leader entry (upstream company/job heading - THE signature): the lead
// (organisation / institution / title) in bold at lead-size on the left, a repeated
// dot leader filling the space, and the dates in bold at lead-size at the right
// terminus. The organisation and its date are a co-equal pair joined by the leader
// (the ledger/index identity) - the date being lead-size, not meta, is deliberate
// here and ONLY here. A secondary line (role italic + location muted) sits below,
// then the body copy justified. Sticky header so it is never orphaned.
#let ledger-entry(lead: "", dates: "", secondary: "", location: "", meta: "", body) = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    block(sticky: true, breakable: false, {
      set par(justify: false)
      // The lead is the dot-leader head; if it is blank (e.g. a role with no
      // organisation) the secondary is promoted to the head so its dates are never
      // lost, and the separate italic secondary line is suppressed.
      let head = if not is-blank(lead) { lead } else { secondary }
      let show-secondary = (not is-blank(lead)) and (not is-blank(secondary))
      if not is-blank(head) or not is-blank(dates) {
        grid(
          columns: (auto, 1fr, auto),
          align: (left + bottom, center + bottom, right + bottom),
          column-gutter: 0.55em,
          if not is-blank(head) { text(size: lead-size, weight: "bold", fill: ink, head) } else { [] },
          if not is-blank(dates) { box(width: 100%, inset: (bottom: 2.5pt), repeat(text(fill: muted, size: meta-size)[.#h(0.4em)])) } else { [] },
          if not is-blank(dates) { text(size: meta-size, fill: muted, dates) } else { [] },
        )
      }
      if show-secondary or not is-blank(location) {
        v(2.5pt)
        grid(
          columns: (1fr, auto),
          align: (left + horizon, right + horizon),
          column-gutter: 0.75em,
          if show-secondary { text(style: "italic", fill: ink, secondary) } else { [] },
          if not is-blank(location) { text(size: meta-size, fill: muted, location) } else { [] },
        )
      }
      if not is-blank(meta) {
        v(1.5pt)
        text(size: meta-size, fill: muted, meta)
      }
    })
    if not is-blank(body) {
      v(4pt)
      block(spacing: 0pt, {
        set text(fill: ink)
        body
      })
    }
  })
}

// Language row (our addition; upstream has none): the language at the left, the
// proficiency muted at the right on one line, so it stays a compact list rather
// than a stack of entry blocks.
#let ledger-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.75em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}



#show: ledger-cv.with(
  author: "Jane Smith",
  font: "Libertinus Serif",
  font-size: 11pt,
  paper: "a4",
  margin: 0.5in,
  leading: 0.6em,
  lang: "en",
)

#masthead(author: "Jane Smith", tagline: "Director of Product", contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.45em) + sym.bar.v + h(0.45em) + [+1 (415) 555 0148] + h(0.45em) + sym.bar.v + h(0.45em) + [San Francisco, CA] }, accent-color: "#1a1a1a")

#cv-section("Summary", accent-color: "#1a1a1a")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#1a1a1a")

#ledger-entry(
  lead: "Stanford University",
  dates: "September 2010 - June 2012",
  secondary: "M.S. in Management Science & Engineering",
  location: "",
  meta: "",
  [],
)

#ledger-entry(
  lead: "University of California, Berkeley",
  dates: "September 2006 - June 2010",
  secondary: "B.A. in Economics, with Honours",
  location: "",
  meta: "",
  [],
)
#cv-section("Experience", accent-color: "#1a1a1a")

#ledger-entry(
  lead: "Meridian Labs",
  dates: "March 2021 - Present",
  secondary: "Director of Product",
  location: "",
  meta: "",
  [
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
- Built and led a cross-functional org of 24 (PMs, designers, analysts), instituting a quarterly OKR cadence that lifted on-time delivery from 61% to 92%.
],
)

#ledger-entry(
  lead: "Northwind Technologies",
  dates: "January 2018 - February 2021",
  secondary: "Senior Product Manager",
  location: "",
  meta: "",
  [
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
- Ran continuous discovery with 120+ customer interviews, translating findings into a roadmap that raised NPS from 22 to 48.
],
)
#cv-section("Projects", accent-color: "#1a1a1a")

#ledger-entry(
  lead: "Activation Engine",
  dates: "",
  secondary: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)

#ledger-entry(
  lead: "Insights Platform",
  dates: "",
  secondary: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)
#cv-section("Skills", accent-color: "#1a1a1a")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market

#cv-section("Languages", accent-color: "#1a1a1a")

#ledger-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#ledger-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#ledger-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#1a1a1a")

#ledger-entry(
  lead: "Certified Scrum Product Owner (CSPO)",
  dates: "January 2020",
  secondary: "Scrum Alliance",
  location: "",
  meta: "",
  [],
)

#ledger-entry(
  lead: "Pragmatic Institute Certified (PMC-III)",
  dates: "January 2019",
  secondary: "Pragmatic Institute",
  location: "",
  meta: "",
  [],
)
#cv-section("Awards", accent-color: "#1a1a1a")

#ledger-entry(
  lead: "Product Leader of the Year",
  dates: "January 2023",
  secondary: "Meridian Labs",
  location: "",
  meta: "",
  [],
)
