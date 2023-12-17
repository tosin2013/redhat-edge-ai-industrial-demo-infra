# redhat-edge-ai-industrial-demo Infra for redhat-edge-ai-industrial-demo

![20231216224549](https://i.imgur.com/M79pCPU.png)

*Still a work in progress*

[redhat-edge-ai-industrial-demo](https://github.com/bdherouville/redhat-edge-ai-industrial-demo)

**Quick Start**
*Testing on RHEL 8 jumpbox*
```
curl -OL https://raw.githubusercontent.com/tosin2013/redhat-edge-ai-industrial-demo-infra/main/dev-box.sh
chmod +x dev-box.sh
./dev-box.sh
```

## After the above script completes run the following commands for your enviornment
**These will be added to the script once it has been properly tested**

## Deployment Options
**AWS**
```
kustomize build clusters/overlays/aws  
oc create -k clusters/overlays/aws
```

**4.14-workshop on RHPDS**
```
kustomize build clusters/overlays/4.14-workshop  
oc create -k clusters/overlays/4.14-workshop
```

**Baremetal**
```
kustomize build clusters/overlays/baremetal    
oc create -k clusters/overlays/baremetal
```

**Rosa**
```
kustomize build clusters/overlays/baremetal    
oc create -k clusters/overlays/baremetal
```

