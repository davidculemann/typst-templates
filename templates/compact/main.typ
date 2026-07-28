// Compact CV, a Typst resume template.
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
// Edit in a browser: https://www.jobsprout.ai/resume-templates/compact
#set page(fill: rgb("#ffffff"))


#let is-blank(v) = v == none or v == "" or v == []

#let muted = rgb("#4a4a4a")

#let compact-cv(
  author: "",
  location: "",
  email: "",
  phone: "",
  social-links: (), // Array of (url, display-text) tuples
  accent-color: "#1f3a5f",
  font: "Source Sans 3",
  font-size: 10pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.55em,
  lang: "en",
  body,
) = {
  // Handle both string and content for author (content is used for diff preview)
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(
    font: font,
    size: font-size,
    fill: rgb("#1a1a1a"),
    lang: lang,
    ligatures: false,
    hyphenate: false,
  )

  set page(
    margin: margin,
    paper: paper,
  )

  set par(justify: false, leading: leading)

  // Tight, evenly spaced bullets: the density lever of this template.
  set list(indent: 0.5em, body-indent: 0.35em, spacing: 0.5em)

  let c = rgb(accent-color)

  show link: set text(fill: c)

  // Glue every header (all grids: section headers and entry headers) to the
  // content that follows it. A sticky block can never be the last thing on a
  // page, so a header at a page bottom is carried to the next page WITH its
  // first following line (its first bullet) instead of being orphaned. The
  // bullet lists themselves stay breakable, so long entries still flow across
  // pages. The name and contact lines are plain blocks, so only headers stick.
  show grid: it => block(sticky: true, it)

  // Contact line: compact, muted, directly beneath the name.
  let contact-items = ()
  if phone != "" and phone != none { contact-items.push(phone) }
  if location != "" and location != none { contact-items.push(location) }
  if email != "" and email != none {
    if type(email) == str {
      contact-items.push(link("mailto:" + email)[#email])
    } else {
      contact-items.push(email)
    }
  }
  for social-link in social-links {
    let (url, display-text) = social-link
    if url != "" and url != none {
      let full-url = if url.starts-with("http") { url } else { "https://" + url }
      contact-items.push(link(full-url)[#display-text])
    }
  }

  // Masthead built as one spacing-controlled block: neutralise ambient block/par
  // spacing so the name -> contact gap is exactly the tight explicit v() below,
  // not the collapsed default block flow. Kept dense to match the template's
  // character. When the name is blank the name line collapses to the lone
  // contact line with no reserved slot.
  let contact-line = text(size: 8.5pt, fill: muted, contact-items.filter(x => x != none).join("  ·  "))
  if is-blank(author) {
    block(above: 0pt, below: 0.9em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt)
      contact-line
    })
  } else {
    block(above: 0pt, below: 0.9em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt)
      text(size: 19pt, weight: "bold", tracking: 0.2pt, fill: c, author)
      v(0.32em)
      contact-line
    })
  }

  body
}

// Section header: a compact bold accent label with a hairline rule filling the
// rest of the line. One line, no stacked gap: the sharp, dense signature.
#let cv-section(title, accent-color: "#1f3a5f") = {
  let c = rgb(accent-color)
  block(above: 0.85em, below: 0.4em, grid(
    columns: (auto, 1fr),
    column-gutter: 7pt,
    align: (left + horizon, left + horizon),
    text(size: 9.5pt, weight: "bold", tracking: 0.8pt, fill: c, upper(title)),
    line(length: 100%, stroke: 0.6pt + c),
  ))
}

