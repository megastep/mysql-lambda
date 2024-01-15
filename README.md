# About MySQL Layer for Ask Nicely
We use this repo to build the MySQL Lambda Layer for our Ask Nicely Lambda app.

At the moment this is locked to version `MySQL 8.0.33`.
## Prerequisites
Running `gcc -v` in your CLI should at least return something. If not you would have to install Xcode + some CLI tools.

## Building the layer
Make sure you have Docker running then run `make mysql`.

```
nickrobinson@Nicks-MacBook-Pro mysql-lambda % make mysql
docker build -f Dockerfile.mysql . -t mysql-layer --build-arg VERSION=8.0.33
[+] Building 2.0s (15/15) FINISHED                                    docker:desktop-linux
 => [internal] load build definition from Dockerfile.mysql                            0.0s
 => => transferring dockerfile: 974B                                                  0.0s
 => [internal] load .dockerignore                                                     0.0s
 => => transferring context: 2B                                                       0.0s
 => [internal] load metadata for docker.io/amd64/amazonlinux:2                        2.0s
 => [ 1/11] FROM docker.io/amd64/amazonlinux:2@sha256:a3f073fc570d69f9dbc387ea4084ba  0.0s
 => CACHED [ 2/11] WORKDIR /root                                                      0.0s
 => CACHED [ 3/11] RUN yum -y update && yum install -y cmake3 make gcc-c++ ncurses-d  0.0s
 => CACHED [ 4/11] RUN wget -q https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8  0.0s
 => CACHED [ 5/11] RUN tar xzf mysql-8.0.33.tar.gz                                    0.0s
 => CACHED [ 6/11] RUN cd mysql-8.0.33; mkdir build; cd build; cmake3 .. -DCMAKE_INS  0.0s
 => CACHED [ 7/11] RUN cp /usr/lib64/libncurses.so.6 /usr/lib64/libtinfo.so.6 /usr/l  0.0s
 => CACHED [ 8/11] RUN cd /opt; strip bin/* lib/*; rm lib/*.a;                        0.0s
 => CACHED [ 9/11] RUN cd /opt/bin; mv mysql mysqldump ..; rm *; cd ..; mv mysql mys  0.0s
 => CACHED [10/11] RUN cd /usr/bin; cp zip unzip /opt/bin                             0.0s
 => CACHED [11/11] RUN cd /opt; zip -9ry /root/mysql-8.0.33-layer.zip bin lib         0.0s
 => exporting to image                                                                0.0s
 => => exporting layers                                                               0.0s
 => => writing image sha256:2ff7fb7b6ca2eed0f1818172f80eb54465d2c7d6b906e729fe28382b  0.0s
 => => naming to docker.io/library/mysql-layer                                        0.0s

What's Next?
  1. Sign in to your Docker account → docker login
  2. View a summary of image vulnerabilities and recommendations → docker scout quickview
docker container cp 93ff49838aab3252d34e35429187956e6610beacf1b627e9829cb2c24def67cd:/root/mysql-8.0.33-layer.zip .
                                               Successfully copied 8.39MB to /Users/nickrobinson/workspace/mysql-lambda/.

```

In the same directory, you should end up with a zip file: `mysql-8.0.33-layer.zip`

## Known issues

If you get these errors:
```
Unable to find image 'mysql-layer:latest' locally
Error response from daemon: pull access denied for mysql-layer, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
```
and these errors:
```
docker container cp :/root/mysql-8.0.33-layer.zip .                                                                                                                                                                                  
must specify at least one container source                                                                                                                                                                                           
make: *** [mysql-8.0.33-layer.zip] Error 1
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
