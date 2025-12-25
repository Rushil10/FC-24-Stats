# Player Stats Multi-Game Engine ⚽

This project is a professional, multi-flavor Flutter application designed to power multiple "Player Stats" apps (FC 24, FIFA 23, etc.) from a single codebase.

## 🚀 One-Command Build System

We use PowerShell automation scripts to handle complex Flutter flavors and environment variables.

### 1. Building the APK
Use `.\build_app.ps1` to generate a release-ready APK.

*   **Build FC 24 Free (Default)**:
    ```powershell
    .\build_app
    ```
*   **Build FC 24 Pro (No Ads)**:
    ```powershell
    .\build_app pro
    ```
*   **Build a specific year (e.g., FIFA 23)**:
    ```powershell
    .\build_app free 23
    ```

### 2. Running & Installing
Use `.\run_app.ps1` to run the app on a device or install a build.

*   **Run the app (Debug mode)**:
    ```powershell
    .\run_app
    ```
*   **Install the latest build**:
    ```powershell
    .\run_app -install
    ```
*   **Run a specific version**:
    ```powershell
    .\run_app pro 23
    ```

---

## 🏗️ How it Works

### Multiple Games & Years
The app title, database, and asset loading are all dynamic.
- The `YEAR` environment variable determines if the app should load `players_24.csv` or `players_23.csv`.
- Database files are uniquely named (e.g., `players24.db`) so multiple games can coexist on one phone without overwriting each other.

### Free vs Pro Version
- **Free**: Includes AdMob Interstitial ads (pop-ups) and Banner ads.
- **Pro**: Automatically disables the ad engine and changes the app name to include "(No Ads)".

### Global Ad Management
We use a global interaction tracker (`InterstitialAdManager`). 
- It counts **every touch** on the screen.
- Every 30 interactions, a pre-loaded interstitial ad is shown (in the Free version only).

---

## ➕ Adding a New Game (e.g., FIFA 22)

To release a new version for an older game:
1.  **Add Flavor**: Add `fifa22` to the `productFlavors` in `android/app/build.gradle`.
2.  **Add Assets**: Drop the CSV into `assets/players_22.csv`.
3.  **Build**: Run `.\build_app free 22`.

The engine handles all the naming and logic automatically!
