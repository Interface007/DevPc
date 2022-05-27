# DevPc
Some of my scripts to setup my Windows laptops. I use chocolatey to setup as much tools as possible because that enables me to keep them up to date in a consistent way and it helps me getting up and running in a minimum amount of time.

All scripts here are published under MIT License - essentially: the scripts are provided "as is" without warranty and you are allowed to do whatever you want with it.

To blindly install what I would install (be aware that this will include some commercial software, for which you need a license/subscription):

Work PC
```PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Interface007/DevPc/main/install-work.ps1'))
```
Installs [Chocolatey](https://chocolatey.org/) as a package manager, schedules an "upgrade" to all choco-packages and installs my default toolset for work.

Private PC
```PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Interface007/DevPc/main/install-privat.ps1'))
```
Installs [Chocolatey](https://chocolatey.org/) as a package manager, schedules an "upgrade" to all choco-packages and installs my default toolset for a "home-pc" (which includes [REAPER daw](https://www.reaper.fm/) and [OBS Studio](https://obsproject.com/) as well as [XMind](https://www.xmind.net/) and [Beyond Compare](https://www.scootersoftware.com/)).

Windows 11 Configuration changes
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Interface007/DevPc/main/setup-win11.ps1'))
```
- sets the task bar to traditional setting (left aligned, so that icons are in a fixed position)
- switches back to traditional ALT+TAB behavior (I usually have 20 to 40 tabs open and I don't want them to show up in my ALT-TAB experience)
- creates a new power scheme "Work-Default" that does not deactivate screen or harddisk and does not hibernate or switch to standby
