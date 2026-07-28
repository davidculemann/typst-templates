// Atlas CV, a Typst resume template.
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
// Edit in a browser: https://www.jobsprout.ai/resume-templates/atlas
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is used
// as ONE tasteful block: a full-width header band (name + contact, white). Below the
// band the two columns are uncolored (ATS-safe): ink on white, the accent tints only the
// section labels/rules and the column divider. Default accent a deep teal.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")
#let band-ink = rgb("#f5f7f6")
#let band-muted = rgb("#cdd8d2")

// Fixed size scale from body B = 10pt (standard rule 2), defined ONCE.
#let display-size = 21pt // ~2.1 x B - the name in the band
#let subhead-size = 12pt // ~1.2 x B - the profession line in the band
#let body-size = 10pt // B
#let label-size = 9pt // ~0.9 x B - section labels (uppercase + tracked)
#let meta-size = 8.2pt // ~0.82 x B - dates, location, contact, level, fine print

#let RAIL-FRAC = 32%

// Document shell: set-rules + PDF metadata only. The band and the two-column body are
// composed by wrapSections. Nunito Sans is the single family (standard rule 1).
#let atlas-cv(
  author: "",
  font: "Nunito Sans",
  font-size: 10pt,
  paper: "a4",
  margin: 1.4cm,
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

// Header band (the tasteful single block): a full-content-width filled rectangle holding
// the name (bold white), profession (muted white) and a quiet contact line (muted white).
// Inset within the page margins so it paginates cleanly and never bleeds a page-2 header.
// Guarded so an empty CV shows no floating band.
// photo (VFS path string) sits at the band's right edge as a circle; none
// renders the text stack alone, byte-identically.
#let band-header(author: "", profession: "", contact: "", accent-color: "#1f5c52", photo: none, photo-radius: 50%, photo-size: 2.2cm) = {
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof {
    block(width: 100%, fill: rgb(accent-color), inset: (x: 18pt, y: 16pt), below: 1.4em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.5em, justify: false)
      show link: set text(fill: band-muted)
      let text-stack = {
        if has-name { text(size: display-size, weight: "bold", fill: band-ink, tracking: 0.3pt, author) }
        if has-prof {
          if has-name { linebreak(); v(3pt) }
          text(size: subhead-size, weight: "regular", fill: band-muted, profession)
        }
        if has-contact {
          if has-name or has-prof { v(7pt) }
          text(size: meta-size, weight: "regular", fill: band-muted, contact)
        }
      }
      if photo != none {
        grid(
          columns: (1fr, auto),
          column-gutter: 14pt,
          align: (left + horizon, right + horizon),
          text-stack,
          box(
            clip: true,
            radius: photo-radius,
            width: photo-size,
            height: photo-size,
            stroke: 1pt + rgb(255, 255, 255, 60),
            image(photo, width: photo-size, height: photo-size, fit: "cover"),
          ),
        )
      } else {
        text-stack
      }
    })
  }
}

// Section label (rail + main share it): accent UPPERCASE + tracking over a thin accent
// rule. Sticky so a label never orphans at a page bottom.
#let cv-section(title, accent-color: "#1f5c52") = {
  block(above: 1.2em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: rgb(accent-color), upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.6pt + rgb(accent-color))
  })
}

// Rail credential (certifications / awards in the narrow rail): compact stacked - name
// (semibold ink), then issuer + date muted beneath, dot-separated. No bullets, no wide
// date grid, so it fills the rail cleanly.
#let rail-cred(name: "", issuer: "", date: "") = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    set text(hyphenate: false)
    if not is-blank(name) { text(weight: "semibold", fill: ink, name) }
    let meta = (issuer, date).filter(v => not is-blank(v)).join(text(fill: muted)[ #sym.dot.c ])
    if not is-blank(meta) { v(2pt); text(size: meta-size, fill: muted, meta) }
  })
}

// Rail language: language over the proficiency level (muted) STACKED beneath, so a long
// level never squeezes the language onto broken lines in the narrow rail.
#let atlas-language(language: "", level: "") = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    set text(hyphenate: false)
    if not is-blank(language) { text(fill: ink, language) }
    if not is-blank(level) {
      if not is-blank(language) { v(1pt) }
      text(size: meta-size, fill: muted, level)
    }
  })
}

// Main entry: semibold-ink title leads with a muted subtitle, dates right; location and
// an optional URL meta line below; then the body. No mid-word hyphenation on the title.
#let atlas-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
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

// Two-column body (below the band): a narrow meta rail on the LEFT (skills, languages,
// certifications, awards) beside the wide main column (summary, experience, ...). The
// divider is the main column's LEFT border (a lightened accent tint, inset so it never
// touches the text), redrawn on every page so the column edge reads deliberately even
// after the rail empties on page 2+.
#let cv-layout(rail: [], main: [], gap: 20pt, accent-color: "#1f5c52") = {
  grid(
    columns: (RAIL-FRAC, 1fr),
    column-gutter: gap,
    rail,
    block(
      width: 100%,
      inset: (left: 16pt),
      stroke: (left: 0.8pt + rgb(accent-color).lighten(55%)),
      main,
    ),
  )
}



#show: atlas-cv.with(
  author: "Jane Smith",
  font: "Nunito Sans",
  font-size: 10pt,
  paper: "a4",
  margin: 1.4cm,
  leading: 0.62em,
  lang: "en",
)

#band-header(author: "Jane Smith", profession: "Director of Product", contact: { link("mailto:jane.smith@example.com")[jane.smith\@example.com] + h(0.5em) + sym.bar.v + h(0.5em) + [+1 (415) 555 0148] + h(0.5em) + sym.bar.v + h(0.5em) + [San Francisco, CA] }, accent-color: "#1f5c52")
#cv-layout(
  rail: [
#cv-section("Skills", accent-color: "#1f5c52")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market, Stakeholder Management, Figma, Python, Experimentation

#cv-section("Languages", accent-color: "#1f5c52")

#atlas-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#atlas-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#atlas-language(
  language: "Mandarin",
  level: "Conversational",
)

#cv-section("Certifications", accent-color: "#1f5c52")

#rail-cred(
  name: "Certified Scrum Product Owner (CSPO)",
  issuer: "Scrum Alliance",
  date: "January 2020",
)

#rail-cred(
  name: "Pragmatic Institute Certified (PMC-III)",
  issuer: "Pragmatic Institute",
  date: "January 2019",
)

#cv-section("Awards", accent-color: "#1f5c52")

#rail-cred(
  name: "Product Leader of the Year",
  issuer: "Meridian Labs",
  date: "January 2023",
)
],
  main: [
#cv-section("Summary", accent-color: "#1f5c52")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#1f5c52")

#atlas-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)

#atlas-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)

#cv-section("Experience", accent-color: "#1f5c52")

#atlas-entry(
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

#atlas-entry(
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

#atlas-entry(
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

#atlas-entry(
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

#atlas-entry(
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

#cv-section("Projects", accent-color: "#1f5c52")

#atlas-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)

#atlas-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)
],
  accent-color: "#1f5c52",
)
