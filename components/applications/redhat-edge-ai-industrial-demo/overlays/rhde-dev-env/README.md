# Tekton pipelines and Application Deployment code


**Using Kustomize**
```
kustomize build components/applications/redhat-edge-ai-industrial-demo/overlays/rhde-dev-env 
```

**Using OC Cli**
```
oc apply -k components/applications/redhat-edge-ai-industrial-demo/overlays/rhde-dev-env
```

