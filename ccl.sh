#!/bin/bash

shopt -s nocasematch

UNAME="$(uname -s)"
case "${UNAME}" in
    Linux*)     CCL_BIN=lx86cl64;;
    Darwin*)    CCL_BIN=dx86cl64;;
    MSYS*)      CCL_BIN=wx86cl64;;
    MINGW*)     CCL_BIN=wx86cl64;;
    *)          echo "Unrecognized platform $UNAME"; exit 1;;
esac

SCRIPT=$1
SCRIPT_DIR=$HOME/.bodge/scripts
shift
exec $HOME/.bodge/lisp/$CCL_BIN --quiet --no-init --batch \
     --load "$SCRIPT_DIR/init.lisp" \
     --eval "(cl-user::command-line-script \"$SCRIPT\")" \
     -- $@
