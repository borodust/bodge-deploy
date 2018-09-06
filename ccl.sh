#!/bin/sh
UNAME="$(uname -s)"
case "${UNAME}" in
    Linux*)     CCL_BIN=lx86cl64;;
    Darwin*)    CCL_BIN=dx86cl64;;
    MSYS*)      CCL_BIN=wx86cl64;;
    *)          echo "Unrecognized platform $UNAME"; exit 1;;
esac

SCRIPT=$1
shift
exec $HOME/opt/lisp/$CCL_BIN --quiet --batch --load "$HOME/bodge/scripts/utils.lisp" --load $SCRIPT --eval "(#__exit 0)" -- $@
