// Public API for @preview/ridgeline-cv.
//
// The design itself lives in ridgeline.typ and is byte-identical to the source
// JobSprout renders in production. This file decides what is public: the show
// rule, exported as `resume` to match the convention the ecosystem already
// uses, plus the helpers a document needs. Everything else stays internal.
#import "ridgeline.typ": margin-cv as resume, masthead, cv-section, cv-layout, rail-contact, margin-entry as ridgeline-entry, margin-rail-cred as ridgeline-cred, margin-language as ridgeline-language
