# DevPc
Some of my scripts to setup my Windows laptops. I use chocolatey to setup as much tools as possible because that enables me to keep them up to date in a consistent way and it helps me getting up and running in a minimum amount of time.

All scripts here are published under MIT License - essentially: the scripts are provided "as is" without warranty and you are allowed to do whatever you want with it.

To blindly install what I would install (be aware that this will include some commercial software, for which you need a license/subscription):

Work PC
```PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Interface007/DevPc/main/install-private.ps1'))
```

Private PC
```PowerShell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Interface007/DevPc/main/install-privat.ps1'))
```