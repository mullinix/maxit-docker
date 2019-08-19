FROM ubuntu:18.04

# setup args for installation
ARG MAXITVER=10.000
ARG MAXITNAME=maxit-v$MAXITVER-prod-src
ARG MAXITTARGZ=$MAXITNAME.tar.gz
ARG MAXITSOURCE=https://sw-tools.rcsb.org/apps/MAXIT/$MAXITTARGZ

# update repository information
RUN apt-get update --fix-missing

# install curl utils so we can download source
RUN apt-get install -y --no-install-recommends \
gnupg2 curl ca-certificates

# install some packages for development (optional)
RUN apt-get install -y --no-install-recommends \
    vim git

# install utils to build source
RUN apt-get install -y --no-install-recommends \
        build-essential

# additional (undeclared in documentation) dependencies
RUN apt-get install -y --no-install-recommends \
        bison flex tcsh

# maxit install time!
RUN mkdir -p /usr/local/maxit

# download source, expand, build
RUN cd /usr/local/maxit && \
    curl -fsSL -O $MAXITSOURCE && \
    tar -zxf $MAXITTARGZ && \
    cd $MAXITNAME && \
    make binary

# setup env vars for install/runtime
ENV RCSBROOT=/usr/local/maxit/$MAXITNAME
ENV PATH="$RCSBROOT/bin":$PATH

# cleanup
RUN rm -f /usr/local/maxit/$MAXITTARGZ
RUN apt-get purge --auto-remove -y \
    gnupg2 curl ca-certificates \
    build-essential bison flex tcsh
# cleanup install cache
RUN rm -rf /var/lib/apt/lists/*

# establish user, home directory
RUN useradd -rm -d /home/developer -s /bin/bash \
    -g root -G root -u 1000 developer
USER developer
ENV HOME /home/developer

CMD [ "/bin/bash" ]
