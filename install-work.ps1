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

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation

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


choco install firacode                          # (free) monospaced font with programming ligatures
choco install lightshot                         # (free) screenshots the way I want them to be
choco install vlc                               # (free) the(!) video player
choco install gimp                              # (free) image editing
choco install adobereader                       # (feee) PDF reader
choco install 7zip                              # (free) handles most comression file formats
choco install treesizefree                      # (free) analyzes where all the harddisk space has gone
choco install microsoft-edge                    # (free) browser based on Chromium
choco install everything                        # (free) filename search

choco install xmind-2020                        # (paid) mindmapping
choco install beyondcompare                     # (paid) takes comparison of folders and files to a new level
choco install boxcryptor                        # (paid) need to keep some content secret in the cloud

# software development and business
choco install git                               # version control
choco install vscode                            # Visual Studio Code
choco install visualstudio2022enterprise        # Visual Studio 2022 Enterprise - still need to install components via VS installer GUI
choco install resharper-ultimate-all            # tooling for efficient C# coding - might be obsolete in the future, but currently it has a lot of great efficiency improvements
choco install sql-server-management-studio      # database development with MS SQL Server needs this
choco install keepass                           # keep the secrets secret
choco install dellcommandupdate                 # for DELL laptops a must have
choco install postman                           # (free) create and manage REST-API-calls
choco install nodejs                            # (free) Node.js - open-source, cross-platform, back-end JavaScript runtime environment
choco install powershell-core                   # (free) open shouce shell
choco install microsoft-teams.install           # (subs) will "install the installer" - user has to install
choco install microsoft-teams                   # (subs) will install for current user
choco install googlechrome                      # (free) browser based on Chromium
choco install firefox                           # (free) browser based on Gecko
choco install citrix-workspace                  # (free) needed for some remote work scenarios
choco install vmware-horizon-client             # (free) some use this desktop virtualization
choco install screamingfrog                     # (paid) website SEO spider

choco install spotify                           # (free) need good music - this installer sometimes hangs at the end of the procedure - so I put it last
