# This Dockerfile requires a build context that provides the necessary assets
# to install system dependencies and Node.js packages. The following assets are
# requires:
# - install-deps.sh for the installation of system dependencies through apt-get
# - package.json for the installation of Node.js packages

# Prefer COPY over ADD

# NOTE: Do not provide a default value in order to make this choice explicit
ARG DOCKER_BASE_IMAGE


FROM ${DOCKER_BASE_IMAGE} AS dev-image

# Copy install-deps.sh for project-specified installation commands
COPY ./install-deps.sh /tmp/install-deps.sh

# Install system dependencies and run project-specified installation commands
# Note that there are no packages installed by default
RUN apt-get update && apt-get install -y --no-install-recommends \
    && . /tmp/install-deps.sh \
    && rm -rf /var/lib/apt/lists/*

ARG PROJECT=app
ENV PROJECT=${PROJECT}

# For the development image, application-specific assets are stored into a
# subdirectory of "/tmp" which is the FHS-designated destination for temporary
# files.
WORKDIR /tmp/${PROJECT}

# Copy Node.js dependency manifest into temporary working directory
COPY package.json /tmp/${PROJECT}/

# Install Node.js packages
ARG NODEJS_PACKAGE_INSTALL_COMMAND="npm install"
RUN ${NODEJS_PACKAGE_INSTALL_COMMAND}


FROM ${DOCKER_BASE_IMAGE} AS prod-image

# Set the default user to the built-in node (non-root) user
USER node

# Copy libraries from build image
COPY --from=dev-image /usr/lib /usr/lib

ARG PROJECT=app
ENV PROJECT=${PROJECT}

# For the production image, application-specific assets are stored into a
# subdirectory of "/opt" which is the FHS-designated destination for add-on
# application software packages.
WORKDIR /opt/${PROJECT}

# Copying folders from the root directory into an image may result to files
# ending up in that image that were not intended for production. We propose
# updating your .dockerignore file to first ignore all files and then gradually
# provide exception rules for for every file or folder that you wish to
# include. This approach makes it more explicit what ends up finding its way
# into an image and may prove helpful in minimizing the chances of assets
# creeping into your image unintentionally.
# https://docs.docker.com/engine/reference/builder/#dockerignore-file

COPY --chown=node . /opt/${PROJECT}/

# Run installation command
# TODO: Experiment with copying node packages from build image
ARG NODEJS_PACKAGE_INSTALL_COMMAND
RUN ${NODEJS_PACKAGE_INSTALL_COMMAND}

# Do not provide default ports in order to make this choice explicit
ARG DOCKER_PORTS

# Expose the ports for the services
EXPOSE ${DOCKER_PORTS}
