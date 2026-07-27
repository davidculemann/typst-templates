// Vertex CV. Replace the details below with your own and delete what you do not
// need; every section here is optional. The accent colour is set once, on the
// line after this comment, and everything picks it up from there.

#import "@preview/vertex-cv:0.1.0": *

#let accent = "#5c3a5f"

#show: resume.with(
  author: "Adam Feldman",
  // EB Garamond ships with Typst, so this renders the same everywhere without
  // installing anything. Any family you have works too.
  font: "EB Garamond",
  font-size: 11pt,
  paper: "a4",
  margin: 1.5cm,
)

#masthead(
  author: "Adam Feldman",
  profession: "Solicitor, Commercial Litigation",
  accent-color: accent,
  contact: [
    adam.feldman\@example.com
    #h(0.6em) | #h(0.6em) +44 20 7946 0509
    #h(0.6em) | #h(0.6em) London, UK
    #h(0.6em) | #h(0.6em) #link("https://example.com/feldman")[example.com/feldman]
  ],
)

#cv-section("Profile", accent-color: accent)

Commercial litigator, eleven years qualified, mostly contract and shareholder
disputes in the mid market. Comfortable telling a client early that a claim is
not worth bringing, which is usually the most valuable advice in the file.

#cv-section("Experience", accent-color: accent)

#vertex-entry(
  title: "Senior Associate",
  subtitle: "Harrowgate Bell LLP",
  dates: "2019 - Present",
  location: "London, UK",
)[
  - Run a caseload of 20 to 25 commercial disputes, typically GBP 500k to GBP 8M
    in value, from letter before action through to trial or settlement.
  - Led the team on a four-week High Court trial concerning a failed earn-out,
    settling on the eve of judgment on terms above the client's target.
  - Supervise three associates and the firm's trainee litigation seat.
  - Act as the firm's relationship partner for two insurer panels, which between
    them account for roughly a fifth of the department's instructions.
]

#vertex-entry(
  title: "Associate",
  subtitle: "Marchpole and Grieve",
  dates: "2015 - 2019",
  location: "London, UK",
)[
  - Acted on shareholder and partnership disputes, including two unfair
    prejudice petitions taken to trial and one contested valuation appeal.
  - Built the firm's precedent bank for disclosure, still in use.
  - Ran the department's move to predictive coding on large disclosure
    exercises, cutting review costs on the two biggest files by about 40%.
]

#vertex-entry(
  title: "Trainee then Solicitor",
  subtitle: "Marchpole and Grieve",
  dates: "2012 - 2015",
  location: "London, UK",
)[
  - Seats in commercial litigation, corporate and employment; qualified into
    litigation in 2014 and stayed in the department since.
]

#cv-section("Education", accent-color: accent)

#vertex-entry(
  title: "Legal Practice Course, Distinction",
  subtitle: "BPP Law School",
  dates: "2011 - 2012",
  location: "London, UK",
)[]

#vertex-entry(
  title: "LLB Law, First Class",
  subtitle: "University of Nottingham",
  dates: "2008 - 2011",
  location: "Nottingham, UK",
)[]

// Short sections read badly stacked full width with three words on each line, so
// pair them up. `vertex-twoup` takes the two column bodies.
#vertex-twoup(
  [
    #cv-section("Admissions", accent-color: accent)

    #vertex-cred(
      name: "Solicitor of the Senior Courts",
      issuer: "England and Wales",
      date: "2014",
    )

    #vertex-cred(
      name: "Higher Rights of Audience, Civil",
      issuer: "SRA",
      date: "2018",
    )
  ],
  [
    #cv-section("Languages", accent-color: accent)

    #vertex-language(language: "English", level: "Native")
    #vertex-language(language: "Hebrew", level: "Fluent")
    #vertex-language(language: "French", level: "Conversational")
  ],
)

#cv-section("Reported Cases", accent-color: accent)

#vertex-entry(
  title: "Ashcombe Partners LLP v Nairn",
  subtitle: "Partnership dissolution; account of profits",
  dates: "2024",
  meta: "[2024] EWHC 733 (Ch)",
)[]

#vertex-entry(
  title: "Larkfield Holdings Ltd v Prendergast",
  subtitle: "Unfair prejudice; valuation of a minority holding",
  dates: "2022",
  meta: "[2022] EWHC 1184 (Ch)",
)[]

#vertex-entry(
  title: "Coalbrook Trading v Sennen Marine",
  subtitle: "Breach of warranty in a share purchase agreement",
  dates: "2019",
  meta: "[2019] EWHC 2907 (Comm)",
)[]

#cv-section("Also", accent-color: accent)

Trustee of a housing advice charity in Tower Hamlets, where I take a duty
session most months. Occasional contributor to the firm's disputes bulletin, and
a supervising solicitor on the university law clinic's contract advice rota.
