#!/bin/bash

kubectl create serviceaccount flink-service-account -n hello-world
kubectl create clusterrolebinding flink-role-binding-flink --clusterrole=cluster-admin --serviceaccount="hello-world:flink-service-account"
