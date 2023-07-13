# Getting started

This repository contains tutorials, scripts, examples etc. for getting started with your machine learning / NLP project.

The information are mainly tailored to users of [DFKI's PEGASUS system](http://projects.dfki.uni-kl.de/km-publications/web/ML/core/hpc-doc/).

## Software development

### IDE

### Debugger

## Remote server 

### SSH

- SSH key
- SSH config

### tmux, screen, ...

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
