# SWATtunR: old and updated versions

These version tags expose the source before the SWAT+ 62 update and the tested updated source in this same repository. They do not replace or rewrite the original Git history.

| Snapshot | Package version | Git tag |
| --- | --- | --- |
| Old source baseline | 0.3.13 | [before-swat62-update](https://github.com/MR-Eini/SWATtunR-swat62/tree/before-swat62-update) |
| Updated development version | 0.3.15 | [swat62-v0.3.15](https://github.com/MR-Eini/SWATtunR-swat62/tree/swat62-v0.3.15) |

The old tag points to commit [`a5542265eba539fdc4177466f582dd00091d6018`](https://github.com/MR-Eini/SWATtunR-swat62/commit/a5542265eba539fdc4177466f582dd00091d6018), the exact upstream source commit used before these edits. It is a source baseline for this update, not a claim that every bundled package dates from three years ago.

## Review the differences on GitHub

1. Open the [old-to-updated comparison](https://github.com/MR-Eini/SWATtunR-swat62/compare/before-swat62-update...swat62-v0.3.15?w=1).
2. Scroll to the changed files. GitHub marks removed lines red and added lines green.
3. Open individual files or commits to inspect each change. Where available, select the split view to see old and new code side by side.

The comparison above hides whitespace-only changes, which is especially useful for files with different Windows line endings. The [complete comparison](https://github.com/MR-Eini/SWATtunR-swat62/compare/before-swat62-update...swat62-v0.3.15) includes every change. The [commit history](https://github.com/MR-Eini/SWATtunR-swat62/commits/main) shows the incremental updates.

Both tags are fixed snapshots. Future versions should receive new version tags; `main` remains the current working branch. These are maintained development versions, not releases issued by the original authors.

## Main changes

- Match observed and simulated records by date when calculating goodness of fit.
- Correct period handling, validation run identities and statistic selection, and calibration export for plant-only parameter sets.
- Preserve numeric precision in exported calibration values.
- Warn about crops without simulated harvest records and align PHU, yield and biomass panels.

## Tested scope

The updated packages ran the supplied migrated reference model with the Windows Intel SWAT+ revision 62 executable. The supplied verification, discharge calibration/validation, sensitivity, crop and water-yield workflows produced outputs. Sixteen regression cases / 64 expectations pass across the four packages. These results do not establish compatibility for every model, executable or optional process; scientific calibration acceptance has not been achieved.

See [COMPATIBILITY.md](COMPATIBILITY.md) and [the workflow results](compatibility/workflow-summary.json) for the tests and limitations. Model input migration and updating the old project-generation layer are separate from these package source comparisons.
