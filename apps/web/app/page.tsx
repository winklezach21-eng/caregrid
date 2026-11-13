const metrics = [
  ["Scheduled today", "—", "Connect your schedule to see staffing"],
  ["Open shifts", "—", "Vacancies will be listed here"],
  ["Call-offs", "—", "Today's reported call-offs"],
  ["Overtime watch", "—", "Hours and overtime indicators"],
];

export default function Home() {
  return (
    <main className="shell">
      <aside className="sidebar">
        <div className="brand">Care<span>Grid</span></div>
        <div className="navLabel">WORKSPACE</div>
        {["Dashboard", "Master Schedule", "Employee Directory", "Open Shifts", "Call-offs", "Attendance & Labor", "Audit History", "Settings"].map((item, i) =>
          <div className={`navItem ${i === 0 ? "active" : ""}`} key={item}>{item}</div>
        )}
        <div className="sidebarFoot">Single-facility preview</div>
      </aside>
      <section className="main">
        <header className="topbar"><div><div className="kicker">MANAGEMENT PORTAL</div><h1>Staffing dashboard</h1></div><div className="profile">Management preview</div></header>
        <div className="welcome"><div><div className="kicker light">CAREGRID</div><h2>Good day.</h2><p>Your facility staffing overview will live here.</p></div><div className="welcomeMark">CG</div></div>
        <div className="metrics">{metrics.map(([label, value, detail]) => <article className="metric" key={label}><div className="metricLabel">{label}</div><div className="metricValue">{value}</div><div className="metricDetail">{detail}</div></article>)}</div>
        <div className="lower">
          <article className="panel"><h3>Today's staffing</h3><p className="muted">Schedule data will appear after the facility schedule is imported.</p><div className="empty">No live schedule connected yet</div></article>
          <article className="panel"><h3>Quick actions</h3><div className="action">＋ <span>Add employee</span></div><div className="action">▦ <span>Open master schedule</span></div><div className="action">⇄ <span>Review coverage requests</span></div></article>
        </div>
        <footer>CareGrid · Development preview · Not connected to live staffing data</footer>
      </section>
    </main>
  );
}
