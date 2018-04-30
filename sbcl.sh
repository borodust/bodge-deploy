#!/bin/sh
SCRIPT=$1
shift
exec $HOME/opt/lisp/run-sbcl.sh --script $SCRIPT $@
