// Basic CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in New Computer Modern, which ships with Typst, so it renders as
// intended with nothing to install.
//
// Derived from basic-typst-resume-template (https://github.com/stuxf/basic-typst-resume-template),
// (c) its authors, used under Unlicense. That licence continues to apply,
// so this file is not MIT-0: keep this notice if you redistribute the template
// itself. A CV you write with it is your own work.
// Modified from the original by JobSprout: restructured for a section registry,
// re-typeset to a fixed size scale, and reworked for empty-field handling.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/basic
#set page(fill: rgb("#ffffff"))


#let resume(
  author: "",
  // VFS path string for an optional circle photo at the header's right; none
  // renders the classic header alone.
  photo: none,
  photo-radius: 50%,
  photo-size: 2.2cm,
  author-position: left,
  personal-info-position: left,
  location: "",
  email: "",
  phone: "",
  social-links: (), // Array of (url, display-text) tuples
  accent-color: "#000000",
  font: "New Computer Modern",
  paper: "a4",
  author-font-size: 20pt,
  font-size: 11pt,
  margin: 0.5in,
  leading: 0.65em,
  lang: "en",
  body,
) = {

  // Handle both string and content for author in document title
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(
    font: font,
    size: font-size,
    lang: lang,
    ligatures: false,
    hyphenate: true
  )

  set page(
    margin: margin,
    paper: paper,
  )

  show link: underline

  show heading.where(level: 2): it => [
    #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
    #line(length: 100%, stroke: 1pt)
  ]

  show heading: set text(fill: rgb(accent-color))
  show link: set text(fill: rgb(accent-color))

  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 700,
      size: author-font-size,
    )
    #pad(it.body)
  ]

  let header-block = {
    [= #(author)]

    let contact-item(value, prefix: "", link-type: "", display: none) = {
      if value != "" and value != none {
        if link-type != "" {
          let display-text = if display != none { display } else { prefix + value }
          let actual-link = if link-type == "mailto:" or link-type == "tel:" {
            if str(value).starts-with(link-type) { value } else { link-type + value }
          } else {
            value
          }
          link(actual-link)[#display-text]
        } else {
          value
        }
      }
    }

    // Build contact items: phone, location, email first, then social links in order
    // Handle both string and content types (content is used for diff preview)
    let contact-items = ()
    if phone != "" and phone != none { contact-items.push(phone) }
    if location != "" and location != none { contact-items.push(location) }
    // For email: if it's content (diff preview), display directly; otherwise make it a link
    if email != "" and email != none {
      if type(email) == str {
        contact-items.push(contact-item(email, link-type: "mailto:", display: email))
      } else {
        contact-items.push(email)
      }
    }

    // Add social links in order they were provided
    for social-link in social-links {
      let (url, display-text) = social-link
      if url != "" and url != none {
        let full-url = if url.starts-with("http") { url } else { "https://" + url }
        contact-items.push(link(full-url)[#display-text])
      }
    }

    pad(
      top: 0.25em,
      align(personal-info-position)[
        #{contact-items.filter(x => x != none).join("  |  ")}
      ],
    )
  }

  if photo != none {
    grid(
      columns: (1fr, auto),
      column-gutter: 16pt,
      align: (left + horizon, right + horizon),
      header-block,
      box(
        clip: true,
        radius: photo-radius,
        width: photo-size,
        height: photo-size,
        image(photo, width: photo-size, height: photo-size, fit: "cover"),
      ),
    )
  } else {
    header-block
  }

  set par(justify: false, leading: leading)
  body
}

#let is-blank(v) = v == none or v == "" or v == []

#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  let rows = ()
  if not (is-blank(top-left) and is-blank(top-right)) {
    rows.push([#top-left #h(1fr) #top-right])
  }
  if not (is-blank(bottom-left) and is-blank(bottom-right)) {
    rows.push([#bottom-left #h(1fr) #bottom-right])
  }
  rows.join(linebreak())
}

#let generic-one-by-two(
  left: "",
  right: "",
) = {
  if not (is-blank(left) and is-blank(right)) {
    [
      #left #h(1fr) #right
    ]
  }
}

#let dates-helper(
  start-date: "",
  end-date: "",
) = {
  start-date + " " + $dash.em$ + " " + end-date
}

#let edu(
  institution: none,
  dates: none,
  degree: none,
  gpa: none,
  location: none,
  consistent: false,
) = {
  if consistent {
    generic-two-by-two(
      top-left: if not is-blank(institution) { strong(institution) } else { [] },
      top-right: dates,
      bottom-left: if not is-blank(degree) { emph(degree) } else { [] },
      bottom-right: if not is-blank(location) { emph(location) } else { [] },
    )
  } else {
    generic-two-by-two(
      top-left: if not is-blank(institution) { strong(institution) } else { [] },
      top-right: location,
      bottom-left: if not is-blank(degree) { emph(degree) } else { [] },
      bottom-right: if not is-blank(dates) { emph(dates) } else { [] },
    )
  }
}

#let work(
  title: none,
  dates: none,
  company: none,
  location: none,
) = {
  generic-two-by-two(
    top-left: if not is-blank(title) { strong(title) } else { [] },
    top-right: dates,
    bottom-left: company,
    bottom-right: if not is-blank(location) { emph(location) } else { [] },
  )
}

#let volunteering(
  role: none,
  dates: none,
  organization: none,
  location: none,
) = {
  generic-two-by-two(
    top-left: if not is-blank(role) { strong(role) } else { [] },
    top-right: dates,
    bottom-left: organization,
    bottom-right: if not is-blank(location) { emph(location) } else { [] },
  )
}

#let project(
  role: none,
  name: none,
  url: none,
  dates: none,
) = {
  generic-one-by-two(
    left: {
      if role == none or role == "" {
        if name != none and name != "" {
          [*#name* #if url != none and url != "" and dates != none and dates != "" [ (#link("https://" + url)[#url])]]
        } else {
          []
        }
      } else {
        if name != none and name != "" {
          [*#role*, #name #if url != none and url != "" and dates != none and dates != "" [ (#link("https://" + url)[#url])]]
        } else {
          [*#role*]
        }
      }
    },
    right: {
      if (dates == none or dates == "") and url != none and url != "" {
        link("https://" + url)[#url]
      } else if dates != none and dates != "" {
        dates
      } else {
        []
      }
    },
  )
}

#let extracurriculars(
  activity: "",
  dates: "",
) = {
  generic-one-by-two(
    left: if activity != "" { strong(activity) } else { [] },
    right: if dates != "" { dates } else { [] },
  )
}

#let certification(
  name: none,
  organization: none,
  url: none,
  date: none,
) = {
  block(width: 100%, {
    generic-one-by-two(
      left: {
        if name != none and name != "" {
          if url != none and url != "" {
            [*#name*#if organization != none and organization != "" [, #organization] #if date != none and date != "" [ (#link("https://" + url)[#url])]]
          } else {
            [*#name*#if organization != none and organization != "" [, #organization]]
          }
        } else {
          []
        }
      },
      right: {
        if (date == none or date == "") and url != none and url != "" {
          link("https://" + url)[#url]
        } else if date != none and date != "" {
          date
        } else {
          []
        }
      },
    )
  })
}

#let award(
  title: none,
  organization: none,
  url: none,
  date: none,
) = {
  block(width: 100%, generic-two-by-two(
    top-left: {
      if title != none and title != "" {
        if url != none and url != "" {
          [*#link("https://" + url)[#title]*]
        } else {
          [*#title*]
        }
      } else {
        []
      }
    },
    top-right: if date != none and date != "" { date } else { [] },
    bottom-left: if organization != none and organization != "" { organization } else { [] },
    bottom-right: {
      if url != none and url != "" and (date == none or date == "") {
        link("https://" + url)[#url]
      } else {
        []
      }
    },
  ))
}

#let publication(
  title: none,
  authors: none,
  url: none,
  url_name: none,
  date: none,
) = {
  [
    #grid(
      columns: (1fr, auto),
      gutter: 16pt,
      align: (left + top, right + top),
      strong(if title != none { title } else { [] }),
      if date != none { date } else { [] },
    )
    #if authors != none and authors != "" [
      #authors \
    ]
    #if url_name != none and url_name != "" and url != none and url != "" [
      #link("https://" + url)[#url_name]
    ] else if url != none and url != "" [
      #link("https://" + url)[#url]
    ] else if url_name != none and url_name != "" [
      #url_name
    ]
  ]
}

#let reference(
  name: none,
  role: none,
  organization: none,
  phone: none,
  email: none,
) = {
  let lines = ()
  if not is-blank(name) { lines.push(strong(name)) }
  let affiliation = ()
  if not is-blank(role) { affiliation.push(role) }
  if not is-blank(organization) { affiliation.push(organization) }
  if affiliation.len() > 0 { lines.push(affiliation.join(", ")) }
  let contact-info = ()
  if not is-blank(phone) { contact-info.push(phone) }
  if not is-blank(email) { contact-info.push(link("mailto:" + email)[#email]) }
  if contact-info.len() > 0 { lines.push(contact-info.join(" | ")) }
  lines.join(linebreak())
}

#let language(
  language: none,
  level: none,
) = {
  if not is-blank(language) and not is-blank(level) {
    [*#language*: #text(weight: "regular")[#level]]
  } else if not is-blank(language) {
    [*#language*]
  } else if not is-blank(level) {
    [#text(weight: "regular")[#level]]
  }
}


#let smart-entry(threshold: 10%, body) = {
  block(breakable: false, height: threshold)
  v(-threshold, weak: true)
  body
}


#show: resume.with(
  author: "Jane Smith",
  email: "jane.smith@stanford.edu",
  phone: "+1 (650) 555-0142",
  location: "Palo Alto, CA",
  social-links: (),
  accent-color: "#000000",
  font: "New Computer Modern",
  font-size: 11pt,
  paper: "a4",
  margin: 0.5in,
  leading: 0.65em,
  lang: "en",
)


== Summary

Dedicated Software Engineer with over 4 years of experience in developing scalable applications and solutions. Proven track record of success in designing, implementing, and optimizing technology systems for high-impact projects in top tech companies.

== Education

#smart-entry[
#edu(
  institution: "Stanford University",
  degree: "BS in Computer Science",
  location: "Stanford, CA",
  dates: "September 2015 - June 2019",
)
- Graduated with Honors, focusing on Software Engineering and Artificial Intelligence.
- Participated in various hackathons, winning 1st place in the Stanford Hackathon for developing an AI-driven application.
]
== Experience

#smart-entry[
#work(
  title: "Software Engineer",
  company: "Google",
  location: "Mountain View, CA",
  dates: "July 2021 - Present",
)
- Led a team of 5 engineers to develop a high-performance data processing pipeline, reducing data processing time by 30%.
]
#smart-entry[
#work(
  title: "Software Engineer",
  company: "Facebook",
  location: "Menlo Park, CA",
  dates: "July 2019 - June 2021",
)
- Developed and maintained microservices for the Ads platform, improving system scalability and reliability.
]
== Projects

