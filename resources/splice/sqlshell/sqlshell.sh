#!/bin/bash

HOST="localhost"
PORT="1527"
USER="splice"
PASS="admin"
SCRIPT=""

# longDB SQL Shell

show_help()
{
        echo "longDB SQL client wrapper script"
        echo "Usage: $(basename $BASH_SOURCE) [-h host] [-p port ] [-u username] [-s password] [-f scriptfile]"
        echo -e "\t-h IP addreess or hostname of longDB (HBase RegionServer)"
        echo -e "\t-p Port which longDB is listening on, defaults to 1527"
        echo -e "\t-u username for longDB database"
        echo -e "\t-s password for longDB database"
        echo -e "\t-f sql file to be executed"
}

# Process command line args
while getopts "h:p:u:s:f:" opt; do
    case $opt in
        h)
                HOST="${OPTARG}"
                ;;
        p)
                PORT="${OPTARG}"
                ;;
        u)
                USER="${OPTARG}"
                ;;
        s)
                PASS="${OPTARG}"
                ;;
        f)
                SCRIPT="${OPTARG}"
                ;;
        \?)
                show_help
                exit 1
                ;;
    esac
done

#Get the directory where this script resides
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export CLASSPATH="${CURDIR}/lib/*"

GEN_SYS_ARGS="-Djava.awt.headless=true"

IJ_SYS_ARGS="-Djdbc.drivers=com.splicemachine.db.jdbc.ClientDriver -Dij.connection.splice=jdbc:splice://${HOST}:${PORT}/splicedb;user=${USER};password=${PASS}"

if [ ! -z "${CLIENT_SSL_KEYSTORE}" ]; then
SSL_ARGS="-Djavax.net.ssl.keyStore=${CLIENT_SSL_KEYSTORE} \
    -Djavax.net.ssl.keyStorePassword=${CLIENT_SSL_KEYSTOREPASSWD} \
    -Djavax.net.ssl.trustStore=${CLIENT_SSL_TRUSTSTORE} \
    -Djavax.netDjavax.net.ssl.trustStore.ssl.trustStorePassword=${CLIENT_SSL_TRUSTSTOREPASSWD}"
fi

if hash rlwrap 2>/dev/null; then
    echo -en "\n ========= rlwrap detected and enabled.  Use up and down arrow keys to scroll through command line history. ======== \n\n"
    RLWRAP=rlwrap
else
    echo -en "\n ========= rlwrap not detected.  Consider installing for command line history capabilities. ========= \n\n"
    RLWRAP=
fi

echo "Running longDB SQL shell"
echo "For help: \"longdb> help;\""
${RLWRAP} java ${GEN_SYS_ARGS} ${SSL_ARGS} ${IJ_SYS_ARGS}  com.splicemachine.db.tools.ij ${SCRIPT}

