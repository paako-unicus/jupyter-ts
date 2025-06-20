c = get_config()

c.ServerApp.jpserver_extensions = {
    "prettier_formatter": True,
}

c.JupyterLabCodeFormatter.formatters = {
    "javascript": ["prettier_formatter.JSPrettierFormatter"],
    "typescript": ["prettier_formatter.TSPrettierFormatter"],
}
