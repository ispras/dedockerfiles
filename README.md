# dedockerfiles

Collection of dockerfiles for dedoc group projects. Now available next dockerfiles:

* `dedoc_p3.9_baseimg.Dockerfile` — [base image](https://hub.docker.com/r/dedocproject/baseimg) for [dedoc](https://github.com/ispras/dedoc) project, include
`python3.9`, secure `pytorch1.11.0`, `tesseract-ocr 5.0`, `libreoffice` and some python tools in order to reduce time for its building in the main dockerfile

* `secure_torch_p3.9_baseimg.Dockerfile` — [base image](https://hub.docker.com/repository/docker/dedocproject/secure_torch_p3.9_baseimg) for ML projects based
on `python3.9` and secure `pytorch1.11.0`

* `secure_torch1.11.0_p3.9.Dockerfile` — image for building secure `pytorch`, `torchvision`, `torchdata` and `torchtext` from sources

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
