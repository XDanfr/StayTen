# StayTen

Never be bothered by Windows 11 upgrade pop‑ups on Windows 10 again!

---

## 🚨 False‑Positive Warning

Some antivirus products, including Defender, may flag `StayTen.exe` as suspicious. This is a **false positive** caused by script‑to‑EXE packaging.  

Either:
- Disable your antivirus temporarily to let the files download **and run**
- Use the PS1 file
- [Submit a false‑positive report to Microsoft](https://www.microsoft.com/wdsi/filesubmission).  
- Or build the EXE yourself using the instructions below.

---

## 🚀 Features

- 🛑 **Block upgrade prompts**  
  Locks Windows Update to your chosen Windows 10 release (default: 21H2).
- 🔄 **Undo changes**  
  Switch to Windows 11 (default: 24H2) when you’re ready.
- 🖱️ **GUI‑based**  
  Simple two‑button interface — no scary terminal.
- 🔒 **Safe**  
  Self‑elevates via UAC and only writes registry keys under  
  `HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate`.

---

## 📝 How It Works

StayTen writes three registry values:

```reg
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate]
"TargetReleaseVersion"=dword:00000001
"ProductVersion"="Windows 10"
"TargetReleaseVersionInfo"="21H2"
```

- **TargetReleaseVersion** = `1` (enable version targeting)  
- **ProductVersion** = `"Windows 10"`  
- **TargetReleaseVersionInfo** = `"21H2"`  

To undo, it sets:
- **ProductVersion** = `"Windows 11"`  
- **TargetReleaseVersionInfo** = `"24H2"`  

---

## ⚙️ Ok cool, how do I use it?

1. **Download** the latest `StayTen.exe` from the Releases page.  
2. **Double‑click** `StayTen.exe`.  
3. Approve the **UAC prompt**.  
4. Click one of the two buttons:
   - **Lock to Win10 21H2**  
   - **Undo Changes**

---

## 🔧 Build from Source

> **Requires:** PowerShell 5.1+ and PS2EXE module

1. Clone the repo:
   ```powershell
   git clone https://github.com/YourUser/StayTen.git
   cd StayTen
   ```
2. Install PS2EXE (if needed):
   ```powershell
   Install-Module -Name PS2EXE -Scope CurrentUser -Force
   ```
3. Compile the script:
   ```powershell
   Invoke-PS2EXE -InputFile StayTen.ps1 -OutputFile StayTen.exe -requireAdmin
   ```

---

## ❤️ Credits

Created by **XDan**  
Contributions and feedback are welcome!
