# Script PowerShell pour configurer ngrok + GitHub Webhook
# Usage: .\setup-ngrok-webhook.ps1 -AuthToken "VOTRE_TOKEN" -GitHubRepo "Marouane148/Projet_JENKINS"

param(
    [Parameter(Mandatory=$false)]
    [string]$AuthToken = "",
    
    [Parameter(Mandatory=$false)]
    [string]$GitHubRepo = "Marouane148/Projet_JENKINS"
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ngrok + GitHub Webhook Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ═══════════════════════════════════════════════════
# ÉTAPE 1 : Vérifier ngrok
# ═══════════════════════════════════════════════════

Write-Host "[STEP 1] Vérification de ngrok..." -ForegroundColor Yellow

try {
    $ngrokVersion = ngrok version
    Write-Host "[OK] ngrok est installé : $ngrokVersion" -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] ngrok n'est pas installé" -ForegroundColor Red
    Write-Host ""
    Write-Host "Pour installer ngrok :" -ForegroundColor Yellow
    Write-Host "  Option A: winget install ngrok" -ForegroundColor Gray
    Write-Host "  Option B: Télécharger depuis https://ngrok.com/download" -ForegroundColor Gray
    exit 1
}

# ═══════════════════════════════════════════════════
# ÉTAPE 2 : Configurer le token
# ═══════════════════════════════════════════════════

Write-Host ""
Write-Host "[STEP 2] Configuration du token ngrok..." -ForegroundColor Yellow

if ([string]::IsNullOrEmpty($AuthToken)) {
    Write-Host ""
    Write-Host "Your ngrok AuthToken is required." -ForegroundColor Cyan
    Write-Host "Get it from: https://dashboard.ngrok.com/auth/your-authtoken" -ForegroundColor Cyan
    Write-Host ""
    $AuthToken = Read-Host "Entrez votre ngrok AuthToken"
}

if ([string]::IsNullOrEmpty($AuthToken)) {
    Write-Host "[ERROR] Token requis !" -ForegroundColor Red
    exit 1
}

# Configurer ngrok avec le token
ngrok config add-authtoken $AuthToken
Write-Host "[OK] Token configuré" -ForegroundColor Green

# ═══════════════════════════════════════════════════
# ÉTAPE 3 : Lancer ngrok
# ═══════════════════════════════════════════════════

Write-Host ""
Write-Host "[STEP 3] Démarrage de ngrok sur le port 8080..." -ForegroundColor Yellow
Write-Host ""
Write-Host "ngrok http 8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "⏳ ngrok va se lancer dans 2 secondes..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Une fois ngrok lancé :" -ForegroundColor Cyan
Write-Host "  1. Copier l'URL ngrok publique (https://xxxx.ngrok-free.app)" -ForegroundColor Gray
Write-Host "  2. Aller au dépôt GitHub: https://github.com/$GitHubRepo" -ForegroundColor Gray
Write-Host "  3. Settings → Webhooks → Add webhook" -ForegroundColor Gray
Write-Host "  4. Payload URL: https://xxxx.ngrok-free.app/github-webhook/" -ForegroundColor Gray
Write-Host "  5. Content type: application/json" -ForegroundColor Gray
Write-Host "  6. Trigger: Just the push event" -ForegroundColor Gray
Write-Host ""

Start-Sleep -Seconds 2

# Lancer ngrok
ngrok http 8080
