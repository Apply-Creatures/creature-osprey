# Get ARCH LINUX image
# FROM archlinux:latest

# Get DEBIAN image
FROM debian:bullseye

# Prevent interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Set user and group environment variables
ENV USER=seed
ENV GROUP=seed

# Download DEBIAN packages
RUN apt-get update && apt-get install -y bash curl git openssl openssh-server jq xz-utils && apt-get clean && rm -rf /var/lib/apt/lists/*
 
# Download ARCH LINUX packages
# RUN pacman -Syu --noconfirm && pacman -S --noconfirm bash curl git openssl openssh jq 

RUN echo "Successfully Downloaded Packages!"

# Copy the shell script file to the container's filesystem.
COPY setup.sh /setup.sh

# Add execute permission to the setup.sh script file
RUN chmod +x /setup.sh 

# Add seed user and seed group to the system
RUN groupadd --system ${GROUP} && useradd --system --gid ${GROUP} --create-home ${USER} && usermod -a -G ${GROUP} ${USER}

# Change the ownership of the working directory to seed
RUN chown -R ${USER}:${GROUP} /home/${USER}

# Set the user for subsequent instructions
USER ${USER}

RUN getent group && getent passwd

# Set working directory to /home/seed
WORKDIR /home/${USER}


# Install the Radicle CLI
ENV RAD_VERSION="1.0.0-rc.10"
ENV LINUX_SYSTEM="x86_64-unknown-linux-musl"
ENV OS_TARGET="${RAD_VERSION}-${LINUX_SYSTEM}"

RUN echo $OS_TARGET && pwd

# Install the Radicle package
RUN curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz && echo "Installed ${OS_TARGET} successfully."

# Install the Radicle signature file
RUN curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz.sig && echo "Installed ${OS_TARGET} signature file successfully."

# Install the Radicle checksum file
RUN curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz.sha256 && echo "Installed ${OS_TARGET} checksum successfully."

RUN ls -l

# Verify the Radicle signature
RUN ssh-keygen -Y check-novalidate -n file -s radicle-$OS_TARGET.tar.xz.sig < radicle-$OS_TARGET.tar.xz

# Verify the Radicle checksum
RUN sha256sum -c radicle-$OS_TARGET.tar.xz.sha256

RUN mkdir .radicle 

# Extract the Radicle pacakge
RUN tar -xvJf radicle-$OS_TARGET.tar.xz --strip-components=1 -C ~/.radicle

RUN cd .radicle && ls -l

# Set the PORT
EXPOSE 8776

# RUN ["/setup.sh"]

ENTRYPOINT ["/setup.sh"]






