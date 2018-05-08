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
call ..\..\paths.bat
@set auxdir=temp
@IF EXIST "%auxdir%\songs.sty" del "%auxdir%\songs.sty"
@IF NOT EXIST "%auxdir%\songs.sty" GOTO MAIN
@echo                                   ------
@echo The songs package file cannot be regenerated because another program
@echo is currently accessing songs.sty. Please close that program first and
@echo then try again.
@GOTO DONE
:MAIN
"%miktexbin%\latex.exe" -aux-directory="%auxdir%" songs.ins
@IF ERRORLEVEL 1 GOTO FAILED
MOVE /Y "%auxdir%\songs.sty" .
@echo Completed successfully!
@GOTO DONE
:FAILED
@echo.
:DONE
@pause
