##########################################
# License
##########################################
# MIT License
#
# Copyright (c) 2019-2022 Sven Erik Matzen
#
# Permission is hereby granted, free of charge, to any
# person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the
# Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute,
# sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
##########################################

# installation of fonts
function Install-Font {
  param (
    $fontUrl,
    $fontName
  )

  # install "Redacted Regular + Script" - unfortunately, this is not available through Chocolatey
  If ((Test-Path "C:\Windows\Fonts\$fontName") -ne $True -and (Test-Path "$($env:LOCALAPPDATA)\Microsoft\Windows\Fonts\$fontName") -ne $True) {
    IF ($fontUrl -like 'http*') {
      Write-Output "downloading $fontName";
      $fileName = "$env:temp\$fontName"
      Invoke-WebRequest -Uri "$fontUrl/$fontName" -OutFile $fileName
      Write-Output "... downloaded $fontName";
    }
    ELSE {
      $fileName = "$fontUrl/$fontName"
    }
        
    Write-Output "installing $fontName ...";
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace("C:\Windows\Fonts")
        
    $copyFlag = [String]::Format("{0:x}", 4 + 16);
    $objFolder.CopyHere($fileName, $copyFlag)
        
    Remove-Item $fileName
    Write-Output "... finished installing $fontName";
  }
  else {
    Write-Output "font $fontName skipped, because already installed";
  }
}

# Google Redacted is a non-readable font - great for calendar screen shots where you just was to show free time slots
Install-Font "https://github.com/google/fonts/raw/main/ofl/redacted"       "Redacted-Regular.ttf"
Install-Font "https://github.com/google/fonts/raw/main/ofl/redactedscript" "RedactedScript-Bold.ttf"
Install-Font "https://github.com/google/fonts/raw/main/ofl/redactedscript" "RedactedScript-Light.ttf"
Install-Font "https://github.com/google/fonts/raw/main/ofl/redactedscript" "RedactedScript-Regular.ttf"

# Fira Code is a great font for developers
Invoke-WebRequest -Uri "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip" -OutFile "$($env:TEMP)\fira.zip"
Expand-Archive "$($env:TEMP)\fira.zip" -DestinationPath "$($env:TEMP)\fira" -Force
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-Bold.ttf"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-Light.ttf"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-Medium.ttf"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-Regular.ttf"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-Retina.ttf"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-SemiBold.ttf"

winget install -e --id Greenshot.Greenshot                    --source winget # (free) screenshots the way I want them to be
winget install -e --id VideoLAN.VLC                           --source winget # (free) the(!) video player
winget install -e --id GIMP.GIMP                              --source winget # (free) image editing
winget install -e --id Adobe.Acrobat.Reader.64-bit            --source winget # (feee) PDF reader
winget install -e --id 7zip.7zip                              --source winget # (free) handles most comression file formats
winget install -e --id JAMSoftware.TreeSize.Free              --source winget # (free) analyzes where all the harddisk space has gone
winget install -e --id voidtools.Everything                   --source winget # (free) filename search
winget install -e --id Telerik.Fiddler.Classic                --source winget # (free) debugging proxy for http(s)

winget install -e --id Obsidian.Obsidian                      --source winget # (freemium) "external brain"
winget install -e --id tailscale.tailscale                    --source winget # (freemium) point-to-point-VPN

winget install -e --id Xmind.Xmind                            --source winget # (paid) mindmapping
winget install -e --id ScooterSoftware.BeyondCompare4         --source winget --locale en-US # (paid) takes comparison of folders and files to a new level
winget install -e --id WinFsp.WinFsp                          --source winget # (free) enables FUSE Related Volume Types for Cryptomator
winget install -e --id Cryptomator.Cryptomator                --source winget # (free) need to keep some content secret in the cloud

# software development and business
winget install -e --id Git.Git                                --source winget # version control

#winget install -e --id dotnet-sdk                            --source winget # .NET SDK

winget install -e --id Microsoft.VisualStudioCode             --source winget # Visual Studio Code
winget install -e --id Microsoft.VisualStudio.2022.Enterprise --source winget # Visual Studio 2022 Enterprise - still need to install components via VS installer GUI
winget install -e --id JetBrains.ReSharper                    --source winget # tooling for efficient C# coding - might be obsolete in the future, but currently it has a lot of great efficiency improvements

winget install -e --id Microsoft.AzureCLI                     --source winget # tooling for Azure
winget install -e --id Microsoft.Azure.FunctionsCoreTools     --source winget # tooling for AzureFunctions
winget install -e --id Microsoft.Azure.AZCopy.10              --source winget # Azure Storage copy 
winget install -e --id Microsoft.Bicep                        --source winget # Azure IaC-Tooling for Bicep-definitions

winget install -e --id Microsoft.PowerAppsCLI                 --source winget # Microsoft Power Platform CLI

winget install -e --id Microsoft.SQLServerManagementStudio    --source winget # database development with MS SQL Server 
winget install -e --id Microsoft.AzureDataStudio              --source winget # database development with MS Azure Studio

winget install -e --id Postman.Postman                        --source winget # (free) create and manage REST-API-calls
winget install -e --id Google.Chrome                          --source winget # (free) browser based on Chromium
winget install -e --id Mozilla.Firefox                        --source winget # (free) browser based on Gecko
winget install -e --id Amazon.Kindle                          --source winget # (free) to read your programming books from Amazon
#winget install -e --id zoomit                                --source winget # (free) ZoomIt tool from SysInternals

winget install -e --id OpenJS.NodeJS                          --source winget # (free) Node.js - open-source, cross-platform, back-end JavaScript runtime environment
winget install -e --id Microsoft.PowerShell                   --source winget # (free) open shouce shell
#winget install -e --id az.powershell                         --source winget # Azure PowerShell
winget install -e --id Docker.DockerDesktop                   --source winget # Docker Desktop
winget install -e --id WiresharkFoundation.Wireshark          --source winget # WireShark network analyzer

