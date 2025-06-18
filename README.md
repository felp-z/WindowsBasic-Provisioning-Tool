# Windows Basic Provisioning Tool

A menu-driven PowerShell provisioning tool to automate and standardize the configuration of Windows workstations after a clean install. Built to be decisive, efficient, and customizable.

## Philosophy

This project views post-installation setup not as a repetitive chore, but as the foundation of a stable, high-performance system. The goal is to transform a manual process into a relentless, automated action. Configure once, execute flawlessly every time.

## Features

-   **Application Installation:** Installs packages via `winget` and local installers (`.exe`/`.msi`).
-   **Bloatware Removal:** Cleans the system of unwanted pre-installed applications.
-   **System Optimization:** Applies performance tweaks, such as the high-performance power plan and disabling background apps.
-   **Graphics Tweaks:** Configures Windows visual effects for maximum responsiveness.
-   **Control Interface:** A simple, direct menu for selective task execution.
-   **Centralized Configuration:** All customization is done via `.json` files, keeping the script logic untouched.

## Directory Structure

For correct execution, the files must follow this structure. Logic scripts are placed in the `scripts` folder, and configurations in the `config` folder.

```
WindowsBasic-Provisioning-Tool/
|
|-- Setup.ps1               # Entry point (Main executor)
|
|-- config/
|   |-- apps.json           # List of applications to install
|   `-- bloatware.json      # List of bloatware to remove
|
`-- scripts/
    |-- install_apps.ps1
    |-- remove_bloatware.ps1
    |-- optimize_windows.ps1
    `-- configure_graphics.ps1
```

## Usage

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/felp-z/WindowsBasic-Provisioning-Tool.git](https://github.com/felp-z/WindowsBasic-Provisioning-Tool.git)
    cd WindowsBasic-Provisioning-Tool
    ```
2.  **Customize Configuration Files:** Edit `config/apps.json` and `config/bloatware.json` to fit your needs.
3.  **Run as Administrator:**
    Open a PowerShell window as Administrator, navigate to the project folder, and run the main script.
    ```powershell
    # Allows local script execution for the current session
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

    # Run the script
    .\Setup.ps1
    ```
4.  **Select an Option:** Choose the desired task from the displayed menu.

## Configuration

The strength of this tool lies in its adaptability through simple configuration files.

### `config/apps.json`

Defines the applications to be installed.

-   **`winget`**: An array of package IDs from the Windows Package Manager.
-   **`custom`**: An array of objects for local installers.
    -   `name`: The application's name for display in the console.
    -   `installerPath`: Absolute or relative path to the executable. **Note:** Use double backslashes (`\\`) in the JSON path.
    -   `arguments`: Arguments for silent installation.

**Example:**
```json
{
  "winget": [
    "Google.Chrome",
    "7zip.7zip"
  ],
  "custom": [
    {
      "name": "Office LTSC Pro Plus 2021",
      "installerPath": "D:\\installers\\Office2021\\setup.exe",
      "arguments": "/configure configuration.xml"
    }
  ]
}
```

### `config/bloatware.json`

Defines the applications to be removed. Provide a list with the exact Microsoft Store package names.

**Example:**
```json
[
  "Microsoft.XboxApp",
  "Microsoft.ZuneMusic",
  "Microsoft.SkypeApp",
  "Microsoft.People"
]
```

## Vision & Scalability

This project is the foundation for an even more robust provisioning system. Potential evolutions include:

-   **Chocolatey Integration:** Add another package manager for greater flexibility.
-   **Registry Configuration:** Create a script that applies registry settings from a `.reg` file or a structured JSON.
-   **Modularization:** Transform each script into an independent function within a single PowerShell module, facilitating distribution and reuse.

## Disclaimer

These scripts perform significant changes to your system. Review the code and configurations before execution. Take full ownership of your actions. Use at your own risk.
