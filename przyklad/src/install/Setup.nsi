; Songbook Installer NSI Script
;
; Copyright (C) 2017 Kevin W. Hamlen
;
; This program is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version 2
; of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
; MA  02110-1301, USA.
;
; The latest version of this program can be obtained from
; http://songs.sourceforge.net.
;
;
; Instructions
;
; This installation script was designed to be compiled with the NSIS install
; system. NSIS can be freely obtained at http://nsis.sourceforge.net.

!define VERSION "3.0"
!define BUILDNUM "0"

; The following are the names of the source files on the machine that is
; GENERATING the install script (using NSIS):
!define SRCDIR "..\..\src"
!define ICONFILE "setup.ico"
!define UNINSTICON "uninstall.ico"
!define READMETXTPATH "."
!define SAMPLEDIR "..\..\Sample"
!define VIMFILESDIR "${SRCDIR}\vim"
!define HISTORYPATH "${SRCDIR}"
!define LICENSEFILE "license.txt"

; Define global variables
Var MIKTEX
Var MIKTEXBIN
Var INITEXFLAG
Var VIMDIR
Var VIMEXE
Var DO_PKG
Var DO_VIM
Var DO_TEX
Var DO_SBD
Var UninstLog
Var CompletionText


Name "Songbook"
OutFile "songs-${VERSION}-setup.exe"
SetCompressor /SOLID lzma
SetCompressorDictSize 1
RequestExecutionLevel admin
Icon "${ICONFILE}"
UninstallIcon "${UNINSTICON}"

VIAddVersionKey "ProductName" "Songs LaTeX Package"
VIAddVersionKey "FileDescription" "Songs Package Setup"
VIAddVersionKey "CompanyName" "Kevin W. Hamlen"
VIAddVersionKey "LegalCopyright" "© 2017 Kevin W. Hamlen"
VIAddVersionKey "FileVersion" "${VERSION}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIProductVersion "${VERSION}.0.${BUILDNUM}"

BrandingText "Songs Package Setup v${VERSION}"
LicenseText "Welcome to the LaTeX Songs Package Installer! Before proceeding, please quickly review the information below."
LicenseData "${LICENSEFILE}"
ComponentText "Please select the components you wish to install."
InstallDir "$DESKTOP\Songbook"
CompletedText "$CompletionText"
UninstallText "This program will uninstall the Songs package along with its original installation folder. If you also installed MiKTeX and/or Vim, you will have to uninstall those software packages separately using the Add/Remove Programs icon in the Control Panel." "Uninstall folder:"

Page license		; license page
Page components		; components selection page
PageEx directory	; MiKTeX directory locator (if cannot be found)
  DirText "Unable to locate MiKTeX. Please enter the root directory where MiKTeX is installed." "MiKTeX Root Folder" "" "Select the root folder of your MiKTeX installation:"
  Caption ": MiKTeX Folder"
  DirVar $MIKTEX
  PageCallbacks MiKTeXDir "" MiKTeXDirLeave
PageExEnd
PageEx directory	; songbook dir
  DirText "Please choose the directory where you would like to store the files that you will actually manipulate in order to change the song book. By default, a folder named Songbook will be placed on the desktop."
  PageCallbacks SongbookDir "" SongbookDirLeave
PageExEnd
Page instfiles		; installation pane

UninstPage uninstConfirm
UninstPage instfiles


!include "Sections.nsh"
!include "FileFunc.nsh"
!insertmacro GetParameters
!insertmacro GetOptions
!insertmacro RefreshShellIcons
!insertmacro un.RefreshShellIcons



; The following macros save installation info to the uninstall.log file
; so that the uninstaller can avoid removing new or modified files.
; A distinction is made between files stored in a path Relative to
; the install folder and those stored in an Absolute path so that if the
; install folder is moved or renamed between install-time and uninstall-time,
; the uninstaller will still work correctly.

!define LOGNAME "uninstall.log"

