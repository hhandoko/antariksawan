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
FROM         oracle/graalvm-ce:1.0.0-rc14 as builder
LABEL        description="Micronaut - GraalVM-based all-in-one JAR builder"

COPY         . /home/app/
WORKDIR      /home/app

RUN          ./gradlew --no-daemon assemble

# ~~~~~~

FROM         oracle/graalvm-ce:1.0.0-rc14 as graalvm
LABEL        description="Micronaut - GraalVM-based native-image builder"

COPY         --from=builder /home/app/build/libs/ /home/app/
WORKDIR      /home/app

RUN          java \
               -cp *.jar \
               io.micronaut.graal.reflect.GraalClassLoadingAnalyzer \
               reflect.json
RUN          native-image \
               --no-server \
               --class-path /home/app/*.jar \
               --rerun-class-initialization-at-runtime='sun.security.jca.JCAUtil$CachedSecureRandomHolder',javax.net.ssl.SSLContext \
               --delay-class-initialization-to-runtime=io.netty.handler.codec.http.HttpObjectEncoder,io.netty.handler.codec.http.websocketx.WebSocket00FrameEncoder,io.netty.handler.ssl.util.ThreadLocalInsecureRandom \
               --allow-incomplete-classpath \
               -H:ReflectionConfigurationFiles=/home/app/reflect.json \
               -H:EnableURLProtocols=http \
               -H:IncludeResources='logback.xml|application.yml|META-INF/services/*.*' \
               -H:+ReportUnsupportedElementsAtRuntime \
               -H:+AllowVMInspection \
               -H:-UseServiceLoaderFeature \
               -H:Name=antariksawan \
               -H:Class=com.hhandoko.antariksawan.Application

# ~~~~~~

FROM         frolvlad/alpine-glibc
LABEL        description="Micronaut - GraalVM native-image runtime container"

COPY         --from=graalvm /home/app/antariksawan ./

EXPOSE       8080
ENTRYPOINT   ["./antariksawan"]
