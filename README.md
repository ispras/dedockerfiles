# dedockerfiles

Collection of dockerfiles for dedoc group projects. The following dockerfiles are available:

* `dedoc_p3.9_base.Dockerfile` — [base image](https://hub.docker.com/r/dedocproject/dedoc_p3.9_base) for [dedoc](https://github.com/ispras/dedoc) project, include
`python3.9`, secure `torch-1.11.0`, `torchvision-0.12.0`, `tesseract-ocr 5.0`, `libreoffice` and some python tools in order to reduce time for its building in the main dockerfile

* `secure_torch_p3.9_base.Dockerfile` — [base image](https://hub.docker.com/repository/docker/dedocproject/secure_torch_p3.9_base) for ML projects based
on `python3.9` and secure `torch-1.11.0` and `torchvision-0.12.0`

* `secure_torch/secure_torch1.11.0_p3.8.Dockerfile` — image for building secure `torch-1.11.0`, `torchvision-0.12.0`, `torchdata-0.3.0` and `torchtext-0.12.0` from sources
with `python3.8`

* `secure_torch/secure_torch1.11.0_p3.9.Dockerfile` — image for building secure `torch-1.11.0`, `torchvision-0.12.0`, `torchdata-0.3.0` and `torchtext-0.12.0` from sources
with `python3.9`

* `secure_torch/secure_torch1.11.0_p3.10.Dockerfile` — image for building secure `torch-1.11.0`, `torchvision-0.12.0`, `torchdata-0.3.0` and `torchtext-0.12.0` from sources
with `python3.10`

## Build the new image locally 

Run the command below from the project root (replace the <image_name> with the name of the desired image)

```shell
export VERSION_TAG=$(date '+%Y_%m_%d')
docker build -t dedocproject/<image_name>:version_$VERSION_TAG -f <image_name>.Dockerfile .
```

## Push the built image to the remote repository

The commands below allow to push the image to the [docker-hub](https://hub.docker.com).
You need login and password for this purpose. 

```shell
docker login -u dedocproject -p <password>
docker tag dedocproject/<image_name>:version_$VERSION_TAG dedocproject/<image_name>:latest
docker push dedocproject/<image_name>:version_$VERSION_TAG
docker push dedocproject/<image_name>:latest
```

## Get torch wheels from docker

Build pytorch image and run it in the first terminal:
```shell
docker build -t secure_torch -f secure_torch/secure_torch1.11.0_p3.9.Dockerfile .
docker run secure_torch
```

Open second terminal and view running container identifier:
```shell
docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS                  PORTS     NAMES
35faf7265eca   secure_torch   "/bin/sh -c 'sleep 3…"   3 seconds ago   Up Less than a second             inspiring_brahmagupta
```

Copy wheel files from running container:
```shell
docker cp 35faf7265eca:/pytorch/dist/torch-1.11.0a0+git137096a-cp39-cp39-linux_x86_64.whl .
docker cp 35faf7265eca:/torchvision/dist/torchvision-0.12.0a0+9b5a3fe-cp39-cp39-linux_x86_64.whl .
docker cp 35faf7265eca:/torchdata/dist/torchdata-0.3.0a0+fbf097d-py3-none-any.whl .
docker cp 35faf7265eca:/torchtext/dist/torchtext-0.12.0a0+d7a34d6-cp39-cp39-linux_x86_64.whl .
```
