// Europass CV. Replace the details below with your own and delete what you do
// not need; every section is optional. The layout, colours and proportions
// follow the CV the official europa.eu Europass editor generates.

#import "@preview/europass-cv:0.1.0": *

#show: resume.with(
  author: "Johann Müller",
  // The official Europass PDF is set in Open Sans; Lato (available on the web
  // app) is the fallback when Open Sans is not installed.
  font: ("Open Sans", "Lato"),
  font-size: 10pt,
  paper: "a4",
  margin: 1.2cm,
  lang: "en",
)

// The shaded header band: logo lockup, name, and the bold-labelled personal
// facts. Pass `show-logo: false` to drop the flag-and-wordmark lockup (the
// official editor offers the same choice), and `margin:` must match the page
// margin above so the band bleeds to the paper edges.
#masthead(
  author: "Johann Müller",
  date-of-birth: [04/10/1996],
  phone: [(+49) 123456789],
  email: link("mailto:j.muller@example.com")[j.muller\@example.com],
  address: [123 Hauptstraße, Berlin, Germany],
  margin: 1.2cm,
)

#ep-section("About me")
Detail-oriented accountant with four years across banking and industry,
comfortable owning month-end close, reconciliations and audit preparation.
Looking to grow into a senior reporting role in an international team.

#ep-section("Work experience")
#ep-entry(
  title: "Junior Accountant",
  subtitle: "BNP Paribas",
  dates: "10/2018 - Current",
  location: "Paris, France",
)[
  - Assisting in the preparation of monthly financial statements and reports for three business units.
  - Managing daily transactions and updating the general ledger across two entities.
  - Performing account reconciliations and ensuring accuracy in financial records.
  - Supporting the senior accountant in budgeting and forecasting activities.
  - Assisting with year-end audits and liaising with external auditors.
  - Handling accounts payable and receivable processes, improving efficiency by 10%.
]
#ep-entry(
  title: "Accounting Intern",
  subtitle: "Siemens AG",
  dates: "06/2018 - 09/2018",
  location: "Berlin, Germany",
)[
  - Assisted in preparing financial reports and reconciliations for the controlling team.
  - Supported the accounting team in maintaining accurate financial records.
  - Conducted data entry and helped in the analysis of budget variances.
  - Gained exposure to month-end closing procedures and financial audits.
]

#ep-section("Education and training")
#ep-entry(
  title: "Bachelor of Science in Accounting",
  subtitle: "University of Munich",
  dates: "10/2015 - 06/2018",
  location: "Munich, Germany",
)[
  - Graduated with distinction; thesis on IFRS 16 lease accounting in mid-cap industrials.
]

#ep-section("Digital skills")
#ep-skills((
  [Microsoft Office (Word, Excel, PowerPoint)], [SAP Accounting], [Google Suite],
  [QuickBooks], [SQL], [Power BI], [DATEV],
))

// Languages render as the official CEFR self-assessment grid. A plain level
// ("B2", "Fluent", "Native") fills the whole row; per-skill levels win when
// given. Mother tongues sit on their own line above the table.
#ep-section("Language skills")
#ep-languages((
  (language: [German], level: "Native"),
  (language: [English], level: "C1"),
  (language: [French], level: "C2", interaction: "C1"),
  (language: [Spanish], level: "B1", writing: "A2"),
  (language: [Dutch], level: "A2"),
))

#ep-section("Honours and awards")
#ep-entry(
  title: "Young Finance Talent Award",
  subtitle: "Bundesverband der Bilanzbuchhalter",
  dates: "11/2023",
)[]
