-- CareGrid initial relational schema.
-- Apply only to a new development Supabase project after review.
create extension if not exists pgcrypto;

create type public.user_role as enum ('administrator', 'don', 'adon', 'scheduler', 'employee');
create type public.employment_status as enum ('active', 'inactive', 'leave', 'terminated');
create type public.credential_type as enum ('RN', 'LPN', 'QMA', 'CNA');
create type public.shift_category as enum ('day', 'evening', 'night');
create type public.assignment_status as enum ('assigned', 'open', 'cancelled');
create type public.shift_request_status as enum ('pending', 'approved', 'declined', 'withdrawn');

create table public.facilities (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  timezone text not null default 'America/Indiana/Indianapolis',
  created_at timestamptz not null default now()
);

create table public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  facility_id uuid not null references public.facilities(id),
  role public.user_role not null default 'employee',
  employee_id uuid,
  display_name text not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.care_areas (
  id uuid primary key default gen_random_uuid(),
  facility_id uuid not null references public.facilities(id),
  name text not null,
  active boolean not null default true,
  unique (facility_id, name),
  unique (id, facility_id)
);

create table public.employees (
  id uuid primary key default gen_random_uuid(),
  facility_id uuid not null references public.facilities(id),
  employee_number text not null,
  first_name text not null,
  last_name text not null,
  phone text,
  email text,
  home_care_area_id uuid,
  status public.employment_status not null default 'active',
  hire_date date,
  rotation_template_id uuid,
  management_notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (facility_id, employee_number),
  unique (id, facility_id),
  foreign key (home_care_area_id, facility_id) references public.care_areas(id, facility_id)
);

alter table public.profiles
  add constraint profiles_employee_facility_fk
  foreign key (employee_id) references public.employees(id);

create table public.employee_credentials (
  employee_id uuid not null references public.employees(id) on delete cascade,
  credential public.credential_type not null,
  primary key (employee_id, credential)
);

create table public.shift_definitions (
  id uuid primary key default gen_random_uuid(),
  facility_id uuid not null references public.facilities(id),
  credential_group text not null check (credential_group in ('nurse_qma', 'cna')),
  category public.shift_category not null,
  start_time time not null,
  end_time time not null,
  duration_minutes integer not null check (duration_minutes > 0),
  label text not null,
  active boolean not null default true,
  unique (facility_id, label)
);

create table public.staffing_positions (
  id uuid primary key default gen_random_uuid(),
  facility_id uuid not null references public.facilities(id),
  label text not null,
  credential_group text not null check (credential_group in ('nurse_qma', 'cna', 'any')),
  sort_order integer not null default 0,
  active boolean not null default true,
  unique (facility_id, label)
);

create table public.rotation_templates (
  id uuid primary key default gen_random_uuid(),
  facility_id uuid not null references public.facilities(id),
  name text not null,
  cycle_days integer not null default 21 check (cycle_days = 21),
  effective_start_date date not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.employees
  add constraint employees_rotation_fk
  foreign key (rotation_template_id) references public.rotation_templates(id);

create table public.rotation_assignments (
  id uuid primary key default gen_random_uuid(),
  rotation_template_id uuid not null references public.rotation_templates(id) on delete cascade,
  employee_id uuid not null references public.employees(id) on delete cascade,
  day_index integer not null check (day_index between 1 and 21),
  care_area_id uuid references public.care_areas(id),
  shift_definition_id uuid references public.shift_definitions(id),
  staffing_position_id uuid references public.staffing_positions(id),
  is_work_day boolean not null default true,
  unique (rotation_template_id, employee_id, day_index)
);

create table public.daily_assignments (
  id uuid primary key default gen_random_uuid(),
  facility_id uuid not null references public.facilities(id),
  shift_date date not null,
  employee_id uuid references public.employees(id),
  care_area_id uuid not null references public.care_areas(id),
  shift_definition_id uuid not null references public.shift_definitions(id),
  staffing_position_id uuid references public.staffing_positions(id),
  position_label text not null,
  status public.assignment_status not null default 'assigned',
  is_override boolean not null default false,
  source_workbook_sheet text,
  source_cell text,
  source_text text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  foreign key (employee_id, facility_id) references public.employees(id, facility_id),
  foreign key (care_area_id, facility_id) references public.care_areas(id, facility_id),
  check ((status = 'open' and employee_id is null) or status <> 'open')
);

create table public.shift_requests (
  id uuid primary key default gen_random_uuid(),
  facility_id uuid not null references public.facilities(id),
  assignment_id uuid not null references public.daily_assignments(id) on delete cascade,
  employee_id uuid not null references public.employees(id),
  status public.shift_request_status not null default 'pending',
  requested_at timestamptz not null default now(),
  reviewed_by uuid references public.profiles(user_id),
  reviewed_at timestamptz
);

create table public.call_offs (
  id uuid primary key default gen_random_uuid(),
  facility_id uuid not null references public.facilities(id),
  employee_id uuid not null references public.employees(id),
  shift_date date not null,
  shift_definition_id uuid not null references public.shift_definitions(id),
  reason_category text,
  notes text,
  reported_at timestamptz not null default now(),
  recorded_by uuid references public.profiles(user_id)
);

create table public.actual_shifts (
  id uuid primary key default gen_random_uuid(),
  facility_id uuid not null references public.facilities(id),
  employee_id uuid not null references public.employees(id),
  assignment_id uuid references public.daily_assignments(id),
  actual_start timestamptz,
  actual_end timestamptz,
  attendance_status text not null default 'scheduled',
  notes text,
  created_at timestamptz not null default now()
);

create table public.audit_log (
  id bigint generated always as identity primary key,
  facility_id uuid not null references public.facilities(id),
  actor_user_id uuid references auth.users(id),
  action text not null,
  entity_type text not null,
  entity_id uuid,
  before_data jsonb,
  after_data jsonb,
  occurred_at timestamptz not null default now()
);

create index daily_assignments_facility_date_idx on public.daily_assignments(facility_id, shift_date);
create index daily_assignments_employee_date_idx on public.daily_assignments(employee_id, shift_date);
create index audit_log_facility_time_idx on public.audit_log(facility_id, occurred_at desc);
create index employees_facility_status_idx on public.employees(facility_id, status);

-- RLS is enabled immediately. Policies are intentionally not permissive yet.
-- Add role-aware policies before connecting real users or inserting live data.
alter table public.facilities enable row level security;
alter table public.profiles enable row level security;
alter table public.care_areas enable row level security;
alter table public.employees enable row level security;
alter table public.employee_credentials enable row level security;
alter table public.shift_definitions enable row level security;
alter table public.staffing_positions enable row level security;
alter table public.rotation_templates enable row level security;
alter table public.rotation_assignments enable row level security;
alter table public.daily_assignments enable row level security;
alter table public.shift_requests enable row level security;
alter table public.call_offs enable row level security;
alter table public.actual_shifts enable row level security;
alter table public.audit_log enable row level security;

-- Audit events should be append-only for application roles.
revoke update, delete on public.audit_log from anon, authenticated;
