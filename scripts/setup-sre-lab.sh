#!/bin/bash

# Exit on any error
set -e

echo "🔍 Checking if Docker is running..."
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker Desktop and press [Enter] to continue."
    read -r
fi

echo "🔧 Checking and installing k3d..."
if ! command -v k3d &> /dev/null; then
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo "k3d is already installed."
fi

echo "🚀 Creating k3d cluster..."
if ! k3d cluster list | grep -q sre-lab; then
    k3d cluster create sre-lab --agents 1
else
    if ! k3d cluster list | grep sre-lab | grep -q "running"; then
        echo "k3d cluster 'sre-lab' exists but is not running. Starting it..."
        k3d cluster start sre-lab
    else
        echo "k3d cluster 'sre-lab' already exists and is running."
    fi
fi

echo "📦 Creating namespace..."
kubectl get namespace sre-lab &> /dev/null || kubectl create namespace sre-lab

echo "📥 Checking and installing Helm..."
if ! command -v helm &> /dev/null; then
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
else
    echo "Helm is already installed."
fi

echo "📈 Adding Prometheus and Grafana repos..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || echo "Prometheus repo already added."
helm repo add grafana https://grafana.github.io/helm-charts || echo "Grafana repo already added."
helm repo update

echo "📊 Installing Prometheus..."
if ! helm list -n sre-lab | grep -q prometheus; then
    helm install prometheus prometheus-community/prometheus -n sre-lab
else
    echo "Prometheus is already installed in the sre-lab namespace."
fi

echo "📉 Installing Grafana..."
if ! helm list -n sre-lab | grep -q grafana; then
    helm install grafana grafana/grafana -n sre-lab --set adminPassword='admin' --set service.type=NodePort
else
    echo "Grafana is already installed in the sre-lab namespace."
fi

echo "📍 Getting Grafana admin credentials..."
echo "Username: admin"

echo "🔑 Retrieving and decoding Grafana admin secret..."
GRAFANA_ADMIN_PASSWORD=$(kubectl get secret -n sre-lab grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
echo "Decoded Grafana Admin Password: $GRAFANA_ADMIN_PASSWORD"

echo "🔗 Port-forwarding Grafana service to localhost:3000..."
kubectl port-forward -n sre-lab svc/grafana 3000:80 & PORT_FORWARD_PID=$!

echo "🛑 To stop the port-forwarding, run: kill $PORT_FORWARD_PID"

echo "⚙️ Deploying Incident Bot..."
kubectl apply -f ./k8s/manifests/incident-bot/deployment.yaml
kubectl apply -f ./k8s/manifests/incident-bot/service.yaml

echo "✅ Done! Your local AI SRE Lab is live."

echo "🔗 Access Grafana at: http://localhost:3000"