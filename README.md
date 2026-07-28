# Typst CV templates

The CV designs behind [JobSprout](https://www.jobsprout.ai), packaged for
[Typst Universe](https://typst.app/universe). Each one is the same source the
hosted builder renders, so a CV you start here and a CV you start there come out
of the same code.

Every package carries a sample document you are meant to edit, a README for that
design specifically, and no dependencies.

| Package | Design | Hosted |
|---|---|---|
| [`lattice-cv`](lattice-cv/0.1.0) | Plain single-column CV with a two-column skills grid. | [Try it](https://www.jobsprout.ai/resume-templates/grid) |
| [`meridian-cv`](meridian-cv/0.1.0) | Serif CV with a flush-right masthead and mirrored axis. | [Try it](https://www.jobsprout.ai/resume-templates/meridian) |
| [`emblem-cv`](emblem-cv/0.1.0) | Single-column CV anchored by a filled monogram. | [Try it](https://www.jobsprout.ai/resume-templates/emblem) |
| [`letterhead-cv`](letterhead-cv/0.1.0) | Single-column CV under a tinted letterhead panel. | [Try it](https://www.jobsprout.ai/resume-templates/letterhead) |
| [`horizon-cv`](horizon-cv/0.1.0) | Single-column CV under a full-bleed colour band. | [Try it](https://www.jobsprout.ai/resume-templates/horizon) |
| [`spine-cv`](spine-cv/0.1.0) | Single-column CV with a full-height accent spine. | [Try it](https://www.jobsprout.ai/resume-templates/spine) |
| [`crest-cv`](crest-cv/0.1.0) | Formal centred serif CV for senior appointments. | [Try it](https://www.jobsprout.ai/resume-templates/crest) |
| [`index-cv`](index-cv/0.1.0) | Numbered-section CV in a Swiss editorial style. | [Try it](https://www.jobsprout.ai/resume-templates/index) |
| [`quietude-cv`](quietude-cv/0.1.0) | Spacious editorial CV with hairline section rules. | [Try it](https://www.jobsprout.ai/resume-templates/minimal) |
| [`ridgeline-cv`](ridgeline-cv/0.1.0) | Uncoloured two-column CV with a right-hand meta rail. | [Try it](https://www.jobsprout.ai/resume-templates/margin) |
| [`vertex-cv`](vertex-cv/0.1.0) | Centred serif CV with short sections set two-up. | [Try it](https://www.jobsprout.ai/resume-templates/vertex) |

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
