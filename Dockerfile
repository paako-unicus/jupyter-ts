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
    mamba clean --all -f -y

# hadolint ignore=DL3016
RUN npm install -g ijavascript typescript ts-node @types/node && \
    pip install --no-cache-dir jupyterlab-code-formatter black
# hadolint ignore=DL3059
RUN ijsinstall
RUN echo "require('ts-node').register();" > /home/${NB_USER}/.ijsstart.js

ENV IJSSTARTUP=/home/${NB_USER}/.ijsstart.js

ENV DENO_INSTALL="/home/${NB_USER}/.deno"
ENV PATH="${DENO_INSTALL}/bin:${PATH}"

RUN curl -fsSL https://deno.land/install.sh | sh

# Install Deno Jupyter kernel for proper Jupyter TypeScript experience
RUN deno jupyter --unstable --install

# Install some formatter plugins
RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
    jupyter serverextension enable --py jupyterlab_code_formatter
ENV JUPYTERLAB_CODE_FORMATTER_FORMATTERS="{ \
    \"python\": [\"black\"], \
    \"javascript\": [\"prettier\", \"--parser\", \"babel\"], \
    \"typescript\": [\"prettier\", \"--parser\", \"typescript\"] \
}"
# Copy configuration files for code formatting (well, prettier anyway)
COPY .prettierrc /home/${NB_USER}/.prettierrc
RUN chown ${NB_USER}:${NB_USER} /home/${NB_USER}/.prettierrc

RUN fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" && \
    fix-permissions "/home/${NB_USER}/.jupyter"