FROM gcc:4.9
RUN apt-get update; exit 0
RUN apt-get -y install cmake \
  && apt-get -y install python-pip \
  && svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_381/final /tmp/llvm-3.8.1/src \
  && svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_381/final /tmp/llvm-3.8.1/src/tools/clang \
  && mkdir /tmp/llvm-3.8.1/build && cd /tmp/llvm-3.8.1/build \
  && cmake /tmp/llvm-3.8.1/src && make -j4 \
  && make install && cd - && rm -rf /tmp/llvm-3.8.1 \
  && pip install wllvm
ENV LLVM_COMPILER=clang
  
