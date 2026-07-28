// Academic CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in Libertinus Serif, which ships with Typst, so it renders as
// intended with nothing to install.
//
// Derived from academicv (https://github.com/roaldarbol/academicv),
// (c) its authors, used under Apache-2.0. That licence continues to apply,
// so this file is not MIT-0: keep this notice if you redistribute the template
// itself. A CV you write with it is your own work.
// Modified from the original by JobSprout: restructured for a section registry,
// re-typeset to a fixed size scale, and reworked for empty-field handling.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/academic
#set page(fill: rgb("#ffffff"))

// Settings
#let academicv-settings = (
  font-heading: "Libertinus Serif",
  font-body: "Libertinus Serif",
  fontsize: 10pt,
  spacing-section: 12pt,
  spacing-entry: 0.1em,
  spacing-element: 3pt,
  spacing-line: 5pt,
  color-hyperlink: rgb("#3278b4"),
  margin: 3.5cm,
  paper: "a4",
  lang: "en",
  justify: true,
)

// ============================================================================
// Academic CV Base Template
// Adapted from https://github.com/roaldarbol/academicv
// ============================================================================

// Utility functions for converting string values to Typst types
#let convert-string-to-length(string) = {
  if type(string) == str {
    if string.ends-with("pt") {
      return float(string.replace("pt", "")) * 1pt
    } else if string.ends-with("em") {
      return float(string.replace("em", "")) * 1em
    } else if string.ends-with("cm") {
      return float(string.replace("cm", "")) * 1cm
    } else if string.ends-with("mm") {
      return float(string.replace("mm", "")) * 1mm
    } else {
      return string
    }
  } else {
    return string
  }
}

#let convert-string-to-color(string-value) = {
  if type(string-value) == str {
    if string-value.starts-with("rgb(") and string-value.ends-with(")") {
      let rgb-str = string-value.slice(4, string-value.len() - 1)
      let components = rgb-str.split(",").map(s => int(float(s.trim())))
      if components.len() == 3 {
        return rgb(components.at(0), components.at(1), components.at(2))
      }
    } else if string-value.starts-with("rgba(") and string-value.ends-with(")") {
      let rgba-str = string-value.slice(5, string-value.len() - 1)
      let components = rgba-str.split(",")
      if components.len() == 4 {
        let r = int(float(components.at(0).trim()))
        let g = int(float(components.at(1).trim()))
        let b = int(float(components.at(2).trim()))
        let a = float(components.at(3).trim())
        return rgba(r, g, b, a)
      }
    } else if string-value.starts-with("#") {
      let hex = string-value.slice(1)
      if hex.len() == 6 {
        let r = int(hex.slice(0, 2), base: 16)
        let g = int(hex.slice(2, 4), base: 16)
        let b = int(hex.slice(4, 6), base: 16)
        return rgb(r, g, b)
      } else if hex.len() == 3 {
        let r = int(hex.at(0) + hex.at(0), base: 16)
        let g = int(hex.at(1) + hex.at(1), base: 16)
        let b = int(hex.at(2) + hex.at(2), base: 16)
        return rgb(r, g, b)
      }
    }
  }
  
  return rgb(0, 0, 255)
}

// Set text and paragraph rules
#let setrules(settings, doc) = {
  set text(
    font: settings.font-body,
    size: settings.fontsize,
    lang: settings.at("lang", default: "en"),
    hyphenate: false,
  )

  set list(
    spacing: settings.spacing-line
  )

  set par(
    leading: settings.spacing-line,
    justify: settings.at("justify", default: true),
  )

  show link: it => {
    text(
      fill: settings.color-hyperlink,
    )[#it]
  }

  doc
}

// Show heading rules
#let showrules(settings, doc) = {
  // Section headings (level 2)
  show heading.where(
    level: 2,
  ): it => block(width: 100%)[
    #v(settings.spacing-section)
    #set align(left)
    #set text(font: settings.font-heading, size: 1em, weight: "semibold")
    #if (settings.at("headingsmallcaps", default:false)) {
      smallcaps(it.body)
    } else {
      it.body
    }
    #v(-0.75em) #line(length: 100%, stroke: 1pt + black)
  ]

  // Name heading (level 1)
  show heading.where(
    level: 1,
  ): it => block(width: 100%)[
    #set text(font: settings.font-heading, size: 1.1em, weight: "semibold")
    #if (settings.at("headingsmallcaps", default:false)) {
      smallcaps(it.body)
    } else {
      it.body
    }
    #v(2pt)
  ]

  doc
}

// ============================================================================
// Layout Functions
// ============================================================================

