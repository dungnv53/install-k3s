# Get a pod log eg. atlassian-mcp pod
microk8s kubectl logs atlassian-mcp-5546d8bbb4-4gc6v -n staging

microk8s kubectl describe pod  atlassian-mcp-5546d8bbb4-4gc6v -n staging

microk8s kubectl  get deployments -n staging

# Edit deployment; We can not edit pod directly?
microk8s kubectl  edit deployment  mcp-gateway -n staging