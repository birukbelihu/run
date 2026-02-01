# run

![GitHub Repo stars](https://img.shields.io/github/stars/BirukBelihu/run?style=flat-square&logo=github)
![GitHub forks](https://img.shields.io/github/forks/BirukBelihu/run?style=flat-square&logo=github)
![GitHub issues](https://img.shields.io/github/issues/BirukBelihu/run?style=flat-square)
![GitHub License](https://img.shields.io/github/license/birukbelihu/run?style=flat-square)
[![release](https://github.com/birukbelihu/run/actions/workflows/release.yml/badge.svg)](https://github.com/birukbelihu/run/actions/workflows/release.yml)

Compile & run source files of any language with just one command.

---

## 📑 Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Supported Languages](#supported-languages)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- 🚀 Single command to run source files across multiple languages
- 🛠 Built-in toolchain checks (detects if required compilers/runtimes are installed)
- 🔍 Automatic language detection based on file extension
- 📦 Config-driven language support (easy to add new languages)
- 🌍 Cross-platform (Windows, Linux, macOS)
- 🧩 Extensible architecture for future features (formatting, linting, packaging)

---

## Installation

### On Windows

```
powershell -ExecutionPolicy ByPass -c "irm https://raw.githubusercontent.com/birukbelihu/run/main/install.ps1 | iex"
```

### On Linux & macOS

```
curl -LsSf curl -fsSL https://raw.githubusercontent.com/birukbelihu/run/main/install.ps1  | sh
```

---

## Supported Languages

Run supports multiple languages out of the box (and more can be added easily):

| Language | Type | Run Check | Run File |
|----------|------|-----------|----------|
| Go | Compiler | `run check go` | `run main.go` |
| Java | Compiler | `run check java` | `run App.java` |
| Python | Interpreter | `run check py` | `run app.py` |
| C | Compiler | `run check c` | `run main.c` |
| C++ | Compiler | `run check c++` | `run main.cpp` |
| Rust | Compiler | `run check rs` | `run main.rs` |

> [!TIP]
> The complete supported languages list is available [here](docs/supported_languages.md).

---

## Configuration

Languages are defined in a JSON configuration file:

```json
{
  "py": {
    "name": "Python",
    "download": "https://www.python.org/downloads/",
    "check": "python --version",
    "run": "python {{file}}",
    "type": "interpreter"
  }
}
```

### Fields Explained

| Field    | Description                               |
|----------|-------------------------------------------|
| name     | Human-readable language name              |
| download | Official download URL                     |
| check    | Command used to verify installation       |
| run      | Command template to execute the file      |
| compile  | (Optional) Compile command                |
| type     | `compiler` or `interpreter`               |

---

## Contributing

Contributions are welcome!  
Please read the [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

This project is licensed under the Apache License, Version 2.0.  
See the [LICENSE](LICENSE) file for more details.