; ${RPath} <path>
; Set the current output path to $INSTDIR\<path>
!macro RPath Path
  !undef UninstPath
  !define UninstPath ${Path}
  !undef UninstType
  !define UninstType "R"
  SetOutPath "$INSTDIR\${UninstPath}"
!macroend
!define RPath "!insertmacro RPath"

; ${APath} <path>
; Set the current output path to <path> (an absolute path)
!macro APath Path
  !undef UninstPath
  !define UninstPath ${Path}
  !undef UninstType
  !define UninstType "A"
  SetOutPath "${UninstPath}"
!macroend
!define APath "!insertmacro APath"

; ${File} <srcpath> <name>
; Add source file <srcpath>/<name> to the installer, to be placed in the
; current output path at install-time.  At uninstall time, delete it only
; if it has not been modified.
!macro File SrcPath FileName
  GetFileTimeLocal "${SrcPath}${FileName}" $R8 $R9
  FileWrite $UninstLog "${UninstType}F ${UninstPath}\${FileName}$\r$\nFT $R8$\r$\n"
  File "${SrcPath}${FileName}"
!macroend
!define File "!insertmacro File"

; ${CreateScratchDir} <dirname>
; Create directory <dirname> in the current output path at install-time.
; At uninstall-time, delete it and all files contained therein.
!macro CreateScratchDir DirName
  IfFileExists "$OUTDIR\${DirName}" +3
    FileWrite $UninstLog "${UninstType}S ${UninstPath}\${DirName}$\r$\n"
    CreateDirectory "$OUTDIR\${DirName}"
!macroend
!define CreateScratchDir "!insertmacro CreateScratchDir"

; ${CreatedFile} <name>
; At install-time, record the timestamp of file <name> in the current output
; directory.  At uninstall-time, remove the file if its last modification
; time differs from the recorded timestamp.
!macro CreatedFile FileName
  GetFileTime "$OUTDIR\${FileName}" $R8 $R9
  FileWrite $UninstLog "${UninstType}F ${UninstPath}\${FileName}$\r$\nFT $R8$\r$\n"
!macroend
!define CreatedFile "!insertmacro CreatedFile"

; ${EndDir} <type> <dir>
; If <type> is "R", then at uninstall-time remove directory $INSTDIR\<dir>
; if it is empty.  If <type> is "A", then remove directory <dir> instead.
!macro EndDir Type DirName
  FileWrite $UninstLog "${Type}D ${DirName}$\r$\n"
!macroend
!define EndDir "!insertmacro EndDir"

; ${EndPath}
; Like ${EndDir} except use the <type> and <dir> most recently set by
; ${RPath} or ${APath}.
!define EndPath "!insertmacro EndDir ${UninstType} ${UninstPath}"

!define UninstPath "."
!define UninstType "R"


Section "!Core Software" sec_songbook
  SetOverwrite on
  SetDateSave on

  ; Set up the uninstaller
  CreateDirectory "$INSTDIR"
  IfFileExists "$INSTDIR\${LOGNAME}" setlogattrs
  FileOpen $UninstLog "$INSTDIR\${LOGNAME}" w
  Goto openlogdone
setlogattrs:
  SetFileAttributes "$INSTDIR\${LOGNAME}" NORMAL
  FileOpen $UninstLog "$INSTDIR\${LOGNAME}" a
  FileSeek $UninstLog 0 END
