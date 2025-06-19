from jupyterlab_code_formatter.formatters import (
    SERVER_FORMATTERS as BASE_FORMATTERS,
    CommandLineFormatter,
)

# Base class that uses `--stdin-filepath` to help Prettier determine the parser
class BasePrettierFormatter(CommandLineFormatter):
    def __init__(self, file_extension: str):
        super().__init__(command=["prettier", "--stdin-filepath", f"dummy.{file_extension}"])

    @property
    def label(self) -> str:
        return "Apply Prettier Formatter"


# Extend the base set of formatters
SERVER_FORMATTERS = BASE_FORMATTERS.copy()
SERVER_FORMATTERS.update({
    "prettier": BasePrettierFormatter("ts"),  # default if you want it
    "javascript": BasePrettierFormatter("js"),
    "typescript": BasePrettierFormatter("ts"),
})

def _load_jupyter_server_extension(server_app):
    #server_app.log.info("[prettier_formatter] Loaded Prettier formatters.")
    pass
