#!/bin/bash
echo "... Loading variables"
. ./variables.sh

figlet "App :: $INFRACODE"

. ./wrk-deploy-app1.sh
