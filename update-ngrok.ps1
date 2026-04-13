# Script PowerShell pour mettre à jour ngrok

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Mise à jour de ngrok" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[INFO] Version actuelle: 3.3.1" -ForegroundColor Yellow
Write-Host "[INFO] Version minimum requise: 3.20.0" -ForegroundColor Yellow
Write-Host ""

# ═══════════════════════════════════════════════════
# Option 1 : Utiliser ngrok update
# ═══════════════════════════════════════════════════

Write-Host "[OPTION 1] Utiliser 'ngrok update'" -ForegroundColor Cyan
try {
    ngrok update
    Write-Host "[OK] Mise à jour via ngrok update réussie" -ForegroundColor Green
    Write-Host ""
    ngrok version
    exit 0
}
catch {
    Write-Host "[WARN] ngrok update a échoué, essai Option 2..." -ForegroundColor Yellow
}

# ═══════════════════════════════════════════════════
# Option 2 : Réinstaller via winget
# ═══════════════════════════════════════════════════

Write-Host ""
Write-Host "[OPTION 2] Réinstallation via winget..." -ForegroundColor Cyan

try {
    winget upgrade Ngrok.Ngrok
    Write-Host "[OK] Mise à jour via winget réussie" -ForegroundColor Green
    Write-Host ""
    
    # Redémarrer PowerShell pour mettre à jour le PATH
    Write-Host "[IMPORTANT] Redémarrer PowerShell pour que les changements prennent effet" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Dans une nouvelle fenêtre PowerShell, vérifier:" -ForegroundColor Cyan
    Write-Host "  ngrok version" -ForegroundColor Gray
    
    exit 0
}
catch {
    Write-Host "[WARN] Mise à jour via winget a échoué, essai Option 3..." -ForegroundColor Yellow
}

# ═══════════════════════════════════════════════════
# Option 3 : Installation manuelle
# ═══════════════════════════════════════════════════

Write-Host ""
Write-Host "[OPTION 3] Téléchargement et installation manuelle..." -ForegroundColor Cyan

# Créer le dossier
$ngrokDir = "C:\ngrok"
New-Item -ItemType Directory -Path $ngrokDir -Force | Out-Null

# URL de la dernière version
$downloadUrl = "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip"
$zipPath = "$ngrokDir\ngrok-latest.zip"
$extractPath = $ngrokDir

Write-Host "[DOWNLOAD] Téléchargement de la dernière version de ngrok..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing
    Write-Host "[OK] Téléchargement réussi" -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] Impossible de télécharger ngrok" -ForegroundColor Red
    Write-Host ""
    Write-Host "Téléchargez manuellement depuis: https://ngrok.com/download" -ForegroundColor Yellow
    exit 1
}

# Extraire
Write-Host "[EXTRACT] Extraction de l'archive..." -ForegroundColor Yellow
try {
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
    Write-Host "[OK] Extraction réussie" -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] Impossible d'extraire ngrok" -ForegroundColor Red
    exit 1
}

# Clean
Remove-Item $zipPath -Force

# Ajouter au PATH
$env:Path += ";$ngrokDir"
Write-Host "[OK] ngrok ajouté au PATH" -ForegroundColor Green

# Vérifier la version
Write-Host ""
Write-Host "[VERIFY] Vérification de la version..." -ForegroundColor Yellow
ngrok version

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Mise à jour terminée !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Vous pouvez maintenant utiliser ngrok :" -ForegroundColor Cyan
Write-Host "  ngrok config add-authtoken VOTRE_TOKEN" -ForegroundColor Gray
Write-Host "  ngrok http 8080" -ForegroundColor Gray
Write-Host ""