openlogdone:
  SetOutPath "$INSTDIR"
  WriteUninstaller "uninstall.exe"
  ${CreatedFile} "uninstall.exe"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Songs Package" "DisplayName" "Songs Package"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Songs Package" "UninstallString" "$INSTDIR\uninstall.exe"

  ; install files and folders in the Songbook directory

  ${RPath} "Sample"
    ${File} "${SAMPLEDIR}\" "chordbook.tex"
    ${File} "${SAMPLEDIR}\" "lyricbook.tex"
    ${File} "${SAMPLEDIR}\" "slidebook.tex"
    ${File} "${SAMPLEDIR}\" "transparencies.tex"
    ${File} "${SAMPLEDIR}\" "generate.bat"
    ${File} "${SAMPLEDIR}\" "songs.sbd"
    ${CreateScratchDir} "temp"
  ${EndPath}

  ${RPath} "src\install"
    ${File} ".\" "${__FILE__}"
    ${File} ".\" "${LICENSEFILE}"
    ${File} ".\" "${ICONFILE}"
    ${File} ".\" "${UNINSTICON}"
  ${EndPath}

  ${RPath} "src\readme"
    ${File} "${SRCDIR}\readme\" "README.tex"
    ${File} "${SRCDIR}\readme\" "tbar.png"
    ${File} "${SRCDIR}\readme\" "sbdshot.png"
    ${File} "${SRCDIR}\readme\" "texshot.png"
    ${File} "${SRCDIR}\readme\" "generate.bat"
    ${CreateScratchDir} "temp"
  ${EndPath}

  ${RPath} "src\songidx"
    ${File} "${SRCDIR}\songidx\" "songidx.lua"
    ${File} "${SRCDIR}\songidx\" "bible.can"
    ${File} "${SRCDIR}\songidx\" "catholic.can"
    ${File} "${SRCDIR}\songidx\" "greek.can"
    ${File} "${SRCDIR}\songidx\" "protestant.can"
    ${File} "${SRCDIR}\songidx\" "tanakh.can"
  ${EndPath}

  ${RPath} "src\package\songs"
    ${File} "${SRCDIR}\package\songs\" "buildsty.bat"
    ${File} "${SRCDIR}\package\songs\" "builddoc.bat"
    ${File} "${SRCDIR}\package\songs\" "songs.sty"
    ${File} "${SRCDIR}\package\songs\" "songs.dtx"
    ${File} "${SRCDIR}\package\songs\" "songs.ins"
    ${CreateScratchDir} "temp"
  ${EndPath}
  ${EndDir} "R" "src\package"

  ${RPath} "src\vim\syntax"
    ${File} "${VIMFILESDIR}\syntax\" "songbook.vim"
  ${EndPath}
  ${RPath} "src\vim\ftdetect"
    ${File} "${VIMFILESDIR}\ftdetect\" "sbd.vim"
  ${EndPath}
  ${RPath} "src\vim\bitmaps"
    ${File} "${VIMFILESDIR}\bitmaps\" "sgen.bmp"
    ${File} "${VIMFILESDIR}\bitmaps\" "qcon.bmp"
    ${File} "${VIMFILESDIR}\bitmaps\" "qcoff.bmp"
  ${EndPath}
  ${RPath} "src\vim\ftplugin"
    ${File} "${VIMFILESDIR}\ftplugin\" "songbook.vim"
    ${File} "${VIMFILESDIR}\ftplugin\" "tex.vim"
  ${EndPath}
  ${RPath} "src\vim\spell"
    ${File} "${VIMFILESDIR}\spell\" "songbook.latin1.spl"
    ${File} "${VIMFILESDIR}\spell\" "wordlist.txt"
  ${EndPath}

  ${EndDir} "R" "src\vim"

  ${RPath} "src"
    ${File} "${HISTORYPATH}\" "history.txt"
    ${File} "${SRCDIR}\" "miktex.bat"

    FileOpen $R0 "$INSTDIR\src\paths.bat" "w"
    FileWrite $R0 `@SET miktexpath=$MIKTEX$\r$\n@SET miktexbin=%miktexpath%\miktex\bin$\r$\n@IF EXIST "%miktexpath%\miktex\bin\x64\pdflatex.exe" SET miktexbin=%miktexpath%\miktex\bin\x64`
    FileClose $R0
    ${CreatedFile} "paths.bat"
  ${EndPath}

  ${RPath} "."
    ${File} "${READMETXTPATH}\" "README.txt"
  ${EndPath}
SectionEnd



SectionGroup "!Software Integration"

