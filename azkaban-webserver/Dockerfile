FROM gradle:6.3.0-jdk8 AS azkaban-builder

ENV AZK_VERSION 3.84.15

RUN wget https://github.com/azkaban/azkaban/archive/${AZK_VERSION}.tar.gz -O - |  tar -xz && \
    cd azkaban-${AZK_VERSION} && \
    ./gradlew build -x test installDist

FROM harbor.reviewpro.com/library/oracle-jre:8u181-b13
LABEL maintainer="albert.domenech@reviewpro.com"

ENV AZK_VERSION 3.84.15
ENV MYSQL_JDBC_VERSION=5.1.45

WORKDIR /root

COPY --from=azkaban-builder /home/gradle/azkaban-${AZK_VERSION}/azkaban-web-server/build/install/azkaban-web-server azkaban-web-server

# apk add --update curl netcat-openbsd mysql-client&& \

RUN set -x && \
    apk add --update curl mysql-client && \
    rm -rf /var/cache/apk/* && \
    curl -sLk http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_JDBC_VERSION.tar.gz| tar xz && \
#    mkdir azkaban-web-server/extlib/ && \
    mv mysql-connector-java-$MYSQL_JDBC_VERSION/mysql-connector-java-$MYSQL_JDBC_VERSION-bin.jar azkaban-web-server/lib/ && \
    rm -rf mysql-connector-java-$MYSQL_JDBC_VERSION && \
    mkdir azkaban-web-server/logs/ && \
    sed -i "s/>webServerLog.*//" azkaban-web-server/bin/start-web.sh && \
    sed -i "s/ &//" azkaban-web-server/bin/internal/internal-start-web.sh

ADD keystore azkaban-web-server/keystore
ADD azkaban.properties azkaban-web-server/conf/azkaban.properties

# Azkaban web server port
EXPOSE 8443

# Define default workdir
WORKDIR /root/azkaban-web-server
# ADD script/run.sh run.sh
# RUN chmod +x run.sh

# CMD ["./run.sh"]
CMD ["bin/start-web.sh"]

