@echo off
rem DOCX repacking script using 7zip
rem AUTHOR: grzegorz.kowalski@wit.edu.pl, grzegorz.kowalski@pot.gov.pl

rem Path to 7-zip executable
set COMPRESSOR=c:\Program Files\7-Zip\7z.exe

rem Path to PNG optimizer
set PNG_OPTIMIZER=c:\IT\optipng-0.7.4-win32\optipng.exe

rem Path to JPEG optimizer executable
set JPG_OPTIMIZER=c:\IT\jpegtran.exe

rem Folder name with leading backslash
set TEMP_SUBFOLDER=\Docx-Repack

rem Some default options
set CONFIG_MAKE_BACKUP=Yes

if not exist %1 goto label_no_input

:decompress
if not exist "%COMPRESSOR%" goto label_no_compressor
"%COMPRESSOR%" x -y -tzip %1 -o%TEMP%%TEMP_SUBFOLDER%

:make_backup
if "%CONFIG_MAKE_BACKUP%"=="Yes" move %1 %1.bak

:optimize_png
if not exist "%PNG_OPTIMIZER%" goto optimize_jpeg

rem Media folder for DOCX files
set MEDIA_FOLDER=%TEMP%%TEMP_SUBFOLDER%\word\media
if exist "%MEDIA_FOLDER%" (
"%PNG_OPTIMIZER%" --preserve -o5 %MEDIA_FOLDER%\*.png 
)

rem Media folder for PPTX files
set MEDIA_FOLDER=%TEMP%%TEMP_SUBFOLDER%\ppt\media
if exist "%MEDIA_FOLDER%" (
"%PNG_OPTIMIZER%" --preserve -o5 %MEDIA_FOLDER%\*.png 
)

rem Media folder for XLSX files
set MEDIA_FOLDER=%TEMP%%TEMP_SUBFOLDER%\xl\media
if exist "%MEDIA_FOLDER%" (
"%PNG_OPTIMIZER%" --preserve -o5 %MEDIA_FOLDER%\*.png 
)

rem Media folder for ODT files
set MEDIA_FOLDER=%TEMP%%TEMP_SUBFOLDER%\media
if exist "%MEDIA_FOLDER%" (
"%PNG_OPTIMIZER%" --preserve -o5 %MEDIA_FOLDER%\*.png 
)

:optimize_jpeg
if not exist "%JPG_OPTIMIZER%" goto compress

rem Media folder for DOCX files
set MEDIA_FOLDER=%TEMP%%TEMP_SUBFOLDER%\word\media
if exist "%MEDIA_FOLDER%" (
FOR /F %%j IN ('dir /B %MEDIA_FOLDER%\*.jpeg') DO %JPG_OPTIMIZER% -optimize %MEDIA_FOLDER%\%%j %MEDIA_FOLDER%\%%j
FOR /F %%j IN ('dir /B %MEDIA_FOLDER%\*.jpg') DO %JPG_OPTIMIZER% -optimize %MEDIA_FOLDER%\%%j %MEDIA_FOLDER%\%%j
)

rem Media folder for PPTX files
set MEDIA_FOLDER=%TEMP%%TEMP_SUBFOLDER%\ppt\media
if exist "%MEDIA_FOLDER%" (
FOR /F %%j IN ('dir /B %MEDIA_FOLDER%\*.jpeg') DO %JPG_OPTIMIZER% -optimize %MEDIA_FOLDER%\%%j %MEDIA_FOLDER%\%%j
FOR /F %%j IN ('dir /B %MEDIA_FOLDER%\*.jpg') DO %JPG_OPTIMIZER% -optimize %MEDIA_FOLDER%\%%j %MEDIA_FOLDER%\%%j
)

rem Media folder for XLSX files
set MEDIA_FOLDER=%TEMP%%TEMP_SUBFOLDER%\xl\media
if exist "%MEDIA_FOLDER%" (
FOR /F %%j IN ('dir /B %MEDIA_FOLDER%\*.jpeg') DO %JPG_OPTIMIZER% -optimize %MEDIA_FOLDER%\%%j %MEDIA_FOLDER%\%%j
FOR /F %%j IN ('dir /B %MEDIA_FOLDER%\*.jpg') DO %JPG_OPTIMIZER% -optimize %MEDIA_FOLDER%\%%j %MEDIA_FOLDER%\%%j
)

rem Media folder for ODT files
set MEDIA_FOLDER=%TEMP%%TEMP_SUBFOLDER%\media
if exist "%MEDIA_FOLDER%" (
FOR /F %%j IN ('dir /B %MEDIA_FOLDER%\*.jpeg') DO %JPG_OPTIMIZER% -optimize %MEDIA_FOLDER%\%%j %MEDIA_FOLDER%\%%j
FOR /F %%j IN ('dir /B %MEDIA_FOLDER%\*.jpg') DO %JPG_OPTIMIZER% -optimize %MEDIA_FOLDER%\%%j %MEDIA_FOLDER%\%%j
)

:compress
"%COMPRESSOR%" a -tzip %1 -r %TEMP%%TEMP_SUBFOLDER%\* -mx=9 -mfb=258 -mm=Deflate -mpass=15

:cleanup
rmdir /S /Q %TEMP%%TEMP_SUBFOLDER%
goto label_exit

:label_no_input
echo File "%1" does not exist!
goto label_exit

:label_no_compressor
echo No archiving utility at this path: "%COMPRESSOR%"!
goto label_exit

:label_exit
