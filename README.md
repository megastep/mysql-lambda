# About MySQL Layer for Ask Nicely
We use this repo to build the MySQL Lambda Layer for our Ask Nicely Lambda app.

At the moment this is locked to version `MySQL 8.0.32`.
## Prerequisites
Running `gcc -v` in your CLI should at least return something. If not you would have to install Xcode + some CLI tools.

## Building the layer
Make sure you have Docker running then run `make mysql`.

```
david@MacBook-Pro mysql-lambda % make mysql                         
docker build -f Dockerfile.mysql . -t mysql-layer --build-arg VERSION=8.0.32
[+] Building 3.5s (15/15) FINISHED                                                                                                                                                                                                   
 => [internal] load build definition from Dockerfile.mysql                                                                                                                                                                      0.0s
 => => transferring dockerfile: 930B                                                                                                                                                                                            0.0s
 => [internal] load .dockerignore                                                                                                                                                                                               0.0s
 => => transferring context: 2B                                                                                                                                                                                                 0.0s
 => [internal] load metadata for docker.io/library/amazonlinux:2                                                                                                                                                                3.4s
 => [ 1/11] FROM docker.io/library/amazonlinux:2@sha256:4f39d87731b57d3be630f9877ab25c4f4cfa8adc3039592c8c00a14235cb2a2b                                                                                                        0.0s
 => CACHED [ 2/11] WORKDIR /root                                                                                                                                                                                                0.0s
 => CACHED [ 3/11] RUN yum -y update && yum install -y cmake3 make gcc-c++ ncurses-devel openssl11 openssl11-devel python-devel wget tar gzip which zip unzip                                                                   0.0s
 => CACHED [ 4/11] RUN wget -q https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.32.tar.gz                                                                                                                                0.0s
 => CACHED [ 5/11] RUN tar xzf mysql-8.0.32.tar.gz                                                                                                                                                                              0.0s
 => CACHED [ 6/11] RUN cd mysql-8.0.32; mkdir build; cd build; cmake3 .. -DCMAKE_INSTALL_PREFIX=/opt -DWITHOUT_SERVER=ON -DDOWNLOAD_BOOST=ON -DWITH_BOOST=/root/boost && make install                                           0.0s
 => CACHED [ 7/11] RUN cp /usr/lib64/libncurses.so.6 /usr/lib64/libtinfo.so.6 /usr/lib64/libssl.so.1.1 /usr/lib64/libcrypto.so.1.1 /opt/lib/                                                                                    0.0s
 => CACHED [ 8/11] RUN cd /opt; strip bin/* lib/*; rm lib/*.a;                                                                                                                                                                  0.0s
 => CACHED [ 9/11] RUN cd /opt/bin; mv mysql mysqldump ..; rm *; cd ..; mv mysql mysqldump ./bin                                                                                                                                0.0s
 => CACHED [10/11] RUN cd /usr/bin; cp zip unzip /opt/bin                                                                                                                                                                       0.0s
 => CACHED [11/11] RUN cd /opt; zip -9r /root/mysql-8.0.32-layer.zip bin lib                                                                                                                                                    0.0s
 => exporting to image                                                                                                                                                                                                          0.0s
 => => exporting layers                                                                                                                                                                                                         0.0s
 => => writing image sha256:c80c78609c6bd09bb46145ffee6c086f7df09568b0c06d2147e8776128ade216                                                                                                                                    0.0s
 => => naming to docker.io/library/mysql-layer                                                                                                                                                                                  0.0s
docker container cp 1200023791b3d2e26b388ab915760cdfb2d7d4dd37c32a94b0f292e656b857d1:/root/mysql-8.0.32-layer.zip .
                               Successfully copied 12.7MB to /Users/david/workspace/mysql-lambda/.
david@MacBook-Pro mysql-lambda %
```

In the same directory, you should end up with a zip file: `mysql-8.0.32-layer.zip`

## Known issues

If you get these errors:
```
Unable to find image 'mysql-layer:latest' locally
Error response from daemon: pull access denied for mysql-layer, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
```
and these errors:
```
docker container cp :/root/mysql-8.0.32-layer.zip .                                                                                                                                                                                  
must specify at least one container source                                                                                                                                                                                           
make: *** [mysql-8.0.32-layer.zip] Error 1
```

Try running this before the `make mysql`:
```
docker container create mysql-layer
```

## What to do after you have generated the zip file?
Ideally, we should just upload that file as a Layer in AWS. Unfortunately, we are hitting some file size limits.
To go around this file size limit, we unzip the file and manually delete the other files that we do not need.

We leave:
* `/bin/mysql`
* `/bin/mysqldump`

We zip it up again. In the end, we would have a very small zip file containing at least `mysql` and `mysqldump`.

## Releases
https://github.com/asknicely/mysql-lambda/releases

## Fork
This repo was forked from: https://github.com/megastep/mysql-lambda
