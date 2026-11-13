export type Credential = "RN" | "LPN" | "QMA" | "CNA";
export type EmploymentStatus = "active" | "inactive" | "leave" | "terminated";
export type ShiftCategory = "day" | "evening" | "night";
export type UserRole = "administrator" | "don" | "adon" | "scheduler" | "employee";

export interface Facility {
  id: string;
  name: string;
  timezone: string;
}

export interface CareArea {
  id: string;
  facilityId: string;
  name: string;
}

export interface Employee {
  id: string;
  employeeNumber: string;
  firstName: string;
  lastName: string;
  credentials: Credential[];
  homeCareAreaId: string | null;
  status: EmploymentStatus;
  rotationTemplateId: string | null;
}

export interface ShiftDefinition {
  id: string;
  credentialGroup: "nurse_qma" | "cna";
  category: ShiftCategory;
  startTime: string;
  endTime: string;
  durationMinutes: number;
}

export interface DailyAssignment {
  id: string;
  employeeId: string | null;
  careAreaId: string;
  shiftDefinitionId: string;
  shiftDate: string;
  positionLabel: string;
  status: "assigned" | "open" | "cancelled";
  isOverride: boolean;
}