Section "MiKTeX Package Files"
  IntCmp $DO_PKG 0 +1 +2 +2
    Return
  ; Install the songs MiKTeX package
  ${APath} "$MIKTEX\tex\latex\songs"
    ${File} "${SRCDIR}\package\songs\" "songs.sty"
  ${EndPath}
  StrCpy $INITEXFLAG 1  ; run initexmf after completed
SectionEnd

Section "Vim Plug-ins"
  IntCmp $DO_VIM 0 +1 +2 +2
    Return
  ; Install Vim support files
  Call FindVim
  IfFileExists "$VIMDIR\vimfiles" +2 +1
    Return
  ${APath} "$VIMDIR\vimfiles\syntax"
    ${File} "${VIMFILESDIR}\syntax\" "songbook.vim"
  ${EndPath}
  ${APath} "$VIMDIR\vimfiles\ftdetect"
    ${File} "${VIMFILESDIR}\ftdetect\" "sbd.vim"
  ${EndPath}
  ${APath} "$VIMDIR\vimfiles\bitmaps"
    ${File} "${VIMFILESDIR}\bitmaps\" "sgen.bmp"
    ${File} "${VIMFILESDIR}\bitmaps\" "qcon.bmp"
    ${File} "${VIMFILESDIR}\bitmaps\" "qcoff.bmp"
  ${EndPath}
  ${APath} "$VIMDIR\vimfiles\ftplugin"
    ${File} "${VIMFILESDIR}\ftplugin\" "songbook.vim"
    ${File} "${VIMFILESDIR}\ftplugin\" "tex.vim"
  ${EndPath}
  ${APath} "$VIMDIR\vimfiles\spell"
    ${File} "${VIMFILESDIR}\spell\" "songbook.latin1.spl"
  ${EndPath}
SectionEnd

SectionGroupEnd



SectionGroup "Create File Associations"

Section "Associate .tex files" sec_tex
  IntCmp $DO_TEX 0 +1 +2 +2
    Return
  ; Create .tex associations
  Call FindVim
  IfFileExists "$VIMEXE" +2 +1
    Return
  WriteRegStr HKCR ".tex" "" "texfiles"
  WriteRegStr HKCR "texfiles\shell\Open\command" "" `"$VIMEXE" -y "%1"`
SectionEnd

Section "Associate .sbd files" sec_sbd
  IntCmp $DO_SBD 0 +1 +2 +2
    Return
  ; Create .sbd associations
  Call FindVim
  IfFileExists "$VIMEXE" +2 +1
    Return
  WriteRegStr HKCR ".sbd" "" "songbookdata"
  WriteRegStr HKCR "songbookdata\shell\Open\command" "" `"$VIMEXE" -y "%1"`
SectionEnd

SectionGroupEnd






Section
  FileClose $UninstLog
  SetFileAttributes "$INSTDIR\${LOGNAME}" READONLY|SYSTEM|HIDDEN

  IntCmp $INITEXFLAG 0 skipinitex
  IfFileExists "$MIKTEXBIN\initexmf.exe" +1 skipinitex
  ClearErrors
  FileOpen $R0 "$TEMP\initexmf.bat" w
  IfErrors skipinitex
  FileWrite $R0 `@echo Please wait while MiKTeX refreshes its filename database...$\r$\n@echo (This can take a few minutes, depending on your disk drive speed.)$\r$\n@"$MIKTEXBIN\initexmf.exe" --admin -u$\r$\n@EXIT`
  FileClose $R0
  ExecWait `"$TEMP\initexmf.bat"`
  Delete "$TEMP\initexmf.bat"
