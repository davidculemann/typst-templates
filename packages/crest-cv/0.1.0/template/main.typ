// Crest CV. Replace the details below with your own and delete what you do not
// need; every section here is optional. The accent colour is set once, on the
// line after this comment, and everything picks it up from there.

#import "@preview/crest-cv:0.1.0": *

#let accent = "#3a5a63"

// Crest is deliberately spare: it gives you the document shell and the section
// divider, and leaves the entries to ordinary Typst. This little helper is all
// an entry needs, and it lives here rather than in the package so you can
// change its shape without fighting anything. Edit it or delete it.
#let muted = rgb("#5a5a55")
#let entry(role: "", org: "", location: "", dates: "") = grid(
  columns: (1fr, auto),
  align: (left + top, right + top),
  column-gutter: 1em,
  [#strong[#role] #linebreak() #text(fill: muted)[#org]],
  [#text(fill: muted)[#dates] #linebreak() #text(fill: muted)[#location]],
)

#show: resume.with(
  author: "Eleanor Prideaux",
  location: "Bath, UK",
  email: "eleanor.prideaux@example.com",
  phone: "+44 1225 496 077",
  social-links: (("example.com/prideaux", "example.com/prideaux"),),
  accent-color: accent,
  // EB Garamond ships with Typst, so this renders the same everywhere without
  // installing anything. Any family you have works too.
  font: "EB Garamond",
  font-size: 10pt,
  paper: "a4",
  margin: 2cm,
)

#cv-section("Profile", accent-color: accent)

Chartered architect with nineteen years in conservation and adaptive reuse,
principally listed buildings in the south west. Most of the work is the argument
before the drawing: what a building can reasonably become, and what it should be
left alone to keep being.

#cv-section("Practice", accent-color: accent)

#entry(
  role: "Director",
  org: "Prideaux and Hale Architects",
  location: "Bath, UK",
  dates: "2016 - Present",
)
- Founded the practice; now eleven staff, with roughly 70% of work on Grade II
  and Grade II\* buildings.
- Led the conversion of a redundant Victorian pumping station into 24 homes,
  taking the scheme through two rounds of listed building consent.
- Appointed conservation architect to a cathedral chapter, covering a
  fifteen-year fabric programme.
- Act as expert witness at planning inquiry, most recently on a contested
  demolition in a conservation area.

#entry(
  role: "Associate",
  org: "Marchmont Reed",
  location: "Bristol, UK",
  dates: "2009 - 2016",
)
- Ran the conservation team on projects including a National Trust visitor
  building and the repair of an eighteenth-century assembly room.
- Wrote the practice's approach to fabric recording, still in use.
- Supervised four architects through Part 3 and the conservation accreditation.

#entry(
  role: "Architect",
  org: "Calder and Wren",
  location: "London, UK",
  dates: "2005 - 2009",
)
- Worked across housing and education, qualifying in 2007.

#cv-section("Education", accent-color: accent)

#entry(
  role: "Diploma in Architecture (RIBA Part 2)",
  org: "University of Bath",
  location: "Bath, UK",
  dates: "2002 - 2005",
)

#entry(
  role: "BSc Architectural Studies",
  org: "University of Bath",
  location: "Bath, UK",
  dates: "1999 - 2002",
)

#cv-section("Professional Standing", accent-color: accent)

#entry(
  role: "Conservation Accredited Architect (SCA)",
  org: "Royal Institute of British Architects",
  dates: "2013",
)

#entry(
  role: "Chartered Member",
  org: "Royal Institute of British Architects",
  dates: "2007",
)

#cv-section("Selected Awards", accent-color: accent)

#entry(
  role: "Conservation Award",
  org: "RIBA South West",
  dates: "2023",
)

#entry(
  role: "Building of the Year, Reuse",
  org: "Bath Preservation Trust",
  dates: "2019",
)

#cv-section("Teaching and Writing", accent-color: accent)

#entry(
  role: "Visiting Critic",
  org: "University of Bath, Department of Architecture",
  dates: "2014 - Present",
)

#entry(
  role: "Repair and the Ordinary Building",
  org: "Context, journal of the IHBC",
  dates: "2021",
)

#cv-section("Interests", accent-color: accent)

Vernacular building in the Mendips, lime mortars, and a long and unfinished
survey of the region's surviving tithe barns.
