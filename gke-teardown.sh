#!/usr/bin/env bash

echo "Preparing teardown..."
echo "Name of your k8s Cluster to Destroy? Remember this is a permanent operation !!"

read CLUSTER

export PROJECT_NAME=$(gcloud config get-value project)
export INSTANCE_REGION=us-central1
export INSTANCE_ZONE=us-central1-f
export CLUSTER_NAME=${CLUSTER}

echo "Set zone for k8s cluster..."
gcloud config set compute/zone ${INSTANCE_ZONE}

echo "Remove k8s cluster..."
gcloud container clusters delete ${CLUSTER_NAME} --quiet
gcloud container clusters list

echo "k8s cluster teardown complete..."