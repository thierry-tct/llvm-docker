#ARG gcc_version=gcc:4.9
#ARG used_image=python
ARG used_image=ubuntu:14.04
#ARG used_image=ubuntu:18.04

FROM $used_image

ARG llvm_version_local=llvm-3.8.1
ARG llvm_version_release=RELEASE_381

RUN apt-get -y update; exit 0
RUN apt-get -y install cmake \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && cd - \
  && ln -s $(which pip3) $(dirname $(which pip3))/pip \
  && apt-get -y install apache2 && apt-get -y install subversion \
  && svn co http://llvm.org/svn/llvm-project/llvm/tags/${llvm_version_release}/final /home/LLVM/${llvm_version_local}/src \
  && svn co http://llvm.org/svn/llvm-project/cfe/tags/$llvm_version_release/final /home/LLVM/$llvm_version_local/src/tools/clang \
  && mkdir /home/LLVM/$llvm_version_local/build_cmake && cd /home/LLVM/$llvm_version_local/build_cmake \
  && cmake CMAKE_BUILD_TYPE=debug /home/LLVM/$llvm_version_local/src && make -j4 \
  && make install && cd - && rm -rf /home/LLVM/$llvm_version_local/build_cmake \
  && pip install wllvm
ENV LLVM_COMPILER=clang


  
#  && if test -f /home/LLVM/$llvm_version_local/src/configure; then mkdir /home/LLVM/$llvm_version_local/build_configure \
#    && cd /home/LLVM/$llvm_version_local/build_configure \
#    && CC=clang CXX=clang++ /home/LLVM/$llvm_version_local/src/configure --enable-cxx11 && CC=clang CXX=clang++ make -j4 ; fi \