#smart-entry[
#project(
  role: "",
  name: "AI-Powered Chatbot",
  url: "github.com/janesmith/chatbot-project",
  dates: "January 2020 - December 2020",
)
- Developed a chatbot using NLP to improve customer service response times, achieving a 40% reduction in ticket resolution time.
]
#smart-entry[
#project(
  role: "",
  name: "E-Commerce Platform",
  url: "janesmith.dev/ecommerce",
  dates: "January 2021 - December 2021",
)
- Engineered a full-stack e-commerce application that handles 10,000 concurrent users, resulting in a 50% increase in transaction speed.
]
== Skills

Java, Python, C++, JavaScript, SQL, Machine Learning


== Certifications

#certification(
  name: "Certified Kubernetes Administrator (CKA)",
  organization: "Linux Foundation",
  url: "www.credly.com/badges/cka-janesmith",
  date: "March 2022",
)
- Validated expertise in Kubernetes administration and orchestration.
#certification(
  name: "AWS Certified Solutions Architect",
  organization: "Amazon Web Services",
  url: "www.credly.com/badges/aws-sa-janesmith",
  date: "May 2021",
)
- Demonstrated ability to design distributed systems on AWS.
== Languages

#language(
  language: "English",
  level: "Native",
), #language(
  language: "Spanish",
  level: "Conversational",
)
