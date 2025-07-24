# FROM alpine/git AS clone

FROM gradle:jdk21 AS build

ARG VERSION

WORKDIR /
RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"

RUN git clone --recurse-submodules --depth 1 --shallow-submodules -b $VERSION https://github.com/PaperMC/Paper.git

# ENV GIT_USER_NAME="Your Name"
# ENV GIT_USER_EMAIL="you@example.com"

# COPY --from=clone /Paper  /Paper

WORKDIR /Paper
RUN ./gradlew applyPatches
RUN ./gradlew createMojmapBundlerJar



FROM eclipse-temurin:21-jre AS main

COPY --from=build /Paper/paper-server/build/libs/paper-bundler-* /paper-server.jar

# ADD entrypoint.sh /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]

# STOPSIGNAL signal
VOLUME /data
WORKDIR /data
CMD ["java", "-jar", "/paper-server.jar"]

FROM main AS eula

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
