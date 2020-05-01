FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
  ncurses-dev libtool-bin gawk help2man texinfo flex bison libexpat-dev \
  gperf autoconf automake build-essential git wget unzip python python-dev \
  && rm -rf /var/lib/apt/lists/*

# crosstool-NG will not run under root...
RUN groupadd toolchain \
  && useradd -g toolchain -m -s /bin/bash toolchain \ 
  && mkdir /toolchain \
  && chown -R toolchain:toolchain /toolchain

USER toolchain

# This patch is applied similiar to pfalcon/esp-open-sdk to work with micropython
ADD --chown=toolchain:toolchain 1000-mforce-l32.patch /toolchain/1000-mforce-l32.patch

# Build and install crosstool-NG (built with prefix build directory to apply local patches)
# Use latest branch xtensa-1.22.x with gcc 4.8.5
RUN cd /toolchain \
  && git clone https://github.com/jcmvbkbc/crosstool-NG \
  && cd crosstool-NG \
  && git checkout xtensa-1.22.x \
  && cp /toolchain/1000-mforce-l32.patch local-patches/gcc/4.8.5/ \
  && ./bootstrap \
  && ./configure --prefix=`pwd` \
  && make MAKELEVEL=0 \
  && make install MAKELEVEL=0

# Now configure and build xtensa cross compiler
RUN cd /toolchain/crosstool-NG \
  && ./ct-ng xtensa-lx106-elf \
  && sed -r -i s%CT_INSTALL_DIR_RO=y%"#"CT_INSTALL_DIR_RO=y% .config \
  && ./ct-ng build \
  && rm builds/xtensa-lx106-elf/build.log.bz2

FROM ubuntu:18.04

COPY --from=0 /toolchain/crosstool-NG/builds/xtensa-lx106-elf /usr/lib/gcc-cross/xtensa-lx106-elf

RUN chown -R 0:0 /usr/lib/gcc-cross/xtensa-lx106-elf