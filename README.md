# **Triops Toolchain**

## **Wiki Guide**  
Essential references to understand and use Triops:  
- [Downloads](https://github.com/vilksons/triops/wiki/Downloads)                    Downloads
- [Development](https://github.com/vilksons/triops/wiki/Development)                Development
- [Licenses](https://github.com/vilksons/triops/wiki/Licenses)                      Licenses
- [Compiler Options](https://github.com/vilksons/triops/wiki/Compiler-Option)       Compiler AMX Options
- [VSCode Tasks](https://github.com/vilksons/triops/wiki/VSCode-Tasks)              VSCode Tasks
- [Required Packages](https://github.com/vilksons/triops/wiki/Required-Packages)    Required Packages
- [PawnCC Installation](https://github.com/vilksons/triops/wiki/PawnCC-Installation) PawnCC Installation
- [Code of Conduct](https://github.com/vilksons/triops/wiki/CODE-OF-CONDUCT)        Code of Conduct

---

**What is Triops?**  
Triops is an SA:MP-specific toolchain designed for debugging and compiling. It is primarily built using Bash (90%) with some Python3 usage.

---

**Up-To-Date**
always Updates with `sync` or `syncc` to Updates full.

---

## **Prerequisites**  
Before starting, ensure the following:  
- **Have the `triops/workspace` script**  
  - Download via GNU/Wget:
   ```sh
   wget -q --show-progress -O workspace https://raw.githubusercontent.com/vilksons/triops/refs/heads/main/Scripts/workspace
   ```
   - With skip installation
   ```sh
   wget -q --show-progress -O workspace https://raw.githubusercontent.com/vilksons/triops/refs/heads/main/Scripts/workspace && \
      chmod +x workspace && bash ./workspace
   ```
- **Install required packages**  
  - Full list available here: [Required Packages](https://github.com/vilksons/triops/wiki/Required-Packages)

---

## **Installation**

### **Linux / Darwin / Windows / macOS / Android**  
Use one of the following environments:  
[WSL](https://learn.microsoft.com/en-us/windows/wsl/install), [Git Bash](https://git-scm.com/downloads), [MSYS2](https://www.msys2.org/), [mingw-w64](https://www.mingw-w64.org/), [Cygwin](https://www.cygwin.com/), [Babun](https://github.com/babun/babun), [Termux](https://termux.dev/en/), [UserLAnd](https://play.google.com/store/apps/details?id=tech.ula&hl=id&pli=1), [Linux Deploy](https://github.com/meefik/linuxdeploy) 
And other third parties that can run Linux Shell.

1. Open the terminal environment.  
2. Make the `workspace` script executable:  
   ```bash
   chmod +x workspace
   ```  
3. Run the script:  
   ```bash
   bash ./workspace
   ```  

## **MacOS ([Docker](https://www.docker.com/))**
1. `FROM ubuntu:latest`
2. `RUN apt-get update && apt-get install -y bash`
3. `COPY workspace /usr/local/bin/workspace`
4. `RUN chmod +x /usr/local/bin/workspace`
5. `CMD ["bash", "/usr/local/bin/workspace"]`

---

## **Usage**

### **File Renaming**  
Rename `yourmode.pwn` files to a project-appropriate format (e.g., `yourmode.io.pwn`).  
Maintain consistent naming conventions for better organization.

### **Compilation**  
- **Default Compilation (of e.g., `.io.pwn`):**  
   ```bash
   compile .
   ```  
- **Specific File Compilation:**  
   ```bash
   compile yourmode.pwn
   ```  
- **Additional Compiler Options:**  
   ```bash
   compile yourmode.pwn opt1 opt2 opt3
   ```
### **Starting**
- **Default Running:**
   ```bash
   running .
   ```
- **Specific File Running:**  
   ```bash
   running yourmode.pwn
   ```
### **Debugging**
- **Default Debugging:**
   ```bash
   debug .
   ```
- **Specific File Debugging:**  
   ```bash
   debug yourmode.pwn
   ```

---

## **Testing and Compatibility**  
```pwn
#include "a_samp"

main() {
   print "Hello, World!"
}
```

## **Configuration (`lang.json`)**

```json
{
    "amx_flags": [
        "-;+",
        "-(+",
        "-d3"
    ],
    "include_paths": "pawno/include",
    "exclude_paths": [
        "includes",
        "includes2",
        "includes3"
    ],
    "samp_log": "server_log.txt",
    "server_conf": "server.cfg",
    "samp_executable": "samp03svr"
    "include_dir": "pawno/include",
    "plugins_dir": "plugins",
    "bot_token": "gsk_abcd",
    "bot_model": "qwen-2.5-32b",
    "bot_profile": "",
}
```

### **Configuration Details**  

| Key               | Description |
|-------------------|------------|
| `amx_flags`      | Compiler flags for AMX. See [Here](https://github.com/vilksons/triops/wiki/Compiler-Option) for more. |
| `include_paths`  | The default directory should be by the compiler.. |
| `exclude_paths`  | Additional include directories for compilation. |
| `samp_log`       | Log of Server-logs (SA-MP) - (open.MP) |
| `server_conf`    | Configuration of Server (SA-MP) - (open.MP) |
| `samp_executable`| Executable of Server (SA-MP) - (open.MP) |
| `include_dir`    | Main include directory for the package manager - (TligPac). |
| `plugins_dir`    | Plugins directory for `.dll` and `.so` implementations - (Tligpac) |
| `bot_token`      | API Key from [Groq Console](https://console.groq.com/keys). |
| `bot_model`      | AI Model from [Groq Console](https://console.groq.com/). |
| `bot_profile`    | Extra chatbot configuration. |
---

## **Example: `include_paths` Usage**  
If a script inside `includes/` is not recognized, define `"include_paths": "includes"` in `lang.json`.  

### **Example Directory Structure**  
```
samp-server/
├── gamemodes/
│   ├── mygamemode.pwn
│   └── ...
│
├── includes/
│   ├── customFile.pwn
│   ├── anotherFile.pwn
│   └── ...
│
└── server.cfg
```  
Define `"include_paths": "includes"` in `lang.json` if a script in `includes/` is ignored.

---

## **Package Manager**
### **Triops Lightweight Intelligent Packager (TligPac)**  

#### **Introduction**  

Triops operates in two distinct modes: Ops Mode and TligPac Mode. The key difference lies in the availability of the **Lightweight Package Fetcher & Installer (LPFI)**. Ops Mode disables LPFI functionality, while TligPac Mode enables it.  

#### **Entering and Exiting TligPac Mode**  

* **Enter TligPac Mode:** To access LPFI commands, switch to TligPac Mode by executing:  

    ```bash
    tligpac
    ```  

* **List Available Commands:** Once in TligPac Mode, display available commands using:  

    ```bash
    help
    ```  

* **Exit TligPac Mode:** Return to Ops Mode with:  

    ```bash
    exit
    ```  

#### **Package Management**  

##### **Installing Packages**  

Packages can be installed by specifying their URL or file path.  

* **Using `install`:**  

    ```bash
    install github/samp-incognito/samp-streamer-plugin
    ```  

--

   ```diff
   users@:~$ tligpac
   users@:~$ install https://github.com/Y-Less/sscanf/releases/download/v2.13.8/sscanf-2.13.8-win32.zip
   Downloading sscanf-2.13.8-win32 v2.13.8
   sscanf-2.13.8-win32 100%[===================>] 241.99K   737KB/s    in 0.3s    
   Complete!. Packages: sscanf-2.13.8-win32 | 2.13.8
   [All packages installed]
   ```

##### **Removing Packages**  

* **Using `remove`:**  

    ```bash
    remove streamer
    ``` 

--

   ```
   users@:~$ remove sscanf
   dbg: No matching include files found: sscanf
   [OK]  Removed plugins: plugins/amxsscanf.dll
   plugins/sscanf.dll
   [OK]  Removal process completed!
   users@:~$ remove sscanf2
   [OK]  Removed includes: pawno/include/sscanf2.inc
   dbg: No matching plugins files found: sscanf2
   [OK]  Removal process completed!
   ```

---

#### **TligPac Configuration**  

TligPac relies on the `tligpac.json` or `tligpac.toml` with tomlq configuration file, utilized when executing `$ install` without arguments.  

##### **`tligpac.toml` Structure:**
```toml
[package]
urls = [
  "github/user/repository",                      # repo github
  "github/user/repository/to/files/zip",         # repo github/to/files/zip
  "github/user/repository/to/files/tar.gz",      # repo github/to/files/tar.gz
  "gitlab/user/repository",                      # repo gitlab
  "gitlab/user/repository/to/files/zip",         # repo gitlab/to/files/zip
  "gitlab/user/repository/to/files/tar.gz",      # repo gitlab/to/files/tar.gz
  "sourceforge/user/repository",                 # sourceforge
  "sourceforge/user/repository/to/files/zip",    # sourceforge/to/files/zip
  "sourceforge/user/repository/to/files/tar.gz", # sourceforge/to/files/tar.gz
  "unknownhost/path/to/target",                  # unknownhost
  "unknownhost/path/to/target/to/files/zip",     # unknownhost/to/files/zip
  "unknownhost/path/to/target/to/files/tar.gz"   # unknownhost/to/files/tar.gz
]
```
##### **`tligpac.json` Structure:**  

```json
{
    "package": [
        "github/user/repository",                        // repo github
        "github/user/repository/to/files/zip",           // repo github/to/files/zip
        "github/user/repository/to/files/tar.gz",        // repo githb/to/files/tar.gz
        "gitlab/user/repository",                        // repo gitlab
        "gitlab/user/repository/to/files/zip",           // repo gitlab/to/files/zip
        "gitlab/user/repository/to/files/tar.gz",        // repo gitlab/to/files/tar.gz
        "sourceforge/user/repository",                   // sourceforge
        "sourceforge/user/repository/to/files/zip",      // sourceforge/to/files/zip
        "sourceforge/user/repository/to/files/tar.gz",   // sourceforge/to/files/tar.gz
        "unknownhost/path/to/target",                    // unknownhost
        "unknownhost/path/to/target/to/files/zip",       // unknownhost/to/files/zip
        "unknownhost/path/to/target/to/files/tar.gz"     // unknownhost/to/files/tar.gz
    ]
}
```  

#### **Key Features and Philosophy**  

* **Automated Dependency Management:** TligPac automates the installation of dependencies like `.dll`, `.so`, and `.inc` files, simplifying the process.  
* **Advanced Include Support:** TligPac accommodates advanced includes, such as Y_Less Include, ensuring seamless integration.  
* **Connection Flexibility:** TligPac is using GNU/Wget for HTTP(S) Downloader
* **Pragmatic Minimalism and DIY:** TligPac adopts a "do-it-yourself" (DIY) approach, emphasizing freedom and convenience without predefined or verified repositories.  
* **Version Control:** TligPac focuses on installing specific versions, rather than automatic updates, to maintain predictability and control.  

---

## **Final Notes**  
- This guide ensures a smooth setup and usage of Triops.  
- Keep your environment updated and refer to the [Wiki](https://github.com/vilksons/triops/wiki) for further details.  
- For issues, check the [Triops GitHub Discussions](https://github.com/vilksons/triops/discussions) or report bugs via GitHub Issues.