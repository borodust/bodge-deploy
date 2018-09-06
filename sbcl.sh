#!/bin/sh
SCRIPT=$1
shift
exec $HOME/opt/lisp/run-sbcl.sh --load "$HOME/bodge/scripts/utils.lisp" --script $SCRIPT $@
