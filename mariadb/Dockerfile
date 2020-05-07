FROM gradle:6.3.0-jdk8 AS azkaban-builder

ENV AZK_VERSION 3.84.15

USER gradle

RUN wget https://github.com/azkaban/azkaban/archive/${AZK_VERSION}.tar.gz -O - |  tar -xz && \
    cd azkaban-${AZK_VERSION} && \
    ./gradlew build -x test installDist --no-daemon

FROM mariadb:10

ENV AZK_VERSION 3.84.15

COPY --from=azkaban-builder home/gradle/azkaban-${AZK_VERSION}/azkaban-db/build/sql/create-all-sql-0.1.0-SNAPSHOT.sql /docker-entrypoint-initdb.d
