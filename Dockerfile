FROM openjdk:8-jre-alpine
ENV CONTROLLER_URL="http://127.0.0.1:19088/controller/" \
    DRIVER_COUNT="1" \
    DRIVER_HOSTS="http://127.0.0.1:18088" \
    DRIVER_INDEX="1" \
    DRIVER_URL="http://127.0.0.1:18088/driver/" \
    LOG_LEVEL="INFO" \
    COSBENCH_VERSION="0.4.2.c4"
RUN apk add --no-cache --virtual .build-deps curl ca-certificates && \
    curl -L https://github.com/intel-cloud/cosbench/releases/download/v${COSBENCH_VERSION}/${COSBENCH_VERSION}.zip -o cosbench.zip && unzip cosbench.zip && \
    mkdir /opt && mv ${COSBENCH_VERSION} /opt/cosbench && \
    rm cosbench.zip && \
    apk del .build-deps
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
VOLUME /opt/cosbench/log /opt/cosbench/archive
EXPOSE 18088 18089 19088 19089
ENTRYPOINT ["/docker-entrypoint.sh"]
WORKDIR /opt/cosbench
CMD ["controller"]