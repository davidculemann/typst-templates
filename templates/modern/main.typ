// Modern CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Source Sans 3. Without it installed the text falls back;
// change the font argument in the show rule below to a family you
// do have, the layout does not depend on it.
//
// Derived from brilliant-CV (https://github.com/yunanwg/brilliant-CV),
// (c) its authors, used under Apache-2.0. That licence continues to apply,
// so this file is not MIT-0: keep this notice if you redistribute the template
// itself. A CV you write with it is your own work.
// Modified from the original by JobSprout: restructured for a section registry,
// re-typeset to a fixed size scale, and reworked for empty-field handling.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/modern
#set page(fill: rgb("#ffffff"))


// Brilliant-CV Base Template Functions
// Adapted for EasyCV

// FontAwesome icon function using ligatures
// Automatically detects brand icons and uses the correct font family
// IMPORTANT: Enables ligatures explicitly since brilliant-cv disables them globally
#let fa-icon(name, solid: true) = {
  let brand-icons = ("github", "linkedin", "twitter", "x-twitter", "facebook", "instagram", "youtube", "discord", "slack", "reddit", "telegram", "whatsapp")
  let is-brand = name in brand-icons

  text(
    font: if is-brand {
      "Font Awesome 6 Brands"
    } else if solid {
      "Font Awesome 6 Free Solid"
    } else {
      "Font Awesome 6 Free Regular"
    },
    weight: if is-brand { 400 } else if solid { 900 } else { 400 },
    ligatures: true,
    name,
  )
}

#let hBar() = [#h(5pt) | #h(5pt)]

#let regularColors = (
  subtlegray: rgb("#ededee"),
  lightgray: rgb("#343a40"),
  darkgray: rgb("#212529"),
)

