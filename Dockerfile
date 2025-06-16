ARG BASE_IMAGE=quay.io/jupyter/scipy-notebook
FROM $BASE_IMAGE

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    make \
    g++ && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# NodeJS <= 20 is required
# https://github.com/n-riesco/ijavascript/issues/184
RUN mamba install --yes nodejs=20.* && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# hadolint ignore=DL3016
RUN npm install -g ijavascript typescript ts-node @types/node
# hadolint ignore=DL3059
RUN ijsinstall
RUN echo "require('ts-node').register();" > /home/${NB_USER}/.ijsstart.js

ENV IJSSTARTUP=/home/${NB_USER}/.ijsstart.js