// Header layout for personal information
#let layout-header(name, titles, location, email, phone, social-links, settings, isbreakable: true) = {
  // Build profiles array in code mode (not content mode)
  let profiles = ()

  if email != "" and email != none {
    profiles = profiles + (box(link("mailto:" + email, email)),)
  }
  if phone != "" and phone != none {
    profiles = profiles + (box(link("tel:" + phone, phone)),)
  }
  
  // Add social links in the order they were provided
  for social-link in social-links {
    let (url, display-text) = social-link
    if url != "" and url != none {
      let full-url = if url.starts-with("http") { url } else { "https://" + url }
      profiles = profiles + (box(link(full-url, display-text)),)
    }
  }

  align(center)[
    = #name

    #if titles.len() > 0 {
      block(width: 100%)[
        #text(weight: "semibold", titles.join("  /  "))
        #v(-4pt)
      ]
    }

    #if location != "" {
      block(width: 100%)[
        #location
        #v(-4pt)
      ]
    }

    #block(width: 100%)[
      #set text(font: settings.font-body, weight: "medium", size: settings.fontsize)
      #pad(x: 0em)[
        #profiles.join([#sym.space.en | #sym.space.en])
      ]
    ]
  ]
}

// Timeline layout for education, experience, etc.
// Simplified version that works with Typst's functional semantics
#let is-blank(v) = v == none or v == "" or v == []

