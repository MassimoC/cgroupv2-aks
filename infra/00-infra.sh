#!/bin/bash
echo "... Loading variables"
. ./variables.sh

figlet "Infra :: $INFRACODE"

. ./in-prerequisites.sh

. ./in-create-aks.sh
