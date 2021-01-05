##
# sudo docker build --no-cache -t thierrytct/llvm:9.0.1 . --build-arg llvm_version_local=9.0.1 && sudo docker push thierrytct/llvm:9.0.1
##

#ARG gcc_version=gcc:4.9
#ARG used_image=python
#ARG used_image=ubuntu:18.04
ARG used_image=ubuntu:20.04

FROM $used_image

ARG llvm_version_local=9.0.1

RUN apt-get -y update; exit 0
RUN apt-get -y install cmake \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && cd - \
  && ln -s $(which pip3) $(dirname $(which pip3))/pip \
  && apt-get -y install apache2 git \
  && git clone -b llvmorg-$llvm_version_local --depth 1 https://github.com/llvm/llvm-project /home/LLVM/llvm-${llvm_version_local}/src \
  && cp -r /home/LLVM/llvm-${llvm_version_local}/src/clang /home/LLVM/llvm-${llvm_version_local}/src/llvm/tools \
  && mkdir /home/LLVM/llvm-$llvm_version_local/build_cmake && cd /home/LLVM/llvm-$llvm_version_local/build_cmake \
  && CXXFLAGS='-g' cmake CMAKE_BUILD_TYPE=Debug /home/LLVM/llvm-$llvm_version_local/src/llvm && CXXFLAGS='-g' make -j4 \
  && make install && cd - && rm -rf /home/LLVM/llvm-$llvm_version_local/build_cmake \
  && pip install wllvm \
  && if [ "$llvm_version_local" = "3.4.2" ]; then \
        sed -i'' "s|/home/LLVM/llvm-$llvm_version_local/build_cmake/bin|$(dirname $(which clang))|g; s|/home/LLVM/llvm-$llvm_version_local/src/llvm/cmake/modules|/usr/local/share/llvm/cmake/|g" \
		/usr/local/share/llvm/cmake/LLVMConfig.cmake ; \
     fi
ENV LLVM_COMPILER=clang


  
#  && if test -f /home/LLVM/llvm-$llvm_version_local/src/llvm/configure; then mkdir /home/LLVM/llvm-$llvm_version_local/build_configure \
#    && cd /home/LLVM/llvm-$llvm_version_local/build_configure \
#    && CC=clang CXX=clang++ /home/LLVM/llvm-$llvm_version_local/src/llvm/configure --enable-cxx11 && CC=clang CXX=clang++ make -j4 ; fi \
