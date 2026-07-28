// Executive CV, a Typst resume template.
//
// Compiles with Typst 0.12 or newer.
// Set in New Computer Modern, which ships with Typst, so it renders as
// intended with nothing to install.
//
// Derived from moderner-cv (https://github.com/pavelzw/moderner-cv),
// (c) its authors, used under MIT. That licence continues to apply,
// so this file is not MIT-0: keep this notice if you redistribute the template
// itself. A CV you write with it is your own work.
// Modified from the original by JobSprout: restructured for a section registry,
// re-typeset to a fixed size scale, and reworked for empty-field handling.
//
// Self-contained: no imports, nothing to install.
// Every design:     https://github.com/davidculemann/typst-templates
// Edit in a browser: https://www.jobsprout.ai/resume-templates/executive
#set page(fill: rgb("#ffffff"))


#let is-blank(v) = v == none or v == "" or v == []

#let moderncv-blue = rgb("#3973AF")
#let light-gray = rgb("#737373")

// FontAwesome icon function using ligatures
// Automatically detects brand icons and uses the correct font family
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

#let _cv-line(left, right, ..args) = {
  set block(below: 0pt, above: 1pt)
  table(
    columns: (1fr, 5fr),
    stroke: none,
    ..args.named(),
    left,
    right,
  )
}

#let _cv_header(..args) = {
  let data = args.named()
  let title = data.at("title", default: [])
  let subtitle = data.at("subtitle", default: [])
  let social = data.at("social", default: ())
  let color = data.at("color", default: moderncv-blue)
  
  let subtitle-emphasis = "normal"
  let subtitle-color = light-gray
  let socials-color = light-gray
  // Path string into the compiler VFS (plan 111); none renders no photo and
  // reserves no space. Named "photo" so the builtin image() stays reachable.
  let photo = data.at("photo", default: none)
  let photo-radius = data.at("photo-radius", default: 0pt)
  let photo-size = data.at("photo-size", default: 2.4cm)
  let emphasize = false

  let titleStack = stack(
    dir: ttb,
    spacing: 1em,
    text(size: 30pt, title),
    text(size: 20pt, subtitle, style: subtitle-emphasis, fill: subtitle-color),
  )

  let format_social(linkPrefix, username, display: none, icon: none) = {
    let displayText = if display != none { display } else { username }
    let iconSpace = if icon != none { h(6pt) } else { [] }
    let iconContent = if icon != none { fa-icon(icon) } else { [] }
    // A diffed field arrives as content, which link() rejects as a destination.
    // Show the highlighted text unlinked for as long as the diff is on screen.
    let linked = if type(username) == str {
      link(linkPrefix + username)[#displayText]
    } else {
      displayText
    }
    [
      #if emphasize [
        #emph[#text(socials-color)[#iconContent#iconSpace#linked]]
      ] else [
        #text(socials-color)[#iconContent#iconSpace#linked]
      ]
    ]
  }

  let custom-social(dest, body) = [
    #if emphasize [
      #emph[#text(socials-color)[#link(dest, body)]]
    ] else [
      #text(socials-color)[#link(dest, body)]
    ]
  ]

  let address-social(body, icon: none) = {
    let iconSpace = if icon != none { h(6pt) } else { [] }
    let iconContent = if icon != none { fa-icon(icon) } else { [] }
    [
      #if emphasize [
        #emph[#text(socials-color)[#iconContent#iconSpace#body]]
      ] else [
        #text(socials-color)[#iconContent#iconSpace#body]
      ]
    ]
  }

  let socialsDict = (
    phone: ("tel:", none, "phone"),
    email: ("mailto:", none, "envelope"),
    github: ("https://github.com/", "GitHub", "github"),
    linkedin: ("https://linkedin.com/in/", "LinkedIn", "linkedin"),
    x: ("https://twitter.com/", "X", "x-twitter"),
    bluesky: ("https://bsky.app/profile/", "Bluesky", "square"),
  )

  let socialsList = ()
  for entry in social {
    let (key, value) = entry
    if key == "address" and type(value) == str {
      socialsList.push(address-social(value, icon: "location-dot"))
    } else if key in socialsDict {
      let (linkPrefix, displayLabel, iconName) = socialsDict.at(key)
      if type(value) == array {
        let (username, displayOverride) = value
        socialsList.push(format_social(linkPrefix, username, display: displayOverride, icon: iconName))
      } else {
        socialsList.push(format_social(linkPrefix, value, display: displayLabel, icon: iconName))
      }
    } else if type(value) == array {
      let (dest, body) = value
      socialsList.push(custom-social(dest, body))
    }
  }

  let socialStack = stack(
    dir: ttb,
    spacing: 0.5em,
    ..socialsList,
  )

  let imageStack = []
  if photo != none {
    // moderncv's accent-framed portrait: a thin rule in the header colour.
    let imageFramed = box(
      clip: true,
      radius: photo-radius,
      stroke: 1pt + color,
      image(photo, width: photo-size, height: photo-size, fit: "cover"),
    )
    imageStack = stack(
      dir: ltr,
      h(1em),
      imageFramed,
    )
  }

  stack(
    dir: ltr,
    titleStack,
    align(
      right + top,
      socialStack,
    ),
    imageStack,
  )
}

