#!/bin/zsh
oc scale deployment/nginx-demo --replicas=0 -n eda-demo
