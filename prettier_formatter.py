import subprocess
from jupyterlab_code_formatter.formatters import BaseFormatter, handle_line_ending_and_magic, SERVER_FORMATTERS

class PrettierFormatter(BaseFormatter):
    label = "Apply Prettier Formatter"
    language = ["javascript", "typescript"]
    aliases = ["prettier"]

    @property
    def importable(self) -> bool:
        return True

    @handle_line_ending_and_magic
    def format_code(self, code: str, notebook: bool, **options) -> str:
        try:
            process = subprocess.run(
                ["prettier", "--stdin-filepath", "file.ts"],
                input=code.encode("utf-8"),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=True,
            )
            return process.stdout.decode("utf-8")
        except subprocess.CalledProcessError as e:
            raise RuntimeError(f"Prettier failed: {e.stderr.decode('utf-8')}")

def _load_jupyter_server_extension(server_app):
    #server_app.log.info("prettier_formatter | extension loaded successfully.")
    pass
