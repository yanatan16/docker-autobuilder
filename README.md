# docker-autobuilder

Docker Automated builds support for private repositories.

A very simple setup with openresty/nginx and a couple small shell scripts. Runs inside a docker container.

# WHY?

_Question_: Docker Hub already has automated builds. Why did you do this?
_Answer_: Docker Hub does not _currently_ support private git submodules from github because deploy keys cannot be re-used.

# How

First move an `id_rsa` and `id_rsa.pub` into `ssh/` that has credentials for your github account.

Now we build the image:
```
docker build -t you/docker-autobuilder .
```

_NOTE_: DONT PUSH THIS PUBLICLY. Its got your private key in it!

Then make a repos configuration `repos/repos.lua` based off of `example.lua` inside that configures which repos you want to build.

If I wanted to build the github repo `notacatjs/dommit` into the docker image `notacatjs/dommit-autobuild`, I'd put this into the `repos/repos.lua`:

```lua
imagemap = {
  ["notacatjs/dommit"] = "notacatjs/dommit-autobuild"
};

return imagemap
```

Now we run the autobuilder:

```
docker run \
    --volume $(pwd)/repos:/app/repos \
    --volume /var/run:/host/var/run \
    --publish 80:80 \
    --env DOCKER_EMAIL="login@hub.docker.io" \
    --env DOCKER_PASSWORD="yourpassword" \
    --env DOCKER_USERNAME="yourusername" \
    --env DOCKER_INDEX="https://index.docker.io/v1/"
    you/docker-autobuilder
```

To test:

```
curl -XPOST \
    'http://yourdockerhost:80/' \
    -H'Content-Type: application/json'\
    -d'{ \
        "ref": "refs/heads/master",
        "repository": { \
            "full_name": "org/repo" \
        }'
```

You can monitor logs with `docker logs`.

Setup as a github webhook with no secret for `push` events, and there ya go. Your own autobuilder!