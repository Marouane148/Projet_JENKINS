@echo off
REM Script pour configurer ngrok + GitHub Webhook
REM Usage: ngrok-setup.bat

setlocal enabledelayedexpansion

cls
echo.
echo ========================================
echo ngrok + GitHub Webhook Setup
echo ========================================
echo.

REM ===================================================
REM ÉTAPE 1 : Vérifier ngrok
REM ===================================================

echo [STEP 1] Verification de ngrok...

ngrok version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] ngrok n'est pas installe
    echo.
    echo Pour installer ngrok :
    echo   Option A: winget install ngrok
    echo   Option B: Telecharger depuis https://ngrok.com/download
    echo.
    pause
    exit /b 1
) else (
    echo [OK] ngrok est installe
)

REM ===================================================
REM ÉTAPE 2 : Configurer le token
REM ===================================================

echo.
echo [STEP 2] Configuration du token ngrok...
echo.
echo Get it from: https://dashboard.ngrok.com/auth/your-authtoken
echo.
set /p AUTHTOKEN="Entrez votre ngrok AuthToken: "

if "%AUTHTOKEN%"=="" (
    echo [ERROR] Token requis !
    pause
    exit /b 1
)

ngrok config add-authtoken %AUTHTOKEN%
echo [OK] Token configure
echo.

REM ===================================================
REM ÉTAPE 3 : Conseils pour la suite
REM ===================================================

echo [STEP 3] Information importante...
echo.
echo ngrok http 8080 va etre lance.
echo.
echo Une fois lance :
echo   1. Copier l'URL ngrok publique (https://xxxx.ngrok-free.app)
echo   2. Aller au depot GitHub: https://github.com/Marouane148/Projet_JENKINS
echo   3. Settings -^> Webhooks -^> Add webhook
echo   4. Payload URL: https://xxxx.ngrok-free.app/github-webhook/
echo   5. Content type: application/json
echo   6. Trigger: Just the push event
echo.
pause

echo.
echo [START] Demarrage de ngrok...
echo.

ngrok http 8080

REM Note: ngrok s'exécutera et bloquera le terminal jusqu'à l'arrêt (CTRL+C)
