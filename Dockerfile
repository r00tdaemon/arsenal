FROM debian

RUN apt-get update && apt-get -y install locales

RUN apt-get update \
    && apt-get -y install vim curl wget git zsh \
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

WORKDIR /home/arsenal/tools

### Install Burpsuite ###
RUN wget -O ./burp.jar 'https://portswigger.net/DownloadUpdate.ashx?Product=Free' \
    && chmod +x ./burp.jar
RUN echo "#! /bin/bash \n\
java -jar /home/arsenal/tools/burp.jar > /dev/null 2>&1 & \n" > bin/burpsuite \
    && chmod +x bin/burpsuite

### Install Xmind ###
RUN wget -O xmind.deb 'https://dl3.xmind.net/XMind-ZEN-for-Linux-64bit.deb' \
    && sudo apt-get -y install ./xmind.deb \
    && rm -f xmind.deb
RUN echo "#! /bin/bash \n\
XMind > /dev/null 2>&1 & \n" > bin/xmind \
    && chmod +x bin/xmind

RUN sudo apt-get clean
WORKDIR /home/arsenal
CMD ["zsh", "-i"]
