# Setup Guide for Secure CI/CD Deployment

## Introduction
This guide provides step-by-step instructions for setting up a secure CI/CD pipeline with Kubernetes deployment for the Mono DevSecOps assessment. It includes security best practices, automated testing, and monitoring tools.

## Prerequisites
Ensure you have the following installed:
- **GitHub Actions** for CI/CD automation
- **Minikube** for local Kubernetes cluster
- **kubectl** for managing Kubernetes resources
- **Docker** for containerization
- **Trivy** for vulnerability scanning
- **Kube-bench** for Kubernetes security benchmarking

## Step 1: Clone the Repository
```sh
 git clone https://github.com/DahunsiJ/mono.git
 cd mono
```

## Step 2: Set Up Minikube
Start Minikube to create a local Kubernetes cluster:
```sh
minikube start --driver=docker --force
```

## Step 3: Deploy Kubernetes Resources
Apply the Kubernetes configurations to set up the deployment:
```sh
kubectl apply -f infra/deployment.yml
kubectl apply -f infra/service.yml
kubectl apply -f infra/ingress.yml
kubectl apply -f infra/rbac.yml
kubectl apply -f infra/network_policy.yml
```

## Step 4: Verify Deployment
Check the status of the running pods and services:
```sh
kubectl get pods -o wide
kubectl get svc
kubectl get ing
```

## Step 5: Run Security Tests
### Run Trivy to Scan the Docker Image
```sh
trivy image dahunsij/secure-mono:latest
```
### Run Kube-bench to Audit Kubernetes Security
```sh
kubectl apply -f https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job.yaml
kubectl logs -f job/kube-bench
```

## Step 6: Access the Application
If using Minikube, expose the service:
```sh
minikube service secure-mono-service
```
If using an ingress controller, add the following entry to `/etc/hosts`:
```sh
127.0.0.1 monoapp.local
```
Then access `http://monoapp.local` in your browser.

## Step 7: Cleanup
To remove the deployment and free up resources:
```sh
kubectl delete -f infra/
minikube stop && minikube delete
```

## Conclusion
This guide ensures a secure and automated deployment with best DevSecOps practices. For further enhancements, consider integrating continuous security monitoring tools like Falco or kube-hunter.

For issues, raise a ticket in the GitHub repository.
