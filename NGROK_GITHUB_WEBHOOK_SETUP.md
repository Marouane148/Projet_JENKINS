# Exposer Jenkins sur Internet avec ngrok + GitHub Webhook

## ÉTAPE 1 : INSTALLER NGROK SUR WINDOWS

### Option A : Utiliser winget (Recommandé)

```powershell
# Installer ngrok via winget
winget install ngrok

# Vérifier l'installation
ngrok version
```

### Option B : Téléchargement manuel

```powershell
# 1. Créer un répertoire pour ngrok
New-Item -ItemType Directory -Path "C:\ngrok" -Force
cd C:\ngrok

# 2. Télécharger ngrok pour Windows (64-bit)
# Remplacer [version] par la dernière version disponible
Invoke-WebRequest -Uri "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip" `
  -OutFile "ngrok.zip"

# 3. Extraire le ZIP
Expand-Archive -Path "ngrok.zip" -DestinationPath "C:\ngrok" -Force

# 4. Ajouter ngrok au PATH (optionnel - pour l'utiliser depuis n'importe où)
$env:Path += ";C:\ngrok"

# Vérifier
ngrok version
```

---

## ÉTAPE 2 : CRÉER ET CONFIGURER UN COMPTE NGROK

### Créer un compte gratuit

1. Aller à https://ngrok.com
2. Cliquer sur "Sign Up" (gratuit)
3. S'enregistrer avec email
4. Confirmer l'email

### Récupérer le token d'authentification

1. Après connexion, aller à : https://dashboard.ngrok.com/auth/your-authtoken
2. Copier votre **AuthToken** (ressemble à : `2U...d9_L...KJhS...YqP...`)

### Configurer ngrok avec le token

```powershell
# Ajouter le token d'authentification
ngrok config add-authtoken VOTRE_TOKEN_ICI

# Exemple avec un token fictif :
# ngrok config add-authtoken 2Uu9d9_L5XKJhSHYqPXXXXXXXXXXXX
```

---

## ÉTAPE 3 : DÉMARRER NGROK POUR EXPOSER JENKINS

### Lancer ngrok sur le port 8080

```powershell
# Démarrer ngrok (exposer Jenkins sur Internet)
ngrok http 8080

# Vous verrez quelque chose comme:
# 
# Session Status                online
# Account                       user@email.com
# Version                       3.3.5
# Region                        eu (Europe)
# Latency                       39ms
# Web Interface                 http://127.0.0.1:4040
# Forwarding                    https://abc123def456.ngrok-free.app -> http://localhost:8080
# Forwarding                    http://abc123def456.ngrok-free.app -> http://localhost:8080
```

✅ **URL PUBLIQUE JENKINS** : `https://abc123def456.ngrok-free.app`

Cette URL est **valide pendant 2 heures** (gratuit) ou indéfinie (avec plan payant).

### Accéder à Jenkins via ngrok

Ouvrir dans le navigateur :
```
https://abc123def456.ngrok-free.app
```

---

## ÉTAPE 4 : CONFIGURER LE WEBHOOK GITHUB

### Ajouter le webhook

1. **Aller au repository** : https://github.com/Marouane148/Projet_JENKINS

2. **Settings → Webhooks → Add webhook**

3. **Remplir le formulaire** :

   - **Payload URL** : `https://abc123def456.ngrok-free.app/github-webhook/`
   - **Content type** : `application/json`
   - **Events** : Sélectionner "Just the push event"
   - **☑ Active** : Cocher

4. **Click "Add webhook"**

✅ **Webhook créé !**

### Tester le webhook

```powershell
# Faire une modification et pusher
cd C:\projet_jenkins\ICDE848

# Modifier un fichier (exemple : ajouter un commentaire au README.md)
echo "# Test webhook" >> README.md

# Committer et pusher
git add README.md
git commit -m "Test webhook ngrok"
git push origin main

# Le webhook GitHub devrait déclencher automatiquement le build Jenkins !
# Vérifier dans Jenkins : http://localhost:8080
```

---

## ÉTAPE 5 : CONFIGURER JENKINS POUR LE WEBHOOK GITHUB

### Dans l'interface Jenkins

1. **Ouvrir Jenkins** : http://localhost:8080

2. **Créer un nouveau job Pipeline** (ou utiliser un existant)
   - Nom : `Projet-JENKINS-Pipeline`
   - Type : **Pipeline**

3. **Configure → Build Triggers**
   - ☑ Cocher **"GitHub hook trigger for GITScm polling"**

4. **Pipeline → Pipeline script from SCM**
   - SCM : **Git**
   - Repository URL : `https://github.com/Marouane148/Projet_JENKINS.git`
   - Script Path : `Jenkinsfile`

5. **Save**

