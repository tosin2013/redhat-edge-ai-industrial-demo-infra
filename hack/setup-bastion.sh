#!/bin/bash
set -x
# Set a default repo name if not provided
#REPO_NAME=${REPO_NAME:-tosin2013/external-secrets-manager}

OC_VERSION=4.14 # 4.12 or 4.14


# Check for CICD PIPLINE FLAG
if [ -z "$CICD_PIPELINE" ]; then
    echo "CICD_PIPELINE is not set."
    echo "Running in interactive mode."
elif [ "$CICD_PIPELINE" == "true" ]; then
    echo "CICD_PIPELINE is set to $CICD_PIPELINE."
    echo "Running in non-interactive mode."
    # Check if the AWS variables are defined and not empty
    if [ -z "${AWS_ACCESS_KEY_ID}" ] || [ -z "${AWS_SECRET_ACCESS_KEY}" ] || [ -z "${AWS_REGION}" ]; then
      echo "AWS variables not found or empty. Exiting..."
      exit 1
    fi
    if [ -z "${SSH_PASSWORD}" ]; then
      echo "SSH_PASSWORD variable not found or empty. Exiting..."
      exit 1
    fi
    if [ -z "${DEPLOYMENT_TYPE}" ]; then
      echo "DEPLOYMENT_TYPE variable not found or empty. Exiting..."
      exit 1
    fi
else
    echo "CICD_PIPELINE is not set."
    echo "Running in interactive mode."
fi



function wait-for-me(){
    while [[ $(oc get pods $1  -n $2 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
        sleep 1
    done

}

if [ -z $GUID ]; then 
     read -p "Enter GUID: " GUID
fi

if [[ -s ~/.vault_password ]]; then
    echo "The file contains information."
else
    curl -OL https://gist.githubusercontent.com/tosin2013/022841d90216df8617244ab6d6aceaf8/raw/92400b9e459351d204feb67b985c08df6477d7fa/ansible_vault_setup.sh
    chmod +x ansible_vault_setup.sh
    echo "Configuring password for Ansible Vault"
    if [ $CICD_PIPELINE == "true" ];
    then
        if [ -z "$SSH_PASSWORD" ]; then
            echo "SSH_PASSWORD enviornment variable is not set"
            exit 1
        fi
        echo "$SSH_PASSWORD" > ~/.vault_password
        sudo cp ~/.vault_password /root/.vault_password
        sudo cp ~/.vault_password /home/lab-user/.vault_password
        bash  ./ansible_vault_setup.sh
    else
        bash  ./ansible_vault_setup.sh
    fi
fi

# Ensure Git is installed
echo "Installing Git..."
sudo dnf install -yq git
if ! yq -v  &> /dev/null
then
    VERSION=v4.34.1
    BINARY=yq_linux_amd64
    sudo wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq &&\
    sudo chmod +x /usr/bin/yq
fi

if ! helm -v  &> /dev/null
then
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
fi


if [ $CICD_PIPELINE == "false" ];
then
  # Check if the repository is already cloned
  if [ -d "$HOME/redhat-edge-ai-industrial-demo-infra" ]; then
    cd $HOME/redhat-edge-ai-industrial-demo-infra
    git config pull.rebase false
    git pull
  else
    cd $HOME
    echo "Cloning from github.com/redhat-edge-ai-industrial-demo-infra ..."
    git clone https://github.com/tosin2013/redhat-edge-ai-industrial-demo-infra.git
    cd $HOME/redhat-edge-ai-industrial-demo-infra
  fi
fi

# Install System Packages
if [ ! -f /usr/bin/podman ]; then
  ./hack/partial-rpm-packages.sh
fi

# Run the configuration script to setup the bastion host with:
# - Python 3.9
# - Ansible
# - Ansible Navigator
# - Pip modules
result=$(whereis ansible-navigator)

# If the result only contains the name "ansible-navigator:" without a path, it means it's not installed
if [[ $result == "ansible-navigator:" ]]; then
    echo "ansible-navigator not found. Installing..."
    ./hack/partial-python39-setup.sh
else
    echo "ansible-navigator is already installed. Skipping installation."
fi


# Install OCP CLI Tools
if [ ! -f /usr/bin/oc ]; then
  ./hack/partial-setup-ocp-cli.sh
fi

cd $HOME

status=$(oc get ArgoCD openshift-gitops -n openshift-gitops -o jsonpath='{.status.phase}')

if [ "$status" == "Available" ]; then
    echo "ArgoCD is available."
else
    echo "ArgoCD is not available."
    git clone https://github.com/tosin2013/sno-quickstarts.git
    cd sno-quickstarts/gitops
    ./deploy.sh
fi