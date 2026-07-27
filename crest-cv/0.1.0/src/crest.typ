
#let is-blank(v) = v == none or v == "" or v == []

#let crest-cv(
  author: "",
  location: "",
  email: "",
  phone: "",
  social-links: (), // Array of (url, display-text) tuples
  accent-color: "#3a5a63",
  font: "EB Garamond",
  font-size: 10pt,
  paper: "a4",
  margin: 2cm,
  leading: 0.62em,
  lang: "en",
  body,
) = {
  // Handle both string and content for author (content is used for diff preview)
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(
    font: font,
    size: font-size,
    fill: rgb("#1a1a1a"),
    lang: lang,
    ligatures: false,
    hyphenate: false,
  )

  set page(
    margin: margin,
    paper: paper,
  )

  set par(justify: false, leading: leading)

  let muted = rgb("#5a5a55")
  let c = rgb(accent-color)

  show link: set text(fill: muted)

  // Glue every entry header (the reading-order title/organisation/date grid) to
  // the bullets that follow it: a sticky block can never be the last thing on a
  // page, so a header at a page bottom is carried to the next page WITH its
  // first following line instead of being orphaned. The bullet lists stay
  // breakable, so long entries still flow across pages. Entry headers are the
  // template's only grids (name, contact, masthead rule and section labels are
  // plain blocks), so this targets exactly them.
  show grid: it => block(sticky: true, it)

  // Masthead: name in a confident serif, muted contact line, and a single thin
  // accent rule that divides the head from the body - the editorial signature.
  let contact-items = ()
  if phone != "" and phone != none { contact-items.push(phone) }
  if location != "" and location != none { contact-items.push(location) }
  if email != "" and email != none {
    if type(email) == str {
      contact-items.push(link("mailto:" + email)[#email])
    } else {
      contact-items.push(email)
    }
  }
  for social-link in social-links {
    let (url, display-text) = social-link
    if url != "" and url != none {
      let full-url = if url.starts-with("http") { url } else { "https://" + url }
      contact-items.push(link(full-url)[#display-text])
    }
  }

  // Masthead built as one spacing-controlled block: neutralise ambient block/par
  // spacing inside it so the only vertical gaps are the explicit v() below.
  // Relying on default block flow stacked 1.2em onto these gaps (name/contact
  // too tight, rule detached), so control it here. When the name is blank the
  // name line AND its dividing rule collapse, so an email-only header sits at
  // the top with no reserved slot and no rule floating over a lone contact line.
  let contact-line = text(size: 8.5pt, fill: muted, tracking: 0.2pt, contact-items.filter(x => x != none).join("  ·  "))
  if is-blank(author) {
    block(above: 0pt, below: 1em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.5em)
      contact-line
    })
  } else {
    // Formal CENTERED masthead: the name centred over a centred contact line, then a
    // DOUBLE RULE (a thicker rule above a thin one) - the letterpress-crest signature.
    block(above: 0pt, below: 1.1em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.5em)
      set align(center)
      text(size: 26pt, weight: "medium", tracking: 0.5pt, fill: rgb("#1a1a1a"), author)
      v(0.55em)
      contact-line
      v(0.7em)
      line(length: 100%, stroke: 1.4pt + c)
      v(2.2pt)
      line(length: 100%, stroke: 0.5pt + c)
    })
  }

  body
}

// Section header (the crest signature): a CENTRED serif small-caps accent label
// flanked by two accent rules ("---- EXPERIENCE ----"), the formal centred divider.
// Sticky so a label is never left orphaned at a page bottom - it travels to the next
// page with the entry that follows it.
#let cv-section(title, accent-color: "#3a5a63") = {
  block(above: 1.3em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    grid(
      columns: (1fr, auto, 1fr),
      column-gutter: 0.9em,
      align: (horizon, horizon, horizon),
      line(length: 100%, stroke: 0.5pt + rgb(accent-color)),
      text(size: 11pt, weight: "semibold", tracking: 1.4pt, fill: rgb(accent-color), smallcaps(title)),
      line(length: 100%, stroke: 0.5pt + rgb(accent-color)),
    )
  })
}
