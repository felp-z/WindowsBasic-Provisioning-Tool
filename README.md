# Windows Provisioning Tool (PowerShell Admin Toolkit)

This repository contains a PowerShell script designed to automate and standardize the initial configuration of Windows workstations. It is an interactive tool for system administrators and IT professionals.

## Functionality

The script presents a menu with the following options:

- **Application Installation:** Installs a base set of essential software using Winget.
- **Windows Updates:** Forces the search and installation of all pending updates.
- **Visual Optimization:** Adjusts the visual effects of Windows to balance performance and aesthetics.
- **Network Optimization:** Disables power management for network adapters.
- **Name and Domain:** Allows you to rename the computer and join it to an Active Directory domain.
- **Temporary Cleanup:** Removes unnecessary files from the system's temporary folders.

## How to Use

1. **Prerequisite: Execution Policy**
To run local scripts, the PowerShell execution policy needs to be set. Open PowerShell as **Administrator** and run the following command once:
```powershell
Set-ExecutionPolicy RemoteSigned
```

2. **Executing the Script**
Download the `Provision-Workstation.ps1` file. To run it, right-click on it and select "Run with PowerShell" or run it from a PowerShell terminal opened as **Administrator**:
```powershell
.\Provision-Workstation.ps1
```

## License

This project is under the MIT License. See the `LICENSE` file for more details.