skipinitex:
  IfFileExists "$MIKTEXBIN\pdflatex.exe" +1 skipdocgen
  ClearErrors
  SetOutPath "$INSTDIR\src\package\songs"
  ExecWait `"$INSTDIR\src\package\songs\builddoc.bat" -nopause`
  IfErrors +2
    CreateShortCut "$INSTDIR\Reference Manual.lnk" "$INSTDIR\src\package\songs\songs.pdf"
  ClearErrors
  SetOutPath "$INSTDIR\src\readme"
  ExecWait `"$INSTDIR\src\readme\generate.bat" -nopause`
  IfErrors +2
    CreateShortCut "$INSTDIR\Tutorial.lnk" "$INSTDIR\src\readme\readme.pdf"
  SetOutPath "$INSTDIR\Sample"
  ExecWait `"$INSTDIR\Sample\generate.bat" -nopause`
skipdocgen:
  ${RefreshShellIcons}
SectionEnd



Section "Uninstall"
  StrCpy $CompletionText "Uninstallation complete!"
  ; Remove registry entries (extensions and application keys)
  DeleteRegKey HKLM "SOFTWARE\Songs Package"
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Songs Package"
  ReadRegStr $R0 HKLM "SOFTWARE\Classes\.tex" ""
  StrCmp $R0 "texfiles" +1 +2
    DeleteRegKey HKLM "SOFTWARE\Classes\.tex"
  ReadRegStr $R0 HKCU "SOFTWARE\Classes\.tex" ""
  StrCmp $R0 "texfiles" +1 +2
    DeleteRegKey HKCU "SOFTWARE\Classes\.tex"
  DeleteRegKey HKLM "SOFTWARE\Classes\texfiles"
  DeleteRegKey HKCU "SOFTWARE\Classes\texfiles"
  ReadRegStr $R0 HKLM "SOFTWARE\Classes\.sbd" ""
  StrCmp $R0 "songbookdata" +1 +2
    DeleteRegKey HKLM "SOFTWARE\Classes\.sbd"
  ReadRegStr $R0 HKCU "SOFTWARE\Classes\.sbd" ""
  StrCmp $R0 "songbookdata" +1 +2
    DeleteRegKey HKCU "SOFTWARE\Classes\.sbd"
  DeleteRegKey HKLM "SOFTWARE\Classes\songbookdata"
  DeleteRegKey HKCU "SOFTWARE\Classes\songbookdata"
  ${un.RefreshShellIcons}

  ; Delete temp files
  Delete "$INSTDIR\*.lnk"
  Delete "$INSTDIR\Sample\*.sbd~"
  Delete "$INSTDIR\Sample\*.tex~"
  Delete "$INSTDIR\Sample\*.pdf"
  Delete "$INSTDIR\src\readme\readme.pdf"
  Delete "$INSTDIR\src\package\songs\songs.pdf"

  ; Remove all other files that have not been modified since installation
  IfFileExists "$INSTDIR\${LOGNAME}" +3
    MessageBox MB_OK|MB_ICONSTOP "File ${LOGNAME} is missing; please delete folder '$INSTDIR' manually."
    Abort
  SetFileAttributes "$INSTDIR\${LOGNAME}" NORMAL
  FileOpen $UninstLog "$INSTDIR\${LOGNAME}" r
logloop:
  ClearErrors
  FileRead $UninstLog $R0
  IfErrors logloopdone
  StrCpy $R1 $R0 1
  StrCpy $R2 $R0 2 1
  StrCpy $R0 $R0 -2 3
  StrCmp $R1 "A" abspath
  StrCmp $R1 "R" +1 badlog
  StrCpy $R0 "$INSTDIR\$R0"
abspath:
  StrCmp $R2 "D " deldir
  StrCmp $R2 "F " delfile
  StrCmp $R2 "S " delsdir
badlog:
  MessageBox MB_OK|MB_ICONSTOP "File ${LOGNAME} is corrupt. Aborting uninstall."
  Abort
delsdir:
  RMDir /r "$R0"
  Goto logloop
deldir:
  Delete "$R0\desktop.ini"
  RMDir "$R0"
  Goto logloop
delfile:
  GetFileTime "$R0" $R1 $R2
  FileRead $UninstLog $R3
  StrCpy $R4 $R3 3
  StrCmp $R4 "FT " +1 badlog
  StrCmp "FT $R1$\r$\n" $R3 +1 +3
    Delete "$R0"
    Goto logloop
  DetailPrint "Retaining modified $R0"
  Goto logloop
