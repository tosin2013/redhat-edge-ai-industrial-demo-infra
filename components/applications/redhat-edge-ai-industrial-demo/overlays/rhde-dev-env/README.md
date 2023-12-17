# Tekton pipelines and Application Deployment code


**Using Kustomize**
```
kustomize build components/applications/redhat-edge-ai-industrial-demo/overlays/rhde-dev-env 
```

**Using oc-cli**
```
oc apply -k components/applications/redhat-edge-ai-industrial-demo/overlays/rhde-dev-env
```

**Via URL**  

*make sure openshift pipelines is installed before running*

```
oc apply -k https://github.com/tosin2013/redhat-edge-ai-industrial-demo-infra/components/applications/redhat-edge-ai-industrial-demo/overlays/rhde-dev-env
```

# References
* https://www.itix.fr/blog/build-multi-architecture-container-images-with-kubernetes-buildah-tekton-and-qemu/
* 