#ARG gcc_version=gcc:4.9
ARG used_image=python

FROM $used_image

ARG llvm_version_local=llvm-3.8.1
ARG llvm_version_release=RELEASE_381

RUN apt-get -y update; exit 0
RUN apt-get -y install cmake \
  && apt-get -y install python3-pip \
  && svn co http://llvm.org/svn/llvm-project/llvm/tags/${llvm_version_release}/final /LLVM/${llvm_version_local}/src \
  && svn co http://llvm.org/svn/llvm-project/cfe/tags/$llvm_version_release/final /LLVM/$llvm_version_local/src/tools/clang \
  && mkdir /LLVM/$llvm_version_local/build && cd /LLVM/$llvm_version_local/build \
  && cmake /LLVM/$llvm_version_local/src && make -j2 \
  && make install && cd - && rm -rf /LLVM/$llvm_version_local \
  && pip install wllvm
ENV LLVM_COMPILER=clang
  
