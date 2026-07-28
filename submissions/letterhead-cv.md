I am submitting
- [x] a new package
- [ ] an update for a package

Description: A single-column CV that opens with a tinted panel behind the name, the way company stationery does. It gives the first screen some weight without spending a strong colour to get there, and because the panel belongs to the header rather than the page, it appears once and page two starts clean. Suits anyone who wants a designed-looking header while keeping the body of the CV conventional.

I have read and followed the submission guidelines and, in particular, I
- [x] selected [a name](https://github.com/typst/packages/blob/main/docs/manifest.md#naming-rules) that isn't the most obvious or canonical name for what the package does
  - Explanation:
    A letterhead is the printed heading on company stationery, which the tinted panel behind the name imitates. It names the borrowed convention, not the document type.

    Following the guidance for template packages, the name is a unique, non-descriptive part (`letterhead`) followed by a descriptive part (`cv`). It is not affiliated with any organisation, so no entity abbreviation applies.
- [x] added a [`typst.toml`](https://github.com/typst/packages/blob/main/docs/manifest.md#package-metadata) file with all required keys
- [x] added a [`README.md`](https://github.com/typst/packages/blob/main/docs/documentation.md) with documentation for my package
- [x] have chosen [a license](https://github.com/typst/packages/blob/main/docs/licensing.md) and added a `LICENSE` file or linked one in my `README.md`
- [x] tested my package locally on my system and it worked
- [x] [`exclude`d](https://github.com/typst/packages/blob/main/docs/tips.md#what-to-commit-what-to-exclude) PDFs or README images, if any, but not the LICENSE
- [x] ensured that my package is licensed such that users can use and distribute the contents of its template directory without restriction, after modifying them through normal use.

Some notes on testing, in case they are useful:

- `typst init @preview/letterhead-cv:0.1.0` into an empty directory, then `typst compile`, gives no diagnostics.
- `typst-package-check 0.6.0 check` reports no errors and no warnings, with network lints enabled.
- `compiler` was established by compiling against real 0.11, 0.12, 0.13 and 0.14 binaries rather than guessed.
- The thumbnail is page one as initialized, recompressed from Typst's own output.
- `src/` is MIT and `template/` is MIT-0, so nothing has to travel with somebody's finished CV. The split is stated in both the LICENSE and the README.
- The design is the same source that renders on the hosted builder linked from `homepage`, so the two cannot drift.

Sample content is entirely fictional.
