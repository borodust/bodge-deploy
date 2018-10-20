#!/bin/bash

UNAME="$(uname -s)"
case "${UNAME}" in
    Linux*)     PLATFORM=linux;CCL_BIN=lx86cl64;;
    Darwin*)    PLATFORM=darwin;CCL_BIN=dx86cl64;;
    MSYS*)      PLATFORM=windows;CCL_BIN=wx86cl64;;
    MINGW*)     PLATFORM=windows;CCL_BIN=wx86cl64;;
    *)          PLATFORM="UNKNOWN:${UNAME}";CCL_BIN=lx86cl64
esac

ARCH=${2:-x86-64}
LISP_IMPL=${1:-sbcl}
FILES_URL=http://bodge.borodust.org/files

BIN_PATH=$HOME/bin/

LISP=$LISP_IMPL-$PLATFORM-$ARCH
LISP_ARCHIVE=/tmp/$LISP.tar.gz
LISP_URL=$FILES_URL/$LISP.tar.gz
LISP_PATH=$HOME/opt/lisp/
LISP_RUNNER=$BIN_PATH/lisp
LISP_RUNNER_URL=$FILES_URL/$LISP_IMPL.sh
LISP_BIN=$BIN_PATH/lisp-bin

QUICKLISP_URL=https://beta.quicklisp.org/quicklisp.lisp
QUICKLISP_FILE=$HOME/quicklisp.lisp

SCRIPTS_URL=$FILES_URL/scripts.tar.gz
SCRIPTS_ARCHIVE=/tmp/scripts.tar.gz
SCRIPTS_PATH=$HOME/bodge/scripts/

C2FFI_ARCHIVE_NAME=c2ffi-$PLATFORM-$ARCH.zip
C2FFI_URL=$FILES_URL/$C2FFI_ARCHIVE_NAME
C2FFI_ARCHIVE_PATH=/tmp/$C2FFI_ARCHIVE_NAME

CCL_IMAGE=$LISP_PATH/$CCL_BIN.image

download () {
    echo "Downloading $1 into $2"
    mkdir -p "$(dirname $2)"
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

ensure_lisp () {
    if [ -f "$LISP_BIN" ]; then
        echo "LISP found"
    else
        echo "Installing LISP"
        download $LISP_URL $LISP_ARCHIVE
        inflate $LISP_ARCHIVE $LISP_PATH
        mkdir -p "$(dirname $LISP_BIN)"
        download $LISP_RUNNER_URL $LISP_RUNNER
        chmod +x $LISP_RUNNER
    fi
}

ensure_lisp

echo "Preparing scripts"
download $SCRIPTS_URL $SCRIPTS_ARCHIVE
inflate $SCRIPTS_ARCHIVE $SCRIPTS_PATH

echo "Preparing Quicklisp"
download $QUICKLISP_URL $QUICKLISP_FILE
$LISP_RUNNER $SCRIPTS_PATH/ensure-quicklisp.lisp $QUICKLISP_FILE

echo "Installing c2ffi"
download $C2FFI_URL $C2FFI_ARCHIVE_PATH
cd $BIN_PATH && unzip -o $C2FFI_ARCHIVE_PATH
