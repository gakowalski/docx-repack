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

"%COMPRESSOR%" x -y -tzip %1 -o%TEMP%%TEMP_SUBFOLDER%
move %1 %1.bak
%PNG_OPTIMIZER% --preserve -o5 %TEMP%%TEMP_SUBFOLDER%\word\media\*.png 
FOR /F %%j IN ('dir /B %TEMP%%TEMP_SUBFOLDER%\word\media\*.jpeg') DO %JPG_OPTIMIZER% -optimize %TEMP%%TEMP_SUBFOLDER%\word\media\%%j %TEMP%%TEMP_SUBFOLDER%\word\media\%%j
FOR /F %%j IN ('dir /B %TEMP%%TEMP_SUBFOLDER%\word\media\*.jpg') DO %JPG_OPTIMIZER% -optimize %TEMP%%TEMP_SUBFOLDER%\word\media\%%j %TEMP%%TEMP_SUBFOLDER%\word\media\%%j
"%COMPRESSOR%" a -tzip %1 -r %TEMP%%TEMP_SUBFOLDER%\* -mx=9 -mfb=258 -mm=Deflate -mpass=15
rmdir /S /Q %TEMP%%TEMP_SUBFOLDER%