// Entry header packed to two lines max: bold title (with the location inline
// after it, muted) on the left; the organisation and the dates share the right
// of the SAME line, the dates in the single accent. Bullets follow below.
#let cv-entry(
  title: "",
  subtitle: "",
  location: "",
  dates: "",
  link-content: none,
  accent-color: "#1f3a5f",
) = {
  let c = rgb(accent-color)

  let left-cell = {
    if not is-blank(title) { strong(title) }
    if not is-blank(location) {
      if not is-blank(title) { text(fill: muted)[  ·  #location] } else { text(fill: muted)[#location] }
    }
  }

  let right-cell = {
    let parts = ()
    if not is-blank(subtitle) { parts.push([#subtitle]) }
    if not is-blank(dates) { parts.push(text(fill: c)[#dates]) }
    if link-content != none { parts.push(link-content) }
    if parts.len() > 0 { parts.join(text(fill: muted)[  ·  ]) }
  }

  grid(
    columns: (1fr, auto),
    column-gutter: 10pt,
    align: (left + top, right + top),
    [#left-cell],
    [#right-cell],
  )
}



#show: compact-cv.with(
  author: "Jane Smith",
  email: "jane.smith@example.com",
  phone: "+1 (415) 555 0148",
  location: "San Francisco, CA",
  social-links: (),
  accent-color: "#1f3a5f",
  font: "Source Sans 3",
  font-size: 10pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.55em,
  lang: "en",
)


#cv-section("Summary", accent-color: "#1f3a5f")

Senior product leader with 12+ years building and scaling data-driven products across fintech and SaaS. Track record of shipping revenue-critical platforms, leading cross-functional teams of 20+, and turning ambiguous problems into measurable growth.

#cv-section("Education", accent-color: "#1f3a5f")

#cv-entry(
  title: "Stanford University",
  subtitle: "M.S. in Management Science & Engineering",
  location: "",
  dates: "September 2010 - June 2012",
  accent-color: "#1f3a5f",
)

#cv-entry(
  title: "University of California, Berkeley",
  subtitle: "B.A. in Economics, with Honours",
  location: "",
  dates: "September 2006 - June 2010",
  accent-color: "#1f3a5f",
)
#cv-section("Experience", accent-color: "#1f3a5f")

#cv-entry(
  title: "Director of Product",
  subtitle: "Meridian Labs",
  location: "",
  dates: "March 2021 - Present",
  accent-color: "#1f3a5f",
)
- Owned the product strategy for a \$120M platform, growing annual recurring revenue 34% over two years through a re-prioritised roadmap.
- Built and led a cross-functional org of 24 (PMs, designers, analysts), instituting a quarterly OKR cadence that lifted on-time delivery from 61% to 92%.
- Launched a self-serve onboarding flow that cut time-to-value from 14 days to under 3, driving a 21% increase in activation.

#cv-entry(
  title: "Senior Product Manager",
  subtitle: "Northwind Technologies",
  location: "",
  dates: "January 2018 - February 2021",
  accent-color: "#1f3a5f",
)
- Led the 0-to-1 launch of a real-time analytics suite, reaching \$9M ARR within the first year and 400+ enterprise accounts.
- Ran continuous discovery with 120+ customer interviews, translating findings into a roadmap that raised NPS from 22 to 48.
- Drove a pricing and packaging overhaul that increased average contract value 27% without measurable churn impact.

#cv-entry(
  title: "Product Manager",
  subtitle: "Brightwave",
  location: "",
  dates: "June 2015 - December 2017",
  accent-color: "#1f3a5f",
)
- Shipped a mobile checkout redesign that lifted conversion 18% and reduced cart abandonment by a third.
- Defined the north-star metric and instrumentation for a 2M-user product, replacing vanity metrics with retention cohorts.
- Coordinated a cross-team migration to a modular design system, cutting feature build times by 40%.

#cv-entry(
  title: "Associate Product Manager",
  subtitle: "Optic Retail Group",
  location: "",
  dates: "August 2013 - May 2015",
  accent-color: "#1f3a5f",
)
- Managed the roadmap for the loyalty programme, growing enrolled members from 90k to 310k in 18 months.
- Automated weekly reporting with SQL and Looker, saving the team 12 hours a week and improving decision speed.
- Ran 30+ pricing and merchandising experiments, standardising the win/loss review that became company practice.

#cv-entry(
  title: "Business Analyst",
  subtitle: "Foundry Studio",
  location: "",
  dates: "January 2012 - July 2013",
  accent-color: "#1f3a5f",
)
- Built financial and demand models informing a \$40M annual budget across three regional markets.
- Delivered an executive dashboard that surfaced margin leakage, recovering \$2.1M in the first year.
- Supported the design of a post-merger integration plan spanning operations, data, and reporting.
#cv-section("Projects", accent-color: "#1f3a5f")

#cv-entry(
  title: "Activation Engine",
  subtitle: "",
  location: "",
  dates: "",
  accent-color: "#1f3a5f",
)
- Led a self-serve onboarding overhaul that lifted new-user activation 21% and became the template for the wider platform.
#block(above: 0.35em)[#text(fill: rgb("#4a4a4a"))[#emph[Product Strategy, Experimentation]]]

#cv-entry(
  title: "Insights Platform",
  subtitle: "",
  location: "",
  dates: "",
  accent-color: "#1f3a5f",
)
- Shipped a real-time analytics suite from scratch to \$9M ARR and 400+ enterprise customers in year one.
#block(above: 0.35em)[#text(fill: rgb("#4a4a4a"))[#emph[Analytics, SQL]]]
#cv-section("Skills", accent-color: "#1f3a5f")

Product Strategy, Roadmapping, Data Analysis, SQL, A/B Testing, User Research, OKRs, Go-to-Market, Stakeholder Management, Figma, Python, Experimentation

#cv-section("Languages", accent-color: "#1f3a5f")

#strong[English]: Native, #strong[Spanish]: Professional working proficiency, #strong[Mandarin]: Conversational
#cv-section("Certifications", accent-color: "#1f3a5f")

#cv-entry(
  title: "Certified Scrum Product Owner (CSPO)",
  subtitle: "Scrum Alliance",
  location: "",
  dates: "January 2020",
  accent-color: "#1f3a5f",
)

#cv-entry(
  title: "Pragmatic Institute Certified (PMC-III)",
  subtitle: "Pragmatic Institute",
  location: "",
  dates: "January 2019",
  accent-color: "#1f3a5f",
)
#cv-section("Awards", accent-color: "#1f3a5f")

#cv-entry(
  title: "Product Leader of the Year",
  subtitle: "Meridian Labs",
  location: "",
  dates: "January 2023",
  accent-color: "#1f3a5f",
)

#cv-entry(
  title: "Top 40 Under 40 in Product",
  subtitle: "ProductCon",
  location: "",
  dates: "January 2022",
  accent-color: "#1f3a5f",
)
