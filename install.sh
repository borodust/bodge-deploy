#!/bin/bash

UNAME="$(uname -s)"
case "${UNAME}" in
    Linux*)     PLATFORM=linux;;
    Darwin*)    PLATFORM=darwin;;
    MSYS*)      PLATFORM=windows;;
    *)          PLATFORM="UNKNOWN:${UNAME}"
esac

SBCL=sbcl-1.4.2-x86-64-$PLATFORM
SBCL_ARCHIVE=/tmp/$SBCL.tar.gz
SBCL_URL=http://bodge.borodust.org/files/$SBCL.tar.gz
SBCL_PATH=$HOME/opt/sbcl/
BIN_PATH=$HOME/bin/
SBCL_BIN=$BIN_PATH/sbcl
QUICKLISP_URL=https://beta.quicklisp.org/quicklisp.lisp
QUICKLISP_FILE=$HOME/quicklisp.lisp
SCRIPTS_URL=http://bodge.borodust.org/files/scripts.tar.gz
SCRIPTS_ARCHIVE=/tmp/scripts.tar.gz
SCRIPTS_PATH=$HOME/bodge/scripts/

download () {
    if curl --no-progress-bar -o $2 -L $1; then
        return 0;
    else
        echo "Couldn't download from $1"
        exit 1;
    fi
}

inflate () {
    echo "Inflating $1 into $2"
    mkdir -p $2
    if tar -C $2 --strip-components=1 -xf $1; then
       return 0;
    else
        echo "Failed to inflate $1"
        exit 1;
    fi
}

ensure_sbcl () {
    if [ -f "$SBCL_BIN" ]; then
        echo "SBCL found"
    else
        echo "Installing SBCL"
        download $SBCL_URL $SBCL_ARCHIVE
        inflate $SBCL_ARCHIVE $SBCL_PATH
        mkdir -p $BIN_PATH
        ln -s $SBCL_PATH/run-sbcl.sh $SBCL_BIN
    fi
}

ensure_sbcl
echo "Preparing scripts"
download $SCRIPTS_URL $SCRIPTS_ARCHIVE
inflate $SCRIPTS_ARCHIVE $SCRIPTS_PATH
echo "Preparing Quicklisp"
download $QUICKLISP_URL $QUICKLISP_FILE


$SBCL_BIN --script $SCRIPTS_PATH/prepare-quicklisp.lisp $QUICKLISP_FILE