logloopdone:
  FileClose $UninstLog
  Delete "$INSTDIR\${LOGNAME}"
  Delete "$INSTDIR\install.log"
  Delete "$INSTDIR\desktop.ini"
  RMDir "$INSTDIR"
  Sleep 500
  IfFileExists "$INSTDIR" +1 +2
    MessageBox MB_OK|MB_ICONINFORMATION "New or modified files in '$INSTDIR' have not been deleted. Delete the folder manually if desired."
SectionEnd



!define IID_ISESSION {8BE9F539-B949-4C7B-991C-DB6C6F737EC7}
Function FindMiKTeX
  IfFileExists "$MIKTEXBIN\pdflatex.exe" foundmiktex +1
  ClearErrors
  ReadRegStr $R0 HKCR "MiKTeX.Session\CLSID" ""
  IfErrors trymiktexdir64
  System::Call "ole32::CoCreateInstance(g '$R0', i 0, i 23, g '${IID_ISESSION}', *i .R0) i.R2"
  StrCmp $R2 0 +1 trymiktexdir64
  System::Call "*(i, w, i, w, i, w, w, w, w, w) i .R1"
  System::Call "$R0->10(i R1) i .R2"
  System::Call "*$R1(i, w, i, w, i, w .s, w, w, w, w)"
  Pop $MIKTEX
  System::Free $R1
  System::Call "$R0->2() i"
  StrCmp $R2 0 +1 trymiktexdir64
  IfFileExists "$MIKTEX\miktex\bin\x64\pdflatex.exe" foundmiktex +1
  IfFileExists "$MIKTEX\miktex\bin\pdflatex.exe" foundmiktex +1
  StrCmp $PROGRAMFILES64 "" trymiktexdir32 +1
trymiktexdir64:
  FindFirst $R0 $R1 "$PROGRAMFILES64\MiKTeX*"
miktexdirloop64:
  StrCmp $R1 "" trymiktexdir32
  StrCpy $MIKTEX "$PROGRAMFILES64\$R1"
  IfFileExists "$MIKTEX\miktex\bin\x64\pdflatex.exe" +2 +1
  IfFileExists "$MIKTEX\miktex\bin\pdflatex.exe" +1 miktexdirloop64
  FindClose $R0
  Goto foundmiktex
trymiktexdir32:
  FindFirst $R0 $R1 "$PROGRAMFILES\MiKTeX*"
miktexdirloop32:
  StrCmp $R1 "" trymiktexreg
  StrCpy $MIKTEX "$PROGRAMFILES\$R1"
  IfFileExists "$MIKTEX\miktex\bin\x64\pdflatex.exe" +2 +1
  IfFileExists "$MIKTEX\miktex\bin\pdflatex.exe" +1 miktexdirloop32
  FindClose $R0
  Goto foundmiktex
trymiktexreg:
  ClearErrors
  ReadRegStr $MIKTEX HKCU "SOFTWARE\MiK\MiKTeX\CurrentVersion\MiKTeX" "Install Root"
  IfErrors +3 +1
    IfFileExists "$MIKTEX\miktex\bin\x64\pdflatex.exe" foundmiktex +1
    IfFileExists "$MIKTEX\miktex\bin\pdflatex.exe" foundmiktex +1
  ClearErrors
  ReadRegStr $MIKTEX HKLM "SOFTWARE\MiK\MiKTeX\CurrentVersion\MiKTeX" "Install Root"
  IfErrors +3 +1
    IfFileExists "$MIKTEX\miktex\bin\x64\pdflatex.exe" foundmiktex +1
    IfFileExists "$MIKTEX\miktex\bin\pdflatex.exe" foundmiktex +1
  StrCpy $MIKTEX "C:\texmf"
