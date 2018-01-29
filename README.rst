Docker TCP Proxy
================

This proxy masquerades as an external server inside a docker network but
actually forwards all connections to an HTTP proxy. This can be useful when
applications don't have native proxy support.

Example usage
-------------
To start a lone container just running the proxy, use something like this (for docker-compose)::

  version: "2.2"
  services:
    mail:
      init: true
      container_name: example.org
      image: crunchr/tcpproxy
      network_mode: bridge
      restart: always
      environment:
        GATEWAY_PROXY_PORT: 6464
        PROXY_http: "80:example.org:80"
        PROXY_https: "443:example.org:443"
        PROXY_mail: "587:smtp.example.org:587"

Here, `GATEWAY_PROXY_PORT` refers to the port the internal HTTP proxy server is
running on and the variables below allow you to specify multiple mappings.
