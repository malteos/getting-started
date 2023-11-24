# Getting started

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://makeapullrequest.com) 

This repository contains tutorials, scripts, examples etc. for getting started with your machine learning / NLP project.

The information are mainly tailored to users of [DFKI's PEGASUS system](http://projects.dfki.uni-kl.de/km-publications/web/ML/core/hpc-doc/).

## Software development

### IDE

- https://code.visualstudio.com/
   - Python with VSCode: https://donjayamanne.github.io/pythonVSCodeDocs/docs/python-path/
- https://www.jetbrains.com/pycharm/

### Debugger

One of the key features of any good IDE is its debugging support. The debugger will make it much easier to fix your code (no need for print-statements anymore).

Tutorials for debuggers:
- https://code.visualstudio.com/docs/editor/debugging
- https://www.youtube.com/watch?v=6cOsxaNC06c
- How To Debug Python Code In Visual Studio Code (VSCode) https://www.youtube.com/watch?v=oCcTiRGPogQ


### GitHub Copilot

- If you are a student, apply for a [GitHub education account](https://education.github.com/discount_requests/application).
- Install [GitHub Copilot](https://github.com/features/copilot)! See [VSCode extensions](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot).

### Coding best practices

Get familar with coding standards and best practices! This improve your code by a lot and makes it much easier to maintain.

- [The Hitchhiker’s Guide to Python Code Style](https://docs.python-guide.org/writing/style/)
- [A PyTorch Tools, best practices & Styleguide](https://github.com/IgorSusmelj/pytorch-styleguide)
 
You can use automated tools to enforce coding styles:

- [VSCode: Using Black to automatically format Python](https://dev.to/adamlombard/how-to-use-the-black-python-code-formatter-in-vscode-3lo0)
- [Python: Linting & Formatting](https://py-vscode.readthedocs.io/en/latest/files/linting.html)

## Remote server 

Today's machine learning requires large computing resources that your local machine won't have. Thus, you need to connect a remote server to run your experiments.

- [How to use CLI instead of GUI](https://github.com/you-dont-need/You-Dont-Need-GUI)

### SSH

- [How to Use SSH to Connect to a Remote Server in Linux or Windows](https://phoenixnap.com/kb/ssh-to-connect-to-remote-server-linux-or-windows)
- http://projects.dfki.uni-kl.de/km-publications/web/ML/core/hpc-doc/docs/guidelines/getting-started/

SSH keys
- [Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

### SSH config
- https://linuxhandbook.com/ssh-config-file/
- https://www.cyberciti.biz/faq/create-ssh-config-file-on-linux-unix/

#### Example

A SSH-config may contain entries like below. Replace `<dfki_account`> with your DFKI Account and `<pegasus_account>` with your PEGASUS account.
```bash
# PEGASUS via SSH-Gate
Host pegasus.dfki  # a custom hostname
    User <pegasus_account>
    HostName login2.pegasus.kl.dfki.de  # change this to a different login node if needed
    ProxyJump <dfki_account>@sshgate.sb.dfki.de

```

With such a config, you can simply connect to PEGASUS by typing `ssh pegasus.dfki`.

#### SSH proxy

An SSH connectio can be used a proxy to access resources from the intranet:

```bash
# replace <proxy_port> with a port number, e.g. 8001
ssh -D <proxy_port> pegasus.dfki
```

This creates a SOCKS proxy (see https://ma.ttias.be/socks-proxy-linux-ssh-bypass-content-filters/).

Enable this proxy via or system settings or browser settings or use a proxy browser plugin like [FoxyProxy](https://help.getfoxyproxy.org/index.php/knowledge-base/how-to-use-your-proxy-service-with-chrome-and-foxyproxy-extension/):

Use the following settings:

-  Proxy Type: SOCKS5
-  Proxy IP address: localhost
-  Proxy port: `<proxy_port>`


### tmux

You connection to a remote might be lost and, therefore, it is important to maintain sessions of the remote server independent from your own connection. 
`tmux` provides this and many other features that will make your work on remote servers much easier.

- [A Quick and Easy Guide to tmux](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)
- [tmux cheatsheet](https://gist.github.com/henrik/1967800)

Alternatives to tmux are: [screen](https://linuxize.com/post/how-to-use-linux-screen/), ...



### Environment

#### `.bashrc` example

The `.bashrc` in your home directory is loaded everytime you start a bash session. 
It is a good place to define global environment variables, e.g., cache paths or login credentials. For example:

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
export TRANSFORMERS_CACHE="/netscratch/$USER/datasets/transformers_cache/"

# Weights & Biases
export WANDB_API_KEY<your WANDB api>
```

#### Python environments (conda / virtualenv / ...)

## Slurm

Read the [PEGASUS documentation](http://projects.dfki.uni-kl.de/km-publications/web/ML/core/hpc-doc/). It should provide all necassary information. For other questions, please use the cluster chat.

Some potentially useful commands:
```bash
# starts an interactive job with pytorch (8hrs time limit)
$ srun -K \
  --container-image=/netscratch/enroot/nvcr.io_nvidia_pytorch_23.07-py3.sqsh \
  --container-workdir="`pwd`" \
  --container-mounts=/netscratch/$USER:/netscratch/$USER,/ds:/ds:ro,"`pwd`":"`pwd`" \
   --time 08:00:00 --pty bash

# list your current jobs
squeue --me
```

## Docker & containers

PEGASUS uses enroot for containers. If you have rebuild Docker images you can convert them as follows:
```bash
srun -p $ANY_PARTITION \
  enroot import \
  -o /netscratch/$USER/enroot/malteos_eulm_latest.sqsh \
  'docker://ghcr.io#malteos/eulm:latest'
```

Build custom images with Podman:
```bash
sbin/podman_build.sh
```

## Jupyter notebooks

You can run Jupyter noteboks on Pegasus:

```bash
# start interactive compute job
# --container-save=$EVAL_DEV_IMAGE 
srun \
  --container-mounts=/netscratch:/netscratch,/home/$USER:/home/$USER \
  --container-image=$IMAGE \
  --container-workdir=$(pwd) -p RTX6000 --time 08:00:00 --pty /bin/bash

# run in compute job
echo "Jupyter starting at ... http://${HOSTNAME}.kl.dfki.de:8880" && jupyter notebook --ip=0.0.0.0 --port=8880 \
    --allow-root --no-browser --config /home/mostendorff/.jupyter/jupyter_notebook_config.json \
    --notebook-dir /netscratch/mostendorff/experiments

# start with fixed token (for VSCode -> "Specify Jupyter connection")
JUPYTER_TOKEN=yoursecrettoken jupyter notebook
```


## Other useful links & resources

- https://github.com/stas00/ml-engineering/
