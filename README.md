# CareGrid — development starter

CareGrid is a single-facility staffing platform designed to support multiple facilities later.

## Architecture
- `apps/mobile`: Expo + React Native + TypeScript (employee app for iOS/Android)
- `apps/web`: Next.js + TypeScript (management dashboard)
- `packages/shared`: shared domain types
- `supabase/migrations`: PostgreSQL schema and initial access-control policies

## Important status
This is a development scaffold, not a deployed or production-ready application. It does not yet connect to a live Supabase project, send notifications, or publish to either app store.

## Prerequisites
- Node.js 20+
- npm 10+
- Expo Go for early device previews
- A Supabase project
- Git

## Getting started
1. Install dependencies from the repository root:
   ```bash
   npm install
   ```
2. Copy `.env.example` to `.env` and add your Supabase project URL and anon key.
3. Apply the SQL migration in `supabase/migrations/0001_initial_schema.sql` to a new Supabase project.
4. Start the mobile app:
   ```bash
   npm run mobile
   ```
5. Start the management dashboard:
   ```bash
   npm run web
   ```

## Next implementation milestones
1. Connect Supabase authentication and role-based access.
2. Build the management employee directory CRUD screens.
3. Import and validate the 21-sheet Daily Master workbook.
4. Implement the 21-day rotation engine and per-day overrides.
5. Implement open-shift requests, manager assignment, and audit events.
6. Add push notifications and attendance features.
7. Complete security review, testing, backups, and app-store preparation.

## Data and privacy
Do not load resident names, diagnoses, medical records, or other resident-identifying information into this initial staffing MVP. Use test employee records until access controls and privacy safeguards have been reviewed. Before production use, configure Supabase row-level security, MFA for privileged users, backups, logging, retention policies, and a documented incident-response process.
