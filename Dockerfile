FROM debian

RUN apt-get update && apt-get -y install locales

RUN apt-get update \
    && apt-get -y install vim curl wget git zsh unzip\
    man sudo locate build-essential

RUN apt-get -y install python-dev python-pip \
        python3-dev python3-pip python3-venv \
        openjdk-8-jdk

RUN python3 -m pip install --upgrade pip
RUN python -m pip install --upgrade pip

RUN apt-get -y install gcc-multilib g++-multilib
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get -y install libc6-dbg libc6-dbg:i386 libc6:i386 libncurses5:i386 libstdc++6:i386

RUN useradd -m arsenal
RUN echo "arsenal ALL=NOPASSWD: ALL" > /etc/sudoers.d/arsenal
RUN chsh -s /usr/bin/zsh arsenal

USER arsenal
RUN mkdir -p /home/arsenal/tools
RUN mkdir -p /home/arsenal/tools/bin

RUN wget -O /home/arsenal/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
RUN echo "export PATH=/home/arsenal/tools/bin:$PATH" >> /home/arsenal/.zshrc
# Create Dirs for symlinks
RUN echo "find _data -name .gitignore -exec dirname '{}' \; | xargs -n1 | sed 's/_data\///' | xargs -n1 -I{} sh -c 'mkdir -p \$(dirname ~/{});'" >> /home/arsenal/.zshrc
# Symlink config dirs
RUN echo "find _data -name .gitignore -exec dirname '{}' \; | xargs -n1 | sed 's/_data\///' | xargs -n1 -I{} ln -sn ~/_data/{} ~/{}" >> /home/arsenal/.zshrc


WORKDIR /home/arsenal/tools
COPY ./scripts ./scripts

### Install Burpsuite ###
RUN . scripts/burpsuite/install

### Install Xmind ###
RUN . scripts/xmind/install

### Install Ghidra ###
RUN . scripts/ghidra/install

RUN sudo apt-get clean
WORKDIR /home/arsenal
CMD ["zsh", "-i"]
