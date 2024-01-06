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
$ kustomize build clusters/overlays/aws  # to test
cd $HOME/redhat-edge-ai-industrial-demo-infra
oc create -k clusters/overlays/aws
```

**4.14-workshop on RHPDS**
```
$ kustomize build clusters/overlays/4.14-workshop  # to test
cd $HOME/redhat-edge-ai-industrial-demo-infra
oc create -k clusters/overlays/4.14-workshop
```

**Baremetal**
```
$ kustomize build clusters/overlays/baremetal     # to test
cd $HOME/redhat-edge-ai-industrial-demo-infra
oc create -k clusters/overlays/baremetal
```

**Rosa**
```
$ kustomize build clusters/overlays/baremetal  # to test  
cd $HOME/redhat-edge-ai-industrial-demo-infra
oc create -k clusters/overlays/rosa
```

## Before running tekton pipelines run the script below 
*This will attach the pull secret to the pipeline service account*
```
./hack/configure-pipeline-secret.sh 
```

## Tekton Run 

* This file will push to your quay repo after you create it.
  * [pipeline-run-quay.yaml](components/applications/redhat-edge-ai-industrial-demo/overlays/rhde-dev-env/pipeline-run-quay.yaml)
* This file will push to the quay instance in openshift you will have to update it to the quay registry after you have created a account.
  * [pipeline-run.yaml](components/applications/redhat-edge-ai-industrial-demo/overlays/rhde-dev-env/pipeline-run.yaml)

## You may also use the script below to run the pipeline
```
./hack/run-pipeline.sh registry-quay-quay.apps.lab.example.com/admin/redhat-edge-ai-industrial-demo
```

### Quick start for OpenShift web console
```
curl -OL https://raw.githubusercontent.com/tosin2013/redhat-edge-ai-industrial-demo-infra/main/hack/run_pipeline.sh
chmod +x run_pipeline.sh

./run_pipeline.sh $(oc get route -n quay | grep registry-quay | awk '{print $2}' | head -1)/admin/redhat-edge-ai-industrial-demo

./run_pipeline.sh quay.io/admin/redhat-edge-ai-industrial-demo
```
