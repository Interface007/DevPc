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
  ELSE {
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

winget install -e --id tailscale.tailscale                    --source winget # (freemium) point-to-point-VPN

winget install -e --id ScooterSoftware.BeyondCompare4         --source winget --locale en-US # (paid) takes comparison of folders and files to a new level

winget install -e --id Microsoft.VisualStudioCode             --source winget # Visual Studio Code
winget install -e --id Microsoft.PowerShell                   --source winget # (free) open shouce shell

winget install -e --id OBSProject.OBSStudio                   --source winget # to record screen/cam/...
winget install -e --id Spotify.Spotify                        --source winget # (free) need good music - this installer sometimes hangs at the end of the procedure - so I put it last

winget install -e --id Cockos.REAPER                      # (paid) audio recoding and production software
winget install -e --id Musescore.Musescore

Push-Location

# show the extensions in explorer
Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
Set-ItemProperty . HideFileExt "0"

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

# enable tree expansion in Explorer when navigating into a folder
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V NavPaneExpandToCurrentFolder /T REG_DWORD /D 00000001 /F

Pop-Location
Stop-Process -processName: Explorer -force        # This will restart the Explorer service to make this work.
