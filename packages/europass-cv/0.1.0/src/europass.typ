#import "is-blank.typ": *

// Official Europass CV tokens, colour-picked from the live europa.eu editor
// preview and a real generated PDF (2026-07-31): black uppercase section labels
// over a thin grey rule with a grey dot hanging in the margin, grey display
// name, a full-bleed #f5f5f5 header band, EC-blue links, and the EU-flag +
// purple "europass" wordmark lockup.
#let ep-rule = rgb("#979797")
#let ep-name-rule = rgb("#b7b7b7")
#let ep-panel = rgb("#f5f5f5")
#let ep-link = rgb("#004494")
#let ep-flag = rgb("#164194")
#let ep-gold = rgb("#ffcc00")
#let ep-purple = rgb("#6c3088")
#let ep-meta-grey(secondary) = rgb(secondary).lighten(28%)

// Size scale relative to the bound body size B (cv-typography-standard rule 2),
// so the hierarchy survives the font-size knob: labels stay above entry heads.
#let name-size = 1.55em // the display name
#let label-size = 1.05em // section labels (uppercase)
#let meta-size = 0.9em // dates, locations, panel, fine print
#let note-size = 0.75em // CEFR table headers + footnote

#let ep-l10n = (
  "en": (
    email: "Email address:",
    phone: "Phone number:",
    address: "Address:",
    website: "Website:",
    dob: "Date of birth:",
    mother: "Mother tongue(s):",
    other: "Other language(s):",
    understanding: "UNDERSTANDING",
    speaking: "SPEAKING",
    writing: "WRITING",
    listening: "Listening",
    reading: "Reading",
    production: "Spoken production",
    interaction: "Spoken interaction",
    note: "Levels: A1 and A2: Basic user; B1 and B2: Independent user; C1 and C2: Proficient user",
  ),
  "es": (
    email: "Correo electrónico:",
    phone: "Teléfono:",
    address: "Dirección:",
    website: "Sitio web:",
    dob: "Fecha de nacimiento:",
    mother: "Lengua(s) materna(s):",
    other: "Otros idiomas:",
    understanding: "COMPRENSIÓN",
    speaking: "EXPRESIÓN ORAL",
    writing: "EXPRESIÓN ESCRITA",
    listening: "Comprensión auditiva",
    reading: "Comprensión lectora",
    production: "Producción oral",
    interaction: "Interacción oral",
    note: "Niveles: A1 y A2: usuario básico; B1 y B2: usuario independiente; C1 y C2: usuario competente",
  ),
)
#let ep-t(lang, key) = ep-l10n.at(lang, default: ep-l10n.at("en")).at(key)

// Document shell. Open Sans is the face the official PDF embeds.
#let europass-cv(
  author: "",
  font: "Open Sans",
  font-size: 10pt,
  paper: "a4",
  margin: 1.2cm,
  leading: 0.62em,
  lang: "en",
  text-color: "#000000",
  secondary-color: "#565656",
  body,
) = {
  let author-str = if type(author) == str { author } else { "CV" }
  set document(author: author-str, title: author-str + " - CV")

  set text(font: font, size: font-size, fill: rgb(text-color), lang: lang, ligatures: false, hyphenate: false)
  set page(margin: margin, paper: paper)
  set par(justify: false, leading: leading, spacing: 1.1em)
  // Outer rhythm between entries and above section labels. The assembler's
  // sectionSpacing knob overrides these with scaled set-rules, so entry and
  // section gaps respond to it; intra-entry spacing stays explicit.
  set block(spacing: 1.1em)
  set list(marker: [•], indent: 0.45em, body-indent: 0.45em)

  show link: set text(fill: ep-link)

  body
}

// The EU flag block: official 2:3 emblem geometry (star circle r = h/3, star
// outer r = h/9), 12 five-pointed stars, one point up.
#let eu-star(cx, cy, r, fill) = {
  let pts = ()
  for k in range(10) {
    let ang = -90deg + k * 36deg
    let rr = if calc.even(k) { r } else { r * 0.382 }
    pts.push((cx + rr * calc.cos(ang), cy + rr * calc.sin(ang)))
  }
  place(top + left, polygon(fill: fill, ..pts))
}

#let europass-logo() = {
  let flag-h = 19pt
  let flag-w = flag-h * 1.5
  box(baseline: 30%, {
    box(width: flag-w, height: flag-h, fill: ep-flag, {
      let cx = flag-w / 2
      let cy = flag-h / 2
      let ring = flag-h / 3
      for k in range(12) {
        let ang = k * 30deg
        eu-star(cx + ring * calc.sin(ang), cy - ring * calc.cos(ang), flag-h / 9, ep-gold)
      }
    })
    h(0.55em)
    text(size: 16.5pt, weight: "bold", fill: ep-purple, tracking: -0.2pt, "europass")
  })
}

