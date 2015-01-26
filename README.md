# docker-autobuilder

Docker Automated builds support for private repositories.

A very simple setup with openresty/nginx and a couple small shell scripts. Runs inside a docker container.

# WHY?

_Question_: Docker Hub already has automated builds. Why did you do this?
_Answer_: Docker Hub does not _currently_ support private git submodules from github because deploy keys cannot be re-used.

# How

First move an `id_rsa` and `id_rsa.pub` into `ssh/` that has credentials for your github account.

Then make a repos configuration directory like `repos/` with a `repos.conf` inside that configures which repos you want to build.

```
docker run \
    --volume $(pwd)/ssh:/root/.ssh \
    --volume <your_repos_conf_dir>:/app/repos \
    --volume /var/run:/host/var/run \
    --publish 80:80 \
    --env DOCKER_EMAIL="login@hub.docker.io" \
    --env DOCKER_PASSWORD="yourpassword" \
    --env DOCKER_USERNAME="yourusername" \
    --env DOCKER_INDEX="https://index.docker.io/v1/"
    yanatan16/docker-autobuilder
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