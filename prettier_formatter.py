from jupyterlab_code_formatter.formatters import CommandLineFormatter, handle_line_ending_and_magic, SERVER_FORMATTERS

class PrettierFormatter(CommandLineFormatter):
    language = ["javascript", "typescript", "js", "ts"]
    aliases = ["prettier"]

    def __init__(self, file_extension: str):
        self.file_extension = file_extension
        super().__init__(command=["prettier", "--stdin-filepath", f"dummy.{file_extension}"])

    @property
    def label(self) -> str:
        return f"Apply Prettier Formatter (default: {self.file_extension})"

    @property
    def importable(self) -> bool:
        return True
    
class JSPrettierFormatter(PrettierFormatter):
    language = ["javascript", "js"]
    aliases = ["js-prettier"]

    @property
    def label(self) -> str:
        return "Apply Prettier Formatter (JavaScript)"

    def __init__(self):
        super().__init__("js")

class TSPrettierFormatter(PrettierFormatter):
    language = ["typescript", "ts"]
    aliases = ["ts-prettier"]

    @property
    def label(self) -> str:
        return "Apply Prettier Formatter (TypeScript)"

    def __init__(self):
        super().__init__("ts")

def _load_jupyter_server_extension(server_app):
    SERVER_FORMATTERS["prettier"] = PrettierFormatter("ts")
    SERVER_FORMATTERS["javascript"] = JSPrettierFormatter()
    SERVER_FORMATTERS["typescript"] = TSPrettierFormatter()
