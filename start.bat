@echo off
title Background Remover
cd /d "%~dp0"

REM Essaie python, puis py (Python Launcher Windows)
where python >nul 2>nul
if %errorlevel% equ 0 (
    python serve.py
    goto :end
)

where py >nul 2>nul
if %errorlevel% equ 0 (
    py serve.py
    goto :end
)

echo.
echo ============================================================
echo   Python n'est pas installe sur votre ordinateur.
echo ============================================================
echo.
echo   Solution la plus simple :
echo   1. Ouvrez le Microsoft Store
echo   2. Cherchez "Python 3"
echo   3. Installez la derniere version (gratuit)
echo   4. Relancez ce fichier
echo.
echo   Ou telechargez Python sur : https://www.python.org/downloads/
echo   (cochez bien "Add Python to PATH" lors de l'installation)
echo.
pause

:end
