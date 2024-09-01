Test of Yocto build of Azure IoT Edge from repository[meta-iotedge](https://github.com/Azure/meta-iotedge)
=========================================================================================================

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

If you have some issues with building Azure IoT Edge for Yocto from the repository
[meta-iotedge](https://github.com/Azure/meta-iotedge), this project will help
to investigate these issues. Some of your issues might be caused by special
settings of your project. So, only a bare minimum configuration is used to stay
as close to default Yocto settings as possible.



Requirements
------------

- Linux [Docker](https://www.docker.com) or [Podman](https://podman.io/)




Usage
-----

1. **Build the docker image**.  ([`Dockerfile.ubuntu22`](./docker/Dockerfile.ubuntu22))

    ```sh
    docker build -f docker/Dockerfile.ubuntu22 -t local/yocto-meta-iotedge-test:latest  docker/
    ```
2. **Run the container**.  
    The container does not run any command automatically as this would prevent investigation and
    scrutiny. Therefore, you need to execute all commands yourself.

    ```sh
    ./run-docker.sh
    ```
3. **Initial set-up the build environment**.  
    Execute the initialisation script inside the container to setup the build environment.

    ```sh
    cd /yocto-build
    ./init-yocto-build.sh
    ```
    This script will:
    1. Fetch and install the Google tool [`repo`](https://source.android.com/docs/setup/develop/repo).
    2. Fetch the Yocto sources involved.
    3. Create a local yocto configuration.
    4. Add the layers to the build.
4. **Build the Azure IoT Edge packages and see what happens**. 
 
    ```sh
    cd /yocto-build
    source ./sources/poky/oe-init-build-env build
    bitbake aziot-edged
    ```





Useful commands
---------------

### Install missing packages

The build inside the container runs as non-priviledged user `yocto` as the Yocto build systems properly complains
if run a s`root`. Hence, you are not able to directly install any missing package. To do that, you need to execute
a shell inside the container as `root` and then install packages.

```sh
docker exec -it -u 0:0 $CONTAINER_HASH_OR_NAME apt install -y $PACKAGE_NAME_TO_INSTALL
```


