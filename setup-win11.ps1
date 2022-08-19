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

# TaskBar to left and without grouping
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl"        -Value "0" -Type Dword
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Value "2" -Type Dword

# old ALT+TAB-experience
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name Explorer
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "MultiTaskingAltTabFilter" -Value "4" -Type Dword

# PowerSettings (no screen-off, no hdd-power-down, ...)
POWERCFG -DUPLICATESCHEME 381b4222-f694-41f0-9685-ff5bb260df2e 4e1057d0-8012-4889-b988-99f26bfb9415
POWERCFG -CHANGENAME 4e1057d0-8012-4889-b988-99f26bfb9415 "Work-Default"
POWERCFG -SETACTIVE  4e1057d0-8012-4889-b988-99f26bfb9415
POWERCFG -Change -monitor-timeout-ac 0      # don't switch off the monitor - I will do it
POWERCFG -CHANGE -monitor-timeout-dc 0      # don't switch off the monitor - I will do it
POWERCFG -CHANGE -disk-timeout-ac 0         # prevent switching off disks (not that important any more, because we all work on SSD)
POWERCFG -CHANGE -disk-timeout-dc 0         # prevent switching off disks (not that important any more, because we all work on SSD)
POWERCFG -CHANGE -standby-timeout-ac 0      # don't go into standby automatically - I will tell you when to switch off
POWERCFG -CHANGE -standby-timeout-dc 0      # don't go into standby automatically - I will tell you when to switch off
POWERCFG -CHANGE -hibernate-timeout-ac 0    # don't hibernate automatically - I will tell you when to sleep
POWERCFG -CHANGE -hibernate-timeout-dc 0    # don't hibernate automatically - I will tell you when to sleep

# Turn on network protection
Set-MpPreference -EnableNetworkProtection Enabled

# harden
  Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"                           -Name "RunAsPPL"                    -Value 0x00000001 -Type Dword -Force -ea 'SilentlyContinue' # Enable 'Local Security Authority (LSA) protection'
# Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"      -Name "ConsentPromptBehaviorUser"   -Value 0x00000000 -Type Dword -Force -ea 'SilentlyContinue' # Set User Account Control (UAC) to automatically deny elevation requests
  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'      -Name 'InactivityTimeoutSecs'       -Value 0x00000384 -Type DWORD -Force -ea 'SilentlyContinue' # set screen activity timer to 900 sec = 15 minutes
  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile'      -Name 'AllowLocalPolicyMerge'       -Value 0x00000000 -Type DWORD -Force -ea 'SilentlyContinue' # Disable merging of local Microsoft Defender Firewall rules with group policy firewall rules for the Public profile
  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile'      -Name 'AllowLocalIPsecPolicyMerge'  -Value 0x00000000 -Type DWORD -Force -ea 'SilentlyContinue' # Disable merging of local Microsoft Defender Firewall connection rules with group policy firewall rules for the Public profile
# Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'                                -Name 'MinimumPIN'                  -Value 0x00000006 -Type DWORD -Force -ea 'SilentlyContinue' # Set 'Minimum PIN length for startup' to '6 or more characters'
  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer'                  -Name 'AlwaysInstallElevated'       -Value 0x00000000 -Type DWORD -Force -ea 'SilentlyContinue' # Disable 'Always install with elevated privileges'
  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown'      -Name 'bEnableFlash'                -Value 0x00000000 -Type DWORD -Force -ea 'SilentlyContinue' # Disable Flash on Adobe Reader DC
  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown'      -Name 'bDisableJavaScript'          -Value 0x00000000 -Type DWORD -Force -ea 'SilentlyContinue' # Disable JavaScript on Adobe Reader DC
  Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Download'         -Name 'RunInvalidSignatures'        -Value 0x00000000 -Type DWORD -Force -ea 'SilentlyContinue' # Disable running or installing downloaded software with invalid signature
# Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft Services\AdmPwd'                    -Name 'AdmPwdEnabled'               -Value 0x00000001 -Type DWORD -Force -ea 'SilentlyContinue' # Enable Local Admin password management
  Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'                           -Name 'RestrictAnonymous'           -Value 0x00000001 -Type DWORD -Force -ea 'SilentlyContinue' # Disable Anonymous enumeration of shares
  Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'                           -Name 'DisableDomainCreds'          -Value 0x00000001 -Type DWORD -Force -ea 'SilentlyContinue' # Disable the local storage of passwords and credentials

  net accounts /minpwlen:14         # minimum password length = 14
  net accounts /uniquepw:24         # password history of 24
  net accounts /minpwage:1          # password must not be changed for one day
  net accounts /lockoutthreshold:10 # lock out account after 10 wrong attempts
