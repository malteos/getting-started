# How To Pegasus

This document provides a collection of useful commands, configurations, and best practices for working with the Pegasus cluster at DFKI. It is intended to be a living document where people can contribute their knowledge and experiences.

## SSH connection

<details>
<summary>SSH Connection Steps (with VPN)</summary>
<br>

1. Connect to the DFKI VPN
2. Choose Login Node to connect to
``` bash
ssh <username>@<login node>
```
3. In order to exit the SSH connection type:
``` bash
exit
```

</details>

<details>
<summary>SSH Connection Steps (without VPN)</summary>
<br>

In order to connect to the cluster without VPN, you can use a ProxyJump to connect to the cluster. For this, you can set up a SSH config file in your local machine.

1. Create or open a SSH config file in your local machine
``` bash
nano ~/.ssh/config
```
2. Add the following lines to the SSH config file
``` bash
Host pegasus.dfki  # a custom hostname
    User <pegasus_account>
    HostName <login node>
    ProxyJump <dfki_account>@sshgate.sb.dfki.de
```
3. Connect to the cluster (first enter DFKI password, then PEGASUS password)
``` bash
ssh pegasus.dfki
```

</details>

<details>
<summary>SSH Key Authentication Setup</summary>
<br>

Setting up SSH key authentication allows you to connect to the remote server without having to enter your password each time.

1. Generate a SSH key pair
``` bash
ssh-keygen
```
2. Connect to the DFKI VPN
3. Copy the public key to the remote server
``` bash
ssh-copy-id <username>@<login node>
```
4. Connect to the remote server
``` bash
ssh <username>@<login node>
```

</details>

## tmux Cheat Sheet

<details>
<summary>Session Managament</summary>
<br>

- **Start a new tmux session:**
  ```bash
  tmux
  ```
- **Attach to an existing session:**
  ```bash
  tmux attach
  ```

- **List existing sessions:**
  ```bash
  tmux list-sessions
  ```

- **Switch between sessions:**
  Press `Ctrl-b (` to switch to the previous session
  Press `Ctrl-b )` to switch to the next session

- **Rename a session (inside tmux):**
  Press `Ctrl-b $`, then enter the new session name

- **Exit tmux session:**
Press `Ctrl-b` to go to the tmux command prompt, then type `exit`

</details>

<details>
<summary>Window Managament</summary>
<br>

- **Create a new window:**
  Press `Ctrl-b c`

- **Split the current pane vertically:**
  Press `Ctrl-b %`

- **Split the current pane horizontally:**
  Press `Ctrl-b "`

- **Navigate between panes:**
  Press `Ctrl-b` followed by an arrow key

- **Detach from tmux:**
  Press `Ctrl-b d`

- **Start scrolling in the current pane:**
  Press `Ctrl-b [` to enter scroll mode, then use the arrow keys to scroll. Use `q` to exit scroll mode.

- **Exit tmux (close current pane or window):**
Type `exit` in each pane or window

</details>

## Terminal Commands

<details>
<summary>File Navigation</summary>
<br>


List all files in current directory (including hidden files)
```bash
ls -a
```

Search for a directory in the current directory containing a search word
```bash
find . -type d -iname "*word*"
```

</details>

<details>
<summary>File Management</summary>

#### Check Storage Usage
```bash
ncdu
```

</details>

## Container Setup

<details>
<summary>Manual Build and Push (using DockerHub)</summary>
<br>

1. Login to DockerHub
```bash
docker login
```
2. Create a repository on DockerHub
3. Build the Docker image using the Dockerfile. The image name should be in the format `<username>/<repository>:<tag>`. For example, `jantiegges/thesis:ssh-v1.0`
```bash
docker build -t <username>/<repository>:<tag> -f <Dockerfile> .
```
4. Push the Docker image to DockerHub
```bash
docker push <username>/<repository>:<tag>
```

</details>

