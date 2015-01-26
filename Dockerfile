FROM tenstartups/openresty
MAINTAINER Jon Eisen <jon@joneisen.me>

# Install docker & sudo
RUN apt-get update -qq && \
    apt-get install docker.io sudo -qqy

# Install sockproc for shell nginx lua scripting
RUN cd /opt && \
    git clone https://github.com/juce/sockproc && \
    cd sockproc && \
    make

# Private ssh key for just you!
# Don't push this image publicly!
ADD ssh /root/.ssh

EXPOSE 80

CMD ["/app/bin/startup.sh"]

VOLUME ["/app/repos", "/host/var/run"]

ADD . /app