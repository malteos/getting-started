ARG BASE_TAG=23.05-py3  
# 23.05-py3: torch 2.0.0 <<Python 3.10>>

ARG BASE_IMAGE=nvcr.io/nvidia/pytorch

FROM $BASE_IMAGE:$BASE_TAG AS main
# https://docs.nvidia.com/deeplearning/frameworks/support-matrix/index.html
# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch

RUN echo 'APT::Sandbox::User "root";' > /etc/apt/apt.conf.d/sandbox-disable
#RUN apt-get update

# USER root
# RUN mkdir /app
# WORKDIR /app

# # Install git-lfs for huggingface hub cli
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get update && apt-get install git-lfs
RUN git lfs install

# Install other utils
RUN apt-get update && apt-get install tree -y

# Install SSH server
RUN apt-get update && apt-get install openssh-server sudo -y

# change port and allow root login
RUN echo "Port 5022" >> /etc/ssh/sshd_config
RUN echo "LogLevel DEBUG3" >> /etc/ssh/sshd_config

RUN mkdir -p /run/sshd
RUN ssh-keygen -A
RUN service ssh start

# copy req file first
COPY requirements.txt /app/requirements.txt

# A hacky but working way to exclude deepspeed, apex and torch from the requirements (we install them manually or they are part of base image)
RUN sed -i 's/^torch/# &/' /app/requirements.txt
RUN pip install -r /app/requirements.txt
RUN sed -i 's/^# \(torch\)/\1/' /app/requirements.txt

# Copy all other project files
COPY . /app

# # Create non-root user and give permissions to /app
# RUN useradd -ms /bin/bash docker
# RUN chown -R docker:docker /app

CMD ["/bin/bash"]

# USER docker
# CMD ["/bin/bash"]
