# Safe Shutdown Manager 🛡️

![Platform](https://img.shields.io/badge/platform-Windows-0078D6)
![Language](https://img.shields.io/badge/language-Batch_%7C_PowerShell-5391FE)

A lightweight, hybrid CLI tool for scheduling Windows shutdowns. Designed with **System Integrity** and **Graceful Shutdown** protocols in mind.

## 💡 Why this tool?
Standard Windows commands (like `shutdown -s -t 3600`) offer no visual feedback and can be hard to manage. Third-party tools are often bloated.
This script provides a **real-time visual timer** in the console, ensures a **safe shutdown process** that prioritizes data safety, and handles user interruptions gracefully.

## ✨ Key Features

### 1. Two Operation Modes
* **Countdown Mode:** "Shut down in 45 minutes."
* **Target Time Mode:** "Shut down at 23:30."
    * *Smart Scheduling:* Automatically detects if the target time is tomorrow (e.g., setting 08:00 AM while it's 10:00 PM schedules for the next day).

### 2. Safety First Architecture (No Force Kill)
This tool uses a **"Graceful Shutdown"** approach (no `/f` flag):
* **Data Integrity:** It sends a polite termination signal. Applications are asked to close, allowing them to save state.
* **Update Safety:** It will NOT corrupt Windows Updates if they are running in the background.
* **Safe Exit:** Uses `[Console]::TreatControlCAsInput` for instant, silent script termination via `Ctrl+C` without system prompts.

### 3. Hybrid Technology
* **Batch:** Handles environment setup, menu navigation, and regex input validation.
* **PowerShell:** Executes inside the Batch wrapper to handle complex `[DateTime]` math, UI rendering, and signal interception.

## 🚀 How to Use

1. Download `shutdown_manager.bat`.
2. Double-click to run.
3. Choose your mode:
    * `[1]` for Countdown.
    * `[2]` for Specific Time.
4. **To Cancel:** Press `Ctrl + C` at any time to instantly kill the timer.

## ⚠️ Important: "Safe Mode" Behavior

Because this tool prioritizes the safety of your OS and files, **it will not force-kill the system**. The shutdown process may be blocked by Windows if:

1.  **Unsaved Work:** You have open documents (Word, Excel, Notepad) with unsaved changes. Windows will pause and ask you to save them.
2.  **Windows Updates:** Critical system updates are being installed.

**Recommendation:** Always save your work and close heavy applications before the timer ends.

---
*Created for the open-source community.*
