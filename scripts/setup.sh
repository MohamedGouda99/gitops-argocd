#!/bin/bash

set -e

echo "🚀 Setting up GitOps with ArgoCD..."

# Check prerequisites
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install it first."
    exit 1
fi

# Check if ArgoCD is installed
if ! kubectl get namespace argocd &> /dev/null; then
    echo "❌ ArgoCD is not installed. Please run scripts/install-argocd.sh first."
    exit 1
fi

# Apply ArgoCD project
echo "📦 Applying ArgoCD project..."
kubectl apply -f argocd/project.yaml

# Create namespaces
echo "📦 Creating application namespaces..."
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace staging --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace production --dry-run=client -o yaml | kubectl apply -f -

# Apply ArgoCD applications
echo "📦 Applying ArgoCD applications..."
kubectl apply -f apps/overlays/dev/argocd-app.yaml
kubectl apply -f apps/overlays/staging/argocd-app.yaml
kubectl apply -f apps/overlays/production/argocd-app.yaml

echo "✅ Setup complete!"
echo ""
echo "📊 Check application status:"
echo "   kubectl get applications -n argocd"
echo ""
echo "🌐 Access ArgoCD UI:"
echo "   kubectl port-forward svc/argocd-server -n argocd 8080:443"

