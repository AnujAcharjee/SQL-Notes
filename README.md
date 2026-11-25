# SQL Learning & Interview Prep

A structured collection of SQL notes, topic-wise practice queries, and common interview scenarios.

---

## Daily Practice Workflow

### 1. Start the MySQL Server *(if not already running)*
*(Run terminal **as Administrator**)*
```bash
net start MySQL80
```

### 2. Run `.sql` Files & Practice Queries
**In Git Bash:**
```bash
# Run any .sql file and print formatted tables
mysql --login-path=local -t < 05_Interview_Scenarios/01_joins_and_missing_data.sql

# Run a quick one-line query
mysql --login-path=local -t -e "USE sql_interview_practice; SELECT * FROM employees;"

# Open interactive mysql> shell (use winpty in Git Bash)
winpty mysql --login-path=local
```

**In PowerShell:**
```powershell


