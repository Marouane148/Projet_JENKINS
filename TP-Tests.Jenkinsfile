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

        stage('Unit Tests') {
            steps {
                echo '========== STAGE: Unit Tests =========='
                sh 'mvn test'
            }
        }

        stage('Integration Tests') {
            steps {
                echo '========== STAGE: Integration Tests =========='
                sh 'mvn verify'
            }
        }
    }

    post {
        always {
            echo '========== Tests terminés =========='
            junit 'target/surefire-reports/**/*.xml'
        }
        success {
            echo '✅ Tests réussis - Déclenchement de TP-Qualite'
            build job: 'TP-Qualite', wait: false
        }
        failure {
            echo '❌ Tests échoués - Arrêt de la chaîne'
        }
    }
}