<details>
<summary>Automatic Build and Push (using GitHub Actions and GHCR)</summary>
<br>

1. Create a new folder `.github/workflows` in the root directory of the repository
2. Create a new file `deploy-image.yml` in the `.github/workflows` folder
3. In the `deploy-image.yml` file, add the following content. In particular, this workflow does the following:
   - It is triggered on every push to the repository if the `Dockerfile`, `Dockerfile-ssh` or `requirements.txt` files are changed
   - It logs in to the GitHub Container Registry (GHCR) using the GitHub token
   - It extracts metadata (tags, labels) for the Docker image
   - It builds and pushes the Docker image to GHCR
   - The image name is in the format `ghcr.io/<username>/<repository>:<tag>`
```yaml
name: Create and Publish Docker Image for Dockerfile

on:
  push:
    paths:
      - "Dockerfile"
      - "Dockerfile-ssh"
      - "requirements.txt"

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: 24.01-py3-thesis-jan

jobs:
  build-and-push-image:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      - name: Log in to the Container registry
        uses: docker/login-action@65b78e6e13532edd9afa3aa52ac7964289d1a9c1
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      # Dockerfile
      - name: Extract metadata (tags, labels) for Docker
        id: meta_base
        uses: docker/metadata-action@9ec57ed1fcdbf14dcef7dfbe97b2010124a938b7
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}-base

      - name: Build and push Docker image (Dockerfile)
        uses: docker/build-push-action@f2a1d5e99d037542a71f64918e516c093c6f3fc4
        with:
          context: .
          file: Dockerfile
          push: true
          tags: ${{ steps.meta_base.outputs.tags }}
          labels: ${{ steps.meta_base.outputs.labels }}

      # Dockerfile-ssh
      - name: Extract metadata (tags, labels) for Docker (SSH)
        id: meta_ssh
        uses: docker/metadata-action@9ec57ed1fcdbf14dcef7dfbe97b2010124a938b7
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}-ssh

      - name: Build and push Docker image (Dockerfile-ssh)
        uses: docker/build-push-action@f2a1d5e99d037542a71f64918e516c093c6f3fc4
        with:
          context: .
          file: Dockerfile-ssh
          push: true
          tags: ${{ steps.meta_ssh.outputs.tags }}
          labels: ${{ steps.meta_ssh.outputs.labels }}
```

</details>

## Project Setup

<details>
<summary>Source Code</summary>

#### Clone a private repository
1. Create a personal access token (PAT) in GitHub
2. Clone the repository using the PAT
```bash
git clone https://<PAT>@github.com/<username>/<repository>
```

#### File Paths
Make sure to use arguments for file paths in the code. This allows you to easily switch between local and cluster paths.

</details>

<details>
<summary>Environment</summary>

#### Global Environment Variables
The .bashrc in your home directory is loaded everytime you start a bash session. It is a good place to define global environment variables, e.g., cache paths or login credentials. For example:
```bash
# append to "~/.bashrc"

# shortcuts
alias ll="ls -l"

# PIP cache
# http://projects.dfki.uni-kl.de/km-publications/web/ML/core/hpc-doc/posts/pypi-cache/
export PIP_INDEX_URL=http://pypi-cache/index
export PIP_TRUSTED_HOST=pypi-cache
export PIP_NO_CACHE=true

# Huggingface
export HF_LOGIN=<your huggingface login>
export HF_PASSWORD=<your huggingface API key>
export HF_DATASETS_CACHE="/netscratch/$USER/datasets/hf_datasets_cache/"
export TRANSFORMERS_CACHE="/netscratch/$USER/models/transformers_cache/"

# Weights & Biases
export WANDB_API_KEY<your WANDB api>
```

</details>

## Run Job on Cluster

