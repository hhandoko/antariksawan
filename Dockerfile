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
FROM         oracle/graalvm-ce:19.2.1 as builder
LABEL        description="Micronaut - GraalVM-based all-in-one JAR builder"

COPY         . /home/app/
WORKDIR      /home/app

# Switch to binary distribution for smaller Gradle download
RUN          sed -i 's/-all.zip/-bin.zip/g' /home/app/gradle/wrapper/gradle-wrapper.properties
RUN          ./gradlew assemble --console=plain

# ~~~~~~

FROM         oracle/graalvm-ce:19.2.1 as graalvm
LABEL        description="Micronaut - GraalVM-based native-image builder"

RUN          gu install native-image

COPY         --from=builder /home/app/build/libs/*-all.jar /home/app/
WORKDIR      /home/app

RUN          native-image --no-server --class-path /home/app/*-all.jar

# ~~~~~~

FROM         frolvlad/alpine-glibc
LABEL        description="Micronaut - GraalVM native-image runtime container"

COPY         --from=graalvm /home/app/antariksawan ./

EXPOSE       8080
ENTRYPOINT   ["./antariksawan"]
