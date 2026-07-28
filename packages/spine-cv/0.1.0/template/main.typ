// Spine CV. Replace the details below with your own and delete what you do not
// need; every section here is optional. The accent colour is set once, on the
// line after this comment, and everything picks it up from there.

#import "@preview/spine-cv:0.1.0": *

#let accent = "#2f3e5c"

#show: resume.with(
  author: "Rosa Iqbal",
  accent-color: accent,
  // Spine is set in Inter. Any installed family works; the Typst web app has
  // Inter, and locally you will want it installed or the text falls back.
  font: "Inter",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
)

#masthead(
  author: "Rosa Iqbal",
  profession: "Infrastructure Engineer",
  accent-color: accent,
  contact: [
    rosa.iqbal\@example.com
    #h(0.6em) | #h(0.6em) +44 20 7946 0958
    #h(0.6em) | #h(0.6em) Manchester, UK
    #h(0.6em) | #h(0.6em) #link("https://example.com/rosa")[example.com/rosa]
  ],
)

#cv-section("Profile", accent-color: accent)

Infrastructure engineer with eight years on platform and reliability work,
mostly in regulated environments where the deployment story has to be as
defensible as the code. Happiest reducing what a team has to remember.

#cv-section("Experience", accent-color: accent)

#spine-entry(
  title: "Infrastructure Engineer",
  subtitle: "Halden Systems",
  dates: "2022 - Present",
  location: "Manchester, UK",
)[
  - Moved 40 services onto a shared deployment pipeline, taking a release from
    two hours of manual steps to nine minutes end to end.
  - Cut cloud spend 31% by right-sizing instances and adding autoscaling across
    three regions, with no change to the error budget.
  - Rebuilt alerting around symptoms, taking out-of-hours pages from 30 to 4.
  - Wrote the on-call handbook the team still uses, and ran the rotation.
]

#spine-entry(
  title: "Platform Engineer",
  subtitle: "Aldergate Digital",
  dates: "2019 - 2022",
  location: "Leeds, UK",
)[
  - Built the internal metrics service that four product teams now depend on,
    handling roughly 2M events a day.
  - Introduced infrastructure-as-code across a mixed estate and retired the last
    hand-configured server in eight months.
  - Ran the migration off a single-region database with 20 minutes of planned
    downtime and no data loss.
]

#spine-entry(
  title: "Junior Developer",
  subtitle: "Cobden Software",
  dates: "2017 - 2019",
  location: "Leeds, UK",
)[
  - Maintained a payments integration used by 300 merchants, and added the
    regression suite that caught the settlement bug before release.
]

#cv-section("Projects", accent-color: accent)

#spine-entry(
  title: "drift",
  subtitle: "Open-source Terraform state diffing",
  dates: "2023",
  meta: "Go, 900+ stars",
)[
  - Diffs two plan runs into review-friendly output rather than raw JSON.
]

#cv-section("Education", accent-color: accent)

#spine-entry(
  title: "University of Manchester",
  subtitle: "BSc Computer Science",
  dates: "2014 - 2017",
  location: "Manchester, UK",
)[]

#cv-section("Certifications", accent-color: accent)

#spine-entry(
  title: "Certified Kubernetes Administrator",
  subtitle: "Cloud Native Computing Foundation",
  dates: "2021",
)[]

#spine-entry(
  title: "AWS Solutions Architect, Associate",
  subtitle: "Amazon Web Services",
  dates: "2020",
)[]

#cv-section("Skills", accent-color: accent)

*Infrastructure* \
Kubernetes, Terraform, AWS, Linux, Postgres

*Languages and tooling* \
Go, Python, Bash, Prometheus, Grafana, GitHub Actions

#cv-section("Languages", accent-color: accent)

#spine-language(language: "English", level: "Native")
#spine-language(language: "Urdu", level: "Fluent")
#spine-language(language: "German", level: "Conversational")
