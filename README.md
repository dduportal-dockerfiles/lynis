# Lynis Docker image

## Description

That image embed [lynis](https://cisofy.com/lynis/), a tools for auditing Linux systems

The idea is to use Docker's lightweight isolation to have an auto-sufficient image that embed lynis and its dependencies, to perform on-demand audit without installing anything on your system, and leaving the place clean after the audit.

[![CircleCi Build Status](https://circleci.com/gh/dduportal-dockerfiles/lynis/tree/master.svg?&style=shield)](https://circleci.com/gh/dduportal-dockerfiles/lynis/tree/master)

## Usage

From here, just pre-download the image from the registry :

```
$ docker pull dduportal/lynis:2.1.0
```

It is strongly recommended to use tags, even if dduportal/lynis will work as latest tag is implied.

Then you have to choices : running directly your test or build your own, which enable you to embed your stuff.

### Basics run

* You can run the container in "quickie mode" to just run lynis in an isolated container :

``` bash
$ docker run dduportal/lynis --help
``` 

* To fetch logs, reports, use docker inside the container, or other advanced use cases, don't forget to share the need files and folders :

```bash
# Auditing a dockerfile which is in the current directory :
$ docker run \
	-v $(pwd):/app \
	-v $(pwd)/lynis-logs:/var/log \
	dduportal/lynis:2.1.0 \
		--auditor "John Doe" \
		--quick \
		audit dockerfile /app/Dockerfile
$ ls ./lynis-logs
lynis.log lynis-report.dat 
```

* If you have some plugins (Lynis Enterprise paid user or community), share them from your host :
```bash
$ docker run \
	-v /usr/local/lynis-plugins:/lynis-plugins \
	lynis \
		--plugin-dir /lynis-plugins \
		audit system
```

### Build your own testing image

The goal here is to embed your own stuff to adapt the behaviour of the image to your needs :
* Include your plugins
* Include your test profiles
* Pre-configure the image to make it indepednant from your host
...

For that, sue a Dockerfile :

```
$ cat Dockerfile
FROM dduportal/lynis:2.1.0
MAINTAINER <your name>
ADD ./your-plugins /app/plugins
ADD ./your-scripts /app/scripts
RUN apk --update add <package you need>
ENTRYPOINT ["/bin/sh"]
CMD ["/app/scripts/exec-lynis.sh"]
$ docker build -t my-lynis:1.0.0 ./
...
$ docker run -t my-lynis:1.0.0
...
```

## Image content and considerations

### Base image

Since this image just need bats and little dependencies, we use [Alpine Linux](https://registry.hub.docker.com/_/alpine/) as a base image :
* It is a light image (~5 Mb)
* It embed an usefull and complete package manager : [apk](http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management) which has [a lot of available packages](http://forum.alpinelinux.org/packages)

### Already installed package

We embed a set of basic packages :
* bash : It is for convenience around the numerous lynis scripts that will need its
* curl (and ca-certificates): because we need to download stuff thru HTTPS for lynis checks
* openssl : cryptographic stuff Bro' 

## Contributing

Do not hesitate to contribute by forking this repository

Pick at least one :

* Implement tests in ```/tests/bats/```

* Write the Dockerfile

* (Re)Write the documentation corrections


Finnaly, open the Pull Request : CircleCi will automatically build and test for you
