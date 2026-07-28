// Quartz CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Raleway. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Licence: MIT-0. Use it, change it, publish the result as your own CV.
// No attribution has to travel with the document you make from it.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/quartz
#set page(fill: rgb("#ffffff"))

// Shared predicate for values that render nothing. Apply BEFORE wrapping a
// value in strong()/emph()/text(): styled empty content is not blank.
// Byte-synced with TYPST_IS_BLANK in utils/typst-blocks.ts (typst-codegen.test.ts).
#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is used
// as ONE tasteful block: a SOFT-TINT full-height left rail (a lightened wash of the
// accent). Because the tint is light, the rail keeps DARK text (ink/muted) - legible on
// the wash, so the global AI-diff colours also read fine and need no shadowing. The
// accent also tints the section labels/rules. Default accent a muted slate-green.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

#let PANEL-FRAC = 33%

// Fixed size scale from body B = 10pt (standard rule 2), defined ONCE.
#let display-size = 18pt // ~1.8 x B - the name (in the narrow rail)
#let subhead-size = 11pt // ~1.1 x B - the profession line
#let body-size = 10pt // B
#let label-size = 9pt // ~0.9 x B - section labels (uppercase + tracked)
#let meta-size = 8.2pt // ~0.82 x B - dates, location, contact, level, fine print

// Document shell: set-rules + PDF metadata + the tint rail. The page background paints a
// light wash of the accent down the left PANEL-FRAC of EVERY page (so a long CV keeps the
// rail). Page left/right margins are 0 so the rail is edge-to-edge; top/bottom margins
// give the flowing main column its per-page margins. Raleway is the single family.
#let quartz-cv(
  author: "",
  font: "Raleway",
  font-size: 10pt,
  paper: "a4",
  margin: 1.4cm,
  leading: 0.62em,
  lang: "en",
  accent-color: "#3f5450",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: false)
  set page(
    paper: paper,
    margin: (top: margin, bottom: margin, left: 0pt, right: 0pt),
    background: place(top + left, rect(width: PANEL-FRAC, height: 100%, fill: rgb(accent-color).lighten(80%))),
  )
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  body
}

// Two-column layout as a BREAKABLE grid, so a long aside flows onto page 2+ alongside
// the main column. It was previously `place`d at the top, contributing zero flow height:
// that let the main column alone drive pagination, but an aside taller than the page then
// kept drawing past the paper edge, overlapping its own entries and losing text (a
// 45-language sidebar reached 2044pt on an 842pt page). The rail fill spans every page via
// the page background, so it still looks continuous when the aside runs short.
// Horizontal padding sits inside each column; the vertical margins come from the page.
#let cv-layout(main: [], aside: [], hpad: 1.4cm, gap: 22pt) = {
  grid(
    columns: (PANEL-FRAC, 1fr),
    column-gutter: gap,
    align: (left + top, left + top),
    block(inset: (left: hpad, right: 12pt), {
      // No mid-word hyphenation in the narrow rail: a long name or skill wraps at a space.
      set text(hyphenate: false)
      aside
    }),
    block(inset: (right: hpad), main),
  )
}

// Rail masthead: an optional circle-clipped photo above the name (bold ink)
// over the profession (accent). photo is a VFS path string; none renders
// nothing and reserves no space.
#let masthead(author: "", profession: "", accent-color: "#3f5450", photo: none, photo-radius: 50%, photo-size: 2.6cm) = {
  block(above: 0pt, below: 1.1em, breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, leading: 0.4em, justify: false)
    if photo != none {
      box(
        clip: true,
        radius: photo-radius,
        width: photo-size,
        height: photo-size,
        stroke: 0.6pt + rgb(accent-color),
        image(photo, width: photo-size, height: photo-size, fit: "cover"),
      )
      v(10pt)
    }
    text(size: display-size, weight: "bold", fill: ink, author)
    if profession != "" {
      v(3pt)
      text(size: subhead-size, weight: "regular", fill: rgb(accent-color), profession)
    }
  })
}

// Rail section label: accent UPPERCASE + tracking over a thin accent rule.
#let panel-section(title, accent-color: "#3f5450") = {
  block(above: 1.4em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: rgb(accent-color), upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.5pt + rgb(accent-color).lighten(35%))
  })
}

// Rail contact: a CONTACT label then one muted line per item (email, phone, location,
// social), a quiet legible stack.
#let panel-contact(items, accent-color: "#3f5450") = {
  panel-section("Contact", accent-color: accent-color)
  set block(spacing: 0pt)
  set par(spacing: 0pt)
  for item in items {
    block(above: 0pt, below: 4pt, breakable: false, {
      set text(size: meta-size, fill: muted)
      item
    })
  }
}

