#!/bin/ash
# starting driver or controller

if [ -z "$MODE" ] && [ -n "$1" ]; then
    MODE="$1"
fi

JAVA_OPTS="$JAVA_OPTS -Dcosbench.tomcat.config=conf/$MODE-tomcat-server.xml -server -cp main/org.eclipse.equinox.launcher_1.2.0.v20110502.jar org.eclipse.equinox.launcher.Main -configuration conf/.$MODE"

if [ "$MODE" = "driver" ]; then
cat << EOF > conf/driver.conf
[driver]
log_level = $LOG_LEVEL
name = driver$DRIVER_INDEX
url = $DRIVER_HOST/driver
EOF
    set -- "java $JAVA_OPTS -console 18089"
fi

if [ "$MODE" = "controller" ]; then
    drivers=
    cat << EOF > conf/controller.conf
[controller]
drivers = $DRIVER_COUNT
name=controller
url=$CONTROLLER_URL
log_level = $LOG_LEVEL
log_file = log/system.log
archive_dir = archive
EOF
    i=1
    for host in $(echo $DRIVER_HOSTS | sed 's/,/\n/g'); do
        cat << EOF >> conf/controller.conf
[driver$i]
name = driver$i
url = $host/driver
EOF
    i=$(($i+1))
    done
    cat conf/controller.conf
    set -- "java $JAVA_OPTS -console 19089"
fi

eval exec "$@"