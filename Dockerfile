FROM archlinux:latest

# Set user and group environment variables
ENV USER=seed
ENV GROUP=seed

# Download linux packages
RUN pacman -Syu --noconfirm && pacman -S --noconfirm bash curl git openssl openssh jq 

RUN echo "Successfully Downloaded Packages!"

# Add seed user and seed group to the system
RUN groupadd --system ${GROUP} && useradd --system --gid ${USER} --create-home ${USER} && usermod -a -G ${GROUP} ${USER}

# RUN getent group && getent passwd

WORKDIR /home/${USER}

# Install the Radicle CLI
RUN curl -sSf https://radicle.xyz/install | sh 

# Copy the shell script file to the container's filesystem.
COPY setup.sh /setup.sh

# Add execute permission to the setup.sh script file
RUN chmod +x /setup.sh 

EXPOSE 8776

ENTRYPOINT ["/setup.sh"]






