FROM xiaobailong/oracle-java:centos7_oracleJDK8

ENV KAFKA_MANAGER_VERSION=2.0.0.2

#https://github.com/yahoo/kafka-manager/archive/2.0.0.2.tar.gz
RUN wget "https://github.com/yahoo/kafka-manager/archive/${KAFKA_MANAGER_VERSION}.tar.gz"
RUN yum install -y unzip
RUN tar -xvf ${KAFKA_MANAGER_VERSION}.tar.gz && rm -rf ${KAFKA_MANAGER_VERSION}.tar.gz \
    && cd kafka-manager-${KAFKA_MANAGER_VERSION} \
    && echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt \
    && ./sbt clean dist \
    && unzip -d ./builded ./target/universal/kafka-manager-${KAFKA_MANAGER_VERSION}.zip \
    && mv -T ./builded/kafka-manager-${KAFKA_MANAGER_VERSION} /opt/kafka-manager

RUN apk update && apk add bash curl
COPY --from=build /opt/kafka-manager /opt/kafka-manager
WORKDIR /opt/kafka-manager

EXPOSE 9000
ENTRYPOINT ["./bin/kafka-manager","-Dconfig.file=conf/application.conf"]
