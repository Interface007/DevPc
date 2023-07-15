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
  If ((Test-Path "C:\Windows\Fonts\$fontName") -ne $True) {
    if ($fontUrl -like 'http*') {
      Write-Output "downloading $fontName";
      $fileName = "$env:temp\$fontName"
      Invoke-WebRequest -Uri "$fontUrl/$fontName" -OutFile $fileName
      Write-Output "... downloaded $fontName";
    }
    else {
      $fileName = "$fontUrl/$fontName"
    }
        
    Write-Output "installing $fontName ...";
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace(0x14)
        
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
Expand-Archive "$($env:TEMP)\fira.zip" -DestinationPath "$($env:TEMP)\fira"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-Bold.ttf"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-Light.ttf"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-Medium.ttf"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-Regular.ttf"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-Retina.ttf"
Install-Font "$($env:TEMP)\fira\ttf" "FiraCode-SemiBold.ttf"

# scheduling daily upgrades of all software
$existingTask = Get-ScheduledTask -TaskName "Choco Upgrade All" -ErrorAction Ignore -WarningAction Ignore
if (!$existingTask) {
    $action = New-ScheduledTaskAction `
        -Execute 'C:\ProgramData\chocolatey\bin\choco.exe' `
        -Argument 'upgrade all -y'

    $trigger =  New-ScheduledTaskTrigger -Daily -At 12am
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Choco Upgrade All" -Description "Upgrade all choco packages"   
}  else {
    Write-Host "task for auto-update exists"
}

winget install Greenshot.Greenshot                # (free) screenshots the way I want them to be
winget install VideoLAN.VLC                       # (free) the(!) video player
winget install GIMP.GIMP                          # (free) image editing
winget install Adobe.Acrobat.Reader.64-bit        # (feee) PDF reader
winget install 7zip.7zip                          # (free) handles most comression file formats
winget install JAMSoftware.TreeSize.Free          # (free) analyzes where all the harddisk space has gone
winget install voidtools.Everything               # (free) filename search

winget install Obsidian.Obsidian                  # (freemium) "external brain"
winget install tailscale.tailscale                # (freemium) point-to-point-VPN

winget install Xmind.Xmind                        # (paid) mindmapping
winget install ScooterSoftware.BeyondCompare4  --locale en-US    # (paid) takes comparison of folders and files to a new level
winget install WinFsp.WinFsp                      # (free) enables FUSE Related Volume Types for Cryptomator
winget install Cryptomator.Cryptomator            # (free) need to keep some content secret in the cloud

# software development and business
winget install Microsoft.VisualStudioCode         # Visual Studio Code
winget install Amazon.Kindle                      # (free) to read your programming books from Amazon

# private use
winget install OBSProject.OBSStudio               # to record screen/cam/...
winget install Spotify.Spotify                    # (free) need good music - this installer sometimes hangs at the end of the procedure - so I put it last

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

# Open files
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
$path = New-Item -Path 'HKCR:\*\shell\Open with VS Code' -Force
$path | New-ItemProperty -Name '(default)' -Value 'Edit with VS Code' -PropertyType 'String' -Force
$path | New-ItemProperty -Name 'Icon' -Value "`"$($env:LOCALAPPDATA)\Programs\Microsoft VS Code\Code.exe`",0" -PropertyType 'String' -Force
$path = New-Item -Path 'HKCR:\\*\shell\Open with VS Code\command' -Force
$path | New-ItemProperty -Name '(default)' -Value "`"$($env:LOCALAPPDATA)\Programs\Microsoft VS Code\Code.exe`" `"%1`"" -PropertyType 'String' -Force

# This will make it appear when you right click ON a folder
$path = New-Item -Path 'HKCR:\\Directory\shell\vscode' -Force
$path | New-ItemProperty -Name '(default)' -Value 'Open Folder as VS Code Project' -PropertyType 'String' -Force
$path = New-Item -Path 'HKCR:\\Directory\shell\vscode\command' -Force
$path | New-ItemProperty -Name '(default)' -Value "`"$($env:LOCALAPPDATA)\Programs\Microsoft VS Code\Code.exe`" `"%V`"" -PropertyType 'String' -Force

Pop-Location
Stop-Process -processName: Explorer -force        # This will restart the Explorer service to make this work.

winget install Cockos.REAPER                      # (paid) audio recoding and production software

winget install wingetui
Start-Process "$($env:LOCALAPPDATA)\Programs\WingetUI\wingetui.exe" -wait -ArgumentList "--updateapps"

# # configure Cryptomator to use WinFUSE ... TODO: neet to check whether this file exists right after setting up Cryptomator via WinGet
# $settingsPath = "$($env:APPDATA)\Cryptomator\settings.json"
# $settings = Get-Content -Path $settingsPath | ConvertFrom-Json
# $settings.mountService = "org.cryptomator.frontend.fuse.mount.WinFspMountProvider"
# $settings.checkForUpdatesEnabled = $true
# $settings.startHidden = $true
# ConvertTo-Json $newSettings | Set-Content -Path $settingsPath