// Masthead: ONE full-bleed #f5f5f5 band (fill outset past the page margins to
// the paper's top/left/right edges, exactly like the official PDF) holding the
// logo lockup, the name with an optional round photo, the light rule under it,
// and the bold-labelled contact facts. `margin` is the resolved page margin,
// passed by wrapSections so the bleed tracks the pageMargins knob.
#let masthead(
  author: "",
  email: none,
  phone: none,
  address: none,
  date-of-birth: none,
  links: (),
  photo: none,
  photo-size: 64pt,
  show-logo: true,
  margin: 1.2cm,
  secondary-color: "#565656",
) = {
  let has-name = not is-blank(author)
  let has-contact = not (
    is-blank(email) and is-blank(phone) and is-blank(address) and is-blank(date-of-birth) and links.len() == 0
  )
  if has-name or has-contact or show-logo {
    block(
      above: 0pt,
      below: 1.4em,
      breakable: false,
      width: 100%,
      fill: ep-panel,
      inset: (bottom: 13pt, top: 2pt),
      outset: (x: margin, top: margin),
      {
        set block(spacing: 0pt)
        set par(spacing: 0pt, leading: 0.5em, justify: false)
        if show-logo {
          align(right, europass-logo())
          v(12pt)
        }
        if photo != none {
          grid(
            columns: (auto, 1fr),
            align: (left + horizon, left + horizon),
            column-gutter: 12pt,
            box(
              clip: true,
              radius: 50%,
              width: photo-size,
              height: photo-size,
              image(photo, width: photo-size, height: photo-size, fit: "cover"),
            ),
            if has-name { text(size: name-size, weight: "bold", fill: rgb(secondary-color), author) },
          )
        } else if has-name {
          text(size: name-size, weight: "bold", fill: rgb(secondary-color), author)
        }
        if (has-name or photo != none) and has-contact {
          v(9pt)
          line(length: 100%, stroke: 0.7pt + ep-name-rule)
          v(10pt)
        }
        if has-contact {
          context {
            let lg = str(text.lang)
            set par(leading: 0.85em)
            set text(size: meta-size)
            // The no-break spaces glue each bold label to its value's first word
            // and each pipe to the preceding fact, so a wrap never strands a
            // label at a line end or opens a line with a bare separator.
            let fact(label, value) = text(weight: "bold", label) + sym.space.nobreak + value
            let items = ()
            if not is-blank(date-of-birth) { items.push(fact(ep-t(lg, "dob"), date-of-birth)) }
            if not is-blank(phone) { items.push(fact(ep-t(lg, "phone"), phone)) }
            if not is-blank(email) { items.push(fact(ep-t(lg, "email"), email)) }
            if not is-blank(address) { items.push(fact(ep-t(lg, "address"), address)) }
            for l in links { items.push(fact(ep-t(lg, "website"), l)) }
            items.join(text(fill: ep-rule)[#sym.space.nobreak#sym.space.nobreak#sym.bar.v#h(0.45em)])
          }
        }
      },
    )
  }
}

// Section label: uppercase over a thin grey rule, with the signature grey dot
// hanging in the left margin. Accent colours the label text (official default
// is black; the editor's swatches tint it). `above` is deliberately unset: the
// gap over a label follows the document block spacing so the sectionSpacing
// knob scales it. `below` is the fixed label-to-first-entry gap.
#let ep-section(title, accent-color: "#000000") = {
  block(below: 1em, sticky: true, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    place(dx: -13pt, dy: 3.2pt, circle(radius: 2.1pt, fill: ep-rule))
    text(size: label-size, weight: "bold", fill: rgb(accent-color), upper(title))
    v(3.5pt)
    line(length: 100%, stroke: 0.7pt + ep-rule)
  })
}

// The single official entry shape (work, education, credentials alike): a
// plain grey "dates  location" line, then the bold caps title with the
// regular-weight organisation beside it, a full-width light rule under the
// head row, then the grey body content.
#let ep-entry(
  title: "",
  subtitle: "",
  dates: "",
  location: "",
  meta: "",
  secondary-color: "#565656",
  body,
) = {
  block(breakable: false, {
    set block(spacing: 0pt)
    set par(spacing: 0pt, justify: false)
    let gap = h(0.6em)
    block(sticky: true, breakable: false, {
      let top = ()
      if not is-blank(dates) { top.push(dates) }
      if not is-blank(location) { top.push(location) }
      if top.len() > 0 {
        text(size: meta-size, fill: ep-meta-grey(secondary-color), top.join(gap))
        v(4.5pt)
      }
      let head = ()
      if not is-blank(title) { head.push(text(weight: "bold", fill: rgb(secondary-color), upper(title))) }
      if not is-blank(subtitle) { head.push(text(fill: rgb(secondary-color), subtitle)) }
      if head.len() > 0 {
        head.join(gap)
        v(5.5pt)
        line(length: 100%, stroke: 0.5pt + ep-name-rule)
      }
      if not is-blank(meta) {
        v(4.5pt)
        text(size: meta-size, fill: ep-meta-grey(secondary-color), meta)
      }
    })
    if not is-blank(body) {
      v(7pt)
      block(spacing: 0pt, text(fill: rgb(secondary-color), body))
    }
  })
}

