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

Function Install-FontManual {
  [CmdletBinding(SupportsShouldProcess)]
  Param(
      [Parameter(Mandatory)]
      [IO.FileInfo]$Font,

      [Parameter(Mandatory)]
      [ValidateSet('System', 'User')]
      [String]$Scope
  )

  switch ($Scope) {
      'System' {
          $FontsFolder = [Environment]::GetFolderPath('Fonts')
          $FontsRegKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
      }
      'User' {
          $FontsFolder = Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath 'Microsoft\Windows\Fonts'
          $FontsRegKey = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
      }
  }

  if ($Scope -eq 'User') {
      $null = New-Item -Path $FontsFolder -ItemType Directory -ErrorAction Ignore
      $null = New-Item -Path $FontsRegKey -ErrorAction Ignore
  }

  try {
      Add-Type -AssemblyName PresentationCore -ErrorAction Stop
  } catch {
      throw $_
  }

  $FontInstallName = $Font.Name
  $FontInstallPath = Join-Path -Path $FontsFolder -ChildPath $FontInstallName

  # Matches the convention used by the Explorer shell
  if (Test-Path -Path $FontInstallPath) {
      $FontNameSuffix = -1
      do {
          $FontNameSuffix++
          $FontInstallName = '{0}_{1}{2}' -f $Font.BaseName, $FontNameSuffix, $Font.Extension
          $FontInstallPath = Join-Path -Path $FontsFolder -ChildPath $FontInstallName
      } while (Test-Path -Path $FontInstallPath)
  }
  Write-Debug -Message ('[{0}] Font install path: {1}' -f $Font.Name, $FontInstallPath)

  $FontUri = New-Object -TypeName Uri -ArgumentList $Font.FullName
  try {
      $GlyphTypeface = New-Object -TypeName Windows.Media.GlyphTypeface -ArgumentList $FontUri
  } catch {
      Write-Error -Message ('Unable to import font: {0}' -f $Font)
      continue
  }

  $FontNameCulture = 'en-US'
  if ($GlyphTypeface.Win32FamilyNames.ContainsKey($FontNameCulture) -and $GlyphTypeface.Win32FaceNames.ContainsKey($FontNameCulture)) {
      $FontFamilyName = $GlyphTypeface.Win32FamilyNames[$FontNameCulture]
      $FontFaceName = $GlyphTypeface.Win32FaceNames[$FontNameCulture]
  } else {
      Write-Error -Message ('Unable to determine font name culture: {0}' -f $Font)
      continue
  }

  # Matches the convention used by the Explorer shell
  if ($FontFaceName -eq 'Regular') {
      $FontRegistryName = '{0} (TrueType)' -f $FontFamilyName
  } else {
      $FontRegistryName = '{0} {1} (TrueType)' -f $FontFamilyName, $FontFaceName
  }
  Write-Debug -Message ('[{0}] Font registry name: {1}' -f $Font.Name, $FontRegistryName)

  try {
      $FontsRegItem = Get-Item -Path $FontsRegKey -ErrorAction Stop
  } catch {
      throw ('Unable to access {0} fonts registry key.' -f $Scope.ToLower())
  }

  if ($FontsRegItem.Property.Contains($FontRegistryName)) {
      Write-Error -Message ('Font registry name already exists: {0}' -f $FontRegistryName)
      continue
  }

  Write-Verbose -Message ('Installing font manually: {0}' -f $Font.Name)
  Copy-Item -Path $Font.FullName -Destination $FontInstallPath
  $null = New-ItemProperty -Path $FontsRegKey -Name $FontRegistryName -PropertyType String -Value $FontInstallName
}

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

    $file = Get-Item -Path $fileName
    Install-FontManual -Font $file -Scope System

    # Write-Output "installing $fontName ...";
    # $objShell = New-Object -ComObject Shell.Application
    # $objFolder = $objShell.Namespace(0x14)
        
    # $copyFlag = [String]::Format("{0:x}", 4 + 16);
    # $objFolder.CopyHere($fileName, $copyFlag)
        
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

winget install 7zip.7zip                          # (free) handles most comression file formats
winget install Adobe.Acrobat.Reader.64-bit        # (feee) PDF reader
winget install voidtools.Everything               # (free) filename search
winget install JAMSoftware.TreeSize.Free          # (free) analyzes where all the harddisk space has gone
winget install VideoLAN.VLC                       # (free) the(!) video player
winget install ScooterSoftware.BeyondCompare4  --locale en-US    # (paid) takes comparison of folders and files to a new level
winget install Microsoft.VisualStudioCode         # Visual Studio Code
winget install geeksoftwareGmbH.PDF24Creator  -e  # PDF-Tools
winget install Microsoft.PowerShell               # (free) open shouce shell

winget install Greenshot.Greenshot                # (free) screenshots the way I want them to be
winget install GIMP.GIMP                          # (free) image editing

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

# This will make it appear when you right click ON a folder
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
$path | New-ItemProperty -Name UserPreferencesMask -Value  ([byte[]](0x9E,0x5E,0x07,0x80,0x12,0x00,0x00,0x00)) -PropertyType Binary -Force

# switch back to win10-context menu in explorer
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# enable tree expansion in Explorer when navigating into a folder
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V NavPaneExpandToCurrentFolder /T REG_DWORD /D 00000001 /F

Pop-Location
Stop-Process -processName: Explorer -force        # This will restart the Explorer service to make this work.
