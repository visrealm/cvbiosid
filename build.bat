setlocal
@echo off

echo ---------------------------
echo CVBIOSID build
echo ---------------------------
echo.


mkdir build 2> NUL

del /Q /S build\*

set VERSION=v0-0-1
set FRIENDLYVER=%VERSION:-=.%

pushd src

set BUILDDIR=..\build
set ASMDIR=%BUILDDIR%\asm

mkdir %ASMDIR% 2> NUL

echo Setting up build directories
echo.
echo Intermediates: %ASMDIR%
echo Binaries:      build
echo.



echo.
echo ---------------------------------------------------------------------
echo Finding CVBasic compiler...


set PATH=..\tools\cvbasic;%PATH%

:: This is where I have my CVBasic fork, so grab it from here if available
set PATH=..\..\CVBasic\build\Release;%PATH%  
set PATH=..\..\gasm80\build\Release;%PATH%  
set LIBPATH=..\src\lib
for %%D in ("%LIBPATH%") do set LIBPATH=%%~fD

where cvbasic.exe
if %errorlevel% neq 0 (
    echo.
    echo cvbasic.exe not in %%PATH%%
    echo.
    echo %%PATH%%="%PATH%"
    exit /b %errorlevel%
)
for /f "tokens=1 delims=" %%A in ('where cvbasic.exe') do (
    echo.
    echo Using : %%A
    goto :end
)
:end
echo ---------------------------------------------------------------------


echo.
echo ---------------------------------------------------------------------
echo Compressing pletter source files...
echo ---------------------------------------------------------------------
echo.

for %%f in (pletter\*.bas) do (
    python ..\tools\cvpletter.py "%%f"
)

:: ColecoVision

echo.
echo ---------------------------------------------------------------------
echo   Compiling for Colecovision
echo ---------------------------------------------------------------------

set BASENAME=CVBIOSID
cvbasic cvbios.bas %ASMDIR%\%BASENAME%.asm %LIBPATH%
if %errorlevel% neq 0 exit /b %errorlevel%
gasm80 %ASMDIR%\%BASENAME%.asm -o %BUILDDIR%\%BASENAME%.rom
copy /Y %BUILDDIR%\%BASENAME%.rom c:\tools\Classic99Phoenix
echo.
echo Output: build\%BASENAME%.rom

:: Just output our compiled ROM files
:: This is very colvuluted way to format the output
set "pad=                              "
for %%A in (%BUILDDIR%\*.*) do (
    set "name=%%~nxA"
    set "size=%%~zA"
    call :printAligned
)
goto :eof

:printAligned
setlocal enabledelayedexpansion
set "namePadded=!name!!pad!"
set "namePadded=!namePadded:~0,30!"
set "sizePad=!pad!!size!"
set "sizePad=!sizePad:~-8!"
echo !namePadded!!sizePad! bytes
endlocal
goto :eof

:: We're done :)


popd
echo.