// Language rows -> the official layout: mother tongue(s) on one line, ungraded
// languages listed on the "Other language(s)" line, and CEFR-graded languages
// in the self-assessment table (horizontal rules only, shaded rows). A row's
// per-skill values (listening/reading/production/interaction/writing) win over
// the single mapped level when present.
#let ep-cefr(level) = {
  if type(level) != str { return none }
  let l = lower(level)
  if l.contains("native") or l.contains("mother") { return "native" }
  for code in ("c2", "c1", "b2", "b1", "a2", "a1") {
    if l.contains(code) { return upper(code) }
  }
  if l.contains("fluent") or l.contains("bilingual") { return "C2" }
  if l.contains("advanced") or l.contains("proficien") or l.contains("professional") { return "C1" }
  if l.contains("upper") { return "B2" }
  if l.contains("intermediate") or l.contains("conversation") { return "B1" }
  if l.contains("basic") or l.contains("beginner") or l.contains("elementary") or l.contains("limited") { return "A2" }
  none
}

// Click-to-source anchor for array-layout entries. Label must match ANCHOR_LABEL.
#let ep-anchor-mark(entry) = {
  if "anchor" in entry and entry.anchor != none {
    context [#metadata((id: entry.anchor, p: here().position())) <cv-anchor>]
  }
}

#let ep-skill-of(row, key, fallback) = {
  let v = row.at(key, default: none)
  if is-blank(v) { fallback } else { ep-cefr(v) }
}

#let ep-languages(secondary-color: "#565656", rows) = context {
  let lang = str(text.lang)
  let tagged = rows.map(r => {
    let base = ep-cefr(r.at("level", default: ""))
    let skills = (
      ep-skill-of(r, "listening", base),
      ep-skill-of(r, "reading", base),
      ep-skill-of(r, "production", base),
      ep-skill-of(r, "interaction", base),
      ep-skill-of(r, "writing", base),
    )
    let graded = base != "native" and skills.all(s => s != none and s != "native")
    r + (cefr: base, skills: skills, graded: graded)
  })
  let mother = tagged.filter(r => r.cefr == "native")
  let graded = tagged.filter(r => r.graded)
  let ungraded = tagged.filter(r => r.cefr != "native" and not r.graded)
  set par(justify: false)
  let lang-name(r) = {
    ep-anchor-mark(r)
    text(weight: "bold", fill: rgb(secondary-color), upper(r.language))
  }
  if mother.len() > 0 {
    block(above: 0.2em, below: 0.7em, sticky: true, {
      text(size: meta-size, ep-t(lang, "mother") + " ")
      mother.map(lang-name).join(", ")
    })
  }
  if ungraded.len() > 0 or graded.len() > 0 {
    block(above: 0.2em, below: 0.7em, sticky: true, {
      text(size: meta-size, ep-t(lang, "other") + " ")
      if ungraded.len() > 0 { ungraded.map(lang-name).join(", ") }
    })
  }
  if graded.len() > 0 {
    let head(t) = align(center + horizon, text(size: meta-size, weight: "bold", upper(t)))
    let sub(t) = align(center + horizon, text(size: meta-size, t))
    let cell(t) = align(center + horizon, text(size: meta-size, t))
    block(below: 0.6em, table(
      columns: (1.4fr, 1fr, 1fr, 1.15fr, 1.15fr, 1fr),
      stroke: none,
      inset: (x: 4pt, y: 7pt),
      // zebra: language rows only (header rows are y = 0 and 1)
      fill: (_, y) => if y >= 2 and calc.even(y) { ep-panel } else { none },
      table.header(
        [],
        table.cell(colspan: 2, head(ep-t(lang, "understanding"))),
        table.cell(colspan: 2, head(ep-t(lang, "speaking"))),
        head(ep-t(lang, "writing")),
        table.hline(stroke: 0.5pt + ep-name-rule),
        [],
        sub(ep-t(lang, "listening")),
        sub(ep-t(lang, "reading")),
        sub(ep-t(lang, "production")),
        sub(ep-t(lang, "interaction")),
        [],
      ),
      ..graded
        .map(r => (
          {
            ep-anchor-mark(r)
            align(left + horizon, text(size: meta-size, weight: "bold", fill: rgb(secondary-color), upper(r.language)))
          },
          ..r.skills.map(cell),
        ))
        .flatten(),
    ))
    block(above: 0pt, text(size: note-size, fill: ep-rule.darken(20%), emph(ep-t(lang, "note"))))
  }
}

// Flat pipe-separated skills line (the official rendering: no groups), grey.
// The pipe glues to the preceding skill so a wrap never opens with a bare
// separator.
#let ep-skills(secondary-color: "#565656", items) = {
  set par(justify: false, leading: 0.75em)
  text(
    fill: rgb(secondary-color),
    items.join(text(fill: ep-rule)[#sym.space.nobreak#sym.space.nobreak#sym.bar.v#h(0.45em)]),
  )
}
