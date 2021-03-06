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

# private use
choco install obs-studio                        # (free) screen recording, management of cameras while production
choco install reaper                            # (paid) audio recoding and production software

choco install spotify                           # (free) need good music - this installer sometimes hangs at the end of the procedure - so I put it last