winget install -e --id Citrix.Workspace                       --source winget # (free) needed for some remote work scenarios
winget install -e --id VMware.HorizonClient                   --source winget # (free) some use this desktop virtualization
winget install -e --id icsharpcode.ILSpy                      --source winget # (free) Intermediate Language (.NET) Disassembler

#winget install -e --id screamingfrog                         --source winget # (paid) website SEO spider
# private use
winget install -e --id OBSProject.OBSStudio                   --source winget # to record screen/cam/...
winget install -e --id Spotify.Spotify                        --source winget # (free) need good music - this installer sometimes hangs at the end of the procedure - so I put it last

Push-Location

# show the extensions in explorer
Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
Set-ItemProperty . HideFileExt "0"

# remove widgets from taskbar
if (!(Test-Path "HKLM:\\SOFTWARE\Policies\Microsoft\Dsh")) { New-Item -Path "HKLM:\\SOFTWARE\Policies\Microsoft\Dsh" -Force }
Set-ItemProperty -Path "HKLM:\\SOFTWARE\Policies\Microsoft\Dsh" -Name "AllowNewsAndInterests" -Value 0 -Type "DWord"

# remove search from taskbar
Set-ItemProperty -Path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -Type "DWord"

# remove chat from taskbar
Set-ItemProperty -Path "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value 0 -Type "DWord"
Set-ItemProperty -Path "HKLM:\\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" -Name "ChatIcon" -Value 3 -Type "DWord"

# because IP filters in "Conditional Access" do need IPv4, we deactivate IPv6 for all networks
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6

# Open files
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
$path = New-Item -Path 'HKCR:\*\shell\Open with VS Code' -Force
$path | New-ItemProperty -Name '(default)' -Value 'Edit with VS Code' -PropertyType 'String' -Force
$path | New-ItemProperty -Name 'Icon' -Value "`"$($env:LOCALAPPDATA)\Programs\Microsoft VS Code\Code.exe`",0" -PropertyType 'String' -Force
$path = New-Item -Path 'HKCR:\*\shell\Open with VS Code\command' -Force
$path | New-ItemProperty -Name '(default)' -Value "`"$($env:LOCALAPPDATA)\Programs\Microsoft VS Code\Code.exe`" `"%1`"" -PropertyType 'String' -Force

# This will make it appear when you right-click ON a folder
$path = New-Item -Path 'HKCR:\Directory\shell\vscode' -Force
$path | New-ItemProperty -Name '(default)' -Value 'Open Folder as VS Code Project' -PropertyType 'String' -Force
$path = New-Item -Path 'HKCR:\Directory\shell\vscode\command' -Force
$path | New-ItemProperty -Name '(default)' -Value "`"$($env:LOCALAPPDATA)\Programs\Microsoft VS Code\Code.exe`" `"%V`"" -PropertyType 'String' -Force

# TaskBar to left and without grouping
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl"        -Value "0" -Type Dword
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value "2" -Type Dword

# ALT+TAB-experience without IE-Tab-Switching
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name Explorer
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "MultiTaskingAltTabFilter" -Value "4" -Type Dword

## very Old ALT-TAB behavior
#$path = Get-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Force
#$path | New-ItemProperty -Name 'AltTabSettings' -Value 1 -PropertyType 'DWORD' -Force

$path = New-Item -Path 'HKCU:\hive\Control Panel\Desktop' -Force
$path | New-ItemProperty -Name UserPreferencesMask -Value  ([byte[]](0x9E, 0x5E, 0x07, 0x80, 0x12, 0x00, 0x00, 0x00)) -PropertyType Binary -Force

# switch back to win10-context menu in explorer
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# enable tree expansion in Explorer when navigating into a folder
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V NavPaneExpandToCurrentFolder /T REG_DWORD /D 00000001 /F

# Remove Microsoft Store from the taskbar (english and german language)
$appname = "Microsoft Store"
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object { $_.Name -eq $appname }).Verbs() `
| Where-Object { $_.Name.replace('&', '') -match 'Unpin from taskbar' -or $_.Name.replace('&','') -match 'Von Taskleiste lösen'} `
| ForEach-Object { $_.DoIt(); $exec = $true }

Pop-Location
Stop-Process -processName: Explorer -force        # This will restart the Explorer service to make this work.

# update WSL when needed - Docker needs to be newer than some installation processes of Windows 11 do install.
Start-Process wsl --update

# install Hyper-V as a Windows feature
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

# create a virtual switch for ethernet sharing:
New-VMSwitch -Name "vEthernet" -NetAdapterName Ethernet -AllowManagementOS:$true

# Apply the Secure Boot UEFI Forbidden List (DBX) and the Code Integrity Boot Policy for kb5025885
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Secureboot /v AvailableUpdates /t REG_DWORD /d 0x30 /f

winget install wingetui
Start-Process "$($env:LOCALAPPDATA)\Programs\WingetUI\wingetui.exe" -wait -ArgumentList "--updateapps"

# # configure Cryptomator to use WinFUSE ... TODO: need to check whether this file exists right after setting up Cryptomator via WinGet
# $settingsPath = "$($env:APPDATA)\Cryptomator\settings.json"
# $settings = Get-Content -Path $settingsPath | ConvertFrom-Json
# $settings.mountService = "org.cryptomator.frontend.fuse.mount.WinFspMountProvider"
# $settings.checkForUpdatesEnabled = $true
# $settings.startHidden = $true
# ConvertTo-Json $newSettings | Set-Content -Path $settingsPath
