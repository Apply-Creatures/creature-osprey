# Get ALPINE image
FROM alpine:3.14

# Download DEBIAN packages
RUN apk update && apk add --no-cache bash curl git openssl openssh jq

# Set user and group environment variables
ENV USER=seed
ENV GROUP=seed

# Copy the shell script file to the container's filesystem.
COPY initializer.sh /initializer.sh

# Add execute permission to the setup.sh script file
RUN chmod +x /initializer.sh 

# Add seed user and seed group to the system - Alpine
RUN addgroup -S ${GROUP} && adduser -S -G ${GROUP} ${USER}

# Make directory manually for Alpine
RUN mkdir -p /home/${USER}/.radicle/${USER}

# Change the ownership of the working directory to seed
RUN chown -R ${USER}:${GROUP} /home/${USER}

COPY /creature-pigeon /home/seed/creature-pigeon

RUN chown -R ${USER}:${GROUP} /home/seed/creature-pigeon

# Set the user for subsequent instructions
USER ${USER}

# Set working directory to /home/seed
WORKDIR /home/${USER}

# Define the version and system variables for installation
ENV RAD_VERSION="1.0.0-rc.10"
ENV LINUX_SYSTEM="x86_64-unknown-linux-musl"
ENV OS_TARGET="${RAD_VERSION}-${LINUX_SYSTEM}"

# Install the Radicle package
RUN curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz

# Install the Radicle signature file
RUN curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz.sig

# Install the Radicle checksum file
RUN curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz.sha256

# Verify the Radicle signature
RUN ssh-keygen -Y check-novalidate -n file -s radicle-$OS_TARGET.tar.xz.sig < radicle-$OS_TARGET.tar.xz

# Verify the Radicle checksum
RUN sha256sum -c radicle-$OS_TARGET.tar.xz.sha256

# Extract the Radicle pacakge
RUN tar -xvJf radicle-$OS_TARGET.tar.xz --strip-components=1 -C ~/.radicle

# Set the execution permission for the extracted files
RUN chmod u+x /home/seed/.radicle/bin/rad
RUN chmod u+x /home/seed/.radicle/bin/radicle-node
RUN chmod u+x /home/seed/.radicle/bin/git-remote-rad

ENV RAD_PATH_EXPORT='export PATH="$PATH:/home/$USER/.radicle/bin"'
ENV RAD_PATH="/home/${USER}/.radicle/bin:${PATH}"
ENV RAD_HOME=/home/seed/.radicle/seed/

# Uncomment this and have your own Radicle passphrase if you need to run locally
# ENV RAD_PASSPHRASE=yoursecret

ENV KEYS_DIR=/home/seed/.radicle/seed/keys/
ENV REPO_DIR=/home/seed/.radicle/seed/creature-pigeon
ENV RADICLE_REPO_STORAGE=/home/seed/.radicle/seed/storage/
ENV REPO_NAME=creature-pigeon


ENTRYPOINT ["/initializer.sh"]