#let moderner-cv(
  name: [],
  subtitle: [],
  social: (),
  color: moderncv-blue,
  subtitle-color: light-gray,
  socials-color: light-gray,
  emphasize-header: false,
  lang: "en",
  font: "New Computer Modern",
  font-fallback: (), // Script fallback families (e.g. CJK) appended after the Latin stack
  font-size: 11pt,
  leading: 0.65em,
  photo: none,
  photo-radius: 0pt,
  photo-size: 2.4cm,
  paper: "a4",
  margin: (
    top: 10mm,
    bottom: 15mm,
    left: 15mm,
    right: 15mm,  ),
  show-footer: false,
  body,
) = [
  #set page(
    paper: paper,
    margin: margin,
  )

  #set text(
    font: (font, "Source Sans 3", "Roboto", "HK Grotesk", ..font-fallback),
    size: font-size,
    lang: lang,
    hyphenate: true,
  )

  #set par(leading: leading)

  #show heading: it => {
    set text(weight: "regular")
    set text(color)
    set block(above: 0pt)
    _cv-line(
      [],
      [#it.body],
    )
  }

  #show heading.where(level: 1): it => {
    set text(weight: "regular")
    set text(color)
    _cv-line(
      [#box(fill: color, width: 28mm, height: 0.25em)],
      [#it.body],
      align: horizon,
    )
  }

  #_cv_header(
    title: name,
    subtitle: subtitle,
    social: social,
    color: color,
    photo: photo,
    photo-radius: photo-radius,
    photo-size: photo-size,
  )

  #body

  #if show-footer [
    #v(1fr, weak: false)
    #name\
    #datetime.today().display("[month repr:long] [day], [year]")
  ]
]

#let cv-line(left-side, right-side) = {
  _cv-line(
    align(right, left-side),
    right-side,
  )
}

#let cv-entry(
  date: [],
  title: [],
  employer: [],
  ..description,
) = {
  let elements = ()
  if not is-blank(title) { elements.push(strong(title)) }
  if not is-blank(employer) { elements.push(emph(employer)) }
  for item in description.pos() {
    if not is-blank(item) { elements.push(item) }
  }
  cv-line(
    date,
    elements.join(", ")
  )
}

#let cv-entry-multiline(
  date: [],
  title: [],
  employer: [],
  ..description,
) = {
  let first-line = ()
  if not is-blank(title) { first-line.push(strong(title)) }
  if not is-blank(employer) { first-line.push(emph(employer)) }
  
  let content = first-line.join(", ")
  
  let desc-items = description.pos().filter(it => not is-blank(it))
  if desc-items.len() > 0 {
      content += linebreak() + text(size: 0.9em, desc-items.join(linebreak()))
  }
  
  cv-line(date, content)
}

#let cv-language(name: [], level: [], comment: []) = {
  _cv-line(
    align(right, name),
    stack(dir: ltr, level, align(right, emph(comment))),
  )
}

