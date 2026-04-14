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

        stage('JaCoCo Coverage') {
            steps {
                echo '========== STAGE: JaCoCo Coverage =========='
                sh 'mvn jacoco:report'
            }
        }

        stage('Checkstyle Analysis') {
            steps {
                echo '========== STAGE: Checkstyle Analysis =========='
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('PMD Analysis') {
            steps {
                echo '========== STAGE: PMD Analysis =========='
                sh 'mvn pmd:pmd'
            }
        }

        stage('SpotBugs Analysis') {
            steps {
                echo '========== STAGE: SpotBugs Analysis =========='
                sh 'mvn com.github.spotbugs:spotbugs-maven-plugin:spotbugs'
            }
        }
    }

    post {
        always {
            echo '========== Analyse de qualité terminée =========='
        }
        success {
            echo '✅ Qualité validée'
            mail(
                subject: "✅ Pipeline réussi - TP-Build ➜ TP-Tests ➜ TP-Qualite",
                body: """
                    Bonjour,
                    
                    Le pipeline d'intégration continue a été exécuté avec succès :
                    
                    ✅ TP-Build : BUILD RÉUSSI
                    ✅ TP-Tests : TESTS RÉUSSIS
                    ✅ TP-Qualite : ANALYSE QUALITÉ RÉUSSIE
                    
                    Le code a été construit, testé et analysé avec succès.
                    
                    Consultez les résultats détaillés : ${BUILD_URL}
                    
                    Cordialement,
                    Jenkins CI/CD
                """,
                to: 'marouanekaidi@gmail.com'
            )
        }
        failure {
            echo '❌ Analyse échouée'
            mail(
                subject: "❌ Pipeline échoué - Vérification requise",
                body: """
                    Bonjour,
                    
                    Le pipeline d'intégration continue a échoué lors de l'analyse de qualité.
                    
                    Veuillez vérifier les logs : ${BUILD_URL}
                    
                    Cordialement,
                    Jenkins CI/CD
                """,
                to: 'marouanekaidi@gmail.com'
            )
        }
    }
}