Generally, you should have a look at the [Pegasus documentation](https://pegasus.dfki.de) for everything. However, as it can be quite overwhelming, here are useful commands and configurations for running jobs on the cluster.

### General

<details>
<summary>Standard Jobs</summary>

#### Run python script
```bash
srun -K \
  --job-name <job name> \
  -p <partition> \
  --gpus=<number of gpus> \
  --mem=<memory> \
  --container-image=<image> \
  --container-mounts=/netscratch/$USER:/netscratch/$USER,/home/$USER:/home/$USER,\
  --container-workdir=$(pwd) \
  --time <time> \
  python <script.py>
```

#### Start interactive bash session
```bash
srun -K \
  --job-name <job name> \
  -p <partition> \
  --container-image=<image> \
  --container-mounts=/netscratch/$USER:/netscratch/$USER,/home/$USER:/home/$USER,\
  --container-workdir=$(pwd) \
  --time <time> \
  --pty bash
```
</details>

<details>
<summary>Jupyter Notebook</summary>
<br>

1. Start interactive bash session
```bash
srun -K \
  --job-name <job name> \
  -p V100-16GB \
  --gpus=1 \
  --mem=48G \
  --container-mounts=/netscratch:/netscratch,/home/$USER:/home/$USER \
  --container-image=/enroot/<image name>.sqsh \
  --container-workdir=$(pwd) \
  --time 02:00:00 \
  --pty bash
```
2. Start Jupyter Notebook
```bash
echo "Jupyter starting at ... http://${HOSTNAME}.kl.dfki.de:8880" && jupyter notebook --ip=0.0.0.0 --port=8880 \
    --allow-root --no-browser --config /home/jtiegges/.jupyter/jupyter_notebook_config.json \
    --notebook-dir /netscratch/jtiegges/notebooks

```
3. Copy the url from the terminal in the following format
```bash
http://${HOSTNAME}.kl.dfki.de:8880/?token=<token>
```
4. In VS Code, open a notebook and click the "Select Kernel" button in the top right corner. Click "Select another kernel" and "Existing Jupyer Server". Enter the URL you copied in the previous step.
5. Now you can run the notebook in VS Code and the code will be executed on the cluster.

</details>


<details>
<summary>Other Useful Commands</summary>

#### Get overview of running jobs
```bash
squeue --me
```

#### Cancel a job
```bash
scancel <job id>
```

</details>

<details>
<summary>Selection of frequent Slurm arguments explained</summary>
<br>

For a list of all available arguments, you can use the `srun --help` command.

**`--container-image`**
the image to use for the container filesystem. Can be either a docker image given as an enroot URI, or a path to a squashfs file on the remote host filesystem.

**`--container-mounts`**
mounts to be added to the container. The format is `source:destination:options`. The options are `ro` for read-only and `rw` for read-write. You can also mount multiple directories by separating them with a comma.

**`--container-workdir`**
working directory inside the container. The working directory is where the command executed within the container will start.

**` -G, --gpus=n`**
number of GPUs to allocate

**` -K, --kill-on-bad-exit`** 
kill the job if any task terminates with anon-zero exit code. Can be used to avoid zombie jobs.

**` -J, --job-name=jobname`**
name of job

**` --no-container-remap-root`**
By default, Slurm remaps the root user inside the container to a non-root user on the host system for security reasons. However, this option disables that behavior, allowing the container to run with root privileges if necessary. This should be used with caution, as running containers as root can pose security risks.

**` -n, --ntasks=ntasks`**
specifies the number of tasks to run within the job. Tasks can be individual processes or threads that collectively make up the job. Specifying the correct number of tasks ensures optimal resource utilization and performance. `ntasks` can for example be used to run multiple training jobs in parallel, each with different sets of hyperparameters.

**` -N, --nodes=N`**
number of nodes on which to run the job. You can specify a range of nodes using the format N = min[-max]. Running a job on multiple nodes is useful for parallel computing.

**` -o, --output=out`**
location of stdout redirection

**` -p, --partition=partition`**
partition requested

**` --pty`**
When this option is enabled, Slurm allocates a pseudo-terminal (PTY) for the job. PTYs are virtual terminal devices that allow interactive communication with the job's processes. Enabling this option is useful for jobs that require interactive input or terminal-based interaction.

**` -t, --time=time`**
time limit

</details>

<details>
<summary>Partitions</summary>
<br>

Check the [Resources Dashboard](http://monitoring.pegasus.kl.dfki.de/d/slurm-resources/resources?orgId=1&refresh=15s) for available partitions and their resources.

TODO: Add more information about partitions and their optimal use case

</details>

### Debugging

<details>
<summary>Debugging with local VS Code using custom enroot image</summary>
<br>

1. Create a new Dockerfile for the custom enroot image
```Dockerfile
### Base Image ###
# 24.01-py3: torch 2.1.2 <<Python 3.10>>
ARG BASE_TAG=24.01-py3  
ARG BASE_IMAGE=nvcr.io/nvidia/pytorch
FROM $BASE_IMAGE:$BASE_TAG AS main
# links for reference documentation
# https://docs.nvidia.com/deeplearning/frameworks/support-matrix/index.html
# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch

### Set up SSH ###
# install SSH server
RUN apt-get update && apt-get install openssh-server sudo -y

# change port and allow root login
RUN echo "Port <SSH port>" >> /etc/ssh/sshd_config
RUN echo "LogLevel DEBUG3" >> /etc/ssh/sshd_config

# create necessary directories and generate SSH keys
RUN mkdir -p /run/sshd
RUN ssh-keygen -A
RUN service ssh start

EXPOSE <SSH port>


# ... (add other necessary configurations)

### Start Container ###
# start the SSH server in daemon mode
CMD ["/usr/sbin/sshd","-D", "-e"]
```
2. Build and push the image as described in section "Container Setup"
3. Import the container image using enroot
```bash
srun -p $ANY_PARTITION \
enroot import \
-o /netscratch/$USER/<image path>.sqsh \
docker://<your username>/<your image>:<tag>
```
4. Adjust your ssh config on you local machine
```bash
# add to ~/.ssh/config
# replace <user> with your pegasus username
# replace <job> with your job name

Host devcontainer.dfki
	User <user>
	Port <SSH port>
	HostName localhost
	ProxyJump devnode.dfki
	CheckHostIP no
	StrictHostKeyChecking=no
	UserKnownHostsFile=/dev/null

Host devnode.dfki
	User <user>
	CheckHostIP no
	ProxyCommand ssh slurm.dfki "nc \$(squeue --me --name=<job name> --states=R -h -O NodeList) 22"
	StrictHostKeyChecking=no
	UserKnownHostsFile=/dev/null

Host slurm.dfki
	User <user>
	HostName <login node>
```
5. Start a compute job with the enroot container
```bash
srun -K \
    --container-mounts=/home/$USER:/home/$USER \ 
    --container-workdir=$(pwd) \
    --container-image=<your image path>.sqsh \
    --ntasks=1 --nodes=1 -p <your partition> \
    --gpus=1 \
    --job-name <your job name> \
    --no-container-remap-root \ 
    --time 2:00:00 /usr/sbin/sshd -D -e 
```
6. Confirm that you can connect to the container from the terminal
```bash
ssh devcontainer.dfki
```
7. Connect to the compute job from VS Code using the Remote - SSH extension. In VS Code, select Remote-SSH: Connect to Host... from the Command Palette (F1, ⇧⌘P)
8. Select the devcontainer.dfki host
9. Open the project folder in VS Code
10. Install necessary extensions in VS Code (e.g. Python)
10. Start debugging as usual

</details>

### Monitoring / Logging

[Job Monitoring Dashboard](http://monitoring.pegasus.kl.dfki.de/d/slurm-current-jobs/current-jobs?refresh=15s&autofitpanels&orgId=1&var-group=All&var-user=All&var-jobid=All&var-jobname=&var-state=All&var-partition=All&var-nodes=All)
