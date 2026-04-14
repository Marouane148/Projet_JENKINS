pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK17'
    }

    environment {
        JAVA_HOME = '/opt/java/openjdk'
        MAVEN_HOME = '/usr/share/maven'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '========== STAGE: Checkout =========='
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo '========== STAGE: Build =========='
                sh 'mvn clean compile'
            }
        }
    }

    post {
        always {
            echo '========== Build terminé =========='
        }
        success {
            echo '✅ Build réussi - Déclenchement de TP-Tests'
            build job: 'TP-Tests', wait: false
        }
        failure {
            echo '❌ Build échoué - Arrêt de la chaîne'
        }
    }
}
