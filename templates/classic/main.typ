// Classic CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in New Computer Modern, which ships with Typst, so it renders as
// intended with nothing to install.
//
// Derived from fantastic-cv (https://typst.app/universe/package/fantastic-cv),
// (c) its authors, used under MIT. That licence continues to apply,
// so this file is not MIT-0: keep this notice if you redistribute the template
// itself. A CV you write with it is your own work.
// Modified from the original by JobSprout: restructured for a section registry,
// re-typeset to a fixed size scale, and reworked for empty-field handling.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/classic
#set page(fill: rgb("#ffffff"))


#let is-blank(v) = v == none or v == "" or v == []

#let format-dates(start-date, end-date) = {
  (start-date, end-date).filter(d => d != "").join(" – ")
}

#let entry-heading(
  main: "",
  dates: "",
  description: "",
  bottom-right: "",
  accent-color: "#26428b",
) = {
  let heading-blank = is-blank(main) and is-blank(dates)
  let detail-blank = is-blank(description) and is-blank(bottom-right)

  if not heading-blank {
    grid(
      columns: (1fr, auto),
      column-gutter: 8pt,
      align: (left, right),
      [=== #underline[#main]],
      [#text(fill: rgb(accent-color))[#dates]],
    )
  }

  if not detail-blank {
    if not heading-blank { v(-0.5em) }
    grid(
      columns: (1fr, auto),
      column-gutter: 8pt,
      align: (left, right),
      [#description],
      [#bottom-right],
    )
  }
}

#let cv-section(title, accent-color: "#26428b") = {
  [== #smallcaps(title)]
  v(-0.5em)
  line(length: 100%, stroke: stroke(thickness: 0.4pt))
  v(-0.5em)
}

#let cv-publication(
  title: "",
  authors: "",
  url: "",
  url_name: "",
  date: "",
  accent-color: "#26428b",
) = {
  grid(
    columns: (1fr, auto),
    column-gutter: 8pt,
    align: (left, right),
    [
      #text(weight: "bold")[#title]       #if authors != "" {
        v(-0.3em)
        authors
        linebreak()
      }
      #if url != "" or url_name != "" {
        v(-0.3em)
        let link-text = if url_name != "" { url_name } else { url }
        let link-dest = if url != "" { "https://" + url } else { "" }
        if link-dest != "" {
          link(link-dest)[#link-text]
        } else {
          link-text
        }
      }
    ],
    [#text(fill: rgb(accent-color))[#date]],
  )
}

#let cv-certification(
  title: "",
  organization: "",
  url: "",
  date: "",
  description: "",
  accent-color: "#26428b",
) = {
  grid(
    columns: (1fr, auto),
    column-gutter: 8pt,
    align: (left, right),
    [
      #text(weight: "bold")[#title]
      #if organization != "" or url != "" {
        [ ]
        if organization != "" {
          text(weight: "medium", smallcaps(organization))
        }
        if url != "" {
          let link-display = url.replace("https://", "").replace("http://", "")
          [ (]
          link(url)[#text(size: 9pt, link-display)]
          [)]
        }
      }
      #if not is-blank(description) {
        linebreak()
        v(-0.3em)
        description
      }
    ],
    [#text(fill: rgb(accent-color))[#date]],
  )
}

#let cv-award(
  title: "",
  organization: "",
  url: "",
  date: "",
  description: "",
  accent-color: "#26428b",
) = {
  grid(
    columns: (1fr, auto),
    column-gutter: 8pt,
    align: (left, right),
    [
      #text(weight: "bold")[#title]
      #if organization != "" or url != "" {
        [ ]
        if organization != "" {
          text(weight: "medium", smallcaps(organization))
        }
        if url != "" {
          let link-display = url.replace("https://", "").replace("http://", "")
          [ (]
          link(url)[#text(size: 9pt, link-display)]
          [)]
        }
      }
      #if not is-blank(description) {
        linebreak()
        v(-0.3em)
        description
      }
    ],
    [#text(fill: rgb(accent-color))[#date]],
  )
}

#let fantastic-cv(
  author: "",
  location: "",
  phone: "",
  email: "",
  social-links: (), // Array of (url, display-text) tuples
  accent-color: "#26428b",
  font: "New Computer Modern",
  font-fallback: (), // Script fallback families (e.g. CJK) appended after the Latin stack
  font-size: 10pt,
  paper: "a4",
  margin: 0.5in,
  leading: 0.65em,
  justify: true,
  lang: "en",
  body,
) = {
  let font-size-title = font-size * 1.5
  let font-size-section = font-size * 1.3
  let font-size-entry = font-size * 1.1

  // Handle both string and content for author (content is used for diff preview)
  let author-str = if type(author) == str { author } else { "CV" }
  set document(
    author: author-str,
    title: author-str + " - CV",
  )

  set text(
    font: (font, "Source Sans 3", "Roboto", "HK Grotesk", ..font-fallback),
    size: font-size,
    lang: lang,
    ligatures: false,
    hyphenate: true,
  )

  set page(
    margin: margin,
    paper: paper,
  )

  set par(justify: justify, leading: leading)

  show link: underline
  show heading: set text(fill: rgb(accent-color))
  show link: set text(fill: rgb(accent-color))

  show heading.where(level: 1): it => [#text(font-size-title, weight: "extrabold")[#it]]
  show heading.where(level: 2): it => [#text(font-size-section, weight: "bold")[#it]]
  show heading.where(level: 3): it => [#text(size: font-size-entry, weight: "semibold")[#it]]

  align(
    left,
    [= #author #h(1fr) #location],
  )

  // Build contact items: phone, email first, then social links in order
  let contact-items = ()
  if phone != "" and phone != none { contact-items.push(phone) }
  // A diffed field arrives as content, which link() rejects as a destination.
  // Show the highlighted text unlinked for as long as the diff is on screen.
  if email != "" and email != none {
    contact-items.push(if type(email) == str { link("mailto:" + email)[#email] } else { email })
  }
  
  // Add social links in the order they were provided
  for social-link in social-links {
    let (url, display-text) = social-link
    if url != "" and url != none {
      let full-url = if url.starts-with("http") { url } else { "https://" + url }
      contact-items.push(link(full-url)[#display-text])
    }
  }

  pad(
    top: 0.25em,
    [#{contact-items.join("  |  ")}],
  )

  body
}


#let smart-entry(threshold: 10%, body) = {
  block(breakable: false, height: threshold)
  v(-threshold, weak: true)
  body
}


#show: fantastic-cv.with(
  author: "Jane Smith",
  location: "Evanston, IL",
  phone: "+1 (847) 555-0132",
  email: "jane.smith@kellogg.northwestern.edu",
  social-links: (),
  accent-color: "#26428b",
  font: "New Computer Modern",
  font-fallback: (),
  font-size: 10pt,
  paper: "a4",
  margin: 0.5in,
  leading: 0.65em,
  justify: true,
  lang: "en",
)


#cv-section("Summary", accent-color: "#26428b")

Strategic and analytical Senior Consultant with over 5 years of experience in management consulting and strategy development. Proven track record in leading global client engagements and delivering impactful solutions for Fortune 500 companies. Adept at leveraging analytical tools to drive strategic decision-making and enhance operational efficiencies.

#v(-0.5em)
#cv-section("Education", accent-color: "#26428b")

#smart-entry[
#entry-heading(
  main: [Kellogg School of Management],
  dates: format-dates("September 2018", "June 2020"),
  description: emph[MBA],
  bottom-right: "Evanston, IL",
  accent-color: "#26428b",
)

- Graduated with honors, focused on strategy and management consulting.
- Led a team project that developed a market entry strategy for a tech startup, resulting in a 30% increase in market share within the first year.
- Completed coursework in Advanced Competitive Strategy, Leadership in Organizations, and Data-Driven Decision Making.

#v(-0.5em)
]
#cv-section("Experience", accent-color: "#26428b")

#smart-entry[
#entry-heading(
  main: [Deloitte Consulting],
  dates: format-dates("July 2020", "Present"),
  description: emph[Senior Consultant],
  bottom-right: "Chicago, IL",
  accent-color: "#26428b",
)
- Led a cross-functional team in a global project to optimize supply chain processes for a Fortune 500 client, achieving a 15% reduction in operational costs over 6 months.
#v(-0.5em)
]
#smart-entry[
#entry-heading(
  main: [Accenture],
  dates: format-dates("July 2018", "June 2020"),
  description: emph[Consultant],
  bottom-right: "New York, NY",
  accent-color: "#26428b",
)
- Collaborated on a project for a leading telecommunications company, resulting in a 25% increase in customer satisfaction through service redesign.
#v(-0.5em)
]
#cv-section("Projects", accent-color: "#26428b")

#smart-entry[
#entry-heading(
  main: [Digital Transformation Strategy for Global Retailer],
  dates: link("https://deloitte.com/case-studies/retail-digital")["https://deloitte.com/case-studies/retail-digital"],
  description: emph[Digital Strategy] + " | " + emph[E-Commerce] + " | " + emph[Change Management],
  bottom-right: "",
  accent-color: "#26428b",
)
#v(-2em) \
- Developed and implemented a comprehensive digital strategy for a retail client, leading to a 20% increase in e-commerce sales.
#v(-0.5em)
]
#smart-entry[
#entry-heading(
  main: [Operational Efficiency Initiative],
  dates: link("https://deloitte.com/case-studies/manufacturing-ops")["https://deloitte.com/case-studies/manufacturing-ops"],
  description: emph[Process Improvement] + " | " + emph[Lean Management],
  bottom-right: "",
  accent-color: "#26428b",
)
#v(-2em) \
- Spearheaded an initiative that streamlined operations for a manufacturing client, resulting in a 10% increase in production efficiency.
#v(-0.5em)
]
#cv-section("Skills", accent-color: "#26428b")

Strategic Planning, Data Analysis, Client Relationship Management, Project Management, Market Research, Financial Modeling

#v(-0.5em)
#cv-section("Certifications", accent-color: "#26428b")

#smart-entry[
#cv-certification(
  title: "Certified Management Consultant (CMC)",
  organization: "Institute of Management Consultants",
  url: "https://www.imcusa.org/cmc-certification",
  date: "May 2021",
  description: [
- Achieved certification demonstrating advanced knowledge and experience in management consulting best practices.
],
  accent-color: "#26428b",
)
#v(-0.5em)
]
#smart-entry[
#cv-certification(
  title: "Data Analytics for Business",
  organization: "Coursera - Wharton",
  url: "https://www.coursera.org/account/accomplishments/certificate/ABC123",
  date: "December 2020",
  description: [
- Completed a professional certification focusing on data analytics tools and techniques for business decision-making.
],
  accent-color: "#26428b",
)
#v(-0.5em)
]
#cv-section("Languages", accent-color: "#26428b")

- #text(weight: "bold")[English]: Fluent
#v(-0.5em)
- #text(weight: "bold")[Spanish]: Conversational

#v(-0.5em)
