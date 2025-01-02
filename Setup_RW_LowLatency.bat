@Echo Off
SetLocal EnableDelayedExpansion

:: Disable Vulnerable Driver Blocklist
Reg.exe Add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d "0" /F >NUL 2>&1

:IMod
:: Define URLs and paths
Set "RW_Setup_Url=https://github.com/DaddyJordan/RW-LowLatency-XHCI-IMOD/raw/refs/heads/main/SetupRw.exe"
Set "IMod_Script_Url=https://raw.githubusercontent.com/DaddyJordan/RW-LowLatency-XHCI-IMOD/refs/heads/main/IMODRW.ps1"
Set "RW_Setup_Path=%Temp%\SetupRw.exe"
Set "IMod_Script_Path=C:\IMODRW.ps1"
Set "Install_Dir=C:\RW-Everything"

:: Create installation directory
Mkdir "%Install_Dir%" >NUL 2>&1

:: Download and install RW-Everything
Curl -L -o "%RW_Setup_Path%" "%RW_Setup_Url%" >NUL 2>&1
Start /Wait "" "%RW_Setup_Path%" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /DIR="%Install_Dir%" >NUL 2>&1

:: Download the IMOD PowerShell script
Curl -L -o "%IMod_Script_Path%" "%IMod_Script_Url%" >NUL 2>&1

:: Create a shortcut in the Startup folder to run the PowerShell script at startup
Set "Shortcut_Folder=%UserProfile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
Set "Shortcut_Name=IMODRW.ps1.lnk"
Set "Shortcut_Path=%Shortcut_Folder%\%Shortcut_Name%"
Powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%Shortcut_Path%'); $s.TargetPath = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'; $s.Arguments = '-ExecutionPolicy Bypass -File \"%IMod_Script_Path%\"'; $s.Save()" >NUL 2>&1

:: Clean up
Del "%RW_Setup_Path%" >NUL 2>&1

Endlocal