#let brilliantCV(
  author: "",
  email: "",
  phone: "",
  location: "",
  social-links: (), // Array of (url, display-text, fa-icon) tuples
  accent-color: "#0396de",
  font: "Source Sans 3",
  header-font: "Roboto",
  font-fallback: (), // Script fallback families (e.g. CJK) appended after the Latin stack
  font-size: 9pt,
  paper: "a4",
  margin: (left: 1.4cm, right: 1.4cm, top: 1cm, bottom: 1cm),
  leading: 0.6em,
  lang: "en",
  body,
) = {
  // Handle both string and content for author
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(
    font: (font, "Roboto", "HK Grotesk", ..font-fallback),
    weight: "regular",
    size: font-size,
    lang: lang,
    ligatures: false,
    hyphenate: true
  )

  set page(
    paper: paper,
    margin: margin,
  )

  show link: set text(fill: rgb(accent-color))

  // Header styling
  let headerFirstNameStyle(str) = {
    text(
      font: (header-font, "Source Sans 3", "HK Grotesk", ..font-fallback),
      size: 32pt,
      weight: "light",
      fill: regularColors.darkgray,
      str,
    )
  }

  let headerLastNameStyle(str) = {
    text(
      font: (header-font, "Source Sans 3", "HK Grotesk", ..font-fallback),
      size: 32pt,
      weight: "bold",
      str
    )
  }

  // Render header - handle content type for diff preview
  set align(left)
  table(
    columns: 1fr,
    inset: 0pt,
    stroke: 0pt,
    row-gutter: 6mm,
    [#if type(author) == str {
      let parts = author.split(" ")
      let first = parts.slice(0, -1).join(" ")
      let last = parts.at(-1)
      headerFirstNameStyle(first)
      h(5pt)
      headerLastNameStyle(last)
    } else {
      // Content type (diff preview) - display directly
      text(font: (header-font, "Source Sans 3", "HK Grotesk", ..font-fallback), size: 32pt, weight: "bold", author)
    }],
    {
      set text(size: 10pt, fill: rgb(accent-color))
      let items = ()
      if location != "" and location != none {
        if type(location) == str {
          items.push([#fa-icon("location-dot") #h(4pt) #location])
        } else {
          items.push([#fa-icon("location-dot") #h(4pt) #location])
        }
      }
      if phone != "" and phone != none {
        if type(phone) == str {
          items.push([#fa-icon("phone") #h(4pt) #phone])
        } else {
          items.push([#fa-icon("phone") #h(4pt) #phone])
        }
      }
      if email != "" and email != none {
        if type(email) == str {
          items.push([#fa-icon("envelope") #h(4pt) #link("mailto:" + email, email)])
        } else {
          items.push([#fa-icon("envelope") #h(4pt) #email])
        }
      }
      // Add social links in the order they were provided
      for social-link in social-links {
        let (url, display-text, icon-name) = social-link
        if url != "" and url != none {
          let full-url = if url.starts-with("http") { url } else { "https://" + url }
          items.push([#fa-icon(icon-name) #h(4pt) #link(full-url)[#display-text]])
        }
      }
      items.join(hBar())
    },
  )

  set par(justify: false, leading: leading)
  set list(indent: 12pt, spacing: 0.4em)

  body
}

#let cvSection(title, accent-color: "#0396de") = {
  // Highlight the first ~3 bytes' worth of grapheme clusters (three Latin
  // letters, or one CJK ideograph). A byte-indexed slice(0, 3) crashes with
  // "not a character boundary" on headings whose third byte falls inside a
  // multi-byte character (e.g. a custom section named "AI技能").
  let clusters = title.clusters()
  let take = 0
  let bytes = 0
  for c in clusters {
    if bytes >= 3 { break }
    take += 1
    bytes += c.len()
  }
  let highlightText = if take > 0 { clusters.slice(0, take).join("") } else { "" }
  let normalText = if clusters.len() > take { clusters.slice(take).join("") } else { "" }

  v(1pt)

  text(size: 16pt, weight: "bold", fill: rgb(accent-color), highlightText)
  if normalText != "" {
    text(size: 16pt, weight: "bold", fill: black, normalText)
  }
  h(2pt)
  box(width: 1fr, line(stroke: 0.9pt, length: 100%))
}

#let is-blank(v) = v == none or v == "" or v == []

#let cvEntry(
  title: "Title",
  society: "Society",
  date: "Date",
  location: "Location",
  description: "",
  tags: (),
  accent-color: "#0396de",
  date-width: 3.6cm,
) = {
  let entryA1Style(str) = {
    text(size: 10pt, weight: "bold", str)
  }

  let entryA2Style(str) = {
    align(
      right,
      text(weight: "medium", fill: rgb(accent-color), style: "oblique", str),
    )
  }

  let entryB1Style(str) = {
    text(size: 8pt, fill: rgb(accent-color), weight: "medium", smallcaps(str))
  }

  let entryB2Style(str) = {
    align(
      right,
      text(size: 8pt, weight: "medium", fill: gray, style: "oblique", str),
    )
  }

  let entryDescriptionStyle(str) = {
    text(
      fill: regularColors.lightgray,
      {
        v(1pt)
        str
      },
    )
  }

  let entryTagStyle(str) = {
    align(center, text(size: 8pt, weight: "regular", str))
  }

  let entryTagListStyle(tags) = {
    for tag in tags {
      box(
        inset: (x: 0.25em),
        outset: (y: 0.25em),
        fill: regularColors.subtlegray,
        radius: 3pt,
        entryTagStyle(tag),
      )
      h(5pt)
    }
  }

  let left-cells = ()
  if not is-blank(society) { left-cells.push(entryA1Style(society)) }
  if not is-blank(title) { left-cells.push(entryB1Style(title)) }
  let right-cells = ()
  if not is-blank(location) { right-cells.push(entryA2Style(location)) }
  if not is-blank(date) { right-cells.push(entryB2Style(date)) }

  v(1pt)
  if left-cells.len() > 0 or right-cells.len() > 0 {
    table(
      columns: (1fr, date-width),
      inset: 0pt,
      stroke: 0pt,
      gutter: 6pt,
      align: (x, y) => if x == 1 { right } else { auto },
      table(
        columns: auto,
        inset: 0pt,
        stroke: 0pt,
        row-gutter: 6pt,
        align: auto,
        ..left-cells,
      ),
      table(
        columns: auto,
        inset: 0pt,
        stroke: 0pt,
        row-gutter: 6pt,
        align: auto,
        ..right-cells,
      ),
    )
  }
  if not is-blank(description) {
    entryDescriptionStyle(description)
  }
  if tags.len() > 0 {
    entryTagListStyle(tags)
  }
}

#let cvProject(
  title: "",
  url: "",
  date: "",
  description: "",
  accent-color: "#0396de",
  date-width: 3.6cm,
) = {
  v(1pt)

  // Title and date row
  if not (is-blank(title) and is-blank(date)) {
    table(
      columns: (1fr, date-width),
      inset: 0pt,
      stroke: 0pt,
      gutter: 6pt,
      align: (left, right),
      text(size: 10pt, weight: "bold", title),
      text(size: 8pt, weight: "medium", fill: gray, style: "oblique", date),
    )
  }

  // URL link (if present)
  if url != "" and url != none {
    v(-4pt)
    link(url)[#text(size: 8pt, fill: rgb(accent-color), url)]
  }

  // Description
  if not is-blank(description) {
    text(fill: regularColors.lightgray, {
      v(1pt)
      description
    })
  }
}

#let cvVolunteering(
  title: "",
  organization: "",
  date: "",
  location: "",
  description: "",
  accent-color: "#0396de",
  date-width: 3.6cm,
) = {
  let left-cells = ()
  if not is-blank(organization) { left-cells.push(text(size: 8pt, weight: "medium", smallcaps(organization))) }
  if not is-blank(title) { left-cells.push(text(size: 10pt, weight: "bold", title)) }
  let right-cells = ()
  if not is-blank(location) {
    right-cells.push(text(size: 10pt, weight: "medium", fill: rgb(accent-color), style: "oblique", location))
  }
  if not is-blank(date) { right-cells.push(text(size: 8pt, weight: "medium", fill: gray, style: "oblique", date)) }

  v(1pt)

  if left-cells.len() > 0 or right-cells.len() > 0 {
    table(
      columns: (1fr, date-width),
      inset: 0pt,
      stroke: 0pt,
      gutter: 6pt,
      align: (x, y) => if x == 1 { right } else { auto },
      table(
        columns: auto,
        inset: 0pt,
        stroke: 0pt,
        row-gutter: 6pt,
        align: auto,
        ..left-cells,
      ),
      table(
        columns: auto,
        inset: 0pt,
        stroke: 0pt,
        row-gutter: 6pt,
        align: auto,
        ..right-cells,
      ),
    )
  }
  if not is-blank(description) {
    text(fill: regularColors.lightgray, {
      v(1pt)
      description
    })
  }
}

#let cvSkill(type: "Type", info: "Info") = {
  let skillTypeStyle(str) = {
    align(right, text(size: 10pt, weight: "bold", str))
  }

  let skillInfoStyle(str) = {
    text(str)
  }

  table(
    columns: (17%, 1fr),
    inset: 0pt,
    column-gutter: 10pt,
    stroke: 0pt,
    skillTypeStyle(type), skillInfoStyle(info),
  )
  v(-6pt)
}

#let cvHonor(
  date: "1990",
  title: "Title",
  issuer: "",
  url: "",
  location: "",
  accent-color: "#0396de",
) = {
  let honorDateStyle(str) = {
    align(right, text(str))
  }

  let honorTitleStyle(str) = {
    text(weight: "bold", str)
  }

  let honorIssuerStyle(str) = {
    text(str)
  }

  let honorLocationStyle(str) = {
    align(
      right,
      text(weight: "medium", fill: rgb(accent-color), style: "oblique", str),
    )
  }

  table(
    columns: (16%, 1fr, 15%),
    inset: 0pt,
    column-gutter: 10pt,
    align: horizon,
    stroke: 0pt,
    honorDateStyle(date),
    if issuer == "" {
      honorTitleStyle(title)
    } else if url != "" {
      [#honorTitleStyle(link(url)[#title]), #honorIssuerStyle(issuer)]
    } else {
      [#honorTitleStyle(title), #honorIssuerStyle(issuer)]
    },
    honorLocationStyle(location),
  )
  v(-6pt)
}

#let cvCertification(
  title: "",
  organization: "",
  url: "",
  date: "",
  description: "",
  accent-color: "#0396de",
  date-width: 3.6cm,
) = {
  v(1pt)

  // Title, organization (url), and date all on one line
  if not (is-blank(title) and is-blank(organization) and is-blank(url) and is-blank(date)) {
    table(
      columns: (1fr, date-width),
      inset: 0pt,
      stroke: 0pt,
      gutter: 6pt,
      align: (left, right),
      {
        if not is-blank(title) { text(size: 10pt, weight: "bold", title) }
        if not is-blank(organization) {
          if not is-blank(title) { text(size: 10pt, [, ]) }
          text(size: 8pt, weight: "medium", smallcaps(organization))
        }
        if not is-blank(url) {
          text(size: 10pt, [ (])
          link(url)[#text(size: 8pt, url)]
          text(size: 10pt, [)])
        }
      },
      text(size: 8pt, weight: "medium", fill: gray, style: "oblique", date),
    )
  }

  // Description (if present)
  if not is-blank(description) {
    text(fill: regularColors.lightgray, {
      v(1pt)
      description
    })
  }
}

#let cvPublication(
  title: "",
  authors: "",
  url: "",
  url_name: "",
  date: "",
  date-width: 3.6cm,
) = {
  v(1pt)

  // Title and date
  if not (is-blank(title) and is-blank(date)) {
    table(
      columns: (1fr, date-width),
      inset: 0pt,
      stroke: 0pt,
      gutter: 6pt,
      align: (left, right),
      text(size: 10pt, weight: "bold", title),
      text(size: 8pt, weight: "medium", fill: gray, style: "oblique", date),
    )
  }

  // Authors
  if authors != "" and authors != none {
    v(-4pt)
    text(size: 9pt, authors)
  }

  // URL or URL name
  if url_name != "" and url_name != none and url != "" and url != none {
    v(-4pt)
    link(url)[#text(size: 8pt, url_name)]
  } else if url != "" and url != none {
    v(-4pt)
    link(url)[#text(size: 8pt, url)]
  } else if url_name != "" and url_name != none {
    v(-4pt)
    text(size: 8pt, url_name)
  }
}

#let cvReference(
  name: "",
  role: "",
  organization: "",
  phone: "",
  email: "",
) = {
  let lines = ()
  if not is-blank(name) { lines.push(strong(name)) }
  let affiliation = ()
  if not is-blank(role) { affiliation.push(role) }
  if not is-blank(organization) { affiliation.push(organization) }
  if affiliation.len() > 0 { lines.push(affiliation.join(", ")) }
  let contact-info = ()
  if not is-blank(phone) { contact-info.push(phone) }
  if not is-blank(email) { contact-info.push(link("mailto:" + email, email)) }
  if contact-info.len() > 0 { lines.push(contact-info.join(" | ")) }
  lines.join(linebreak())
}

#let cvLanguage(
  language: "",
  level: "",
) = {
  if not (is-blank(language) and is-blank(level)) {
    [
      #grid(
        columns: (1fr, auto),
        align: (left, right),
        strong(language),
        level,
      )
    ]
  }
}



#show: brilliantCV.with(
  author: "Jane Smith",
  email: "jane.smith@wharton.upenn.edu",
  phone: "+1 (215) 555-0176",
  location: "Philadelphia, PA",
  social-links: (),
  accent-color: "#0396de",
  font: "Source Sans 3",
  header-font: "Roboto",
  font-fallback: (),
  font-size: 9pt,
  paper: "a4",
  margin: (left: 1.4cm, right: 1.4cm, top: 1cm, bottom: 1cm),
  leading: 0.6em,
  lang: "en",
)


#cvSection("Summary", accent-color: "#0396de")

Strategic Senior Product Manager with over 7 years of experience in driving product innovation and cross-functional leadership in the social media space.


#cvSection("Education", accent-color: "#0396de")


#cvEntry(
  title: "MBA",
  society: "Wharton School, University of Pennsylvania",
  date: "August 2014 - May 2016",
  location: "Philadelphia, PA",
  description: [
- Graduated with honors, focusing on Product Management and Digital Innovation.
],
  accent-color: "#0396de",
  date-width: 3.6cm,
)
#cvEntry(
  title: "BS in Engineering",
  society: "Massachusetts Institute of Technology (MIT)",
  date: "August 2010 - May 2014",
  location: "Cambridge, MA",
  description: [
- Specialized in Systems Engineering, blending technical expertise with product strategy.
],
  accent-color: "#0396de",
  date-width: 3.6cm,
)
#cvSection("Experience", accent-color: "#0396de")


#cvEntry(
  title: "Product Manager",
  society: "Tech Innovations Inc.",
  date: "April 2019 - January 2023",
  location: "San Francisco, CA",
  description: [
- Led a cross-functional team to launch a new social media feature that increased user engagement by 30% within the first quarter.
],
  accent-color: "#0396de",
  date-width: 3.6cm,
)
#cvEntry(
  title: "Associate Product Manager",
  society: "Innovatech Solutions",
  date: "June 2016 - March 2019",
  location: "New York, NY",
  description: [
- Managed product lifecycle for a suite of social media tools, leading to a 50% increase in customer satisfaction.
],
  accent-color: "#0396de",
  date-width: 3.6cm,
)
#cvSection("Skills", accent-color: "#0396de")

Product Strategy, Cross-Functional Leadership, Data Analysis, Agile Methodologies, User Experience Design, Market Research


#cvSection("Projects", accent-color: "#0396de")


#cvProject(
  title: "Social Media Engagement Platform",
  url: "https://www.techinnovations.com/social-media-engagement",
  date: "January 2021 - December 2021",
  description: [
- Designed and launched a platform that enhanced user interactions, achieving a 35% increase in daily active users.
],
  accent-color: "#0396de",
  date-width: 3.6cm,
)
#cvProject(
  title: "Analytics-Driven Feature Launch",
  url: "https://www.techinnovations.com/analytics-feature",
  date: "May 2020 - November 2020",
  description: [
- Led a successful feature launch driven by analytics, resulting in a 50% increase in user engagement.
],
  accent-color: "#0396de",
  date-width: 3.6cm,
)
#cvSection("Certifications", accent-color: "#0396de")


#cvCertification(
  title: "Certified Scrum Product Owner (CSPO)",
  organization: "Scrum Alliance",
  url: "www.scrumalliance.org/certifications/certified-scrum-product-owner",
  date: "June 2018",
  description: [
- Demonstrated expertise in Agile methodologies and product ownership.
],
  accent-color: "#0396de",
  date-width: 3.6cm,
)
#cvCertification(
  title: "Product Management Certification",
  organization: "General Assembly",
  url: "generalassemb.ly",
  date: "September 2017",
  description: [
- Completed a comprehensive program focusing on product lifecycle management.
],
  accent-color: "#0396de",
  date-width: 3.6cm,
)
#cvSection("Awards", accent-color: "#0396de")


#cvCertification(
  title: "Best Product Launch of the Year",
  organization: "Tech Innovations Inc.",
  url: "www.techinnovations.com/awards",
  date: "December 2022",
  description: [
- Recognized for leading the launch of a groundbreaking social media feature that significantly boosted user engagement.
],
  accent-color: "#0396de",
  date-width: 3.6cm,
)
#cvSection("Publications", accent-color: "#0396de")


#cvPublication(
  title: "Driving User Engagement through Product Innovation",
  authors: "Jane Smith",
  url: "https://www.productmanagementjournal.com/driving-user-engagement",
  url_name: "Product Management Journal",
  date: "October 2021",
  date-width: 3.6cm,
)
#v(6pt)
#cvSection("Languages", accent-color: "#0396de")


#cvLanguage(
  language: "English",
  level: "Fluent",
)
#cvLanguage(
  language: "Spanish",
  level: "Conversational",
)