#let publication(
  title: "",
  authors: "",
  url: "",
  url_name: "",
  date: "",
) = {
  let stack-items = ()
  if not is-blank(title) { stack-items.push(strong(title)) }

  if authors != "" {
      stack-items.push(authors)
  }
  
  if url != "" or url_name != "" {
      let link-text = if url_name != "" { url_name } else { url }
      let link-dest = if url != "" { "https://" + url } else { "" }
      if link-dest != "" {
          stack-items.push(link(link-dest)[#link-text])
      } else {
          stack-items.push(link-text)
      }
  }
  
  cv-line(
    date, 
    stack(dir: ttb, spacing: 0.3em, ..stack-items)
  )
}

#let cv-reference(
  name: "",
  role: "",
  organization: "",
  phone: "",
  email: "",
) = {
  let stack-items = ()
  if not is-blank(name) { stack-items.push(strong(name)) }

  let line2 = ()
  if role != "" { line2.push(role) }
  if organization != "" { line2.push(organization) }
  if line2.len() > 0 {
      stack-items.push(line2.join(", "))
  }
  
  let line3 = ()
  if phone != "" { line3.push(phone) }
  if email != "" { line3.push(link("mailto:" + email)[#email]) }
  if line3.len() > 0 {
      stack-items.push(line3.join(" | "))
  }
  
  cv-line([], stack(dir: ttb, spacing: 0.3em, ..stack-items))
}

#let cv-double-item(left-1, right-1, left-2, right-2) = {
  set block(below: 0pt)
  table(
    columns: (1fr, 2fr, 1fr, 2fr),
    stroke: none,
    align(right, left-1), right-1, align(right, left-2), right-2,
  )
}



#show: moderner-cv.with(
  name: "Jane Smith",
  subtitle: [CV],
  social: (
    ("phone", "+1 (415) 555-0163"),
    ("email", "jane.smith@cs.stanford.edu"),
    ("address", "San Francisco, CA")
  ),
  color: rgb("#3973af"),
  font: "New Computer Modern",
  font-fallback: (),
  font-size: 11pt,
  paper: "a4",
  leading: 0.65em,
  margin: (top: 10mm, bottom: 15mm, left: 15mm, right: 15mm),
  lang: "en",
)


= Summary

Dynamic and innovative Research Scientist specializing in Machine Learning with a focus on large language models. Proven track record of contributing to cutting-edge AI research and publications in top-tier conferences.

= Education


#cv-entry-multiline(
  title: "PhD in Computer Science",
  employer: "Stanford University",
  date: "Sep 2018 - Jun 2023",
  [
- Conducted research on large language models, developing algorithms that improved language understanding and generation.
- Published significant findings in leading AI conferences, contributing to the advancement of AI technologies.
]
)
#cv-entry-multiline(
  title: "BS in Computer Science",
  employer: "Stanford University",
  date: "Sep 2014 - Jun 2018",
  [
- Graduated with honors, focusing on AI and machine learning applications.
]
)
= Experience


#cv-entry-multiline(
  title: "Research Scientist",
  employer: "Google AI",
  date: "Jul 2023 - Present",
  [
- Lead a team of researchers in developing state-of-the-art models for natural language processing, resulting in a 40% increase in accuracy for language understanding tasks.
]
)
#cv-entry-multiline(
  title: "Research Intern",
  employer: "OpenAI",
  date: "Jun 2022 - Sep 2022",
  [
- Contributed to the development of GPT-3, focusing on fine-tuning and model evaluation, which led to a 25% improvement in model performance.
]
)
= Projects


#cv-entry(
  title: "Advanced Language Model Architecture",
  employer: [#link("https://github.com/janesmith/advanced-lm")[github.com/janesmith/advanced-lm]],
  date: "Jan 2022 - Jun 2022",
  [
- Developed a novel architecture for language models that improved contextual understanding.
]
)
#cv-entry(
  title: "AI for Healthcare",
  employer: [#link("https://github.com/janesmith/ai-healthcare")[github.com/janesmith/ai-healthcare]],
  date: "Jun 2021 - Jan 2022",
  [
- Designed AI solutions for predicting patient outcomes using machine learning techniques.
]
)
= Skills

Machine Learning, Deep Learning, Natural Language Processing, Python, TensorFlow, PyTorch


= Certifications


#cv-entry-multiline(
  title: "Deep Learning Specialization",
  employer: [Coursera - DeepLearning.AI (#link("https://www.coursera.org/account/accomplishments/specialization/DLSPEC123")[www.coursera.org/account/accomplishments/specialization/DLSPEC123])],
  date: "May 2020",
  [
- Completed a comprehensive specialization on deep learning, covering neural networks and their applications.
]
)
= Awards


#cv-entry-multiline(
  title: "Best Paper Award",
  employer: [NeurIPS 2022 (#link("https://neurips.cc/Conferences/2022/Awards")[neurips.cc/Conferences/2022/Awards])],
  date: "Dec 2022",
  [
- Recognized for outstanding contributions to the conference with a focus on innovative AI research.
]
)
= Languages


#cv-language(
  name: "English",
  level: "Fluent",
  comment: [],
)
#cv-language(
  name: "Spanish",
  level: "Conversational",
  comment: [],
)
