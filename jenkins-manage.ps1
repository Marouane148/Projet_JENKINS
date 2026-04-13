# Script de gestion Jenkins sous Windows avec Docker
# Usage: .\jenkins-manage.ps1 -Action start|stop|restart|logs|password|status|clean

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("start", "stop", "restart", "logs", "password", "status", "clean")]
    [string]$Action
)

$ProjectPath = "C:\projet_jenkins\ICDE848"
$ContainerName = "jenkins-master"

# Vérifier que Docker est disponible
try 
{
    $null = docker --version
}
catch 
{
    Write-Host "[ERROR] Docker n'est pas installe ou n'est pas accessible !" -ForegroundColor Red
    exit 1
}

Write-Host "[INFO] Gestion Jenkins - Action: $Action" -ForegroundColor Cyan
Write-Host "[INFO] Chemin du projet: $ProjectPath" -ForegroundColor Gray


switch ($Action) 
{
    "start" 
    {
        Write-Host "[START] Demarrage de Jenkins..." -ForegroundColor Green
        Set-Location $ProjectPath
        docker-compose up -d
        Write-Host "[SUCCESS] Jenkins demarre..." -ForegroundColor Green
        Write-Host "[WAIT] Attendre 30-60 secondes avant d'acceder a Jenkins..." -ForegroundColor Yellow
        Write-Host "[URL] http://localhost:8080" -ForegroundColor Cyan
    }

    "stop" 
    {
        Write-Host "[STOP] Arret de Jenkins..." -ForegroundColor Yellow
        Set-Location $ProjectPath
        docker-compose down
        Write-Host "[SUCCESS] Jenkins arrete" -ForegroundColor Green
    }

    "restart" 
    {
        Write-Host "[RESTART] Redemarrage de Jenkins..." -ForegroundColor Yellow
        Set-Location $ProjectPath
        docker-compose restart jenkins
        Write-Host "[SUCCESS] Jenkins redemarr" -ForegroundColor Green
        Write-Host "[WAIT] Attendre quelques secondes..." -ForegroundColor Yellow
    }

    "logs" 
    {
        Write-Host "[LOGS] Logs de Jenkins (CTRL+C pour quitter):" -ForegroundColor Cyan
        Set-Location $ProjectPath
        docker-compose logs -f jenkins
    }

    "password" 
    {
        Write-Host "[PASSWORD] Recuperation du mot de passe initial..." -ForegroundColor Cyan
        Set-Location $ProjectPath
        try 
        {
            $password = docker exec $ContainerName cat /var/jenkins_home/secrets/initialAdminPassword 2>&1
            Write-Host "[SUCCESS] Mot de passe initial:" -ForegroundColor Green
            Write-Host "$password" -ForegroundColor Yellow
            Write-Host "[NOTE] Copier ce mot de passe pour l'acces Jenkins" -ForegroundColor Yellow
        }
        catch 
        {
            Write-Host "[ERROR] Jenkins n'est peut-etre pas demarr" -ForegroundColor Red
            Write-Host "[HELP] Lancez: .\jenkins-manage.ps1 -Action start" -ForegroundColor Yellow
        }
    }

    "status" 
    {
        Write-Host "[STATUS] Etat de Jenkins:" -ForegroundColor Cyan
        Write-Host ""
        Set-Location $ProjectPath
        docker-compose ps
        Write-Host ""
        try 
        {
            $response = docker exec $ContainerName curl -s http://localhost:8080/api/json 2>&1
            $health = $response | ConvertFrom-Json
            Write-Host "[SUCCESS] Jenkins est operationnel" -ForegroundColor Green
            Write-Host "[INFO] Version: $($health.version)" -ForegroundColor Gray
        }
        catch 
        {
            Write-Host "[WARN] Jenkins ne repond pas encore ou n'est pas pret" -ForegroundColor Yellow
        }
    }

    "clean" 
    {
        Write-Host "[CLEAN] ATTENTION: Cette action supprime tous les volumes et donnees Jenkins!" -ForegroundColor Red
        $confirmation = Read-Host "Continuer? (oui/non)"
        if ($confirmation -eq "oui") 
        {
            Write-Host "[CLEAN] Nettoyage complet..." -ForegroundColor Yellow
            Set-Location $ProjectPath
            docker-compose down -v
            Write-Host "[SUCCESS] Nettoyage termine" -ForegroundColor Green
        }
        else 
        {
            Write-Host "[CANCELLED] Operation annulee" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "[INFO] Autres commandes disponibles:" -ForegroundColor Gray
Write-Host "   .\jenkins-manage.ps1 -Action start     # Demarrer Jenkins" -ForegroundColor Gray
Write-Host "   .\jenkins-manage.ps1 -Action stop      # Arreter Jenkins" -ForegroundColor Gray
Write-Host "   .\jenkins-manage.ps1 -Action restart   # Redemarrer Jenkins" -ForegroundColor Gray
Write-Host "   .\jenkins-manage.ps1 -Action status    # Verifier l'etat" -ForegroundColor Gray
Write-Host "   .\jenkins-manage.ps1 -Action logs      # Voir les logs" -ForegroundColor Gray
Write-Host "   .\jenkins-manage.ps1 -Action password  # Obtenir le mot de passe initial" -ForegroundColor Gray
