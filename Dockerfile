FROM ubuntu:18.04

# setup args for installation
ARG MAXITSOURCE=https://sw-tools.rcsb.org/apps/MAXIT/maxit-v10.000-prod-src.tar.gz

# update repository information
RUN apt-get update --fix-missing

# install curl utils so we can download source
RUN apt-get install -y --no-install-recommends \
gnupg2 curl ca-certificates

# download source
RUN curl -fsSL MAXITSOURCE

# install utils to build source
RUN apt-get install -y --no-install-recommends \
        gunzip tar build-essential

# install gsl
RUN apt-get install -y --no-install-recommends \
    libgsl23 libgslcblas0 libgsl-dev libgsl-dbg

# install some packages for development (optional)
RUN apt-get install -y --no-install-recommends \
    vim git

# cleanup install cache
RUN rm -rf /var/lib/apt/lists/*

# establish user, home directory
RUN useradd -rm -d /home/developer -s /bin/bash \
    -g root -G root -u 1000 developer
USER developer
ENV HOME /home/developer

CMD [ "/bin/bash" ]
