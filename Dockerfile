FROM xiaobailong/oracle-java:centos7_oracleJDK8 AS build

ENV KAFKA_MANAGER_VERSION=3.0.0.5

#https://github.com/yahoo/kafka-manager/archive/3.0.0.5.tar.gz
RUN wget "https://github.com/yahoo/kafka-manager/archive/${KAFKA_MANAGER_VERSION}.tar.gz"
RUN yum makecache fast && yum update -y && yum install -y unzip
RUN tar -xvf ${KAFKA_MANAGER_VERSION}.tar.gz \
    && cd CMAK-${KAFKA_MANAGER_VERSION} \
    && echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt \
    && ./sbt clean dist \
    && unzip -d ./builded ./target/universal/CMAK-${KAFKA_MANAGER_VERSION}.zip \
    && mv -T ./builded/CMAK-${KAFKA_MANAGER_VERSION} /opt/kafka-manager

FROM xiaobailong/oracle-java:centos7_oracleJDK8

COPY --from=build /opt/kafka-manager /opt/kafka-manager
WORKDIR /opt/kafka-manager

EXPOSE 9000
ENTRYPOINT ["./bin/kafka-manager","-Dconfig.file=conf/application.conf"]
