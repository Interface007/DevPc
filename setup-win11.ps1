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

# TaskBar to left
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value "0" -Property Dword

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