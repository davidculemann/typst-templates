// Public API for @preview/spine-cv.
//
// The design itself lives in spine.typ and is byte-identical to the source
// JobSprout renders in production. This file decides what is public: the show
// rule, exported as `resume` to match the convention the ecosystem already
// uses, plus the helpers a document needs. Everything else stays internal.
#import "spine.typ": spine-cv as resume, masthead, cv-section, spine-entry, spine-language
