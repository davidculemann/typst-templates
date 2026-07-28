// Horizon CV. Replace the details below with your own and delete what you do
// not need; every section here is optional. The accent colour is set once, on
// the line after this comment, and everything picks it up from there.

#import "@preview/horizon-cv:0.1.0": *

#let accent = "#1f4a54"

// The header band bleeds past the page edges, so it has to know how wide the
// margin is. Keep these two in step: set the margin here and pass the same
// value to both `resume` and `horizon-header`.
#let page-margin = 1.5cm

#show: resume.with(
  author: "Samuel Okonkwo",
  font: "Roboto",
  font-size: 10.5pt,
  paper: "a4",
  margin: page-margin,
)

#horizon-header(
  author: "Samuel Okonkwo",
  profession: "Product Manager",
  margin: page-margin,
  accent-color: accent,
  contact: [
    samuel.okonkwo\@example.com
    #h(0.6em) | #h(0.6em) +44 161 496 0155
    #h(0.6em) | #h(0.6em) Manchester, UK
    #h(0.6em) | #h(0.6em) #link("https://example.com/samuel")[example.com/samuel]
  ],
)

#cv-section("Profile", accent-color: accent)

Product manager on B2B software, most recently on the unglamorous half of the
product where the customers are internal teams and the competition is a
spreadsheet somebody built in 2016. Comfortable saying no in writing, and
happier removing a feature than adding one.

#cv-section("Experience", accent-color: accent)

#horizon-entry(
  title: "Senior Product Manager",
  subtitle: "Kestrel Freight Software",
  dates: "2022 - Present",
  location: "Manchester, UK",
)[
  - Own the planning and dispatch area, used daily by 4,000 operators across 60
    customers, working with two engineering teams.
  - Shipped the rules engine that replaced per-customer configuration work,
    cutting onboarding from six weeks to nine days.
  - Cut support tickets on the scheduling screen by 44% after a discovery round
    that killed two features nobody was using.
]

#horizon-entry(
  title: "Product Manager",
  subtitle: "Brightmoor Analytics",
  dates: "2019 - 2022",
  location: "Leeds, UK",
)[
  - Took the reporting product from beta to 90 paying accounts in two years.
  - Ran the pricing change that lifted average contract value 22% with no
    measurable increase in churn.
  - Set up the weekly customer call rota that the whole product team now shares.
]

#horizon-entry(
  title: "Business Analyst",
  subtitle: "Brightmoor Analytics",
  dates: "2017 - 2019",
  location: "Leeds, UK",
)[]

#cv-section("Selected Work", accent-color: accent)

#horizon-entry(
  title: "Dispatch rules engine",
  subtitle: "Replaced bespoke per-customer configuration with a shared model",
  dates: "2024",
  meta: "Shipped to 60 customers over two quarters",
)[]

#cv-section("Education", accent-color: accent)

#horizon-entry(
  title: "University of Manchester",
  subtitle: "BSc Management and Information Systems",
  dates: "2014 - 2017",
  location: "Manchester, UK",
)[]

#cv-section("Certifications", accent-color: accent)

#horizon-entry(
  title: "Certified Scrum Product Owner",
  subtitle: "Scrum Alliance",
  dates: "2020",
)[]

#cv-section("Skills", accent-color: accent)

*Product* \
Discovery interviews, opportunity solution trees, roadmap and prioritisation,
pricing, experiment design, and writing the kind of spec an engineer reads once
and does not need to ask about.

*Tools* \
Jira, Linear, Amplitude, SQL, Figma, and enough dbt to pull my own numbers.

#cv-section("Languages", accent-color: accent)

#horizon-language(language: "English", level: "Native")
#horizon-language(language: "Igbo", level: "Fluent")
#horizon-language(language: "Spanish", level: "Conversational")
#horizon-language(language: "French", level: "Basic")
