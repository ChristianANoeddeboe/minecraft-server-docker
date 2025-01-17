FROM eclipse-temurin:21-jre
WORKDIR /var/minecraft
COPY start.sh start.sh
COPY setup.sh setup.sh
RUN apt update && apt upgrade -y
RUN apt install -y curl jq

# Download latest Fabric installer for 1.21.4 and rename it to server.jar
RUN curl -OJ https://meta.fabricmc.net/v2/versions/loader/1.21.4/0.16.10/1.0.1/server/jar && \
    mv fabric-server-mc.1.21.4-loader.0.16.10-launcher.1.0.1.jar server.jar

# Make start script executable
RUN chmod +x start.sh setup.sh

# Start the server once to generate the eula.txt file
RUN ./start.sh

# Accept the EULA
RUN sed -i 's/eula=false/eula=true/g' eula.txt

# Create mods directory and download latest Fabric API for 1.21.4
RUN mkdir -p mods && \
    FABRIC_VERSION=$(curl -sH "Accept: application/vnd.github+json" "https://api.github.com/repos/FabricMC/fabric/releases" | jq \
    -r '.[] | select(.tag_name | contains("1.21.4")) | .tag_name' | head -n1) && \
    curl -L -o mods/fabric-api.jar "https://github.com/FabricMC/fabric/releases/download/${FABRIC_VERSION}/fabric-api-${FABRIC_VERSION}.jar"

# Expose the port
EXPOSE 25565
