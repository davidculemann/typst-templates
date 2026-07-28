// Public API for @preview/quietude-cv.
//
// The design itself lives in quietude.typ and is byte-identical to the source
// JobSprout renders in production. This file decides what is public: the show
// rule, exported as `resume` to match the convention the ecosystem already
// uses, plus the helpers a document needs. Everything else stays internal.
#import "quietude.typ": minimal-cv as resume, cv-section
