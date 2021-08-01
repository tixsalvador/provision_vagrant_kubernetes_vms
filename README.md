# provision_vagrant_kubernetes_vms
Clone repo and run vagrant up  
Change NIC name on Vagrantfile  
Change IP address on Vagrantfile and worker.sh

# Clone only a subdirectory. 
```sh
# Create a directory, so Git doesn't get messy, and enter it
mkdir my-dir && cd my-dir

# Start a Git repository
git init

# Track repository, do not enter subdirectory
git remote add -f origin https://github.com/tixsalvador/provision_vagrant_kubernetes_vm

# Enable the tree check feature
git config core.sparseCheckout true

# Create a file in the path: .git/info/sparse-checkout
# That is inside the hidden .git directory that was created
# by running the command: git init
# And inside it enter the name of the sub directory you only want to clone in this example cloning debian10 directory only
echo 'debian10' >> .git/info/sparse-checkout

## Download with pull, not clone
## git pull origin <branch>
git pull origin main
```

Resources:
https://kind.sigs.k8s.io/docs/user/quick-start/

