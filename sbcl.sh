#!/bin/sh
SCRIPT=$1
shift
exec $HOME/.bodge/lisp/run-sbcl.sh --load "$HOME/.bodge/scripts/init.lisp" --script $SCRIPT $@
