# Get ALPINE image
FROM alpine:latest

# Download DEBIAN packages
RUN apk update && apk add --no-cache bash curl git openssl openssh jq

# Set user and group environment variables
ENV USER=seed
ENV GROUP=seed

RUN echo "Successfully Downloaded Packages!"

# Copy the shell script file to the container's filesystem.
COPY setup.sh /setup.sh

# Add execute permission to the setup.sh script file
RUN chmod +x /setup.sh 

# Add seed user and seed group to the system - Alpine
RUN addgroup -S ${GROUP} && adduser -S -G ${GROUP} ${USER}

# Make directory manually for Alpine
RUN mkdir -p /home/${USER}

# Change the ownership of the working directory to seed
RUN chown -R ${USER}:${GROUP} /home/${USER}

COPY /apply-creatures /home/${USER}/apply-creatures-private

# RUN cd /home/${USER}/apply-creatures-private && pwd

RUN chown -R ${USER}:${GROUP} /home/${USER}/apply-creatures-private

# Set the user for subsequent instructions
USER ${USER}

# Set working directory to /home/seed
WORKDIR /home/${USER}

# Install the Radicle CLI
ENV RAD_VERSION="1.0.0-rc.10"
ENV LINUX_SYSTEM="x86_64-unknown-linux-musl"
ENV OS_TARGET="${RAD_VERSION}-${LINUX_SYSTEM}"

# RUN echo $OS_TARGET && pwd

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

RUN mkdir .radicle 

# Extract the Radicle pacakge
RUN tar -xvJf radicle-$OS_TARGET.tar.xz --strip-components=1 -C ~/.radicle

# Set the PORT
EXPOSE 8776

RUN ls -la /home/${USER}/apply-creatures-private

# RUN ["/setup.sh"]

ENTRYPOINT ["/setup.sh"]






