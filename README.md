# Typst CV templates

The CV designs behind [JobSprout](https://www.jobsprout.ai), packaged for
[Typst Universe](https://typst.app/universe). Each one is the same source the
hosted builder renders, so a CV you start here and a CV you start there come out
of the same code.

Every package carries a sample document you are meant to edit, a README for that
design specifically, and no dependencies.

## Every design

All 42 designs, each a single self-contained `main.typ` that compiles on
Typst 0.12 or newer with nothing to install. Download one, or copy it into
[the Typst app](https://typst.app).

| Design | Slug | Licence |
|---|---|---|
| [Academic CV](templates/academic) | `academic` | see NOTICE |
| [Anchor CV](templates/anchor) | `anchor` | MIT-0 |
| [Atlas CV](templates/atlas) | `atlas` | MIT-0 |
| [Banner CV](templates/banner) | `banner` | MIT-0 |
| [Basic CV](templates/basic) | `basic` | see NOTICE |
| [Caption CV](templates/caption) | `caption` | MIT-0 |
| [Charter CV](templates/charter) | `charter` | MIT-0 |
| [Classic CV](templates/classic) | `classic` | see NOTICE |
| [Codex CV](templates/codex) | `codex` | MIT-0 |
| [Column CV](templates/column) | `column` | MIT-0 |
| [Compact CV](templates/compact) | `compact` | MIT-0 |
| [Creative CV](templates/creative) | `creative` | see NOTICE |
| [Crest CV](templates/crest) | `crest` | MIT-0 |
| [Emblem CV](templates/emblem) | `emblem` | MIT-0 |
| [Executive CV](templates/executive) | `executive` | see NOTICE |
| [Folio CV](templates/folio) | `folio` | MIT-0 |
| [Gazette CV](templates/gazette) | `gazette` | MIT-0 |
| [Grid CV](templates/grid) | `grid` | MIT-0 |
| [Harbor CV](templates/harbor) | `harbor` | MIT-0 |
| [Horizon CV](templates/horizon) | `horizon` | MIT-0 |
| [Index CV](templates/index) | `index` | MIT-0 |
| [Keyline CV](templates/keyline) | `keyline` | MIT-0 |
| [Ledger CV](templates/ledger) | `ledger` | see NOTICE |
| [Letterhead CV](templates/letterhead) | `letterhead` | MIT-0 |
| [Margin CV](templates/margin) | `margin` | MIT-0 |
| [Marker CV](templates/marker) | `marker` | MIT-0 |
| [Meridian CV](templates/meridian) | `meridian` | MIT-0 |
| [Minimal CV](templates/minimal) | `minimal` | MIT-0 |
| [Modern CV](templates/modern) | `modern` | see NOTICE |
| [Portrait CV](templates/portrait) | `portrait` | MIT-0 |
| [Preface CV](templates/preface) | `preface` | MIT-0 |
| [Print CV](templates/print) | `print` | see NOTICE |
| [Quartz CV](templates/quartz) | `quartz` | MIT-0 |
| [Refined CV](templates/refined) | `refined` | MIT-0 |
| [Slate CV](templates/slate) | `slate` | MIT-0 |
| [Spine CV](templates/spine) | `spine` | MIT-0 |
| [Strata CV](templates/strata) | `strata` | MIT-0 |
| [Terrace CV](templates/terrace) | `terrace` | MIT-0 |
| [Timeline CV](templates/timeline) | `timeline` | MIT-0 |
| [Typographic CV](templates/typographic) | `typographic` | see NOTICE |
| [Vellum CV](templates/vellum) | `vellum` | MIT-0 |
| [Vertex CV](templates/vertex) | `vertex` | MIT-0 |

Nine are ports of existing Universe packages and carry their upstream terms in a
`NOTICE`; the rest are MIT-0, so nothing has to travel with the CV you make.

## On Typst Universe

A subset is also published as installable packages, which adds a proper template
scaffold (`typst init`) on top of the same design.

| Package | Design | Hosted |
|---|---|---|
| [`grid-cv`](packages/grid-cv/0.1.0) | Plain single-column CV with a two-column skills grid. | [Try it](https://www.jobsprout.ai/resume-templates/grid) |
| [`meridian-cv`](packages/meridian-cv/0.1.0) | Serif CV with a flush-right masthead and mirrored axis. | [Try it](https://www.jobsprout.ai/resume-templates/meridian) |
| [`emblem-cv`](packages/emblem-cv/0.1.0) | Single-column CV anchored by a filled monogram. | [Try it](https://www.jobsprout.ai/resume-templates/emblem) |
| [`letterhead-cv`](packages/letterhead-cv/0.1.0) | Single-column CV under a tinted letterhead panel. | [Try it](https://www.jobsprout.ai/resume-templates/letterhead) |
| [`horizon-cv`](packages/horizon-cv/0.1.0) | Single-column CV under a full-bleed colour band. | [Try it](https://www.jobsprout.ai/resume-templates/horizon) |
| [`spine-cv`](packages/spine-cv/0.1.0) | Single-column CV with a full-height accent spine. | [Try it](https://www.jobsprout.ai/resume-templates/spine) |
| [`crest-cv`](packages/crest-cv/0.1.0) | Formal centred serif CV for senior appointments. | [Try it](https://www.jobsprout.ai/resume-templates/crest) |
| [`index-cv`](packages/index-cv/0.1.0) | Numbered-section CV in a Swiss editorial style. | [Try it](https://www.jobsprout.ai/resume-templates/index) |
| [`quietude-cv`](packages/quietude-cv/0.1.0) | Spacious editorial CV with hairline section rules. | [Try it](https://www.jobsprout.ai/resume-templates/minimal) |
| [`ridgeline-cv`](packages/ridgeline-cv/0.1.0) | Uncoloured two-column CV with a right-hand meta rail. | [Try it](https://www.jobsprout.ai/resume-templates/margin) |
| [`vertex-cv`](packages/vertex-cv/0.1.0) | Centred serif CV with short sections set two-up. | [Try it](https://www.jobsprout.ai/resume-templates/vertex) |

## Installing one

```sh
typst init @preview/spine-cv:0.1.0 my-cv
typst compile my-cv/main.typ
```

Or open the package on Universe and choose *Create project in app*.

## Licence

Package sources under `<name>/0.1.0/src/` are MIT. The sample documents
under `<name>/0.1.0/template/` are MIT-0, because that is the part you
edit and publish as your own CV, and no attribution should have to travel with
it.

## This repository is generated

The contents are assembled from JobSprout's template registry. Sending a patch
here would be overwritten on the next release, so please open an issue instead
and describe what is wrong with the design or the documentation; the fix belongs
upstream, and it will reach the hosted builder at the same time.
