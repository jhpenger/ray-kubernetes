FROM ubuntu:latest
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# disable interactive functions, suppress tzdata prompting for geographic location
ENV DEBIAN_FRONTEND noninteractive

# missing tzdata in 18.04 beta
RUN apt-get update && \
    apt-get install -y tzdata

RUN apt-get update \
    && apt-get install -y vim git wget \
    && apt-get install -y cmake build-essential autoconf curl libtool libboost-all-dev unzip \
    && apt-get install -y python3-pip
RUN pip3 install --upgrade pip
RUN git clone https://github.com/jhpenger/ray-kubernetes.git
RUN pip install numpy

#install additional dependencies
RUN apt-get update \
    && apt-get -y install flex \
    && apt-get -y install bison \
    && apt-get install -y nano \
    && apt-get install -y openssh-server \
    && apt install -y python-opencv \
    && apt install pssh \
    && pip install cython \
    && pip install pyarrow \
    && apt-get install -y pkg-config \
    && pip install modin \
    && pip install tensorflow \
    && pip install gym \
    && pip install scipy \
    && pip install opencv-python \
    && pip install bokeh \
    && pip install ipywidgets==6.0.0 \
    && pip install jupyter \
    && pip install lz4

RUN echo "alias python='python3'" >> ~/.bashrc \
	&& source ~/.bashrc

RUN ssh-keygen -f /root/.ssh/id_rsa -P "" \
    && echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

#RUN echo "export LC_ALL='C.UTF-8'" >> ~/.bashrc \
#   && echo "export LANG='C.UTF-8'" >> ~/.bashrc
