// Letterhead CV. Replace the details below with your own and delete what you do
// not need; every section here is optional. The accent colour is set once, on
// the line after this comment, and everything picks it up from there.

#import "@preview/letterhead-cv:0.1.0": *

#let accent = "#4a5d46"

#show: resume.with(
  author: "Claire Bonnet",
  // Letterhead is set in Inter. The Typst web app has it; locally you will want
  // it installed or the text falls back to whatever comes next.
  font: "Inter",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
)

// The tinted panel behind the header is the design. It is drawn by `masthead`,
// so it sits on page one only and does not repeat.
#masthead(
  author: "Claire Bonnet",
  profession: "Operations Manager",
  accent-color: accent,
  contact: [
    claire.bonnet\@example.com
    #h(0.6em) | #h(0.6em) +44 121 496 0288
    #h(0.6em) | #h(0.6em) Birmingham, UK
    #h(0.6em) | #h(0.6em) #link("https://example.com/claire")[example.com/claire]
  ],
)

#cv-section("Profile", accent-color: accent)

Operations manager in light manufacturing, mostly on sites where the process was
designed for half the current volume. Usually brought in when the numbers are
fine on paper and wrong on the floor. The fix is usually a conversation with
the people running the machines rather than a new system.

#cv-section("Experience", accent-color: accent)

#letterhead-entry(
  title: "Operations Manager",
  subtitle: "Verrier Components",
  dates: "2021 - Present",
  location: "Birmingham, UK",
)[
  - Took on-time delivery from 82% to 96% across two lines in eleven months,
    without adding headcount.
  - Redesigned the changeover procedure on the press shop, cutting average
    changeover from 95 minutes to 34.
  - Introduced a daily production review that surfaced a recurring supplier
    defect costing roughly GBP 90k a year.
  - Manage 48 staff across three shifts, plus the maintenance team.
]

#letterhead-entry(
  title: "Production Supervisor",
  subtitle: "Ashgrove Plastics",
  dates: "2017 - 2021",
  location: "Coventry, UK",
)[
  - Ran a 22-person shift through a doubling of output following a new contract.
  - Led the site's move to a planned maintenance schedule, halving unplanned
    downtime in the first year.
  - Trained and signed off 14 operators on the new extrusion line.
]

#letterhead-entry(
  title: "Team Leader",
  subtitle: "Ashgrove Plastics",
  dates: "2015 - 2017",
  location: "Coventry, UK",
)[]

#cv-section("Education", accent-color: accent)

#letterhead-entry(
  title: "Aston University",
  subtitle: "BEng Manufacturing Engineering",
  dates: "2011 - 2015",
  location: "Birmingham, UK",
)[]

#cv-section("Certifications", accent-color: accent)

#letterhead-entry(
  title: "Lean Six Sigma Black Belt",
  subtitle: "British Quality Foundation",
  dates: "2022",
)[]

#letterhead-entry(
  title: "IOSH Managing Safely",
  subtitle: "Institution of Occupational Safety and Health",
  dates: "2019",
)[]

#letterhead-entry(
  title: "ILM Level 5 Leadership and Management",
  subtitle: "Institute of Leadership and Management",
  dates: "2018",
)[]

#cv-section("Skills", accent-color: accent)

*Operations* \
Lean and continuous improvement, capacity planning, SMED, planned maintenance,
supplier quality, shift scheduling.

*Systems* \
SAP, MRP, Power BI, and the spreadsheet the site actually runs on.

#cv-section("Languages", accent-color: accent)

#letterhead-language(language: "English", level: "Native")
#letterhead-language(language: "French", level: "Fluent")
#letterhead-language(language: "Polish", level: "Conversational")
