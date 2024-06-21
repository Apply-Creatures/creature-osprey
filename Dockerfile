FROM archlinux:latest

# Set user and group environment variables
ENV USER=seed
ENV GROUP=seed

# Download linux packages
RUN pacman -Syu --noconfirm && pacman -S --noconfirm bash curl git openssl openssh jq 

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

WORKDIR /home/${USER}

# Install the Radicle CLI

# RUN curl -sSf https://radicle.xyz/install | sh 



# EXPOSE 8776

RUN ["/setup.sh"]

# ENTRYPOINT ["/setup.sh"]






