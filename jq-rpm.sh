#!/usr/bin/env bash
#
# This script packages a Storm release tarball as RHEL6/CentOS6 RPM using fpm.
#
# NOTE: To simplify switching JDK versions for use with Storm WE DO NOT ADD A DEPENDENCY ON A
#       SPECIFIC JDK VERSION to the Storm RPM.  You must manage the installation of JDK manually!
#
#       Before this decision we specified the JDK dependency e.g. via the fpm option:
#           -d "java-1.6.0-openjdk"

MYSELF=`basename $0`
MY_DIR=`echo $(cd $(dirname $0); pwd)`

### CONFIGURATION BEGINS ###

INSTALL_ROOT_DIR="/usr/local/bin"
MAINTAINER="<michael@michael-noll.com>"

### CONFIGURATION ENDS ###

if [ "$OS" = "$OS_MAC" ]; then
  declare -r SED_OPTS="-E"
else
  declare -r SED_OPTS="-r"
fi

function print_usage() {
    myself=`basename $0`
    echo "Usage: $myself <jq-download-url-or-local-path>"
    echo
    echo "Examples:"
    echo "  \$ $myself http://stedolan.github.io/jq/download/linux64/jq"
    echo "  \$ $myself /local/path/to/jq"
}

if [ $# -ne 1 ]; then
    print_usage
    exit 1
fi

JQ_URI="$1"
JQ=`basename $JQ_URI`

# Prepare environment
OLD_PWD=`pwd`
BUILD_DIR=`mktemp -d /tmp/jq-build.XXXXXXXXXX`
cd $BUILD_DIR

cleanup_and_exit() {
  local exitCode=$1
  rm -rf $BUILD_DIR
  cd $OLD_PWD
  exit $exitCode
}

URL_REGEX="^(http|https|ftp)://.*"
# Ignore case when regex matching.
shopt -s nocasematch

# Get jq.
if [[ "$JQ_URI" =~ $URL_REGEX ]]; then
    # Download jq.
    wget $JQ_URI || cleanup_and_exit $?
elif [ -f "${JQ_URI}" ]; then
    cp $JQ_URI . || cleanup_and_exit $?
elif [ -f "$MY_DIR/$JQ_URI" ]; then
    cp $MY_DIR/$JQ_URI . || cleanup_and_exit $?
fi

chmod +x ./$JQ
JQ_VERSION=`./$JQ --version 2>&1 | sed $SED_OPTS 's/^.*([0-9]+\.[0-9]+)$/\1/'`
echo "Building an RPM for ${JQ_VERSION}..."

# Build the RPM
fpm -s dir -t rpm -a all \
    -n jq \
    -v $JQ_VERSION \
    --iteration "1.miguno" \
    --maintainer "$MAINTAINER" \
    --vendor "Stephen Dolan" \
    --url http://stedolan.github.io/jq/ \
    --description "lightweight and flexible command-line JSON processor" \
    -p $OLD_PWD/jq-VERSION.el6.ARCH.rpm \
    -a "x86_64" \
    --prefix $INSTALL_ROOT_DIR \
    * || cleanup_and_exit $?

echo "You can verify the proper creation of the RPM file with:"
echo "  \$ rpm -qpi jq-*.rpm    # show package info"
echo "  \$ rpm -qpR jq-*.rpm    # show package dependencies"
echo "  \$ rpm -qpl jq-*.rpm    # show contents of package"

# Clean up
cleanup_and_exit 0
