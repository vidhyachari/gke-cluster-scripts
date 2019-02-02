#!/usr/bin/env bash

echo "Preparing setup..."

echo "Your k8s cluster name?"

read CLUSTER

export PROJECT_NAME=$(gcloud config get-value project)
export INSTANCE_REGION=us-central1
export INSTANCE_ZONE=us-central1-f
export CLUSTER_NAME=${CLUSTER}

echo "Setting zone for gcloud config..."
gcloud config set compute/zone ${INSTANCE_ZONE}

echo "Creating container engine cluster..."
gcloud container clusters create ${CLUSTER_NAME} \
    --machine-type g1-small
    --preemptible \
    --zone ${INSTANCE_ZONE} \
    --scopes cloud-platform \
    --enable-autorepair \
    --enable-autoupgrade \
    --enable-autoscaling --min-nodes 1 --max-nodes 4 \
    --num-nodes 3 \
    --enable-legacy-authorization

echo "Confirm k8s cluster is running..."
gcloud container clusters list

echo "Get k8s credentials..."
gcloud container clusters get-credentials ${CLUSTER_NAME} \
    --zone ${INSTANCE_ZONE}

echo "Confirm connection to cluster..."
kubectl cluster-info

echo "Create cluster administrator..."
kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin --user=$(gcloud config get-value account)

echo "Confirm the pod is running..."
kubectl get pods

echo "List production services..."
kubectl get svc