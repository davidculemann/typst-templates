
#let is-blank(v) = v == none or v == "" or v == []

#let minimal-cv(
  author: "",
  location: "",
  email: "",
  phone: "",
  social-links: (), // Array of (url, display-text) tuples
  accent-color: "#334155",
  font: "Inter",
  font-size: 10pt,
  paper: "a4",
  margin: 3cm,
  leading: 0.65em,
  lang: "en",
  body,
) = {
  // Handle both string and content for author (content is used for diff preview)
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(
    font: font,
    size: font-size,
    fill: rgb("#141414"),
    lang: lang,
    ligatures: false,
    hyphenate: false,
  )

  set page(
    margin: margin,
    paper: paper,
  )

  set par(justify: false, leading: leading)

  let muted = rgb("#5b5b5b")

  show link: set text(fill: muted)

  // Keep an entry header (the reading-order title/organisation/location/date
  // grid) glued to the bullets that follow it: a sticky block can never be the
  // last thing on a page, so it is carried to the next page WITH its first
  // bullet instead of being orphaned. Only the header sticks; the bullet list
  // stays breakable, so long entries still flow across pages normally. Entry
  // headers are the template's only grids (the name and contact lines are
  // plain blocks), so this targets exactly them.
  show grid: it => block(sticky: true, it)

  // Contact line: small, muted, directly beneath the name.
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
  // spacing so the only vertical gap is the explicit v() below (name -> contact
  // air). Default block flow collapsed the name/contact gap too tight; control
  // it here. When the name is blank the name line collapses and the header is
  // the lone contact line, no reserved slot.
  let contact-line = text(
    size: 8.5pt,
    fill: muted,
    tracking: 0.2pt,
    contact-items.filter(x => x != none).join("  ·  "),
  )
  if is-blank(author) {
    block(above: 0pt, below: 1.2em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt)
      contact-line
    })
  } else {
    block(above: 0pt, below: 1.2em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt)
      text(
        size: 23pt,
        weight: "semibold",
        tracking: 0.4pt,
        fill: rgb(accent-color),
        author,
      )
      v(0.6em)
      contact-line
    })
  }

  body
}

// Section header: small uppercase tracked label above a thin accent hairline.
// Neutralise ambient block/par spacing so the label -> hairline gap is exactly
// the tight v() below, not v() stacked on top of the default block spacing.
#let cv-section(title, accent-color: "#334155") = {
  block(above: 1.15em, below: 0.9em, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    text(
      size: 8.5pt,
      weight: "semibold",
      tracking: 1.8pt,
      fill: rgb("#141414"),
      upper(title),
    )
    v(0.28em)
    line(length: 100%, stroke: 0.5pt + rgb(accent-color))
  })
}
