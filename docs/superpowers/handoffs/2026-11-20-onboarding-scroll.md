# Onboarding neighborhood scroll — 2026-11-20

## Result
User reported Chrome scroll working inside the neighborhood selector only over pointer-cursor labels. Reproduced against the complete Rails-rendered onboarding with its initialization JavaScript: wheel over a label moved list scrollTop by 120px; wheel over column gaps, row gaps or padding moved document scrollY by 120px and left list scrollTop at zero. A minimal standalone fixture did not reproduce it; full form/layout was necessary.

Moved `.onboarding-zones` from fieldset to an inner div. The fieldset keeps the accessible legend and has a spacing/min-width reset. The div is labelled by the legend and keyboard focusable; its focus ring uses the existing visual language. Scroll containment and responsive columns are preserved. No wheel-event interception or JavaScript changes.

## Validation
- Full Rails suite on original checkout: 327 tests, 2082 assertions. Revalidated after integration onto latest origin/main: 353 tests, 2256 assertions, zero failures/errors/skips.
- Expanded onboarding integration coverage for named focusable scroller containing zone labels; CSS mirror passes.
- Chrome and Firefox: wheel over labels, column/row gaps, padding => list 120px / document 0px after fix. Bottom boundary remains contained. Keyboard ArrowDown scrolls list, accent-insensitive `cordon` filtering and selection/summary work. 390px viewport has no horizontal overflow.
- Browser checks used real Rails-rendered test HTML with 41 temporary test zones, real CSS and onboarding.js, outside production. Navigation assets/scripts were not part of the standalone fixture.
- `impeccable detect` flagged three pre-existing unrelated CSS borders around lines 2462–2495; left untouched.
- QA harness and screenshots in `/private/tmp/onboarding-scroll-qa/` and `/private/tmp/onboarding-scroll-{desktop,mobile}.png` are temporary.

## Files / scope
`app/views/search_preferences/_onboarding.html.erb`, asset stylesheet and public mirror, onboarding integration test, spec/plan and STATUS.

Integrated in an isolated worktree onto updated origin/main for the user-requested commit and push. Not deployed. Existing unrelated working-tree changes (sound, deployment, README, prior STATUS entry and related untracked artifacts) were preserved. No scraping or notifications triggered.
