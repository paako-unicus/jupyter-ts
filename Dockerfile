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
RUN npm install -g ijavascript typescript ts-node @types/node prettier && \
    pip install --no-cache-dir jupyterlab-code-formatter black isort
# hadolint ignore=DL3059
RUN ijsinstall
RUN echo "require('ts-node').register();" > /home/${NB_USER}/.ijsstart.js

ENV IJSSTARTUP=/home/${NB_USER}/.ijsstart.js

ENV DENO_INSTALL="/home/${NB_USER}/.deno"
ENV PATH="${DENO_INSTALL}/bin:${PATH}"

RUN curl -fsSL https://deno.land/install.sh | sh

# Install Deno Jupyter kernel for proper Jupyter TypeScript experience
RUN deno jupyter --unstable --install

# Copy configuration files for code formatting (well, prettier anyway)
COPY .prettierrc /home/${NB_USER}/.prettierrc
COPY prettier_formatter.py /home/${NB_USER}/formatters/prettier_formatter.py
COPY jupyter_server_config.py /home/${NB_USER}/.jupyter/jupyter_server_config.py

USER root
RUN chown ${NB_USER}:${NB_GROUP} /home/${NB_USER}/.prettierrc && \
    chown -R ${NB_USER}:${NB_GROUP} /home/${NB_USER}/work/ && \
    #chown -R ${NB_USER}:${NB_GROUP} /home/${NB_USER}/.jupyter/lab/ && \
    chown -R ${NB_USER}:${NB_GROUP} /home/${NB_USER}/formatters/ && \
    chown ${NB_USER}:${NB_GROUP} /home/${NB_USER}/.jupyter/jupyter_server_config.py && \
    chmod +x /home/${NB_USER}/formatters/prettier_formatter.py
USER ${NB_UID}

ENV PYTHONPATH="/home/${NB_USER}/formatters/:${PYTHONPATH}"

RUN fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" && \
    fix-permissions "/home/${NB_USER}/.jupyter"