# CareGrid architecture decisions

1. One shared platform supports employee mobile access and management web access.
2. First rollout is one facility; every operational record is facility-scoped to support future multi-facility growth.
3. Employee home unit is stored on the employee record; a daily assignment's care area is independent so temporary moves do not rewrite home unit.
4. A 21-day rotation template is separate from daily assignments. Daily overrides do not mutate the recurring pattern.
5. Open shifts are represented explicitly with `status = open` and no employee assigned. A pickup request does not fill the shift.
6. Imported workbook sheet, cell, and source text are retained on imported assignments for traceability.
7. The initial staffing product should not store resident-identifying or clinical information.
8. Audit history is designed as append-only. Production audit events should be written by trusted server-side functions, not accepted as arbitrary client edits.
9. Role-aware row-level security must be completed and tested before production data is entered.
