@echo off

rem должен быть установлен 7zip, GIT и NxNandManager

echo Choose mounted SD card letter

for /f "tokens=3-6 delims=: " %%a in ('WMIC LOGICALDISK GET FreeSpace^,Name^,Size^,filesystem^,description ^|FINDSTR /I "Removable" ^|findstr /i "exfat fat32"') do (@echo wsh.echo "Disk letter: %%c;" ^& " free: " ^& FormatNumber^(cdbl^(%%b^)/1024/1024/1024, 2^)^& " GB;"^& " size: " ^& FormatNumber^(cdbl^(%%d^)/1024/1024/1024, 2^)^& " GB;" ^& " FS: %%a" > %temp%\tmp.vbs & @if not "%%c"=="" @echo( & @cscript //nologo %temp%\tmp.vbs & del %temp%\tmp.vbs)
echo.
	set /P sd="Enter SD card letter: "

del "%sd%:\license-request.dat"
copy "%sd%:\license.dat" "%sd%:\sxos\emunand\"
copy "%sd%:\switch\prod.keys" "%sd%:\sxos\emunand\"

set /P sn="Enter SN: "

rem папка с NxNandManager
set nnm="E:\Switch\NxNandManager"

echo.
echo ====================================================
echo Making of 10Gb and 2Gb RAWNAND files
echo.


if exist %nnm%\RAWNAND.10gb del %nnm%\RAWNAND.10gb
%nnm%\NxNandManager.exe -i "%sd%:\sxos\emunand\full.00.bin" -o "%nnm%\RAWNAND.10gb" -keyset "%sd%:\switch\prod.keys" --incognito -user_resize=7576 FORMAT_USER FORCE\
del %nnm%\emu\* /F /Q
%nnm%\NxNandManager.exe -i "%nnm%\RAWNAND.10gb" -o "%nnm%\emu\RAWNAND" -keyset "%sd%:\switch\prod.keys" -user_resize=64

echo.
echo Dumps Resized well
echo ====================================================
echo.

echo.
echo ====================================================
echo Making of shrinked backup on cloud storage
echo ====================================================
echo.


rem папка, куда будет класться заархивированный бекап
set path="E:\Switch\backup\"

if exist %path%%sn%.zip del %path%%sn%.zip

copy "%sd%:\license.dat" "%nnm%\emu\"
copy "%sd%:\switch\prod.keys" "%nnm%\emu\"
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx9 -r0 -ssw %path%%sn%.zip %nnm%\emu\*

echo.
echo Shrinked backup was made on cloud storage
echo ====================================================
echo.

echo.
echo ====================================================
echo Making of needed files backup on cloud storage
echo.


del %nnm%\emu\RAWNAND

rem папка, куда будет класться заархивированный бекап ключа, лицензии и prodinfo
set path="E:\Switch\backup\tiny\"

if exist %path%%sn%.zip del %path%%sn%.zip

%nnm%\NxNandManager.exe -i "%sd%:\sxos\emunand\full.00.bin" -o "%nnm%\emu\PRODINFO" -part=PRODINFO

"C:\Program Files\7-Zip\7z.exe" a -tzip -mx9 -r0 -ssw %path%%sn%.zip %nnm%\emu\*

echo.
echo Needed files backup was made on cloud storage
echo ====================================================
echo.

echo.
echo ====================================================
echo Split dump to 4GB parts
echo.


del "%nnm%\out" /F /Q
mkdir "%nnm%\out"

chdir /d %nnm%
"C:\Program Files\Git\usr\bin\split.exe" -b 4000000K -d RAWNAND.10gb out\full.

echo.
echo Dump was splitted to 4Gb parts
echo ====================================================
echo.

echo.
echo ====================================================
echo Add .bin to each emunand part
echo.

for %%G in (out\*) do (move %%G %%G.bin)

echo.
echo .bin was added to each emunand part
echo ====================================================
echo.

echo.
echo ====================================================
echo Remove oroginal emunand files from SD
echo.

del %sd%:\sxos\emunand\full.*

echo.
echo Original emunand was removed from SD
echo ====================================================
echo.

echo.
echo ====================================================
echo Move shrinked emunand files to SD
echo.

move %nnm%\out\* %sd%:\sxos\emunand\

echo.
echo Shrinked emunand files was moved to SD
echo ====================================================
echo.

echo.
echo ====================================================
echo                       DONE
echo ====================================================

pause