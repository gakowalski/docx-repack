<?php 
$_7z_cmd = 'dependencies/7z-22.01/7za.exe';
$optipng_cmd = 'dependencies/optipng-0.7.7-win32/optipng.exe';
$jpegtran_cmd = 'dependencies/jpegtran.exe';
$touch_cmd = 'dependencies/touch.exe';

function proper_directory_separator($path) {
	return str_replace('/', DIRECTORY_SEPARATOR, $path);
}

$media_folders = Array(
	'Media folder for DOCX files' => '\\word\\media',
	'Media folder for PPTX files' => '\\ppt\\media',
	'Media folder for XLSX files' => '\\xl\\media',
	'Media folder for ODT files' => '\\media',
	'Thumbnail folder for ODS files' => '\\Thumbnails',
);
?>@echo off
rem DOCX repacking script using 7zip
rem AUTHOR: grzegorz.adam.kowalski@outlook.com, grzegorz.adam.kowalski@gmail.com

rem Path to 7-zip executable
set COMPRESSOR=<?= proper_directory_separator($_7z_cmd) ?>

rem Path to Touch utility
set TOUCH_UTILITY=<?= proper_directory_separator($touch_cmd) ?>

set TOUCH_OPTIONS=-c -r %1.bak %1

rem Path to PNG optimizer
set PNG_OPTIMIZER=<?= proper_directory_separator($optipng_cmd) ?>

rem Path to JPEG optimizer executable
set JPG_OPTIMIZER=<?= proper_directory_separator($jpegtran_cmd) ?>

rem Folder name with leading backslash
set TEMP_SUBFOLDER=\Docx-Repack

if not exist "%1" goto label_no_input

:decompress
if not exist "%COMPRESSOR%" goto label_no_compressor
"%COMPRESSOR%" x -y -tzip %1 -o%TEMP%%TEMP_SUBFOLDER%

:make_backup
if exist %1.bak del %1.bak
move %1 %1.bak

:optimize_png
if not exist "%PNG_OPTIMIZER%" goto optimize_jpeg

<?php foreach ($media_folders as $comment => $folder): ?>
rem <?php echo $comment; ?>

set MEDIA_FOLDER=%TEMP%%TEMP_SUBFOLDER%<?php echo $folder; ?>

if exist "%MEDIA_FOLDER%" (
	FOR /F %%j IN ('dir /B %MEDIA_FOLDER%\*.png') DO (
		echo "%PNG_OPTIMIZER%" --preserve -o5 %MEDIA_FOLDER%\%%j
		"%PNG_OPTIMIZER%" --preserve -o5 %MEDIA_FOLDER%\%%j
	)
)

<?php endforeach; ?>

:optimize_jpeg
if not exist "%JPG_OPTIMIZER%" goto compress

<?php foreach ($media_folders as $comment => $folder): ?>
rem <?php echo $comment; ?>

set MEDIA_FOLDER=%TEMP%%TEMP_SUBFOLDER%<?php echo $folder; ?>

if exist "%MEDIA_FOLDER%" (
	FOR /F %%j IN ('dir /B %MEDIA_FOLDER%\*.jp*') DO (
		echo %JPG_OPTIMIZER% -optimize %MEDIA_FOLDER%\%%j %MEDIA_FOLDER%\%%j
		%JPG_OPTIMIZER% -optimize %MEDIA_FOLDER%\%%j %MEDIA_FOLDER%\%%j
	)
)
<?php endforeach; ?>

:compress
"%COMPRESSOR%" a -tzip %1 -r %TEMP%%TEMP_SUBFOLDER%\* -mx=9 -mfb=258 -mm=Deflate -mpass=15

:copy_modification_date
if exist "%TOUCH_UTILITY%" "%TOUCH_UTILITY%" %TOUCH_OPTIONS%

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
