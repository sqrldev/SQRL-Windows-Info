@echo off
mode con: cols=90 lines=60

:Loop
cls
echo Options (HKCU\software\gibson research\sqrl)
echo 0x1 = Darken Password Screens (Secure Desktop)
echo 0x2 = Run on Startup
echo 0x4 = Show Identity Management Functions
reg query "HKCU\software\gibson research\sqrl" /v "OptionSettings" 2>NUL | find "REG_DWORD"
echo:
echo SQRL:// (HKCR\sqrl)
reg query HKCR\sqrl /ve 2>NUL | find "REG_SZ"
reg query HKCR\sqrl /v "URL Protocol" 2>NUL | find "REG_SZ"
echo:
echo SQRL:// (HKCR\sqrl\shell\open\command)
reg query HKCR\sqrl\shell\open\command /ve 2>NUL | find "REG_SZ"

echo:
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto Beg64
:Beg32
echo Startup (HKLM\software\microsoft\windows\currentversion\run)
reg query HKLM\software\microsoft\windows\currentversion\run /v "SQRL Login Client" 2>NUL | find "REG_SZ"
echo:
echo Uninstall (HKLM\software\microsoft\windows\currentversion\uninstall\sqrl)
reg query HKLM\software\microsoft\windows\currentversion\uninstall\sqrl /v Uninstallstring 2>NUL | find "REG_SZ"
reg query HKLM\software\microsoft\windows\currentversion\uninstall\sqrl /v DisplayVersion 2>NUL | find "REG_SZ"
reg query HKLM\software\microsoft\windows\currentversion\uninstall\sqrl /v ReleaseNumber 2>NUL | find "REG_DWORD"
echo:
echo %ProgramFiles%\GRC
dir /b "%ProgramFiles%\GRC\sqrl*.exe"
:End32
goto End64

:Beg64
echo Startup (HKLM\software\wow6432node\microsoft\windows\currentversion\run)
reg query HKLM\software\wow6432node\microsoft\windows\currentversion\run /v "SQRL Login Client" 2>NUL | find "REG_SZ"
echo:
echo Uninstall (HKLM\software\wow6432node\microsoft\windows\currentversion\uninstall\sqrl)
reg query HKLM\software\wow6432node\microsoft\windows\currentversion\uninstall\sqrl /v Uninstallstring 2>NUL | find "REG_SZ"
reg query HKLM\software\wow6432node\microsoft\windows\currentversion\uninstall\sqrl /v DisplayVersion 2>NUL | find "REG_SZ"
reg query HKLM\software\wow6432node\microsoft\windows\currentversion\uninstall\sqrl /v ReleaseNumber 2>NUL | find "REG_DWORD"
echo:
echo sqrl*.exe in %ProgramFiles(x86)%\GRC
dir /b "%ProgramFiles(x86)%\GRC\sqrl*.exe"
:End64

dir /b "%LocalAppData%\sqrl*.exe" 2>&1 | find /i ".exe" >NUL
if %errorlevel%==0 echo: & echo sqrl*.exe Files in %LocalAppData% & dir /b "%LocalAppData%\sqrl*.exe"

echo:
echo Task Manager (SQRL executables currently runnung)
wmic process where "name='sqrl.exe'" get ExecutablePath 2>&1 | find ".exe"
wmic process where "name='sqrl-fork.exe'" get ExecutablePath 2>&1 | find ".exe"
wmic process where "name='sqrl-installer.exe'" get ExecutablePath 2>&1 | find ".exe"
wmic process where "name='sqrl-client-side-logging.exe'" get ExecutablePath 2>&1 | find ".exe"

wmic process where "name='sqrlw.exe'" get ExecutablePath 2>&1 | find ".exe"
wmic process where "name='sqrlview.exe'" get ExecutablePath 2>&1 | find ".exe"
wmic process where "name='sqrlserver.exe'" get ExecutablePath 2>&1 | find ".exe"

dir /b "%ProgramData%\Microsoft\Windows\Start Menu\Programs\sqrl*.lnk" 2>&1 | find /i ".lnk" >NUL
if %errorlevel%==0 echo: & echo sqrl*.lnk in %ProgramData%\Microsoft\Windows\Start Menu\Programs & dir /b "%ProgramData%\Microsoft\Windows\Start Menu\Programs\sqrl*.lnk"

echo:
echo Identity Files in %UserProfile%\My Documents\sqrl
dir /b "%UserProfile%\my documents\sqrl\*.sqrl"

dir /b "%ProgramFiles%\GRC\*.sqrl" 2>&1 | find /i ".sqrl" >NUL
if %errorlevel%==0 echo: & echo Identity Files in %ProgramFiles%\GRC & dir /b "%ProgramFiles%\GRC\*.sqrl"

dir /b "%ProgramFiles(x86)%\GRC\*.sqrl" 2>&1 | find /i ".sqrl" >NUL
if %errorlevel%==0 echo: & echo Identity Files in %ProgramFiles(x86)%\GRC & dir /b "%ProgramFiles(x86)%\GRC\*.sqrl"

dir /b "*.sqrl" 2>&1 | find /i ".sqrl" >NUL
if %errorlevel%==0 echo: & echo Identity Files in the current directory & dir /b "*.sqrl"

echo:
echo | set /p "=Press any key to refresh or <Ctrl>C to exit "
echo:
pause > NUL
goto Loop
