#! /bin/bash
# Run this as super user (sudo)

set -u

error_exit()
{
    echo "Error: $1"
    exit 1
}

# Decide whether to use the prebuild files for the newer llvm version (1: yes, 0: no)
NewerVersionFromSource=0

TOPDIR=$(dirname $(readlink -f $0))

used_image="ubuntu:20.04"
llvm_version="9.0.0"

if [ $# -eq 1 -o $# -eq 2 ]
then
    llvm_version=$1
    if [ $# -eq 2 ]
    then
        used_image=$2
    fi
else
    [ $# -eq 0 ] || error_exit "expected one or two optional arguments: <llvm version (e.g.: 9.0.1)> <used image>"
fi


# use Dockerfile for versions before 5.x.x, from 5.x.x, use the script in llvm repo

major=$(echo $llvm_version | cut -d'.' -f1)

cd $TOPDIR

if [ $NewerVersionFromSource -eq 1 -o $major -lt 5 ]
then
    docker build --no-cache -t thierrytct/llvm:$llvm_version . --build-arg llvm_version_local=$llvm_version --build-arg used_image=$used_image \
                                                                                        || error_exit "docker call failed (version is $llvm_version)"
else
    # use the Docker build script from https://github.com/silkeh/docker-clang
    test -d docker-clang && rm -rf docker-clang
    git clone https://github.com/silkeh/docker-clang docker-clang
    cd docker-clang

    dft=Dockerfile.template
    test -f $dft || error_exit "template missing"
    sed -i'' "s/{release}/$major/g; s/{version}/$llvm_version/g; s/{image}/$used_image/g" $dft || error_exit "sed failed"
    sed -i'' "/# Install dependencies/iENV DEBIAN_FRONTEND=noninteractive" $dft  # Avoid apt get install to ask for region and hang
    
    echo '
    # Install useful
    RUN apt-get -y install cmake \
      && apt-get install -y python3-pip python3-dev \
      && cd /usr/local/bin \
      && ln -s /usr/bin/python3 python \
      && cd - \
      && ln -s $(which pip3) $(dirname $(which pip3))/pip \
      && apt-get -y install apache2 git \
      && pip install wllvm' >> $dft
    
    docker build --no-cache -t thierrytct/llvm:$llvm_version -f $dft . || error_exit "docker call failed (version is $llvm_version)"
    
    cd -
    rm -rf docker-clang
fi

docker push thierrytct/llvm:$llvm_version
