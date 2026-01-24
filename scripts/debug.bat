@echo off

set build_dir="build"

cd ..

if not exist "%build_dir%" (
   mkdir %build_dir%

   if errorlevel 1 (
   echo Build folder creation failed
   exit /b
 )
)

go build -o %build_dir% .
set GOOS=linux&&set GOARCH=amd64&&go build -o %build_dir% .

if errorlevel 1 (
   echo run Build failed
   exit /b
)

cd %build_dir%
cls