foundmiktex:
  StrCpy $MIKTEXBIN "$MIKTEX\miktex\bin"
  IfFileExists "$MIKTEX\miktex\bin\x64\pdflatex.exe" +1 +2
    StrCpy $MIKTEXBIN "$MIKTEX\miktex\bin\x64"
FunctionEnd

Function FindVim
  IfFileExists $VIMEXE findvimdir
  ClearErrors
  ReadRegStr $R0 HKCU "SOFTWARE\Classes\Vim.Application\CLSID" ""
  IfErrors findvimhklm
  ReadRegStr $VIMEXE HKCU "SOFTWARE\Classes\CLSID\$R0\LocalServer32" ""
  IfErrors findvimhklm
  IfFileExists $VIMEXE findvimdir
findvimhklm:
  ClearErrors
  ReadRegStr $R0 HKLM "SOFTWARE\Classes\Vim.Application\CLSID" ""
  IfErrors vimdefaults
  ReadRegStr $VIMEXE HKLM "SOFTWARE\Classes\CLSID\$R0\LocalServer32" ""
  IfErrors vimdefaults
  IfFileExists $VIMEXE findvimdir vimdefaults
findvimdir:
  StrCpy $R0 $VIMEXE 1
  StrCmp $R0 `"` +1 +2
    StrCpy $VIMEXE $VIMEXE "" 1
  StrCpy $R0 $VIMEXE -1
  StrCmp $R0 `"` +1 +2
    StrCpy $VIMEXE $VIMEXE -1
  StrCpy $VIMDIR $VIMEXE
findvimloop1:
  StrCmp $VIMDIR "" vimdefaults
  StrCpy $R0 $VIMDIR "" -1
  StrCmp $R0 "\" findvimloop2 +1
  StrCpy $VIMDIR $VIMDIR -1
  Goto findvimloop1
findvimloop2:
  StrCpy $VIMDIR $VIMDIR -1
  StrCmp $VIMDIR "" vimdefaults
  StrCpy $R0 $VIMDIR "" -1
  StrCmp $R0 "\" +1 findvimloop2
  StrCpy $VIMDIR $VIMDIR -1
  IfFileExists "$VIMDIR\vimfiles" foundvim vimdefaults
vimdefaults:
  StrCpy $VIMDIR "$PROGRAMFILES\Vim"
foundvim:
FunctionEnd

Function MiKTeXDir
  Call FindMiKTeX
  IfFileExists "$MIKTEXBIN\pdflatex.exe" +1 +2
    Abort
FunctionEnd

Function MiKTeXDirLeave
  IfFileExists "$MIKTEXBIN\pdflatex.exe" +1 +2
    Return
  MessageBox MB_ABORTRETRYIGNORE|MB_ICONEXCLAMATION|MB_DEFBUTTON2 `The path "$MIKTEX" does not contain a valid MiKTeX installation. Completing this installation before installing MiKTeX will cause many important features to be omitted. Click "Abort" to abort this installer and install MiKTeX. Click "Retry" to try a different folder. Or click "Ignore" to proceed with the installation (omitting all MiKTeX features).` /SD IDIGNORE IDABORT miktexdirquit IDIGNORE miktexdirignore
  Abort
miktexdirquit:
  Quit
miktexdirignore:
FunctionEnd

Function SongbookDir
  SectionGetFlags ${sec_songbook} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  IntCmp $R0 0 +1 +2 +2
    Abort
FunctionEnd

Function SongbookDirLeave
  IfFileExists "$INSTDIR" +1 songbookdirignore
  MessageBox MB_ABORTRETRYIGNORE|MB_ICONEXCLAMATION|MB_DEFBUTTON2 `The folder "$INSTDIR" already exists. Are you sure you want to overwrite it? Click "Ignore" to overwrite any older files there with newer files. Click "Retry" to install to a different folder name. Click "Abort" to abort this installation.` /SD IDIGNORE IDABORT songbookdirquit IDIGNORE songbookdirignore
  Abort
songbookdirquit:
  Quit
songbookdirignore:
FunctionEnd

