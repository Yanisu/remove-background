@echo off
REM ============================================================
REM   Initialise le depot git et fait le premier commit.
REM   A executer une seule fois, au tout debut.
REM ============================================================

title Init Git - Background Remover
cd /d "%~dp0"

REM Verifier que git est installe
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo.
    echo Git n'est pas installe sur cette machine.
    echo Telechargez-le sur : https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

REM Si un .git partiel existe deja (suite a un init rate), on le nettoie
if exist ".git" (
    echo Nettoyage d'un .git existant...
    rmdir /s /q ".git"
)

echo.
echo === Configuration de git (locale au projet) ===
git config --local user.email "yanis.cheze@open-lake.com"
git config --local user.name "Yanis Cheze"

echo.
echo === Initialisation du depot ===
git init -b main
if %errorlevel% neq 0 (
    echo Echec de l'init.
    pause
    exit /b 1
)

REM Reapplique la config locale apres init
git config --local user.email "yanis.cheze@open-lake.com"
git config --local user.name "Yanis Cheze"

echo.
echo === Ajout des fichiers ===
git add .
git status

echo.
echo === Premier commit ===
git commit -m "Initial commit: Background Remover (BRIA RMBG-1.4)"

echo.
echo ============================================================
echo   Depot pret !
echo.
echo   Etapes suivantes pour publier sur GitHub :
echo.
echo   1. Cree un nouveau depot sur https://github.com/new
echo      (sans README, sans .gitignore, sans licence)
echo.
echo   2. Lance ensuite "git-push.bat" en collant l'URL HTTPS
echo      du depot quand demande.
echo.
echo ============================================================
pause
