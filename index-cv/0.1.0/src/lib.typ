// Public API for @preview/index-cv.
//
// The design itself lives in index.typ and matches the source JobSprout
// renders in production, with the shared helpers it imports vendored alongside
// it and their import paths adjusted to suit. This file decides what is public: the show
// rule, exported as `resume` to match the convention the ecosystem already
// uses, plus the helpers a document needs. Everything else stays internal.
#import "index.typ": index-cv as resume, masthead, cv-section, index-body, index-entry, index-language