// Rail credential (certifications / awards): compact stacked - name (semibold ink), then
// issuer + date muted beneath, dot-separated.
#let quartz-rail-cred(name: "", issuer: "", date: "") = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    set text(hyphenate: false)
    if not is-blank(name) { text(weight: "semibold", fill: ink, name) }
    let meta = (issuer, date).filter(v => not is-blank(v)).join(text(fill: muted)[ #sym.dot.c ])
    if not is-blank(meta) { v(2pt); text(size: meta-size, fill: muted, meta) }
  })
}

// Rail language: language over the proficiency level (muted) STACKED beneath.
#let quartz-language(language: "", level: "") = {
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

// Main section label: accent UPPERCASE + tracking over an accent rule.
#let main-section(title, accent-color: "#3f5450") = {
  block(above: 1.3em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: rgb(accent-color), upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.6pt + rgb(accent-color))
  })
}

// Main entry: semibold-ink title leads with a muted subtitle, dates right; location and
// an optional URL meta line below; then the body. No mid-word hyphenation on the title.
#let quartz-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
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



#show: quartz-cv.with(
  author: "Jane Smith",
  accent-color: "#3f5450",
  font: "Raleway",
  font-size: 10pt,
  paper: "a4",
  margin: 1.4cm,
  leading: 0.62em,
  lang: "en",
)

#cv-layout(
  main: [
#main-section("Summary", accent-color: "#3f5450")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#main-section("Education", accent-color: "#3f5450")

#quartz-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)

#quartz-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)

#main-section("Experience", accent-color: "#3f5450")

#quartz-entry(
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

#quartz-entry(
  title: "Senior Product Manager",
  subtitle: "Northwind Technologies",
  dates: "January 2018 - February 2021",
  location: "",
  meta: "",
  [
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
- Ran continuous discovery with 120+ customer interviews, translating findings into a roadmap that raised NPS from 22 to 48.
- Drove a pricing and packaging overhaul that increased average contract value 27% without measurable churn impact.
],
)

#quartz-entry(
  title: "Product Manager",
  subtitle: "Brightwave",
  dates: "June 2015 - December 2017",
  location: "",
  meta: "",
  [
- Shipped a mobile checkout redesign that lifted conversion 18% and reduced cart abandonment by a third.
- Defined the north-star metric and instrumentation for a 2M-user product, replacing vanity metrics with retention cohorts.
- Coordinated a cross-team migration to a modular design system, cutting feature build times by 40%.
],
)

#quartz-entry(
  title: "Associate Product Manager",
  subtitle: "Optic Retail Group",
  dates: "August 2013 - May 2015",
  location: "",
  meta: "",
  [
- Managed the roadmap for the loyalty programme, growing enrolled members from 90k to 310k in 18 months.
- Automated weekly reporting with SQL and Looker, saving the team 12 hours a week and improving decision speed.
- Ran 30+ pricing and merchandising experiments, standardising the win/loss review that became company practice.
],
)

#quartz-entry(
  title: "Business Analyst",
  subtitle: "Foundry Studio",
  dates: "January 2012 - July 2013",
  location: "",
  meta: "",
  [
- Built financial and demand models informing a \$40M annual budget across three regional markets.
- Delivered an executive dashboard that surfaced margin leakage, recovering \$2.1M in the first year.
- Supported the design of a post-merger integration plan spanning operations, data, and reporting.
],
)

#main-section("Projects", accent-color: "#3f5450")

#quartz-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)

#quartz-entry(
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
  aside: [#masthead(author: "Jane Smith", profession: "Director of Product", accent-color: "#3f5450")
#panel-contact((
  link("mailto:jane.smith@example.com")[jane.smith\@example.com],
  [+1 (415) 555 0148],
  [San Francisco, CA],
), accent-color: "#3f5450")

#panel-section("Skills", accent-color: "#3f5450")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market, Stakeholder Management, Figma, Python, Experimentation

#panel-section("Languages", accent-color: "#3f5450")

#quartz-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#quartz-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#quartz-language(
  language: "Mandarin",
  level: "Conversational",
)

#panel-section("Certifications", accent-color: "#3f5450")

#quartz-rail-cred(
  name: "Certified Scrum Product Owner (CSPO)",
  issuer: "Scrum Alliance",
  date: "January 2020",
)

#quartz-rail-cred(
  name: "Pragmatic Institute Certified (PMC-III)",
  issuer: "Pragmatic Institute",
  date: "January 2019",
)

#panel-section("Awards", accent-color: "#3f5450")

#quartz-rail-cred(
  name: "Product Leader of the Year",
  issuer: "Meridian Labs",
  date: "January 2023",
)
],
)
