@REM Copyright (C) 2017 Kevin W. Hamlen
@REM
@REM This program is free software; you can redistribute it and/or
@REM modify it under the terms of the GNU General Public License
@REM as published by the Free Software Foundation; either version 2
@REM of the License, or (at your option) any later version.
@REM
@REM This program is distributed in the hope that it will be useful,
@REM but WITHOUT ANY WARRANTY; without even the implied warranty of
@REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@REM GNU General Public License for more details.
@REM
@REM You should have received a copy of the GNU General Public License
@REM along with this program; if not, write to the Free Software
@REM Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
@REM MA  02110-1301, USA.
@REM
@REM The latest version of this program can be obtained from
@REM http://songs.sourceforge.net.
@REM
@ECHO off
CALL ..\..\paths.bat
@IF EXIST songs.pdf del songs.pdf
@IF NOT EXIST songs.pdf GOTO MAIN
@ECHO                                   ------
@ECHO The songs package documentation cannot be regenerated because another program
@ECHO (probably Adobe Acrobat Reader) is currently accessing songs.pdf. Please
@ECHO close that program first and then try again.
@GOTO DONE
:MAIN
@SET auxdir=temp
@SET latex="%miktexbin%\pdflatex.exe"
%latex% -aux-directory="%auxdir%" songs.dtx
@IF ERRORLEVEL 1 GOTO FAILED
"%miktexbin%\makeindex.exe" -s gind.ist -o "%auxdir%\songs.ind" "%auxdir%\songs.idx"
"%miktexbin%\makeindex.exe" -s gglo.ist -o "%auxdir%\songs.gls" "%auxdir%\songs.glo"
%latex% -aux-directory="%auxdir%" songs.dtx
@IF ERRORLEVEL 1 GOTO FAILED
"%miktexbin%\makeindex.exe" -s gind.ist -o "%auxdir%\songs.ind" "%auxdir%\songs.idx"
"%miktexbin%\makeindex.exe" -s gglo.ist -o "%auxdir%\songs.gls" "%auxdir%\songs.glo"
%latex% -aux-directory="%auxdir%" songs.dtx
@IF ERRORLEVEL 1 GOTO FAILED
@ECHO Completed successfully!
@GOTO DONE
:FAILED
@ECHO.
:DONE
@IF "%1"=="-nopause" (EXIT) ELSE PAUSE
