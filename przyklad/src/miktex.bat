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
IF x%1x==xx (
  @ECHO This script should not be executed directly. Instead, run the
  @ECHO generate.bat script in the Sample folder to regenerate all
  @ECHO song books in that folder.
  @PAUSE
  GOTO SKIP
)
SET badfile=0
FOR %%I IN (*.tex~) DO IF "%%I"==%1 SET badfile=1
IF %badfile%==1 GOTO SKIP
@ECHO.
@ECHO Compiling %1 [pass %3 of 2]
@ECHO ------------------------------------
"%miktexbin%\pdflatex.exe" -aux-directory="%2" %1
:SKIP
