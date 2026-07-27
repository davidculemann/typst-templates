// Ridgeline CV. Replace the details below with your own and delete what you do
// not need; every section here is optional. The accent colour is set once, on
// the line after this comment, and everything picks it up from there.

#import "@preview/ridgeline-cv:0.1.0": *

#let accent = "#2b4c7e"

#show: resume.with(
  author: "Aoife Byrne",
  font: "Raleway",
  font-size: 10pt,
  paper: "a4",
  margin: 1.4cm,
)

// The masthead spans the full width, above the two columns.
#masthead(
  author: "Aoife Byrne",
  profession: "Clinical Nurse Specialist, Respiratory",
  accent-color: accent,
)

// `cv-layout` is the design: a wide main column and a narrow meta rail, divided
// by a hairline that repaints on every page. Career goes in `main`; everything
// scannable goes in `rail`.
#cv-layout(
  accent-color: accent,
  main: [
    #cv-section("Profile", accent-color: accent)

    Respiratory nurse specialist running a nurse-led clinic for COPD and
    bronchiectasis. Most of the work is keeping people out of hospital, which is
    less about medicine than about whether someone can get to an appointment.

    #cv-section("Experience", accent-color: accent)

    #ridgeline-entry(
      title: "Clinical Nurse Specialist, Respiratory",
      subtitle: "St Brendan's NHS Foundation Trust",
      dates: "2020 - Present",
      location: "Dublin and Kildare",
    )[
      - Set up and now run a nurse-led COPD clinic seeing 40 patients a week,
        which cut related emergency admissions in the catchment by 18%.
      - Independent prescriber for the respiratory caseload, working to shared
        protocols agreed with the consultant team.
      - Lead the trust's pulmonary rehabilitation programme, including the move
        to a hybrid model that raised completion from 54% to 78%.
      - Redesigned the discharge bundle with the ward team, which took 30-day
        readmissions for COPD from 22% to 14% over eighteen months.
      - Sit on the regional respiratory network, representing nurse-led services.
    ]

    #ridgeline-entry(
      title: "Senior Staff Nurse, Respiratory Ward",
      subtitle: "St Brendan's NHS Foundation Trust",
      dates: "2016 - 2020",
      location: "Dublin",
    )[
      - Shift lead on a 28-bed respiratory ward, including through two winters
        of sustained escalation.
      - Practice educator for the ward, mentoring 20 student nurses.
      - Led the ward's transition to electronic observations, including the
        training and the first three months of floor support.
      - Ran the audit that established the ward's sepsis screening baseline.
    ]

    #ridgeline-entry(
      title: "Staff Nurse",
      subtitle: "Ardagh General Hospital",
      dates: "2013 - 2016",
      location: "Galway",
    )[
      - General medical, rotating through respiratory and care of the elderly,
        with a secondment to the acute assessment unit.
    ]

    #cv-section("Audit and Improvement", accent-color: accent)

    #ridgeline-entry(
      title: "COPD discharge bundle",
      subtitle: "Trust-wide quality improvement project",
      dates: "2023",
      meta: "Presented at the Irish Thoracic Society annual meeting",
    )[
      - Cut 30-day readmissions by 8 percentage points across two sites.
    ]

    #ridgeline-entry(
      title: "Spirometry quality audit",
      subtitle: "Primary care interface project",
      dates: "2021",
    )[
      - Found that a third of referrals carried unusable spirometry; the
        retraining that followed halved inappropriate referrals.
    ]

    #cv-section("Education", accent-color: accent)

    #ridgeline-entry(
      title: "MSc Advanced Nursing Practice",
      subtitle: "University College Dublin",
      dates: "2018 - 2020",
    )[]

    #ridgeline-entry(
      title: "BSc Nursing",
      subtitle: "University of Galway",
      dates: "2009 - 2013",
    )[]

    #cv-section("Teaching", accent-color: accent)

    #ridgeline-entry(
      title: "Module contributor, Respiratory Assessment",
      subtitle: "MSc Advanced Practice, University College Dublin",
      dates: "2022 - Present",
    )[
      - Teach the spirometry and NIV sessions, and supervise four dissertations
        a year on the respiratory pathway.
    ]
  ],
  rail: [
    #rail-contact(
      (
        [aoife.byrne\@example.com],
        [+353 1 496 0733],
        [Dublin, Ireland],
        [#link("https://example.com/aoife")[example.com/aoife]],
      ),
      accent-color: accent,
    )

    #cv-section("Registration", accent-color: accent)

    #ridgeline-cred(
      name: "Registered Nurse",
      issuer: "NMBI",
      date: "2013",
    )

    #ridgeline-cred(
      name: "Registered Nurse Prescriber",
      issuer: "NMBI",
      date: "2021",
    )

    #cv-section("Skills", accent-color: accent)

    Spirometry and interpretation \
    Non-invasive ventilation \
    Independent prescribing \
    Advanced life support \
    Pulmonary rehabilitation \
    Clinical audit \
    Student mentorship

    #cv-section("Development", accent-color: accent)

    #ridgeline-cred(
      name: "Advanced Life Support",
      issuer: "Resuscitation Council",
      date: "2024",
    )

    #ridgeline-cred(
      name: "Non-Medical Prescribing",
      issuer: "UCD",
      date: "2021",
    )

    #ridgeline-cred(
      name: "Spirometry Certificate",
      issuer: "ARTP",
      date: "2019",
    )

    #cv-section("Memberships", accent-color: accent)

    #ridgeline-cred(
      name: "Irish Thoracic Society",
      issuer: "Member",
      date: "2018",
    )

    #ridgeline-cred(
      name: "Irish Nurses Organisation",
      issuer: "Member",
      date: "2013",
    )

    #cv-section("Languages", accent-color: accent)

    #ridgeline-language(language: "English", level: "Native")
    #ridgeline-language(language: "Irish", level: "Fluent")
  ],
)
