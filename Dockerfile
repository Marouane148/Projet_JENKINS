FROM jenkins/jenkins:lts

USER root

# Installer Maven et dépendances essentielles
RUN apt-get update && \
    apt-get install -y \
    maven \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Détecter la version Java disponible et définir JAVA_HOME
# Jenkins LTS inclut déjà Java, on utilise le Java fourni par Jenkins
ENV JAVA_HOME=/opt/java/openjdk
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=${MAVEN_HOME}/bin:${JAVA_HOME}/bin:$PATH

# Vérifier les installations
RUN echo "=== Vérification des installations ===" && \
    java -version && \
    mvn -version && \
    echo "=== OK ===" 

# Revenir à l'utilisateur jenkins
USER jenkins

# Installer les plugins Jenkins au démarrage (optionnel)
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
