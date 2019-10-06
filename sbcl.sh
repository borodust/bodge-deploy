#!/bin/sh
SCRIPT=$1
SCRIPT_DIR=$HOME/.bodge/scripts
shift

shopt -s nocasematch

UNAME="$(uname -s)"
case "${UNAME}" in
    MSYS*)      SBCL_BIN=sbcl.exe;;
    MINGW*)     SBCL_BIN=sbcl.exe;;
    WINDOWS*)   SBCL_BIN=sbcl.exe;;
    *)          SBCL_BIN=run-sbcl.sh;;
esac

export SBCL_HOME=$HOME/.bodge/lisp/

exec $SBCL_HOME/$SBCL_BIN \
     --noinform --disable-ldb --lose-on-corruption --end-runtime-options \
     --no-userinit --no-sysinit --disable-debugger \
     --load "$SCRIPT_DIR/init.lisp" \
     --eval "(cl-user::command-line-script \"$SCRIPT\")" \
     --end-toplevel-options \
     $@
