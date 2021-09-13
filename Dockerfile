FROM opensuse/tumbleweed

MAINTAINER Andrew V. Jones "andrew.jones@vector.com"

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ENV BUILD_DEPS \
    cmake \
    gcc11 \
    gcc11-c++ \
    git \
    ninja \
    glibc-devel \
    libffi-devel \
    gmp-devel \
    make \
    zlib-devel \
    git \
    gpg2 \
    wget \
    tar \
    gzip

RUN zypper --non-interactive install -y ${BUILD_DEPS} && \
    cd /etc/pki/trust/anchors && \
    wget http://devops.vectors.com/Vector_Root_CA_2.0.crt && \
    update-ca-certificates && \
    update-alternatives --remove-all gcc || \
    update-alternatives --remove-all g++ || \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 10 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 10 && \
    cd / && \
    mkdir stack && \
    cd stack && \
    wget --no-check-certificate https://get.haskellstack.org/stable/linux-x86_64.tar.gz && \
    tar -xzvf linux-x86_64.tar.gz && \
    cd stack-2.7.3-linux-x86_64 && \
    export PATH=/stack/stack-2.7.3-linux-x86_64:${PATH} && \
    cd / && \
    git -c http.sslVerify=false clone https://github.com/andrewvaughanj/psychec.git -b avj_original && \
    cd psychec && \
    cd solver && \
    stack build && \
    cd .. && \
    mkdir build && \
    cd build && \
    cmake -G Ninja .. && \
    ninja && \
    ./psychecgen -h

# EOF
