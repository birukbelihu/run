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

echo Building windows binary...
set GOOS=windows
go build -o %build_dir% .

echo Building linux binary...
set GOOS=linux
go build -o %build_dir% .

if errorlevel 1 (
   echo run Build failed
   exit /b
)

cd %build_dir%
cls