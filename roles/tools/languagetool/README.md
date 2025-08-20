# LanguageTool Ansible Role

This role installs and configures LanguageTool, a powerful grammar and style checker for multiple languages, following XDG Base Directory Specification.

## Requirements

- Java 8 or higher (openjdk-11-jdk recommended)
- System packages: `curl`, `wget`, `unzip`

## Features

- **XDG Compliant**: Follows XDG Base Directory Specification
- **Multiple Interfaces**: Command-line, GUI, and server modes
- **Shell Integration**: Adds convenient aliases and environment variables
- **Desktop Integration**: Creates desktop entry for GUI access
- **User-level Installation**: Installs to `~/.local/` directories

## Installation Locations

- **Application**: `~/.local/share/languagetool/`
- **Configuration**: `~/.config/languagetool/`
- **Cache**: `~/.cache/languagetool/`
- **Binaries**: `~/.local/bin/languagetool*`

## Usage

### Command Line
```bash
# Check a text file
languagetool --language en-US document.txt

# Check text from stdin  
echo "This are wrong." | languagetool --language en-US -

# Short alias
lt --language en-US mytext.txt
```

### Server Mode
```bash
# Start server (default port 8081)
languagetool-server

# API usage
curl -d "language=en-US&text=Hello world." http://localhost:8081/v2/check
```

### GUI Mode
```bash
# Start graphical interface
languagetool-gui

# Or use short alias
lt-gui
```

## Configuration

Key variables in `defaults/main.yml`:

- `languagetool_version`: Version to install (default: "latest")
- `languagetool_default_language`: Default language code (default: "en-US")
- `languagetool_server_port`: Server port (default: 8081)
- `languagetool_java_opts`: JVM options (default: "-Xmx1g -Dfile.encoding=UTF-8")

## Aliases

The role creates these shell aliases:
- `lt` → `languagetool`
- `languagetool-check` → `languagetool --language en-US`
- `lt-server` → `languagetool-server`
- `lt-gui` → `languagetool-gui`

## Integration

### With Editors
LanguageTool can integrate with various editors through plugins:
- VS Code: LanguageTool Linter extension
- Vim/Neovim: Various plugins available
- Emacs: Multiple packages support LanguageTool

### With LibreOffice/OpenOffice
LanguageTool provides native extensions for office suites.

## Supported Languages

LanguageTool supports 25+ languages including:
- English (US, UK, CA, AU, NZ, ZA)
- German, French, Spanish, Portuguese
- Dutch, Polish, Russian, Italian
- And many more...

## API Endpoint

When running the server, the API is available at:
- **Base URL**: `http://localhost:8081`
- **Check endpoint**: `/v2/check`
- **Languages endpoint**: `/v2/languages`

## Troubleshooting

1. **Java not found**: Install Java with `sudo apt install openjdk-11-jdk`
2. **Memory issues**: Adjust `languagetool_java_opts` to increase `-Xmx` value
3. **Port conflicts**: Change `languagetool_server_port` in configuration
4. **Slow startup**: First run may be slow as LanguageTool initializes language models

## Links

- [Official Website](https://languagetool.org/)
- [GitHub Repository](https://github.com/languagetool-org/languagetool)
- [API Documentation](https://languagetool.org/http-api/)
- [Supported Languages](https://languagetool.org/languages/)