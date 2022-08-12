:: ------ Batch file to read a video file and convert to flv using ffmpeg
:: don't print out commands
echo off
setlocal enabledelayedexpansion

set ffmpeg="%~dp0\tools\ffmpeg-20161221-54931fd-win64-static\bin\ffmpeg.exe" 

set argCount=0
for %%x in (%*) do (
  set /A argCount+=1
  set "argVec[!argCount!]=%%~x"
)

for /L %%i in (1,1,%argCount%) do (
  color E0

  set infile=!argVec[%%i]!
  for /F "delims=" %%i in ("!argVec[%%i]!") do @set basename=%%~ni
  set "mp4=!basename!.mp4"
  set "mp4_tmp=!basename!-tmp.mp4"

  title "Optimize Video for Web Streaming (!mp4!)"

  :: %ffmpeg% -i !infile! -c:v copy -c:a aac -strict experimental -b:a 128k !mp4_tmp!
  :: %ffmpeg% -y -i !infile! -strict experimental -pix_fmt yuv420p -profile:v baseline -level 3.0 -acodec aac -ar 44100 -ac 2 -ab 128k -vf "scale=720:480" -async 1 -movflags faststart !mp4_tmp!
  %ffmpeg% -y -i !infile! -strict experimental -pix_fmt yuv420p -profile:v baseline -level 3.0 -acodec aac -ar 44100 -ac 2 -ab 128k -async 1 -movflags faststart !mp4_tmp! 
  if errorlevel 1 goto :abort

  del !mp4!
  del !infile!
  rename !mp4_tmp! !mp4!
  if errorlevel 1 goto :abort
  color A0 
  echo "Success!"
)

title "Process Complete!"
color A0
pause
exit

:: ---------------------------------------------------------------------------------------------------------------------

:abort
color CF
del %mp4_tmp%
echo " "
echo "Problem! See window output"
pause
exit
