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
- [Usage](#usage)
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
curl -LsSf https://raw.githubusercontent.com/birukbelihu/run/main/install.sh | bash
```

---

## Usage

Run a source file

```
run main.go
run main.py
run app.js
run Main.java
```

Check toolchain availability

```
run check go
run check python
run check java
run check c c++ rust fortran ocaml
```

---

## Supported Languages

Run supports multiple languages out of the box (and more can be added easily):

| Language | Type | Run Source File | Check Toolchain |
|----------|------|----------|-----------|
| Go | Compiler | `run main.go` | `run check go` |
| Java | Compiler | `run App.java` | `run check java` |
| Python | Interpreter | `run app.py` | `run check py` |
| C | Compiler | `run main.c` | `run check c` |
| C++ | Compiler | `run main.cpp` | `run check c++` |
| Rust | Compiler | `run main.rs` | `run check rs` |
| JavaScript (Node.js) | Interpreter | `run main.js` | `run check javascript` |
| Ruby | Interpreter | `run main.rb` | `run check rb` |
| PHP | Interpreter | `run main.php` | `run check php` |
| TypeScript | Compiler | `run main.ts` | `run check typescript` |
| Kotlin | Compiler | `run main.kt` | `run check kt` |
| C# | Compiler | `run main.cs` | `run check cs` |
| Swift | Compiler | `run main.swift` | `run check swift` |
| Lua | Interpreter | `run main.lua` | `run check lua` |
| R | Interpreter | `run main.r` | `run check r` |
| Julia | Interpreter | `run main.jl` | `run check jl` |
| Zig | Compiler | `run main.zig` | `run check zig` |
| Nim | Compiler | `run main.nim` | `run check nim` |
| D | Compiler | `run main.d` | `run check d` |
| Scala | Compiler | `run main.scala` | `run check scala` |
| Perl | Interpreter | `run main.perl` | `run check perl` |
| Haskell | Compiler | `run main.haskell` | `run check haskell` |
| Elixir | Interpreter | `run main.elixir` | `run check elixir` |
| Clojure | Interpreter | `run main.clojure` | `run check clojure` |
| Dart | Compiler | `run main.dart` | `run check dart` |
| Common Lisp | Interpreter | `run main.lisp` | `run check lisp` |
| Bash | Interpreter | `run main.bash` | `run check bash` |
| PowerShell | Interpreter | `run main.powershell` | `run check powershell` |
| Groovy | Interpreter | `run main.groovy` | `run check groovy` |
| OCaml | Compiler | `run main.ocaml` | `run check ocaml` |
| Fortran | Compiler | `run main.f95` | `run check fortran` |

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
Please read the [CONTRIBUTING](https://github.com/birukbelihu/run/blob/main/CONTRIBUTING.md) for guidelines.

---

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for more details.
