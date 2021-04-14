@echo off

set arg1=%lab4
tasm %arg1%.asm
pause
tlink %arg1%.obj
pause
td %arg1%.exe
REM pause
REM %arg1%.exe