// Slate CV, a Typst resume template.
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
// Edit in a browser: https://www.jobsprout.ai/resume-templates/slate
#set page(fill: rgb("#ffffff"))

#let is-blank(v) = v == none or v == "" or v == []

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is
// used as ONE tasteful block: a full-height left sidebar (painted by the page
// background so it continues on every page). On the panel, ink/grey are replaced by
// near-white / a muted white-green for legibility (the filled-panel two-tone
// secondary logic, not a second colour). Off the panel: ink on white.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")
#let panel-ink = rgb("#f4f7f5")
#let panel-muted = rgb("#b7c6bd")
#let panel-line = rgb(255, 255, 255, 60) // faint white rule, works over any accent

#let PANEL-FRAC = 34%

// Fixed size scale from body B = 10pt (standard rule 2), defined ONCE.
#let display-size = 20pt // ~2.0 x B - the name (in the panel)
#let subhead-size = 11.5pt // ~1.15 x B - the profession line
#let body-size = 10pt // B
#let label-size = 9pt // ~0.9 x B - section labels (the one uppercase + tracked role)
#let meta-size = 8.2pt // ~0.82 x B - dates, location, contact, level, fine print

// Document shell: set-rules + PDF metadata + the sidebar fill. The page background
// paints the accent panel down the left PANEL-FRAC of EVERY page (so a long CV keeps
// the sidebar on page 2+). Page left/right margins are 0 so the panel is edge-to-edge;
// top/bottom margins give the flowing main column its per-page margins. The two
// columns are composed by wrapSections through #cv-layout. Raleway is the single
// family (standard rule 1); regular + semibold + bold, each with a role.
#let slate-cv(
  author: "",
  font: "Raleway",
  font-size: 10pt,
  paper: "a4",
  margin: 1.4cm,
  leading: 0.6em,
  lang: "en",
  accent-color: "#2f4a3f",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: true)
  set page(
    paper: paper,
    margin: (top: margin, bottom: margin, left: 0pt, right: 0pt),
    background: place(top + left, rect(width: PANEL-FRAC, height: 100%, fill: rgb(accent-color))),
  )
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  body
}

// Two-column layout as a BREAKABLE grid, so a long aside flows onto page 2+
// alongside the main column. It was previously `place`d at the top, contributing
// zero flow height: that let the main column alone drive pagination, but an aside
// taller than the page then kept drawing past the paper edge, overlapping its own
// entries and losing text (a 45-language sidebar reached 2044pt on an 842pt page).
// The panel fill spans every page via the page background, so the rail still
// looks continuous when the aside runs short on the final page.
// Horizontal padding sits inside each column; the vertical margins come from the page.
#let cv-layout(author: "", main: [], aside: [], hpad: 1.4cm, gap: 22pt) = {
  grid(
    columns: (PANEL-FRAC, 1fr),
    column-gutter: gap,
    align: (left + top, left + top),
    block(inset: (left: hpad, right: 12pt), {
      set text(fill: panel-ink)
      // No mid-word hyphenation in the narrow panel: a long name ("Culemann") or skill must
      // wrap at a space, never break as "Cule-mann".
      set text(hyphenate: false)
      show link: set text(fill: panel-muted)
      // AI-diff marks on the filled panel: the global diff colours are dark ink on a
      // light fill (built for a white page) and become illegible light boxes here.
      // Shadow them with a translucent mark that keeps the panel's own near-white text.
      let diff-add(content) = highlight(fill: rgb(120, 214, 160, 80), extent: 1pt)[#text(fill: panel-ink, content)]
      let diff-remove(content) = highlight(fill: rgb(233, 130, 130, 75), extent: 1pt)[#text(fill: panel-muted, strike(content))]
      aside
    }),
    block(inset: (right: hpad), {
      set text(fill: ink)
      main
    }),
  )
}

// Panel masthead: an optional circle-clipped photo above the name (bold
// near-white) over the profession (muted white). photo is a path string into
// the compiler VFS; none renders nothing and reserves no space.
#let masthead(author: "", profession: "", photo: none, photo-radius: 50%, photo-size: 2.6cm) = {
  block(above: 0pt, below: 1.1em, breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, leading: 0.45em, justify: false)
    if photo != none {
      box(
        clip: true,
        radius: photo-radius,
        width: photo-size,
        height: photo-size,
        stroke: 1pt + panel-line,
        image(photo, width: photo-size, height: photo-size, fit: "cover"),
      )
      v(10pt)
    }
    text(size: display-size, weight: "bold", fill: panel-ink, author)
    if profession != "" {
      v(3pt)
      text(size: subhead-size, weight: "regular", fill: panel-muted, profession)
    }
  })
}

