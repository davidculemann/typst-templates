// Index CV. Replace the details below with your own and delete what you do not
// need; every section here is optional. The accent colour is set once, on the
// line after this comment, and everything picks it up from there.

#import "@preview/index-cv:0.1.0": *

#let accent = "#3a3f6b"

#show: resume.with(
  author: "Priya Raman",
  font: "Roboto",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
)

#masthead(
  author: "Priya Raman",
  profession: "UX Designer",
  accent-color: accent,
  contact: [
    priya.raman\@example.com
    #h(0.6em) | #h(0.6em) +44 20 7946 0644
    #h(0.6em) | #h(0.6em) London, UK
    #h(0.6em) | #h(0.6em) #link("https://example.com/priya")[example.com/priya]
  ],
)

// Sections number themselves, in order, as you declare them. Wrap each
// section's contents in `index-body` so they line up under the label instead of
// under the number.
#cv-section("Profile", accent-color: accent)

#index-body[
  Designer on complex internal tools, the kind with 40 fields on a screen and a
  user who has been doing the job for eleven years. Most of my work is removing
  decisions rather than adding features.
]

#cv-section("Experience", accent-color: accent)

#index-body[
  #index-entry(
    title: "Lead Product Designer",
    subtitle: "Ardent Health Systems",
    dates: "2021 - Present",
    location: "London, UK",
  )[
    - Redesigned the clinical scheduling tool used by 2,300 staff across nine
      trusts, cutting median booking time from 4:10 to 1:35.
    - Built and now maintain the design system, adopted by four product teams
      and the two agencies working alongside them.
    - Run fortnightly research sessions on ward, which is where every worthwhile
      idea in the last three years has come from.
  ]

  #index-entry(
    title: "Product Designer",
    subtitle: "Kelvin and Rowe",
    dates: "2018 - 2021",
    location: "London, UK",
  )[
    - Designed across six client products in logistics and insurance, usually as
      the only designer on the team.
    - Introduced usability testing as a standard project phase, which the studio
      then began charging for separately.
  ]

  #index-entry(
    title: "Junior Designer",
    subtitle: "Sable Interactive",
    dates: "2016 - 2018",
    location: "Bristol, UK",
  )[
    - Interface design and prototyping across web and mobile, and the studio's
      first accessibility audits.
  ]
]

#cv-section("Selected Work", accent-color: accent)

#index-body[
  #index-entry(
    title: "Ward round companion",
    subtitle: "Tablet tool for consultant-led rounds",
    dates: "2023",
    meta: "Rolled out to nine trusts",
  )[]

  #index-entry(
    title: "Ardent Design System",
    subtitle: "Component library and usage guidance",
    dates: "2022",
  )[]

  #index-entry(
    title: "Referral triage rebuild",
    subtitle: "Reworked a 40-field form into a five-step flow",
    dates: "2021",
    meta: "Median completion 11 minutes to 4",
  )[]
]

#cv-section("Education", accent-color: accent)

#index-body[
  #index-entry(
    title: "University of the West of England",
    subtitle: "BA Graphic Design",
    dates: "2013 - 2016",
    location: "Bristol, UK",
  )[]
]

#cv-section("Skills", accent-color: accent)

#index-body[
  *Design* \
  Interaction design, design systems, prototyping, usability testing,
  accessibility to WCAG 2.2 AA, service blueprinting.

  *Tools* \
  Figma, Storybook, Maze, and enough HTML and CSS to be useful in a stand-up
  rather than just describing what I want.
]

#cv-section("Languages", accent-color: accent)

#index-body[
  #index-language(language: "English", level: "Native")
  #index-language(language: "Tamil", level: "Fluent")
  #index-language(language: "German", level: "Conversational")
  #index-language(language: "Hindi", level: "Basic")
]
