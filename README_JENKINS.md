# 🚀 Jenkins Docker Setup - Projet ICDE848

Configuration complète de Jenkins avec Docker pour un projet Maven/Java avec JDK 17.

## 📋 Prérequis

- ✅ Docker Desktop installé et en cours d'exécution
- ✅ Docker Compose
- ✅ Windows PowerShell ou Command Prompt
- ✅ Au moins 4 GB de RAM disponible pour Docker

## 📂 Fichiers créés

| Fichier | Purpose |
|---------|---------|
| `docker-compose.yml` | Configuration principal Docker Compose |
| `Dockerfile` | Image Jenkins personnalisée (Maven + Java 17) |
| `.env` | Variables d'environnement |
| `plugins.txt` | Liste des plugins à installer |
| `jenkins-manage.ps1` | Script PowerShell pour gérer Jenkins |
| `JENKINS_COMMANDS.txt` | Commandes manuelles |
| `JENKINS_SETUP_GUIDE.txt` | Guide de configuration complet |

## 🚀 Démarrage rapide

### Option 1: Utiliser le script PowerShell (Recommandé - Windows)

```powershell
# 1. Démarrer Jenkins
C:\projet_jenkins\ICDE848> .\jenkins-manage.ps1 -Action start

# 2. Vérifier l'état
.\jenkins-manage.ps1 -Action status

# 3. Obtenir le mot de passe initial
.\jenkins-manage.ps1 -Action password

# 4. Voir les logs
.\jenkins-manage.ps1 -Action logs
```

### Option 2: Commandes manuelles

```powershell
# Naviguer vers le répertoire
cd C:\projet_jenkins\ICDE848

# Démarrer Jenkins
docker-compose up -d

# Attendre ~30 secondes, puis récupérer le mot de passe
docker exec jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword

# Vérifier l'état
docker ps
```

## 🌐 Accès Jenkins

Une fois démarré:

**URL**: [http://localhost:8080](http://localhost:8080)

**Port Jenkins**: 8080  
**Port Agents**: 50000

## 🔑 Première connexion

1. Accéder à http://localhost:8080
2. Copier le mot de passe initial (obtenu ci-dessus)
3. Cliquer sur "Install suggested plugins" ou sélectionner manuellement
4. Créer un compte administrateur (optionnel pour test)
5. Configurer les tools (voir ci-dessous)

## ⚙️ Configuration Jenkins

### Configurer JDK 17 et Maven 3

1. Aller à: **Manage Jenkins** → **Tools** → **Global Tool Configuration**

2. **JDK Configuration**:
   - Nom: `JDK17`
   - Chemin: `/usr/lib/jvm/java-17-openjdk-amd64`

3. **Maven Configuration**:
   - Nom: `Maven3`
   - Chemin: `/usr/share/maven`

4. Cliquer **Save**

### Créer le Pipeline du projet

1. Cliquer **+ New Item**
2. Nom: `Projet-JENKINS-Pipeline`
3. Type: **Pipeline**
4. Configuration:
   - **Pipeline script from SCM**
   - **SCM**: Git
   - **Repository URL**: `https://github.com/Marouane148/Projet_JENKINS.git`
   - **Script Path**: `Jenkinsfile`
5. **Build Now**

## 📝 Jenkinsfile exemple

Votre `Jenkinsfile` devrait contenir:

```groovy
pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
        MAVEN_HOME = '/usr/share/maven'
        PATH = "${MAVEN_HOME}/bin:${JAVA_HOME}/bin:${PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }
    }

    post {
        always {
            junit 'target/surefire-reports/*.xml'
        }
    }
}
```

## 🛠️ Commandes utiles

| Commande | Description |
|----------|-------------|
| `.\jenkins-manage.ps1 -Action start` | Démarrer Jenkins |
| `.\jenkins-manage.ps1 -Action stop` | Arrêter Jenkins |
| `.\jenkins-manage.ps1 -Action restart` | Redémarrer Jenkins |
| `.\jenkins-manage.ps1 -Action status` | Vérifier l'état |
| `.\jenkins-manage.ps1 -Action logs` | Voir les logs en temps réel |
| `.\jenkins-manage.ps1 -Action password` | Récupérer le mot de passe initial |

## 🔍 Vérifications

### Jenkins démarre correctement

```powershell
docker-compose ps
# Doit montrer jenkins-master en "Up"
```

### Java et Maven sont disponibles

```powershell
docker exec jenkins-master java -version
docker exec jenkins-master mvn -version
```

### Jenkins répond

```powershell
docker exec jenkins-master curl -s http://localhost:8080/api/json
```

## 🧹 Arrêt et nettoyage

### Arrêter Jenkins (données persistantes)

```powershell
.\jenkins-manage.ps1 -Action stop
# ou
docker-compose down
```

### Supprimer tout (⚠️ données perdues)

```powershell
.\jenkins-manage.ps1 -Action clean
# ou
docker-compose down -v
```

## 🐛 Dépannage

### "Port 8080 already in use"

```powershell
# Trouver le processus utilisant le port
netstat -ano | findstr :8080

# Changer le port dans .env ou docker-compose.yml
# Par exemple: JENKINS_HOST_PORT=8081
```

### "Permission denied" sur jenkins-manage.ps1

```powershell
# Autoriser l'exécution des scripts PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Jenkins prend du temps à démarrer

C'est normal! Jenkins peut mettre 30-60 secondes à être complètement disponible.

```powershell
# Monitoriser les logs
.\jenkins-manage.ps1 -Action logs
```

### Git ne peut pas cloner le projet

Vérifier que:
- L'URL du repository est correcte
- Les credentials GitHub sont configurés (si privé)
- Le conteneur a accès à Internet

## 📊 Ressources

- **RAM**: 2 GB (configurable dans docker-compose.yml - `JAVA_OPTS`)
- **Stockage**: Dépend des builds (volume `jenkins_home`)
- **CPU**: Sans limite (peut être configuré)

## 🔗 Liens utiles

- [Jenkins Official Docs](https://jenkins.io/doc/)
- [Jenkins Docker Hub](https://hub.docker.com/r/jenkins/jenkins)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Maven in Docker](https://hub.docker.com/_/maven)

## 📞 Support

Pour plus d'aide:

1. Consulter `JENKINS_SETUP_GUIDE.txt`
2. Consulter `JENKINS_COMMANDS.txt`
3. Vérifier les logs: `.\jenkins-manage.ps1 -Action logs`
4. Consulter la documentation Jenkins officielle

---

✅ **Jenkins est prêt à être utilisé !**
