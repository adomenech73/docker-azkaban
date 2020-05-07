FROM gradle:6.3.0-jdk8 AS azkaban-builder

ENV AZK_VERSION 3.84.15

USER gradle

RUN wget https://github.com/azkaban/azkaban/archive/${AZK_VERSION}.tar.gz -O - |  tar -xz && \
    cd azkaban-${AZK_VERSION} && \
    ./gradlew build -x test installDist --no-daemon

FROM harbor.reviewpro.com/library/oracle-jre:8u181-b13
LABEL maintainer="albert.domenech@reviewpro.com"

ENV AZK_VERSION 3.84.15
ENV MYSQL_JDBC_VERSION=5.1.45

WORKDIR /root

COPY --from=azkaban-builder /home/gradle/azkaban-${AZK_VERSION}/azkaban-exec-server/build/install/azkaban-exec-server azkaban-exec-server

RUN set -x && \
    apk add --update curl jq && \
    rm -rf /var/cache/apk/* && \
    curl -sLk http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_JDBC_VERSION}.tar.gz| tar xz && \
    #mkdir azkaban-exec-server/extlib/ && \
    mv mysql-connector-java-$MYSQL_JDBC_VERSION/mysql-connector-java-$MYSQL_JDBC_VERSION-bin.jar azkaban-exec-server/lib/ && \
    rm -rf mysql-connector-java-$MYSQL_JDBC_VERSION && \
    # sed -i "s/>executorServerLog__`date +%F+%T`.out 2>&1 &//" azkaban-exec-server/bin/start-exec.sh && \
    sed -i "s/>executorServerLog.*//" azkaban-exec-server/bin/start-exec.sh && \
    sed -i "s/ &//" azkaban-exec-server/bin/internal/internal-start-executor.sh

ADD azkaban.properties azkaban-exec-server/conf/azkaban.properties

# Azkaban executor port
EXPOSE 12321

# Define default workdir
WORKDIR /root/azkaban-exec-server

CMD ["bin/start-exec.sh"]
