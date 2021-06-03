# About MySQL Layer for Ask Nicely
We use this repo to build the MySQL Lambda Layer for our Ask Nicely Lambda app.

At the moment this is locked to version `MySQL 5.7.34`. The same version number found in our SQL fixtures.

## Prerequisites
Running `gcc -v` in your CLI should at least return something. If not you would have to install Xcode + some CLI tools.

## Building the layer
Make sure you have Docker running then run `make mysql`.

```
➜  mysql-lambda git:(master) ✗ make mysql
docker build -f Dockerfile.mysql . -t mysql-layer --build-arg VERSION=5.7.34
[+] Building 493.9s (12/12) FINISHED
 => [internal] load build definition from Dockerfile.mysql                                                                                                                              0.0s
 => => transferring dockerfile: 43B                                                                                                                                                     0.0s
 => [internal] load .dockerignore                                                                                                                                                       0.0s
 => => transferring context: 2B                                                                                                                                                         0.0s
 => [internal] load metadata for docker.io/library/amazonlinux:latest                                                                                                                   1.3s
 => [1/8] FROM docker.io/library/amazonlinux@sha256:06b9e2433e4e563e1d75bc8c71d32b76dc49a2841e9253746eefc8ca40b80b5e                                                                    0.0s
 => CACHED [2/8] WORKDIR /root                                                                                                                                                          0.0s
 => CACHED [3/8] RUN yum -y update && yum install -y cmake3 make gcc-c++ ncurses-devel openssl-devel python-devel wget tar gzip which zip                                               0.0s
 => [4/8] RUN wget -q https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.34.tar.gz                                                                                                 9.3s
 => [5/8] RUN tar xzf mysql-5.7.34.tar.gz                                                                                                                                               5.9s
 => [6/8] RUN cd mysql-5.7.34; mkdir build; cd build; cmake3 .. -DCMAKE_INSTALL_PREFIX=/opt -DWITHOUT_SERVER=ON -DDOWNLOAD_BOOST=ON -DWITH_BOOST=/root/boost && make install          435.2s
 => [7/8] RUN cp /usr/lib64/libncurses.so.6 /usr/lib64/libtinfo.so.6 /opt/lib/                                                                                                          0.3s
 => [8/8] RUN cd /opt; strip bin/* lib/*; rm lib/*.a; zip -9r /root/mysql-5.7.34-layer.zip bin lib share                                                                               14.8s
 => exporting to image                                                                                                                                                                 26.9s
 => => exporting layers                                                                                                                                                                26.9s
 => => writing image sha256:e23cba24594542237f867922ad4ae75c0f677e1772c9c6ca86ff9ba803bed55e                                                                                            0.0s
 => => naming to docker.io/library/mysql-layer                                                                                                                                          0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
docker container cp 2c17c0cc5cdcb6e7e9688d44d7dbabde75cdd1f7ea72f92909f62790b521ae2e:/root/mysql-5.7.34-layer.zip .
```

In the same directory, you would end up with a zip file: `mysql-5.7.34-layer.zip`

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
