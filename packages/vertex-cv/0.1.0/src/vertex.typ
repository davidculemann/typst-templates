#import "is-blank.typ": *

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is the
// section rules and the masthead rule; body ink, meta muted. A classical centered serif
// masthead over full-width history, with the short sections set two-up. Default accent a
// muted plum.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale from body B = 11pt (standard rule 2; EB Garamond runs small), ONCE.
#let display-size = 25pt // ~2.3 x B - the name (masthead)
#let subhead-size = 13pt // ~1.18 x B - the profession line
#let body-size = 11pt // B
#let label-size = 10.5pt // ~0.95 x B - section labels (uppercase + tracked)
#let meta-size = 9pt // ~0.82 x B - dates, location, contact, level, fine print

// Document shell: set-rules + PDF metadata only. Masthead and sections are composed by
// wrapSections. EB Garamond is the single family (standard rule 1).
#let vertex-cv(
  author: "",
  font: "EB Garamond",
  font-size: 11pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.62em,
  lang: "en",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(font: font, size: font-size, fill: ink, lang: lang, ligatures: false, hyphenate: false)
  set page(margin: margin, paper: paper)
  set par(justify: false, leading: leading)

  show link: set text(fill: muted)

  body
}

// Masthead (CENTERED): name (bold) over the profession (accent) and a quiet contact
// line, closed by a thin accent rule. Guarded.
#let masthead(author: "", profession: "", contact: "", accent-color: "#5c3a5f") = {
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof or has-contact {
    block(above: 0pt, below: 1.3em, breakable: false, {
      set block(spacing: 0pt)
      set par(spacing: 0pt, leading: 0.4em, justify: false)
      set align(center)
      if has-name { block(spacing: 0pt, text(size: display-size, weight: "bold", fill: ink, author)) }
      if has-prof {
        v(6pt)
        block(spacing: 0pt, text(size: subhead-size, weight: "regular", fill: rgb(accent-color), profession))
      }
      if has-contact {
        v(7pt)
        block(spacing: 0pt, text(size: meta-size, fill: muted, contact))
      }
      if has-name or has-prof or has-contact { v(9pt); line(length: 100%, stroke: 0.6pt + rgb(accent-color)) }
    })
  }
}

// Section label: accent UPPERCASE + tracking over a thin accent rule. Sticky. Used for
// full-width sections and (at half width) inside the two-up band.
#let cv-section(title, accent-color: "#5c3a5f") = {
  block(above: 1.2em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.8pt, fill: rgb(accent-color), upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.6pt + rgb(accent-color))
  })
}

// Two-up band: the short sections (skills, languages, certifications, awards) set in two
// balanced columns. Each half receives a set of whole sections (split in TypeScript), so
// no section is ever cut across the divide. A guaranteed top gap keeps it clear of the
// preceding experience; breakable:false moves the whole band to the next page rather than
// splitting it into headerless fragments across a page break.
// Breakable on purpose: `breakable: false` cannot be honoured once the two-up band
// is taller than a page, and Typst then overflows it past the bottom margin rather
// than splitting it. The inner grid breaks column-wise, so a tall band continues on
// the next page with both lanes intact.
#let vertex-twoup(left, right) = {
  block(above: 1.4em, below: 0pt, grid(columns: (1fr, 1fr), column-gutter: 24pt, left, right))
}

// Entry: semibold-ink title leads with a muted subtitle, dates right; location and an
// optional URL meta line below; then the body. No mid-word hyphenation on the title.
#let vertex-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt)
    block(sticky: true, breakable: false, {
      set par(justify: false)
      set text(hyphenate: false)
      grid(
        columns: (1fr, auto),
        align: (left + top, right + top),
        column-gutter: 0.75em,
        {
          if not is-blank(title) { text(weight: "semibold", fill: ink, title) }
          if not is-blank(title) and not is-blank(subtitle) { text(fill: muted)[ #sym.dash.en ] }
          if not is-blank(subtitle) { text(fill: muted, subtitle) }
        },
        if not is-blank(dates) { text(size: meta-size, fill: muted, dates) } else { [] },
      )
      if not is-blank(location) {
        v(3pt)
        text(size: meta-size, fill: muted, location)
      }
      if not is-blank(meta) {
        v(3pt)
        text(size: meta-size, fill: muted, meta)
      }
    })
    if not is-blank(body) {
      v(3.5pt)
      block(spacing: 0pt, { set text(fill: ink); body })
    }
  })
}

// Credential (certifications / awards, set two-up): compact stacked - name (semibold),
// then issuer + date muted beneath, dot-separated. Fills a half column without cramping.
#let vertex-cred(name: "", issuer: "", date: "") = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    set text(hyphenate: false)
    if not is-blank(name) { text(weight: "semibold", fill: ink, name) }
    let meta = (issuer, date).filter(v => not is-blank(v)).join(text(fill: muted)[ #sym.dot.c ])
    if not is-blank(meta) { v(2pt); text(size: meta-size, fill: muted, meta) }
  })
}

// Language row: language left, level muted right.
#let vertex-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}
