# Script PowerShell pour installer ngrok correctement sur Windows

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation de ngrok sur Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ═══════════════════════════════════════════════════
# ÉTAPE 1 : Installer ngrok via winget
# ═══════════════════════════════════════════════════

Write-Host "[STEP 1] Installation de ngrok via winget..." -ForegroundColor Yellow

# Spécifier le package winget (pas msstore)
winget install -e --id Ngrok.Ngrok

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Echec de l'installation winget" -ForegroundColor Red
    Write-Host ""
    Write-Host "Essai avec le package Microsoft Store..." -ForegroundColor Yellow
    winget install -e --id 9MVS1J51GMK6
}

Write-Host "[OK] ngrok installé" -ForegroundColor Green

# ═══════════════════════════════════════════════════
# ÉTAPE 2 : Ajouter ngrok au PATH
# ═══════════════════════════════════════════════════

Write-Host ""
Write-Host "[STEP 2] Mise à jour du PATH..." -ForegroundColor Yellow

# Trouver ngrok.exe
$ngrokPaths = @(
    "C:\Program Files\ngrok\ngrok.exe",
    "C:\Program Files (x86)\ngrok\ngrok.exe",
    "$env:LOCALAPPDATA\Microsoft\WinGet\Links\ngrok.exe",
    "$env:ProgramFiles\ngrok\ngrok.exe"
)

$ngrokFound = $false
$ngrokPath = ""

foreach ($path in $ngrokPaths) {
    if (Test-Path $path) {
        Write-Host "[OK] ngrok trouvé à: $path" -ForegroundColor Green
        $ngrokFound = $true
        $ngrokPath = $path
        break
    }
}

if (-not $ngrokFound) {
    Write-Host "[WARN] ngrok.exe non trouvé aux emplacements attendus" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Lancer cette commande pour trouver ngrok :" -ForegroundColor Yellow
    Write-Host "  Get-Command ngrok -ErrorAction SilentlyContinue" -ForegroundColor Gray
    Write-Host ""
}

# Ajouter au PATH de session actuelle
$ngrokDir = Split-Path $ngrokPath
if (-not $env:Path.Contains($ngrokDir)) {
    $env:Path += ";$ngrokDir"
    Write-Host "[OK] PATH mis à jour pour cette session" -ForegroundColor Green
}

# ═══════════════════════════════════════════════════
# ÉTAPE 3 : Tester l'installation
# ═══════════════════════════════════════════════════

Write-Host ""
Write-Host "[STEP 3] Vérification de l'installation..." -ForegroundColor Yellow

try {
    $version = ngrok version
    Write-Host "[OK] ngrok fonctionne !" -ForegroundColor Green
    Write-Host "$version" -ForegroundColor Cyan
}
catch {
    Write-Host "[ERROR] ngrok ne répond pas" -ForegroundColor Red
    Write-Host ""
    Write-Host "Solutions :" -ForegroundColor Yellow
    Write-Host "1. Redémarrer PowerShell complètement (fermer et rouvrir)" -ForegroundColor Gray
    Write-Host "2. Redémarrer l'ordinateur" -ForegroundColor Gray
    Write-Host "3. Vérifier que winget a bien installé ngrok" -ForegroundColor Gray
    exit 1
}

# ═══════════════════════════════════════════════════
# ÉTAPE 4 : Prêt pour la configuration
# ═══════════════════════════════════════════════════

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "ngrok est prêt pour utilisation !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Prochaines étapes :" -ForegroundColor Cyan
Write-Host "1. Créer un compte ngrok (gratuit): https://ngrok.com" -ForegroundColor Gray
Write-Host "2. Récupérer le token: https://dashboard.ngrok.com/auth/your-authtoken" -ForegroundColor Gray
Write-Host "3. Configurer le token:" -ForegroundColor Gray
Write-Host "   ngrok config add-authtoken VOTRE_TOKEN" -ForegroundColor DarkGray
Write-Host "4. Lancer ngrok:" -ForegroundColor Gray
Write-Host "   ngrok http 8080" -ForegroundColor DarkGray
Write-Host ""

Write-Host "Tableau de bord ngrok: http://127.0.0.1:4040" -ForegroundColor Yellow
Write-Host ""
