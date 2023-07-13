# Getting started

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

SSH config
- https://linuxhandbook.com/ssh-config-file/
- https://www.cyberciti.biz/faq/create-ssh-config-file-on-linux-unix/

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

## Docker & containers

## Jupyter notebooks
