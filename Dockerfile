###
# File     : Dockerfile
# License  :
#   Copyright (c) 2019 antariksawan Contributors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# Notes    :
#   Based on multi-stage GraalVM native image Dockerfile from Micronaut
###
FROM         gradle:jdk8 as builder
COPY         --chown=gradle:gradle . /home/app
WORKDIR      /home/app
RUN          ./gradlew build

# ~~~~~~

FROM         oracle/graalvm-ce:1.0.0-rc11 as graalvm
COPY         --from=builder /home/app/ /home/app/
WORKDIR      /home/app
RUN          java \
               -cp build/libs/*.jar \
               io.micronaut.graal.reflect.GraalClassLoadingAnalyzer \
               reflect.json
RUN          native-image \
               --no-server \
               --class-path /home/app/build/libs/*.jar \
               -H:ReflectionConfigurationFiles=/home/app/reflect.json \
               -H:EnableURLProtocols=http \
               -H:IncludeResources='logback.xml|application.yml|META-INF/services/*.*' \
               -H:+ReportUnsupportedElementsAtRuntime \
               -H:+AllowVMInspection \
               --rerun-class-initialization-at-runtime='sun.security.jca.JCAUtil$CachedSecureRandomHolder',javax.net.ssl.SSLContext \
               --delay-class-initialization-to-runtime=io.netty.handler.codec.http.HttpObjectEncoder,io.netty.handler.codec.http.websocketx.WebSocket00FrameEncoder,io.netty.handler.ssl.util.ThreadLocalInsecureRandom \
               -H:-UseServiceLoaderFeature \
               --allow-incomplete-classpath \
               -H:Name=antariksawan \
               -H:Class=com.hhandoko.antariksawan.Application

# ~~~~~~

FROM         frolvlad/alpine-glibc
EXPOSE       8080
COPY         --from=graalvm /home/app/antariksawan .
ENTRYPOINT   ["./antariksawan"]
