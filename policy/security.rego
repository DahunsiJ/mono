package main

deny[msg] {
  input.kind == "Deployment"
  input.spec.template.spec.securityContext.runAsRoot == true
  msg := "Running as root is not allowed"
}