#let layout-timeline(data, primary-element: none, secondary-element: none, tertiary-element: none, settings: none, isbreakable: true) = {
  let year-column-width = 9.5em
  let spacing-entry = settings.at("spacing-entry", default: 0.5em)
  let spacing-element = -1em + settings.at("spacing-element", default: 2pt)

  let primary = if type(primary-element) == array { primary-element } else { (primary-element,) }
  let secondary = if type(secondary-element) == array { secondary-element } else { (secondary-element,) }
  let tertiary = if type(tertiary-element) == array { tertiary-element } else { (tertiary-element,) }

  // Helper to get first non-blank value from entry for given fields
  let get-first-value(entry, fields) = {
    for field in fields {
      if field in entry and not is-blank(entry.at(field)) {
        return (field: field, value: entry.at(field))
      }
    }
    return none
  }

  // Helper to get all values for fields (except the first one)
  let get-other-values(entry, fields, skip-field) = {
    let result = ()
    for field in fields {
      if field != skip-field and field in entry and not is-blank(entry.at(field)) {
        result = result + (entry.at(field),)
      }
    }
    result
  }

  // Helper to format date range
  let format-date(entry) = {
    let has-end = "end-date" in entry and entry.end-date != none and entry.end-date != ""
    let has-start = "start-date" in entry and entry.start-date != none and entry.start-date != ""

    if has-end {
      if has-start {
        if entry.start-date == entry.end-date {
          entry.start-date
        } else {
          entry.start-date + " - " + entry.end-date
        }
      } else {
        entry.end-date
      }
    } else if has-start {
      entry.start-date
    } else {
      ""
    }
  }

  block(width: 100%, breakable: isbreakable, inset: 0pt, outset: 0pt)[
    #for (i, entry) in data.enumerate() {
      // Click-to-source anchor (top of entry). Label must match ANCHOR_LABEL.
      if "anchor" in entry and entry.anchor != none {
        context [#metadata((id: entry.anchor, p: here().position())) <cv-anchor>]
      }
      let year-text = format-date(entry)
      let primary-result = get-first-value(entry, primary)

      table(
        columns: (year-column-width, 1fr),
        stroke: none,
        inset: 0pt,
        column-gutter: 0pt,
        table.vline(x: 1, stroke: 0.5pt + gray),
        pad(right: 0.8em)[#align(right, year-text)],

        pad(left: 0.8em)[#{
          // Primary content (bold) with optional URL link
          let rendered = false
          if primary-result != none {
            text(weight: "bold", primary-result.value)
            if primary-result.field == "institution" and "location" in entry and not is-blank(entry.location) {
              ", " + entry.location
            }
            // Check for URL in primary elements and render as clickable link
            if "url" in entry and entry.url != none and entry.url != "" {
              [ (#link("https://" + entry.url)[#entry.url])]
            }
            rendered = true
          }

          // Secondary content (italic)
          let sec-values = ()
          for field in secondary {
            if field in entry and not is-blank(entry.at(field)) {
              sec-values = sec-values + (entry.at(field),)
            }
          }
          if sec-values.len() > 0 {
            if rendered { v(spacing-element) }
            text(style: "italic", sec-values.join(", "))
            rendered = true
          }

          // Tertiary content (smaller text)
          let tert-values = ()
          for field in tertiary {
            if field in entry and not is-blank(entry.at(field)) and field != "url" {
              tert-values = tert-values + (entry.at(field),)
            }
          }
          if tert-values.len() > 0 {
            if rendered { v(spacing-element) }
            text(size: 8pt, tert-values.join(", "))
          }
        }]
      )

      if i < data.len() - 1 {
        v(spacing-entry)
      }
    }
  ]
}

// Order-driven custom-section timeline. Each entry is a dict with a "year"
// string (the formatted date(range), rendered in the left column) and a
// "cells" array of pre-styled content blocks in reading order (title first,
// then the remaining middle fields in field order). The cells fill a 2-column
// grid in the content area: cell 1 = top-left, 2 = top-right, 3 = bottom-left,
// 4 = bottom-right, 5+ = full-width lines below. An optional "body" content
// block renders full-width below the grid.
#let layout-custom-timeline(data, settings: none, isbreakable: true) = {
  let year-column-width = 9.5em
  let spacing-entry = settings.at("spacing-entry", default: 0.5em)

  block(width: 100%, breakable: isbreakable, inset: 0pt, outset: 0pt)[
    #for (i, entry) in data.enumerate() {
      if "anchor" in entry and entry.anchor != none {
        context [#metadata((id: entry.anchor, p: here().position())) <cv-anchor>]
      }
      let cells = entry.at("cells", default: ())
      let grid-cells = cells.slice(0, calc.min(cells.len(), 4))
      let overflow = if cells.len() > 4 { cells.slice(4) } else { () }
      let body = entry.at("body", default: [])

      table(
        columns: (year-column-width, 1fr),
        stroke: none,
        inset: 0pt,
        column-gutter: 0pt,
        table.vline(x: 1, stroke: 0.5pt + gray),
        pad(right: 0.8em)[#align(right, entry.at("year", default: ""))],

        pad(left: 0.8em)[#{
          if grid-cells.len() > 0 {
            let left-aligned = ()
            let right-aligned = ()
            for (j, cell) in grid-cells.enumerate() {
              if calc.even(j) { left-aligned.push(cell) } else { right-aligned.push(cell) }
            }
            grid(
              columns: (1fr, auto),
              align: (left + top, right + top),
              [#left-aligned.join(linebreak())],
              [#right-aligned.join(linebreak())],
            )
          }
          for line in overflow { block(above: 0.3em)[#line] }
          if body != [] { body }
        }]
      )

      if i < data.len() - 1 {
        v(spacing-entry)
      }
    }
  ]
}

// Prose layout for summary, statement, etc.
#let layout-prose(data, isbreakable: true) = {
  block(width: 100%, breakable: isbreakable)[
    #if type(data) == array {
      for item in data {
        pad(left: 1em, item)
      }
    } else {
      pad(left: 1em, data)
    }
  ]
}

// Bullet list layout. Items are either plain content or an
// (anchor, body) dict (array-layout entries carrying a click-to-source anchor).
#let layout-bullet-list(data, isbreakable: true) = {
  block(width: 100%, breakable: isbreakable)[
    #for item in data {
      let is-dict = type(item) == dictionary
      if is-dict and item.at("anchor", default: none) != none {
        context [#metadata((id: item.anchor, p: here().position())) <cv-anchor>]
      }
      let content-item = if is-dict { item.at("body", default: []) } else { item }
      grid(
        columns: (10pt, 1fr),
        gutter: 0pt,
        [•],
        pad(left: 5pt, content-item)
      )
    }
  ]
}

// Numbered list layout. Items are either plain content or an
// (anchor, body) dict (array-layout entries carrying a click-to-source anchor).
#let layout-numbered-list(data, isbreakable: true) = {
  block(width: 100%, breakable: isbreakable)[
    #for (i, item) in data.enumerate() {
      let number = i + 1
      let is-dict = type(item) == dictionary
      if is-dict and item.at("anchor", default: none) != none {
        context [#metadata((id: item.anchor, p: here().position())) <cv-anchor>]
      }
      let content-item = if is-dict { item.at("body", default: []) } else { item }
      grid(
        columns: (15pt, 1fr),
        gutter: 0pt,
        align(right, str(number) + "."),
        pad(left: 5pt, content-item)
      )
    }
  ]
}

