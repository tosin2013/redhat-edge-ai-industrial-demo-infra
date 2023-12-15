# redhat-edge-ai-industrial-demo Infra for redhat-edge-ai-industrial-demo

[redhat-edge-ai-industrial-demo](https://github.com/bdherouville/redhat-edge-ai-industrial-demo)

**Quick Start**
*Testing on RHEL 8 jumpbox*
```
curl -OL https://raw.githubusercontent.com/tosin2013/redhat-edge-ai-industrial-demo-infra/main/dev-box.sh
chmod +x dev-box.sh
./dev-box.sh
```

## Deployment Options
**AWS**
```
kustomize build clusters/overlays/aws    
```

**Baremetal**
```
kustomize build clusters/overlays/baremetal    
```

**Rosa**
```
kustomize build clusters/overlays/baremetal    
```