#import "is-blank.typ": *

// One accent + ink + one muted grey (cv-typography-standard rule 6). The accent is
// used as ONE tasteful block: a SOFT-TINT masthead panel (a lightened wash of the
// accent) holding the name in dark ink, plus the section label rules. Off the panel:
// ink on white. Default accent a muted sage.
#let ink = rgb("#1f2430")
#let muted = rgb("#6b7280")

// Fixed size scale from body B = 10.5pt (standard rule 2), defined ONCE.
#let display-size = 23pt // ~2.2 x B - the name (in the panel)
#let subhead-size = 12pt // ~1.14 x B - the profession line
#let body-size = 10.5pt // B
#let label-size = 9.5pt // ~0.9 x B - section labels (uppercase + tracked)
#let meta-size = 8.6pt // ~0.82 x B - dates, location, contact, level, fine print

// Document shell: set-rules + PDF metadata only. The masthead panel and sections are
// composed by wrapSections. Inter is the single family (standard rule 1).
#let letterhead-cv(
  author: "",
  font: "Inter",
  font-size: 10.5pt,
  paper: "a4",
  margin: 1.5cm,
  leading: 0.65em,
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

// Masthead (the tasteful block): a full-width panel filled with a very light wash of
// the accent, holding the name (bold ink), profession (accent, medium) and a quiet
// contact line, all in DARK text (legible on the light tint). Guarded so an empty CV
// shows no floating panel. Inset within the page margins so it never bleeds page 2.
// photo (VFS path string) sits at the panel's right edge, rounded; none
// renders the text stack alone, byte-identically.
#let masthead(author: "", profession: "", contact: "", accent-color: "#4a5d46", photo: none, photo-radius: 4pt, photo-size: 2.3cm) = {
  let has-name = not is-blank(author)
  let has-prof = not is-blank(profession)
  let has-contact = not is-blank(contact)
  if has-name or has-prof or has-contact {
    block(
      width: 100%,
      fill: rgb(accent-color).lighten(88%),
      inset: (x: 18pt, y: 16pt),
      radius: 3pt,
      below: 1.3em,
      breakable: false,
      {
        set block(spacing: 0pt)
        set par(spacing: 0pt, leading: 0.45em, justify: false)
        let text-stack = {
          if has-name { text(size: display-size, weight: "bold", fill: ink, author) }
          if has-prof {
            if has-name { v(4pt) }
            text(size: subhead-size, weight: "medium", tracking: 0.3pt, fill: rgb(accent-color).darken(12%), profession)
          }
          if has-contact {
            if has-name or has-prof { v(7pt) }
            text(size: meta-size, fill: muted, contact)
          }
        }
        if photo != none {
          grid(
            columns: (1fr, auto),
            column-gutter: 14pt,
            align: (left + horizon, right + horizon),
            text-stack,
            box(
              clip: true,
              radius: photo-radius,
              width: photo-size,
              height: photo-size,
              image(photo, width: photo-size, height: photo-size, fit: "cover"),
            ),
          )
        } else {
          text-stack
        }
      },
    )
  }
}

// Section label: accent UPPERCASE + tracking over a thin accent rule. Sticky so a
// label never orphans at a page bottom.
#let cv-section(title, accent-color: "#4a5d46") = {
  block(above: 1.25em, below: 0.9em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    text(size: label-size, weight: "semibold", tracking: 0.9pt, fill: rgb(accent-color), upper(title))
    v(3pt)
    line(length: 100%, stroke: 0.6pt + rgb(accent-color))
  })
}

// Entry: semibold-ink title leads with a muted subtitle, dates right; location and an
// optional URL meta line below; then the body. No mid-word hyphenation on the title.
#let letterhead-entry(title: "", subtitle: "", dates: "", location: "", meta: "", body) = {
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

// Language row: language left, level muted right.
#let letterhead-language(language: "", level: "") = {
  grid(
    columns: (1fr, auto),
    align: (left + horizon, right + horizon),
    column-gutter: 0.6em,
    language,
    if not is-blank(level) { text(size: meta-size, fill: muted, level) } else { [] },
  )
}
