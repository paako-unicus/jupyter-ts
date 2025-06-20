# jupyterlab-typescript-dev

A custom JupyterLab docker image with support for TypeScript, JavaScript, Deno, and Prettier-based code formatting.

This image is ideal for development and exploration in notebooks with full support for modern JS/TS tooling, along with Python tooling and formatters.

## Features

- JupyterLab based on [`quay.io/jupyter/scipy-notebook`](https://quay.io/repository/jupyter/scipy-notebook)
- TypeScript kernel via [`IJavascript`](https://github.com/n-riesco/ijavascript)
- Deno support with the [`deno jupyter` kernel](https://deno.land/manual@v1.44.2/tools/jupyter)
- Integrated formatters via [`jupyterlab-code-formatter`](https://github.com/jupyterlab-contrib/jupyterlab-code-formatter):
  - Python (`black`, `isort`)
  - JavaScript / TypeScript via a `prettier` custom extension
- `.prettierrc` support built in
- Custom server extension to bridge Prettier into Jupyter’s formatting system

## 🚀 Quickstart

### Build

```bash
docker build -t jupyter-ts .
```

### Run

```bash
docker run -p 8888:8888 -v $(pwd)/notebooks:/home/jovyan/work \
  -v $(pwd)/jupyter-settings:/home/jovyan/.jupyter/lab/user-settings \
  jupyter-ts
```

Or with compose:

```bash
docker compose up -d
```

Access JupyterLab at http://localhost:8888 (no token required).

## Code Formatting

The following formatters are available:

| Language   | Formatter        |
| ---------- | ---------------- |
| Python     | `black`, `isort` |
| JavaScript | `prettier`       |
| TypeScript | `prettier`       |


The custom PrettierFormatter uses Jupyter’s plugin interface and supports language-specific configuration.

### Formatter Setup Notes

Formatters can be triggered via the command palette (Ctrl+Shift+P) or right-click context menu.

To customize `black`'s or `isort`'s behavior, check the settings menu for JupyterLab Code Formatter.

To customize `prettier`’s behavior, edit the included `.prettierrc` file (copied into the image).

Default formatting configuration can be adjusted via JupyterLab advanced settings (Settings > Code Formatter).

## Known Limitations

The Prettier formatter is a custom plugin — not part of jupyterlab-code-formatter by default.

Formatter must be manually selected as the default for JS/TS in JupyterLab settings.

Notebooks default to the Deno kernel unless manually changed.

## References

[IJavascript](https://github.com/n-riesco/ijavascript)

[Deno Jupyter kernel](https://deno.land/manual@v1.44.2/tools/jupyter)

[JupyterLab Code Formatter](https://github.com/jupyterlab-contrib/jupyterlab-code-formatter)

[Prettier](https://prettier.io/)

Happy hacking!