Function .onGUIInit
  ClearErrors
  ReadRegStr $R0 HKCR ".tex" ""
  IfErrors checksbd
  ClearErrors
  ReadRegStr $R1 HKCR "$R0\shell\Open\command" ""
  IfErrors checksbd
  SectionGetFlags ${sec_tex} $R0
  IntOp $R0 $R0 & ${SECTION_OFF}
  SectionSetFlags ${sec_tex} $R0
checksbd:
  ClearErrors
  ReadRegStr $R0 HKCR ".sbd" ""
  IfErrors initdone
  ClearErrors
  ReadRegStr $R1 HKCR "$R0\shell\Open\command" ""
  IfErrors initdone
  SectionGetFlags ${sec_sbd} $R0
  IntOp $R0 $R0 & ${SECTION_OFF}
  SectionSetFlags ${sec_sbd} $R0
initdone:
FunctionEnd

Function .onInit
  StrCpy $CompletionText "Installation complete!"
  ${GetParameters} $R0
  ${GetOptions} $R0 "/MIKTEX=" $MIKTEX
  ${GetOptions} $R0 "/VIM=" $VIMEXE
  StrCpy $DO_PKG 1
  StrCpy $DO_VIM 1
  StrCpy $DO_TEX 1
  StrCpy $DO_SBD 1
  StrCpy $INITEXFLAG 0  ; do not run initexmf by default
  IfSilent +2 +1
    Return
  ; The following command-line options are for silent installations only
  ClearErrors
  ${GetOptions} $R0 "/PKG-" $R1		; do not install MiKTeX packages
  IfErrors +2
    StrCpy $DO_PKG 0
  ClearErrors
  ${GetOptions} $R0 "/VIM-" $R1		; do not install Vim plug-ins
  IfErrors +2
    StrCpy $DO_VIM 0
  ClearErrors
  ${GetOptions} $R0 "/TEX-" $R1		; do not associate .tex files
  IfErrors +2
    StrCpy $DO_TEX 0
  ClearErrors
  ${GetOptions} $R0 "/SBD-" $R1		; do not associate .sbd files
  IfErrors +2
    StrCpy $DO_SBD 0
FunctionEnd

!macro MOUSEOVER msg
  !ifndef MOID
    !define MOID 0
  !endif
  StrCmp $0 ${MOID} +1 +2
    SendMessage $R0 0x000C 0 'STR:Select components to install:$\r$\n$\r$\n${msg}'
  !define /math MOID2 ${MOID} + 1
  !undef MOID
  !define MOID ${MOID2}
  !undef MOID2
!macroend
!define MouseOver "!insertmacro MOUSEOVER"

Function .onMouseOverSection
  FindWindow $R0 "#32770" "" $HWNDPARENT
  GetDlgItem $R0 $R0 0x000003FE
  ${MouseOver} `The "Core Software" includes the song book files themselves along with related runtime tools. (required)`
  ${MouseOver} `The "Software Integration" components install the software required to use the Songbook Software with MiKTeX and Vim.`
  ${MouseOver} `The "MiKTeX Package Files" must be installed in order to generate song books using MiKTeX. (required)`
  ${MouseOver} `The "Vim Plug-ins" allow song book files to be edited using Vim. (highly recommended)`
  ${MouseOver} ``
  ${MouseOver} `Check the "Create File Associations" box to associate .tex and .sbd files with Vim.`
  ${MouseOver} `Check the "Associate .tex files" box to cause .tex files to be opened by Vim. (recommended)`
  ${MouseOver} `Check the "Associate .sbd files" box to cause .sbd files to be opened by Vim. (recommended)`
  ${MouseOver} ``
FunctionEnd

Function .onInstSuccess
  IfFileExists "$INSTDIR\README.pdf" +1 noreadme
  MessageBox MB_YESNO|MB_ICONQUESTION `Show readme file after exiting?` IDNO noreadme
  ExecShell "" `"$INSTDIR\README.pdf"`
noreadme:
FunctionEnd
