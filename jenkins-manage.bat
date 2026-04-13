@echo off
REM Script de gestion Jenkins pour Windows (Command Prompt)
REM Usage: jenkins-manage.bat start|stop|restart|logs|password|status|clean

setlocal enabledelayedexpansion
cd /d C:\projet_jenkins\ICDE848

if "%1"=="" (
    echo.
    echo Usage: jenkins-manage.bat [start^|stop^|restart^|logs^|password^|status^|clean]
    echo.
    echo Exemples:
    echo   jenkins-manage.bat start     - Demarrer Jenkins
    echo   jenkins-manage.bat stop      - Arreter Jenkins
    echo   jenkins-manage.bat restart   - Redemarrer Jenkins
    echo   jenkins-manage.bat status    - Verifier l'etat
    echo   jenkins-manage.bat logs      - Voir les logs
    echo   jenkins-manage.bat password  - Obtenir le mot de passe initial
    echo   jenkins-manage.bat clean     - Nettoyer (supprime les donnees!)
    echo.
    goto :end
)

if "%1"=="start" (
    echo.
    echo [*] Demarrage de Jenkins...
    docker-compose up -d
    echo [+] Jenkins demarre...
    echo [!] Attendre 30-60 secondes avant d'acceder a Jenkins
    echo [>] Jenkins: http://localhost:8080
    echo.
    goto :end
)

if "%1"=="stop" (
    echo.
    echo [*] Arret de Jenkins...
    docker-compose down
    echo [+] Jenkins arrete
    echo.
    goto :end
)

if "%1"=="restart" (
    echo.
    echo [*] Redemarrage de Jenkins...
    docker-compose restart jenkins
    echo [+] Jenkins redemarri
    echo [!] Attendre quelques secondes...
    echo.
    goto :end
)

if "%1"=="logs" (
    echo.
    echo [*] Logs de Jenkins (CTRL+C pour quitter)
    echo.
    docker-compose logs -f jenkins
    goto :end
)

if "%1"=="password" (
    echo.
    echo [*] Recuperation du mot de passe initial...
    echo.
    for /f "delims=" %%i in ('docker exec jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword') do (
        set PASSWORD=%%i
    )
    if defined PASSWORD (
        echo [+] Mot de passe initial:
        echo.
        echo     !PASSWORD!
        echo.
        echo [>] Copier ce mot de passe pour acceder a Jenkins
    ) else (
        echo [-] Erreur: Jenkins n'est peut-etre pas demarr ou n'est pas pret
        echo [!] Lancez: jenkins-manage.bat start
    )
    echo.
    goto :end
)

if "%1"=="status" (
    echo.
    echo [*] Etat de Jenkins
    echo.
    docker-compose ps
    echo.
    docker exec jenkins-master curl -s http://localhost:8080/api/json >nul 2>&1
    if !errorlevel! equ 0 (
        echo [+] Jenkins est operationnel
    ) else (
        echo [!] Jenkins ne repond pas encore ou n'est pas pret
    )
    echo.
    goto :end
)

if "%1"=="clean" (
    echo.
    echo [!] ATTENTION: Cette action supprime tous les volumes et donnees Jenkins!
    echo.
    set /p confirm="Continuer? (oui/non): "
    if /i "!confirm!"=="oui" (
        echo [*] Nettoyage complet...
        docker-compose down -v
        echo [+] Nettoyage termine
    ) else (
        echo [-] Operation annulee
    )
    echo.
    goto :end
)

echo [-] Action inconnue: %1
echo [!] Utilisez: jenkins-manage.bat start^|stop^|restart^|logs^|password^|status^|clean

:end
endlocal
