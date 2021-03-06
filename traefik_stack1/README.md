WARNING: Please see `traefik_stack5`, as it has the latest udpates.

## Introduction
This project will run those services (Traefik, Portainer, Nginx, Caddy, Whoami) in one simple copy-paste command. Please also refer the the [README](https://github.com/pascalandy/docker-stack-this/blob/master/README.md) at the root of this repo.

#### Anything special about this mono repo?
- This stack does not use ACME (https://). ACME is a pain while developping … reaching limits, etc.
- I still have issues in the project `traefik-manager` which use ACME.
- If you don’t want to use socat, see `traefik-manager-noacme`

## Launching the Docker stack
1. Go to http://labs.play-with-docker.com/ 
2. Create **one instance** and wait for thethe node to provision
3. On **node1**, copy paste:

```
ENV_BRANCH=1.34
ENV_MONOREPO=traefik_stack1

# Setup alpine node and docker swarm

source <(curl -s https://raw.githubusercontent.com/pascalandy/docker-stack-this/master/play-with-docker-init/alpine-setup.sh) && sleep 2 && \
git checkout "$ENV_BRANCH" && \
cd "$ENV_MONOREPO" && \
./runup.sh;
```

This is it! Once deployed, you will see: 

#### Three stacks

```
docker stack ls

NAME                SERVICES
toolmonitor         1
toolproxy           2
toolweb             3
```

#### Six services

```
docker service ls

ID                  NAME                    MODE                REPLICAS            IMAGE                        PORTS
tvyos6h2ctg8        toolmonitor_portainer   replicated          1/1                 portainer/portainer:1.15.2
x0dzf3v6arwx        toolproxy_socat         replicated          1/1                 devmtl/socatproxy:1.0B
911t1dv9xmh3        toolproxy_traefik       replicated          1/1                 devmtl/traefikfire:1.4.3B    *:80->80/tcp,*:8080->8080/tcp
ss2xfhrrnm4n        toolweb_home            replicated          2/2                 abiosoft/caddy:0.10.10
wd57j2wjoi4y        toolweb_who1            replicated          2/2                 nginx:1.13-alpine
bfk5rco6avbh        toolweb_who2            replicated          2/2                 emilevauge/whoami:latest
```

## Confirm that Traefik and the gang are running
1. The script `runup.sh` did the hard work for us.

2. When you see that all services are deployed, click on `80` to see the static landing page.

![screen](https://user-images.githubusercontent.com/6694151/31318199-57e7e88a-ac1c-11e7-86a4-61a6172ac7be.png)

3. From the same URL generated by play-with-docker, in the address bar of your browser, add `/who1/` or `/who2/` or `/portainer/` to access other services.

#### Example
```
http://pwd10-0-7-3-80.host1.labs.play-with-docker.com/
http://pwd10-0-7-3-80.host1.labs.play-with-docker.com/who1/
http://pwd10-0-7-3-80.host1.labs.play-with-docker.com/who2/
http://pwd10-0-7-3-80.host1.labs.play-with-docker.com/portainer/
```

**WARNING**! Portainer requires a slash `/` at the end of the path. There is something to tweak with Traefik Labels in order for it to accept the proxy the request without the slash `/` at the end.

#### Web apps details:
- **/** = [caddy](https://hub.docker.com/r/abiosoft/caddy/)
- **/who1/** = [nginx](https://hub.docker.com/_/nginx/)
- **/who2/** = [whoami](https://hub.docker.com/r/emilevauge/whoami/)
- **/portainer/** = [portainer](https://hub.docker.com/r/portainer/portainer//)

#### All commands
In the active path, just execute those bash-scripts:

- `./runup.sh`
- `./rundown.sh`
- `./runctop.sh`

`./runctop.sh` is not a stack but a simple docker run to see the memory consumed by each containers.

## What is Traefik?
[Traefik](https://docs.traefik.io/configuration/backends/docker/) is a powerful layer 7 reverse proxy. Once running, the proxy will give you access to many web apps. I think this is a solid use cases to understand how this reverse-proxy works.

#### Traefik version 
In `toolproxy.yml` look for something like `traefik:1.4.2`.

In some mono-repo I **my own traefik image**. Feel free to use the official images. It will not break anything.

## Backlog
Here is what’s missing to make this stack perfect?
 
- Secure traefik dashboard
- Use SSL endpoints (ACME)
- Fix the need to use a trailing slash `/` at the end of Portainer service

#### Something is off? Please let me know.
I consider this README crystal clear. If there is anything that I could improve, please let me know and make sure to review the [contributing doc](../CONTRIBUTING.md).

## Shameless promotion :-p
Looking to **kick-start your website** (static page + a CMS) ? Take a look at [play-with-ghost](http://play-with-ghost.com/) (another project I shared). It allows you to see and edit websites made with **Ghost**. In short, you can try Ghost on the spot without having to sign up! Just use the dummy email & password provided.

## Wanna help?
If you have solid skills 🤓 with Docker Swarm, Linux bash and the gang and you’re looking to help a startup to launch a solid project, I would love to get to know you. Buzz me 👋 on Twitter [@askpascalandy](https://twitter.com/askpascalandy). You can see the things that are done and the things we have to do [here](http://firepress.org/blog/technical-challenges-we-are-facing-now/).

I’m looking for bright and caring people to join this [journey](http://firepress.org/blog/tag/from-the-heart/) with me.

```
 ____                     _      _              _
|  _ \ __ _ ___  ___ __ _| |    / \   _ __   __| |_   _
| |_) / _` / __|/ __/ _` | |   / _ \ | '_ \ / _` | | | |
|  __/ (_| \__ \ (_| (_| | |  / ___ \| | | | (_| | |_| |
|_|   \__,_|___/\___\__,_|_| /_/   \_\_| |_|\__,_|\__, |
                                                  |___/
```

Cheers!
Pascal