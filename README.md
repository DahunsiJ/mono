# Secure CI/CD Deployment for Mono DevSecOps Assessment

## Overview

This repository contains a **secure CI/CD pipeline** for deploying a Kubernetes application following DevSecOps best practices.

## Features

- **Automated CI/CD Pipeline** using GitHub Actions.
- **Security Scanning** via CodeQL, Conftest, and Trivy.
- **Secure Kubernetes Deployment** with RBAC, Network Policies, and Pod Security Policies.
- **Monitoring & Compliance** with Kube-bench and Kubernetes audit logs.

## Architecture

The deployment follows this structure:

```
GitHub Actions -> Docker -> Kubernetes (Minikube/Cloud) -> Secure App
```

### Security Layers Implemented

- **Code Scanning:** CodeQL detects security vulnerabilities.
- **Container Security:** Trivy scans images for CVEs.
- **RBAC & Least Privilege:** Service accounts with limited permissions.
- **Pod Security:** Restricts privilege escalation and root access.
- **Network Security:** Policies enforce controlled communication.

## Setup & Deployment

### Prerequisites

- **GitHub Actions** enabled
- **Minikube** for local testing
- **Docker** for building images
- **kubectl** for Kubernetes management

### Deployment Steps

1. Clone the repository:
   ```sh
   git clone https://github.com/DahunsiJ/mono.git
   cd mono
   ```
2. Start Minikube:
   ```sh
   minikube start --driver=docker --force
   ```
3. Deploy Kubernetes Resources:
   ```sh
   kubectl apply -f infra/
   ```
4. Verify Deployment:
   ```sh
   kubectl get pods -o wide
   ```
5. Run Security Checks:
   ```sh
   trivy image dahunsij/secure-mono:latest
   kubectl logs -f job/kube-bench
   ```

## Contributing

Contributions are welcome! Please submit a pull request following the project’s security and coding guidelines.

## License

This project is licensed under the JUSTUS License.

