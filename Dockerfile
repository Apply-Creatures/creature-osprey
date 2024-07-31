# Get ALPINE image
FROM alpine:3.14

# Install packages
RUN apk update && apk add --no-cache bash curl git openssl openssh jq openrc libgcc gcompat

# install bun
RUN curl -fsSL https://bun.sh/install | bash

# https://github.com/oven-sh/bun/issues/5545
# Install glibc to run Bun
RUN if [[ $(uname -m) == "aarch64" ]] ; \
    then \
    # aarch64
    wget https://raw.githubusercontent.com/squishyu/alpine-pkg-glibc-aarch64-bin/master/glibc-2.26-r1.apk ; \
    apk add --no-cache --allow-untrusted --force-overwrite glibc-2.26-r1.apk ; \
    rm glibc-2.26-r1.apk ; \
    else \
    # x86_64
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk ; \
    apk add --no-cache --allow-untrusted --force-overwrite glibc-2.28-r0.apk ; \
    rm glibc-2.28-r0.apk ; \
    fi

ENV BUN_INSTALL="/root/.bun"
RUN chmod -R 777 /root

# Set user and group environment variables
ENV USER=seed
ENV GROUP=seed

ENV NODE_NAME=creature-osprey

# Copy the shell script file to the container's filesystem.
COPY initializer.sh /initializer.sh

# Add permission to the setup.sh script file
RUN chmod +x /initializer.sh

# Add seed user and seed group to the system - Alpine
RUN addgroup -S ${GROUP} && adduser -S -G ${GROUP} ${USER}

# Make directory manually for Alpine
RUN mkdir -p /home/${USER}/.radicle/${USER}

# copy this repo as it will be added in as pinned demo
COPY . /home/${USER}/${NODE_NAME}

# Change the ownership of the working directory to seed
RUN chown -R ${USER}:${GROUP} /home/${USER}

COPY radicle-httpd.service /etc/init.d/radicle-httpd
RUN chmod +x /etc/init.d/radicle-httpd
RUN rc-update add radicle-httpd default

RUN chown -R ${USER}:${GROUP} /home/${USER}/${NODE_NAME}

# Set the user for subsequent instructions
USER ${USER}

# Set working directory to /home/seed
WORKDIR /home/${USER}

# Define the version and system variables for installation
ENV RAD_VERSION="1.0.0-rc.10"
ENV LINUX_SYSTEM="x86_64-unknown-linux-musl"
ENV OS_TARGET="${RAD_VERSION}-${LINUX_SYSTEM}"

ENV HTTPD_VERSION="0.15.0"
ENV HTTPD_OS_TARGET="${HTTPD_VERSION}-${LINUX_SYSTEM}"

# Install the Radicle packages
RUN curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz
RUN curl -O -L https://files.radicle.xyz/releases/radicle-httpd/latest/radicle-httpd-$HTTPD_OS_TARGET.tar.xz

# Install the Radicle signature files
RUN curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz.sig
RUN curl -O -L https://files.radicle.xyz/releases/radicle-httpd/latest/radicle-httpd-$HTTPD_OS_TARGET.tar.xz.sig

# Install the Radicle checksum file
RUN curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz.sha256
RUN curl -O -L https://files.radicle.xyz/releases/radicle-httpd/latest/radicle-httpd-$HTTPD_OS_TARGET.tar.xz.sha256

# Verify the Radicle signatures
RUN ssh-keygen -Y check-novalidate -n file -s radicle-$OS_TARGET.tar.xz.sig < radicle-$OS_TARGET.tar.xz
RUN ssh-keygen -Y check-novalidate -n file -s radicle-httpd-$HTTPD_OS_TARGET.tar.xz.sig < radicle-httpd-$HTTPD_OS_TARGET.tar.xz

# Verify the Radicle checksums
RUN sha256sum -c radicle-$OS_TARGET.tar.xz.sha256
RUN sha256sum -c radicle-httpd-$HTTPD_OS_TARGET.tar.xz.sha256

# Extract the Radicle pacakges
RUN tar -xvJf radicle-$OS_TARGET.tar.xz --strip-components=1 -C ~/.radicle
RUN mkdir ~/.radicle-httpd && tar -xvJf radicle-httpd-$HTTPD_OS_TARGET.tar.xz --strip-components=1 -C ~/.radicle-httpd
RUN chmod +x /home/${USER}/.radicle-httpd/bin/radicle-httpd

# Set the execution permission for the extracted files
RUN chmod u+x /home/${USER}/.radicle/bin/rad
RUN chmod u+x /home/${USER}/.radicle/bin/radicle-node
RUN chmod u+x /home/${USER}/.radicle/bin/git-remote-rad

ENV RAD_PATH_EXPORT='export PATH="$PATH:/home/$USER/.radicle/bin"'
ENV RAD_PATH="/home/${USER}/.radicle/bin:${PATH}"
ENV RAD_HOME=/home/${USER}/.radicle/${USER}/
ENV RAD_ALIAS=${NODE_NAME}

# Uncomment this and have your own Radicle passphrase if you need to run locally
# ENV RAD_PASSPHRASE=yoursecret

ENV KEYS_DIR=/home/${USER}/.radicle/${USER}/keys/
ENV REPO_DIR=/home/${USER}/.radicle/${USER}/${NODE_NAME}
ENV RADICLE_REPO_STORAGE=/home/${USER}/.radicle/${USER}/storage/
ENV DOMAIN=applycreatures.com
# Copy peers DID
COPY peers.list $REPO_DIR

# Setting up the UI explorer
RUN git clone https://github.com/radicle-dev/radicle-interface.git radicle-explorer

WORKDIR /home/${USER}/radicle-explorer
# switch to explorer version compatible with the version of radicle-httpd
RUN git checkout b105d06fae415769bd20b65f0f4346d40537be78 \
    # need to nuke the lock file as it's broken
    && rm -rf package-lock.json \
    && $BUN_INSTALL/bin/bun install \
    && $BUN_INSTALL/bin/bun install @rollup/rollup-linux-x64-gnu --save-optional \
    # Adjust vite config to listen to 0.0.0.0
    && sed -i 's/localhost/0.0.0.0/g' vite.config.ts \
    # Adjust default.json entries as they have the garden URLs
    && sed -i -e "s|https://radicle.zulipchat.com|https://${DOMAIN}|g" \
    -e "s|seed.radicle.garden|osprey.${DOMAIN}|g" \
    -e 's|"port": 443,|"port": 8443,|g' config/default.json \
    # Exclude some dep that cannot be optimised
    && sed -i '/export default defineConfig({/a\
    optimizeDeps: {\
    exclude: ["twemoji"]\
    },' vite.config.ts

ENV LD_LIBRARY_PATH="/usr/lib:/lib:$LD_LIBRARY_PATH"
ENTRYPOINT ["/initializer.sh"]