✅ **Jenkins est maintenant configuré pour recevoir les webhooks !**

---

## ÉTAPE 6 : VÉRIFIER QUE TOUT FONCTIONNE

### Checker l'état du webhook GitHub

```powershell
# Ouvrir GitHub Settings → Webhooks
# https://github.com/Marouane148/Projet_JENKINS/settings/hooks

# Vous devriez voir:
# ✅ Recent Deliveries : voir les appels webhook
# ✅ Response status : 200 OK
```

### Vérifier les logs Jenkins

```powershell
# Voir les logs de Jenkins
.\jenkins-manage.ps1 -Action logs

# Ou dans l'interface Jenkins :
# http://localhost:8080/log
# Chercher : "GitHub hook triggered"
```

### Test complet

```powershell
# 1. Modifier le code
cd C:\projet_jenkins\ICDE848
echo "# Test" >> src/main/java/fr/epsi/model/Article.java

# 2. Committer et pusher
git add .
git commit -m "Trigger webhook test"
git push origin main

# 3. Jenkins devrait automatiquement déclencher le build
# Vérifier la console Jenkins : http://localhost:8080
```

---

## ÉTAPES SUPPLÉMENTAIRES (OPTIONNEL)

### Si ngrok s'arrête (reconnexion)

```powershell
# ngrok s'arrête après 2 heures (version gratuite)
# Pour relancer :
ngrok http 8080

# L'URL changera ! Vous devrez mettre à jour le webhook GitHub
```

### Utiliser une URL ngrok statique (Plan payant)

Pour une URL stable :
1. Acheter un plan ngrok
2. Créer une configuration statique dans `ngrok.yml`
3. Lancer : `ngrok http 8080 --domain=mondomaine.ngrok.io`

### Garder ngrok en arrière-plan (PowerShell)

```powershell
# Lancer ngrok dans une nouvelle fenêtre PowerShell sans bloquer
Start-Process powershell -ArgumentList 'ngrok http 8080'

# Ou avec tmux/screen sur WSL
wsl tmux new-session -d -s ngrok 'ngrok http 8080'
```

---

## COMMANDES RAPIDES RÉCAPITULATIVES

```powershell
# 1. Installer ngrok
winget install ngrok

# 2. Configurer le token
ngrok config add-authtoken VOTRE_TOKEN_ICI

# 3. Lancer ngrok
ngrok http 8080

# 4. Copier l'URL publique (dans un autre terminal PowerShell)
# Ex: https://abc123def456.ngrok-free.app

# 5. Mettre à jour le webhook GitHub avec cette URL
# Settings → Webhooks → Payload URL : https://abc123def456.ngrok-free.app/github-webhook/

# 6. Tester
cd C:\projet_jenkins\ICDE848
git commit --allow-empty -m "Test webhook"
git push origin main

# 7. Vérifier dans Jenkins
.\jenkins-manage.ps1 -Action logs
```

---

## DÉPANNAGE

### ❌ "ngrok: Le terme 'ngrok' n'est pas reconnu"

```powershell
# ngrok n'est pas dans le PATH
# Solution 1 : Redémarrer PowerShell après installation
# Solution 2 : Utiliser le chemin complet
C:\ngrok\ngrok.exe http 8080

# Solution 3 : Ajouter le PATH manuellement
$env:Path += ";C:\ngrok"
ngrok http 8080
```

### ❌ "Error: ERR_NGROK_108 invalid origin"

```powershell
# Le token n'est pas valide
# Solution : Vérifier et reconfigurer

ngrok config add-authtoken VOTRE_NOUVEAU_TOKEN
```

### ❌ "Jenkins ne déclenche pas les builds"

```powershell
# Vérifier :
# 1. ngrok est bien démarré
# 2. URL ngrok est correcte dans GitHub webhook
# 3. "GitHub hook trigger for GITScm polling" est coché dans Jenkins
# 4. Voir les webhooks GitHub : Recent Deliveries (status 200 = OK)
# 5. Logs Jenkins : .\jenkins-manage.ps1 -Action logs
```

### ❌ "Webhook status 500 ou 403"

```powershell
# Jenkins refuse la connexion
# Solution : 
# 1. Vérifier que Jenkins tourne : .\jenkins-manage.ps1 -Action status
# 2. Vérifier que le port 8080 est accessible
# 3. Vérifier que le job Pipeline existe et est configuré
```

---

## RÉFÉRENCES

- ngrok : https://ngrok.com
- GitHub Webhooks : https://docs.github.com/en/developers/webhooks-and-events/webhooks/about-webhooks
- Jenkins GitHub Webhook : https://plugins.jenkins.io/github/

---

✅ **Vous avez maintenant Jenkins exposé sur Internet avec webhooks GitHub automatiques !**
