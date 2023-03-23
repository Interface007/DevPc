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
    If((Test-Path "C:\Windows\Fonts\$fontName") -ne $True) {
        Write-Output "downloading $fontName";
        $fileName = "$env:temp\$fontName"
        Invoke-WebRequest -Uri "$fontUrl/$fontName" -OutFile $fileName
        Write-Output "... downloaded $fontName";

        Write-Output "installing $fontName ...";
        $objShell = New-Object -ComObject Shell.Application
        $objFolder = $objShell.Namespace(0x14)
        
        $copyFlag = [String]::Format("{0:x}", 4 + 16);
        $objFolder.CopyHere($fileName, $copyFlag)
        
        Remove-Item $fileName
        Write-Output "... finished installing $fontName";
    } else {
        Write-Output "font $fontName skipped, because already installed";
    }
}

Install-Font "https://github.com/google/fonts/raw/main/ofl/redacted"       "Redacted-Regular.ttf"
Install-Font "https://github.com/google/fonts/raw/main/ofl/redactedscript" "RedactedScript-Bold.ttf"
Install-Font "https://github.com/google/fonts/raw/main/ofl/redactedscript" "RedactedScript-Light.ttf"
Install-Font "https://github.com/google/fonts/raw/main/ofl/redactedscript" "RedactedScript-Regular.ttf"

# scheduling daily upgrades of all software
#$existingTask = Get-ScheduledTask -TaskName "WinGet Upgrade --All" -ErrorAction Ignore -WarningAction Ignore
#if (!$existingTask) {
#    $action = New-ScheduledTaskAction `
#        -Execute 'C:\ProgramData\chocolatey\bin\choco.exe' `
#        -Argument 'upgrade all -y'
#
#    $trigger =  New-ScheduledTaskTrigger -Daily -At 12am
#    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Choco Upgrade All" -Description "Upgrade all choco packages"   
#}  else {
#    Write-Host "task for auto-update exists"
#}


#winget install firacode                          # (free) monospaced font with programming ligatures
winget install lightshot                          # (free) screenshots the way I want them to be
winget install vlc                                # (free) the(!) video player
winget install gimp.gimp                          # (free) image editing
winget install adobereader                        # (feee) PDF reader
winget install 7zip                               # (free) handles most comression file formats
winget install treesizefree                       # (free) analyzes where all the harddisk space has gone
winget install everything                         # (free) filename search
winget install fiddler                            # (free) debugging proxy for http(s)

winget install --id=Obsidian.Obsidian  -e         # (freemium) "external brain"
winget install tailscale                          # (freemium) point-to-point-VPN

winget install xmind-2020                         # (paid) mindmapping
winget install beyondcompare                      # (paid) takes comparison of folders and files to a new level
winget install cryptomator                        # (free) need to keep some content secret in the cloud

# software development and business
winget install git                               # version control

winget install dotnet-sdk                        # .NET SDK

winget install vscode                            # Visual Studio Code
winget install visualstudio2022enterprise        # Visual Studio 2022 Enterprise - still need to install components via VS installer GUI
winget install resharper-ultimate-all            # tooling for efficient C# coding - might be obsolete in the future, but currently it has a lot of great efficiency improvements

winget install azure-cli                         # tooling for Azure
winget install azure-functions-core-tools        # tooling for AzureFunctions
winget install azcopy10                          # Azure Storage copy 
winget install bicep                             # Azure IaC-Tooling for Bicep-definitions

winget install sql-server-management-studio      # database development with MS SQL Server 
winget install azure-data-studio                 # database development with MS Azure Studio

winget install lastpass                          # keep the secrets secret
winget install postman                           # (free) create and manage REST-API-calls
winget install googlechrome                      # (free) browser based on Chromium
winget install firefox                           # (free) browser based on Gecko
winget install kindle                            # (free) to read your programming books from Amazon
winget install zoomit                            # (free) ZoomIt tool from SysInternals

winget install nodejs                            # (free) Node.js - open-source, cross-platform, back-end JavaScript runtime environment
winget install powershell-core                   # (free) open shouce shell
winget install az.powershell                     # Azure PowerShell
winget install docker-desktop                    # Docker Desktop

winget install citrix-workspace                  # (free) needed for some remote work scenarios
winget install vmware-horizon-client             # (free) some use this desktop virtualization
winget install ilspy                             # (free) Intermediate Language (.NET) Disassembler

winget install vcredist140                       # (free) dependency for some software - installed just to be able to upgrade
winget install vcredist2015                      # (free) dependency for some software - installed just to be able to upgrade

winget install screamingfrog                     # (paid) website SEO spider

winget install obs-studio                        # to record screen/cam/...

winget install spotify                           # (free) need good music - this installer sometimes hangs at the end of the procedure - so I put it last
