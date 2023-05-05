docx-repack
===========

Batch script to re-compress DOCX, XLSX, PPTX, ODT and ODS files so their size is smaller and they can be still opened by Microsoft Office without any additional actions. Script decompresses document file, optimizes image files (JPEG and PNG) archived inside and compresses it all again but with stronger compression.

Required:
* MS Windows
* [7-zip](http://www.7-zip.org/)

Optional (for date-time preserving):
* nabiy's ["touch"](http://sourceforge.net/projects/touchforwindows/) utility or any other compatible

Optional (for image optimization):
* [OptiPNG](http://optipng.sourceforge.net/)
* [jpegtrans](http://jpegclub.org/jpegtran/).

Usage
=====

```
repack.bat target_file.docx
```

Original file will be renamed to `target_file.docx.bak`.


To-Do-List
==========

* Add options for enable/disable file overwrite and backup deletion
* Recognizing corrupted ZIP archives
* Automatic component download (perhaps using some VB script?)
* Reg script to add "Repack" option to context menu