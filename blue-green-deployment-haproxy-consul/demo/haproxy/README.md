# haproxy-consul

Dynamic haproxy configuration using consul packed into a Docker container

# Overview

This project combines [Alpine Linux](https://www.alpinelinux.org), [consul template](https://github.com/hashicorp/consul-template), and [haproxy](http://haproxy.org)
to create a proxy that forwards traffic to apps registered in Docker based on service name and tag

## How it works

First you must make sure that your container is started with the propper environment variables

```
docker run -ti --rm -e 'SERVICE_NAME=laptopbg-web' -e 'SERVICE_TAGS=noservice,shell,blue' -p 9999 alpine /bin/sh
```

mandatory environment variables are:

 * SERVICE_NAME - to be usefull it must be laptopbg-web (easily changeble)

Non Mandatory (but needed if you want it to be usable:

 * SERVICE_TAGS - tag your service appropriately. Recommended (well usable) tags are "blue" and "green"

The container will start and generate haproxy config (which by default will redirect to a holding page if provided)

In order for a container to be considered it must have:
 * SERVICE_NAME
 * Minimum of 1 exposed port (please avoid common ports). It is recommended to just expose the port and not explicitly forward it.
 * The propper tag

## Building

```
docker build -t haproxy .
```

## Running

#### consul Configuration

When `HAPROXY_MODE` is set to `consul`, haproxy-consul uses consul service names

## Options

If you want to override the config and template files, mount a volume and set the `CONSUL_CONFIG` environment variable before launch. In docker this can be accomplished with the `-e` option:

```
docker run -v /host/config:/my_config -e CONSUL_CONFIG=/my_config -net=host --name=haproxy -d -e HAPROXY_DOMAIN=mycompany.com asteris/haproxy-consul
```

If you need to have a root CA added so you can connect to Consul over SSL, mount
a directory containing your root CA at `/usr/local/share/ca-certificates/`.

Configure using the following environment variables:

Variable | Description | Default
---------|-------------|---------
`HAPROXY_MODE` | forward consul service or Marathon apps | `consul`
`HAPROXY_USESSL` | Enable the SSL frontend (see [below](#ssl-termination)) | `false`

consul-template variables:

Variable | Description | Default
---------|-------------|---------
`CONSUL_TEMPLATE` | Location of consul-template bin | `/usr/local/bin/consul-template`
`CONSUL_CONNECT`  | The consul connection | `consul.service.consul:8500`
`CONSUL_CONFIG`   | File/directory for consul-template config | `/consul-template/config.d`
`CONSUL_LOGLEVEL` | Valid values are "debug", "info", "warn", and "err". | `debug`
`CONSUL_TOKEN`    | The [Consul API token](http://www.consul.io/docs/internals/acl.html) | 

consul KV variables:

Variable | Description | Default
---------|-------------|---------
`service/haproxy/maxconn` | maximum connections | 1024
`service/haproxy/timeouts/connect` | connect timeout | 5000ms
`service/haproxy/timeouts/client` | client timeout | 50000ms
`service/haproxy/timeouts/server` | server timeout | 50000ms
`service/laptopbg/color` | Which color to run | none

### SSL Termination

If you wish to configure HAproxy to terminate incoming SSL connections, you must set the environment variable `HAPROXY_USESSL=true`, and mount your SSL certificate at `/haproxy/ssl.crt` - this file should contain both the SSL certificate and the private key to use (with no passphrase), in PEM format. You should also include any intermediate certificates in this bundle.

If you do not provide an SSL certificate at container runtime, a self-signed certificate will be generated for the value of `*.HAPROXY_DOMAIN`.

For example:
```
docker run -v /etc/ssl/wildcard.example.com.pem:/haproxy/ssl.crt -e HAPROXY_USESSL=true -e HAPROXY_DOMAIN=example.com --net=host --name=haproxy haproxy-consul
```

You can also force that all incoming connections are redirected to HTTPS, by setting `HAPROXY_USESSL=force`.

SSL termination is currently only available in 'consul' mode.
