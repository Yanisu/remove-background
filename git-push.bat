@echo off
REM ============================================================
REM   Connecte le depot local a GitHub et pousse le code.
REM   A executer apres git-init.bat et apres avoir cree
REM   le depot sur https://github.com/new
REM ============================================================

title Push vers GitHub - Background Remover
cd /d "%~dp0"

where git >nul 2>nul
if %errorlevel% neq 0 (
    echo Git n'est pas installe.
    pause
    exit /b 1
)

if not exist ".git" (
    echo Aucun depot git trouve dans ce dossier.
    echo Lance d'abord "git-init.bat".
    pause
    exit /b 1
)

echo.
echo Colle l'URL HTTPS de ton depot GitHub
echo Exemple : https://github.com/yanischeze/background-remover.git
echo.
set /p REPO_URL="URL : "

if "%REPO_URL%"=="" (
    echo URL vide. Abandon.
    pause
    exit /b 1
)

echo.
echo === Configuration du remote ===
git remote remove origin 2>nul
git remote add origin %REPO_URL%
git remote -v

echo.
echo === Push initial vers main ===
git branch -M main
git push -u origin main

echo.
echo ============================================================
echo   Termine. Le code est sur GitHub.
echo ============================================================
pause
