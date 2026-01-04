# GitOps-Based Infrastructure with ArgoCD

## 🚀 Project Overview

This project demonstrates a complete GitOps workflow using ArgoCD for continuous deployment. It includes multi-cluster management, automated sync, rollback capabilities, and application health monitoring.

## 📋 Features

- **GitOps Methodology**: Git as single source of truth
- **ArgoCD Integration**: Continuous deployment automation
- **Multi-Cluster Management**: Deploy to multiple Kubernetes clusters
- **Automated Sync**: Automatic synchronization from Git
- **Rollback Capabilities**: Easy rollback to previous versions
- **Health Monitoring**: Application health checks
- **RBAC**: Role-based access control
- **Multi-Environment**: Dev, Staging, Production

## 🏗️ Architecture

```
┌─────────────┐
│   GitHub    │
│  Repository │
│  (GitOps)   │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│     ArgoCD      │
│  (Controller)   │
└──────┬──────────┘
       │
       ├──► Cluster 1 (Dev)
       ├──► Cluster 2 (Staging)
       └──► Cluster 3 (Production)
```

## 📁 Project Structure

```
.
├── apps/
│   ├── base/
│   │   ├── kustomization.yaml
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── overlays/
│   │   ├── dev/
│   │   │   ├── kustomization.yaml
│   │   │   └── argocd-app.yaml
│   │   ├── staging/
│   │   │   ├── kustomization.yaml
│   │   │   └── argocd-app.yaml
│   │   └── production/
│   │       ├── kustomization.yaml
│   │       └── argocd-app.yaml
├── argocd/
│   ├── install.yaml
│   ├── application.yaml
│   └── project.yaml
├── scripts/
│   ├── install-argocd.sh
│   └── setup.sh
└── README.md
```

## 🛠️ Prerequisites

- Kubernetes cluster (1.19+)
- kubectl configured
- Git repository
- Helm 3.x (optional)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd 5-gitops-argocd
```

### 2. Install ArgoCD

```bash
chmod +x scripts/install-argocd.sh
./scripts/install-argocd.sh
```

Or install manually:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 3. Get ArgoCD Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### 4. Access ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Access: https://localhost:8080
- Username: admin
- Password: (from step 3)

### 5. Create ArgoCD Application

```bash
kubectl apply -f argocd/application.yaml
```

Or use the setup script:

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

## 📝 Configuration

### Application Configuration

Each environment has its own overlay:

```yaml
# apps/overlays/dev/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- ../../base

replicas:
- name: sample-app
  count: 2

images:
- name: sample-app
  newTag: dev-latest

configMapGenerator:
- name: app-config
  literals:
  - ENVIRONMENT=dev
```

### ArgoCD Application

```yaml
# argocd/application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: sample-app
spec:
  project: default
  source:
    repoURL: https://github.com/your-org/gitops-repo
    targetRevision: main
    path: apps/overlays/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```

## 🔒 Security Features

- **RBAC**: Role-based access control
- **SSO Integration**: Single sign-on support
- **Secrets Management**: External secrets integration
- **Network Policies**: Kubernetes network policies

## 📊 Monitoring

### Application Health

ArgoCD monitors:
- Deployment status
- Pod health
- Resource sync status
- Application health

### Metrics

- Sync frequency
- Sync success rate
- Application status
- Resource utilization

## 🔄 GitOps Workflow

1. **Developer pushes changes** to Git repository
2. **ArgoCD detects changes** (via webhook or polling)
3. **ArgoCD syncs** application to cluster
4. **Health checks** verify deployment
5. **Notifications** sent on success/failure

## 🧪 Testing

### Validate Kustomize

```bash
kubectl kustomize apps/overlays/dev
```

### Dry Run Sync

```bash
argocd app sync sample-app --dry-run
```

## 📚 Additional Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Kustomize Documentation](https://kustomize.io/)
- [GitOps Principles](https://www.gitops.tech/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License

## 👤 Author

Your Name - DevOps Engineer

