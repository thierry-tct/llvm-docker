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
The recommended approach is to use the script `buildimage.sh` which can be ran by optionally specifyion the llvm version (e.g. 9.0.0) and the source image (e.g. ubuntu 20.04).
Make sure to run as super user (sudo)
Before that, make sure to login, using `sudo docker login` .

All together:

```
sudo docker login

sudo ./buildimage.sh [llvm version] [source image name]
```
