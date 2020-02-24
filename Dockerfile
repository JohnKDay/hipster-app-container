FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y curl python-pip ruby wget jq bash-completion apt-transport-https sudo gnupg2 git tmux openssh-server vim software-properties-common && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && apt-get install --no-install-recommends -y kubectl=1.14.8-00 && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ && \
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    wget -q https://xpra.org/gpg.asc -O- | sudo apt-key add - && \
    add-apt-repository "deb https://xpra.org/ bionic main" && \
    apt-get update && apt-get install --no-install-recommends -y code xpra firefox sakura && \
    pip install awscli && \
    curl -s https://api.github.com/repos/kubernetes-sigs/aws-iam-authenticator/releases/latest | grep "browser_download.url.*linux_amd64" | cut -d : -f 2,3 | tr -d '"' | wget -O /usr/local/bin/aws-iam-authenticator -qi - && chmod 555 /usr/local/bin/aws-iam-authenticator && \
    curl -s https://api.github.com/repos/GoogleContainerTools/skaffold/releases/latest | grep "browser_download.url.*linux-amd64.$" | cut -d : -f 2,3 | tr -d '"' | wget -O /usr/local/bin/skaffold -qi - && chmod 555 /usr/local/bin/skaffold && \
    curl -sq https://storage.googleapis.com/kubernetes-helm/helm-v2.15.2-linux-amd64.tar.gz| tar zxvf - --strip-components=1 -C /usr/local/bin linux-amd64/helm && \
    curl -sq https://download.docker.com/linux/static/stable/x86_64/docker-18.09.9.tgz | tar zxvf - --strip-components=1 -C /usr/local/bin docker/docker && \
    rm -rf /var/lib/apt/lists/*

#COPY SAPDH /root/SAPDH
COPY bin/* /usr/local/bin/

# Configure SSHD
RUN mkdir /var/run/sshd
RUN echo 'root:hipster' | chpasswd
RUN useradd -ms /bin/bash hipster
RUN echo 'hipster:hipster' | chpasswd
RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# create ENV file to direct docker commands to DinD pod
RUN echo "DOCKER_HOST=tcp://localhost:2375" >> /etc/environment

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
EXPOSE 14500
CMD ["/usr/local/bin/prep_and_start_sshd.sh"]
