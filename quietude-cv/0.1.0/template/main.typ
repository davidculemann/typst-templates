// Quietude CV. Replace the details below with your own and delete what you do
// not need; every section here is optional. The accent colour is set once, on
// the line after this comment, and everything picks it up from there.

#import "@preview/quietude-cv:0.1.0": *

#let accent = "#334155"

// Quietude is deliberately spare: it gives you the document shell and the
// section rule, and leaves the entries to ordinary Typst. This little helper is
// all an entry needs, and it lives here rather than in the package so you can
// change its shape without fighting anything. Edit it or delete it.
#let muted = rgb("#5b5b5b")
#let entry(role: "", org: "", location: "", dates: "") = grid(
  columns: (1fr, auto),
  align: (left + top, right + top),
  column-gutter: 1em,
  [#strong[#role] #linebreak() #text(fill: muted)[#org]],
  [#text(fill: muted)[#dates] #linebreak() #text(fill: muted)[#location]],
)

#show: resume.with(
  author: "Ruth Ellison",
  location: "Edinburgh, UK",
  email: "ruth.ellison@example.com",
  phone: "+44 131 496 0620",
  social-links: (("example.com/ellison", "example.com/ellison"),),
  accent-color: accent,
  // Quietude is set in Inter. The Typst web app has it; locally you will want
  // it installed or the text falls back to whatever comes next.
  font: "Inter",
  font-size: 10pt,
  paper: "a4",
  // The wide margin is the design. Narrowing it undoes most of the effect.
  margin: 3cm,
)

#cv-section("Profile", accent-color: accent)

Commissioning editor in narrative non-fiction, twelve years across two houses.
I acquire perhaps eight books a year and would rather publish six well. The
part of the job I am best at is the long conversation before a proposal exists,
where a writer works out what the book is actually about.

#cv-section("Experience", accent-color: accent)

#entry(
  role: "Senior Commissioning Editor",
  org: "Thistlewood Press",
  location: "Edinburgh, UK",
  dates: "2020 - Present",
)
- Acquire and edit narrative non-fiction across history, science and memoir,
  running a list of around 30 active titles.
- Signed four Sunday Times bestsellers, including one first-time author whose
  proposal had been turned down elsewhere.
- Chair the acquisitions meeting and mentor two assistant editors.
- Rebuilt the way the house handles unagented submissions, which now accounts
  for roughly a quarter of what the list acquires.

#entry(
  role: "Commissioning Editor",
  org: "Thistlewood Press",
  location: "Edinburgh, UK",
  dates: "2016 - 2020",
)
- Built the popular science list from four titles a year to eleven.
- Ran the house's first author-development programme with two literary agencies.
- Took the science list's average first print run from 4,000 to 9,000 without
  raising the advance the house was willing to pay.

#entry(
  role: "Assistant Editor",
  org: "Harkaway and Bell",
  location: "London, UK",
  dates: "2013 - 2016",
)
- Structural and line editing across the general non-fiction list, working
  most closely with first-time authors through second and third drafts.

#cv-section("Education", accent-color: accent)

#entry(
  role: "MA English Literature",
  org: "University of Edinburgh",
  location: "Edinburgh, UK",
  dates: "2009 - 2013",
)

#cv-section("Selected Titles", accent-color: accent)

#entry(
  role: "The Cold Coast",
  org: "Acquired 2022, shortlisted for the Baillie Gifford Prize",
  dates: "2024",
)

#entry(
  role: "Everything Louder",
  org: "Acquired 2020, 90,000 copies to date",
  dates: "2022",
)

#entry(
  role: "A Perfectly Ordinary Winter",
  org: "Acquired 2018, translated into nine languages",
  dates: "2020",
)

#cv-section("Also", accent-color: accent)

Trustee of the Scottish Book Trust, and an occasional judge for the Saltire
Society first book award. I speak at Edinburgh most years, usually on the
unglamorous mechanics of acquisition, and I read submissions on the train,
which is where a surprising number of the good ones have turned up.
