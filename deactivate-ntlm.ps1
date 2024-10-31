Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"        -Name "LmCompatibilityLevel"         -Value 5
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name "RestrictSendingNTLMTraffic"   -Value 2
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name "RestrictReceivingNTLMTraffic" -Value 2
