# llvm-docker
[Docker](https://docs.docker.com) image of LLVM installed from source 

## Get the image Ready and run
Pull the docker image or build the docker image locally
1. Pulling the image
pull the image
```
docker pull thierrytct/llvm:<VERSION>
```
Run Docker container
```
docker run --rm -it thierrytct/llvm:<VERSION> /bin/bash
```

2. Building the image locally
Make the image (Optionally use `--build-arg <ARG>=<value>` to set llvm version...)
```
git clone https://github.com/thierry-tct/llvm-docker.git llvm-docker
docker build --tag thierrytct/llvm llvm-docker
```
Run Docker container
```
docker run --rm -it thierrytct/llvm /bin/bash
```

---
## Building for upload
docker build -t llvm:3.4.2 . --build-arg llvm_version_local=llvm-3.4.2 --build-arg llvm_version_release=RELEASE_342