// Panel section label: near-white UPPERCASE + tracking over a faint white rule.
#let panel-section(title) = {
  block(above: 1.4em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: panel-ink, upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.5pt + panel-line)
  })
}

// Panel contact: a CONTACT label then one muted-white line per item (email, phone,
// location, social), no icons - a quiet legible stack.
#let panel-contact(items) = {
  panel-section("Contact")
  // sectionSpacing must not leak into the contact rows (explicit below controls them).
  set block(spacing: 0pt)
  set par(spacing: 0pt)
  for item in items {
    block(above: 0pt, below: 4pt, breakable: false, {
      set text(size: meta-size, fill: panel-muted)
      item
    })
  }
}

// Panel credential (certifications / awards in the sidebar): compact stacked -
// name (near-white), then issuer + date (muted white) beneath, dot-separated. No
// bullets and no wide date grid, so it fills the panel cleanly without cramping.
#let slate-rail-cred(name: "", issuer: "", date: "") = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    // No mid-word hyphenation: a long credential name wraps at spaces, not "Profes-sional".
    set text(hyphenate: false)
    if not is-blank(name) { text(weight: "semibold", fill: panel-ink, name) }
    let meta = (issuer, date).filter(v => not is-blank(v)).join(text(fill: panel-muted)[ #sym.dot.c ])
    if not is-blank(meta) { v(2pt); text(size: meta-size, fill: panel-muted, meta) }
  })
}

// Panel language: language (near-white) with the proficiency level (muted white)
// STACKED beneath it. Stacked, not a two-column row: in the narrow panel a long level
// ("Native or bilingual proficiency") would squeeze the language onto its own broken,
// hyphenated lines ("Eng-lish"). No hyphenation on the language name.
#let slate-language(language: "", level: "") = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    set text(hyphenate: false)
    if not is-blank(language) { text(fill: panel-ink, language) }
    if not is-blank(level) {
      if not is-blank(language) { v(1pt) }
      text(size: meta-size, fill: panel-muted, level)
    }
  })
}

// Main section label: accent UPPERCASE + tracking over an accent rule.
#let main-section(title, accent-color: "#2f4a3f") = {
  block(above: 1.3em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: rgb(accent-color), upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.6pt + rgb(accent-color))
  })
}

// Main entry: semibold-ink title leads with a muted subtitle, dates right; location
// and an optional URL meta line below; then the body. Title leads with weight, not
// uppercase (standard rule 4).
#let slate-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    block(sticky: true, breakable: false, {
      set par(justify: false)
      // No mid-word hyphenation on the title line: a long organisation/degree wraps at
      // a space, not "Ad-vanced". The date top-aligns so it stays beside the first line.
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



#show: slate-cv.with(
  author: "Jane Smith",
  accent-color: "#2f4a3f",
  font: "Raleway",
  font-size: 10pt,
  paper: "a4",
  margin: 1.4cm,
  leading: 0.6em,
  lang: "en",
)

#cv-layout(
  main: [
#main-section("Summary", accent-color: "#2f4a3f")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#main-section("Education", accent-color: "#2f4a3f")

#slate-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  dates: "September 2010 - June 2012",
  location: "",
  meta: "",
  [],
)

#slate-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  dates: "September 2006 - June 2010",
  location: "",
  meta: "",
  [],
)
#main-section("Experience", accent-color: "#2f4a3f")

#slate-entry(
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

#slate-entry(
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

#slate-entry(
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

#slate-entry(
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

#slate-entry(
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
#main-section("Projects", accent-color: "#2f4a3f")

#slate-entry(
  title: "Activation Engine",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
],
)

#slate-entry(
  title: "Insights Platform",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  [
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
],
)],
  aside: [#masthead(author: "Jane Smith", profession: "Director of Product")
#panel-contact((
  link("mailto:jane.smith@example.com")[jane.smith\@example.com],
  [+1 (415) 555 0148],
  [San Francisco, CA],
))

#panel-section("Skills")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market, Stakeholder Management, Figma, Python, Experimentation

#panel-section("Languages")

#slate-language(
  language: "English",
  level: "Native",
)
#v(3pt)
#slate-language(
  language: "Spanish",
  level: "Professional working proficiency",
)
#v(3pt)
#slate-language(
  language: "Mandarin",
  level: "Conversational",
)

#panel-section("Certifications")

#slate-rail-cred(
  name: "Certified Scrum Product Owner (CSPO)",
  issuer: "Scrum Alliance",
  date: "January 2020",
)

#slate-rail-cred(
  name: "Pragmatic Institute Certified (PMC-III)",
  issuer: "Pragmatic Institute",
  date: "January 2019",
)
#panel-section("Awards")

#slate-rail-cred(
  name: "Product Leader of the Year",
  issuer: "Meridian Labs",
  date: "January 2023",
)],
)