// Reference layout (custom 3-line format)
#let layout-reference(data, isbreakable: true) = {
  block(width: 100%, breakable: isbreakable)[
    #for (i, ref) in data.enumerate() {
      // Click-to-source anchor (top of entry). Label must match ANCHOR_LABEL.
      if "anchor" in ref and ref.anchor != none {
        context [#metadata((id: ref.anchor, p: here().position())) <cv-anchor>]
      }
      let lines = ()
      if "name" in ref and not is-blank(ref.name) { lines.push(strong(ref.name)) }

      let affiliation = ()
      if "role" in ref and not is-blank(ref.role) { affiliation.push(ref.role) }
      if "organization" in ref and not is-blank(ref.organization) { affiliation.push(ref.organization) }
      if affiliation.len() > 0 { lines.push(affiliation.join(", ")) }

      let contact = ()
      if "phone" in ref and not is-blank(ref.phone) {
        contact = contact + (ref.phone,)
      }
      if "email" in ref and not is-blank(ref.email) {
        contact = contact + (link("mailto:" + ref.email, ref.email),)
      }

      if contact.len() > 0 {
        lines.push(contact.join(" | "))
      }

      lines.join(linebreak())

      if i < data.len() - 1 {
        v(1em)
      }
    }
  ]
}

// Main template function
#let academic-cv(
  name: "",
  titles: (),
  location: "",
  email: "",
  phone: "",
  social-links: (), // Array of (url, display-text) tuples
  settings: (:),
  body
) = {
  set page(
    paper: settings.at("paper", default: "a4"),
    margin: settings.at("margin", default: 3.5cm),
    numbering: settings.at("pageNumbering", default: "1 / 1"),
    number-align: settings.at("pageNumberAlign", default: center),
  )
  
  setrules(settings, 
    showrules(settings, {
      layout-header(
        name, titles, location, email, phone, social-links, settings
      )
      body
    })
  )
}



#show: academic-cv.with(
  name: "Jane Smith",
  titles: (),
  location: "Cambridge, MA",
  email: "jane.smith@mit.edu",
  phone: "+1 (617) 555-0198",
  social-links: (),
  settings: academicv-settings,
)


== Education

#layout-timeline(
  ((
  institution: "Massachusetts Institute of Technology (MIT)",
  location: "Cambridge, MA",
  title: "PhD in Computer Science",
  start-date: "09/2018",
  end-date: "06/2023",
  description: [
- Thesis: 'Efficient Neural Architectures for Natural Language Understanding' - Developed novel transformer variants achieving state-of-the-art results on NLU benchmarks.
- Advisor: Prof. Regina Barzilay. GPA: 4.0/4.0
],
), (
  institution: "Stanford University",
  location: "Stanford, CA",
  title: "BSc in Computer Science",
  start-date: "09/2014",
  end-date: "06/2018",
  description: [
- Graduated with Distinction. Senior thesis on attention mechanisms in neural networks.
- Relevant coursework: Machine Learning, Deep Learning, Natural Language Processing, Statistical Learning Theory.
],
)),
  primary-element: ("institution",),
  secondary-element: ("title",),
  tertiary-element: ("description",),
  settings: academicv-settings,
  isbreakable: true
)

== Experience

#layout-timeline(
  ((
  institution: "DeepMind",
  location: "London, UK",
  title: "Research Intern",
  start-date: "06/2021",
  end-date: "09/2021",
  description: [
- Developed a novel reinforcement learning algorithm for language model alignment that improved model performance by 15% on safety benchmarks.
- Collaborated with a team of researchers to implement state-of-the-art techniques in neural architectures, resulting in a paper submission to NeurIPS.
],
),),
  primary-element: ("institution",),
  secondary-element: ("title",),
  tertiary-element: ("description",),
  settings: academicv-settings,
  isbreakable: true
)

== Publications

#layout-numbered-list(
  ((body: [*Efficient Attention Mechanisms for Long-Context Language Understanding*. Jane Smith, Regina Barzilay, Tommi Jaakkola. 05/2023. #link("https://" + "neurips.cc/Conferences/2023")[NeurIPS 2023]]), (body: [*Scaling Laws for Transfer Learning in Natural Language Processing*. Jane Smith, et al.. 07/2022. #link("https://" + "icml.cc/Conferences/2022")[ICML 2022]]), (body: [*Robust Neural Machine Translation with Adversarial Training*. Jane Smith, Michael Chen, Regina Barzilay. 06/2021. #link("https://" + "aclanthology.org/events/acl-2021")[ACL 2021]])),
  isbreakable: true
)

== Awards

#layout-timeline(
  ((
  title: "NSF Graduate Research Fellowship",
  url: "",
  institution: "National Science Foundation",
  start-date: "04/2019",
  description: [
- Three-year fellowship supporting graduate research in computer science and artificial intelligence.
],
),),
  primary-element: ("title", "url"),
  secondary-element: ("institution",),
  tertiary-element: ("description",),
  settings: academicv-settings,
  isbreakable: true
)

