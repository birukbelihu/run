## run

![GitHub Repo stars](https://img.shields.io/github/stars/BirukBelihu/run?style=flat-square&logo=github)
![GitHub forks](https://img.shields.io/github/forks/BirukBelihu/run?style=flat-square&logo=github)
![GitHub issues](https://img.shields.io/github/issues/BirukBelihu/run?style=flat-square)
![GitHub License](https://img.shields.io/github/license/birukbelihu/run?style=flat-square)
[![release](https://github.com/birukbelihu/run/actions/workflows/release.yml/badge.svg)](https://github.com/birukbelihu/run/actions/workflows/release.yml)


compile & run source file of any language with just one command.

## Features

- 🚀 Single command to run source files across multiple languages
- 🛠 Built-in toolchain checks (detects if required compilers/runtimes are installed)
- 🔍 Automatic language detection based on file extension
- 📦 Config-driven language support (easy to add new languages)
- 🌍 Cross-platform (Windows, Linux, macOS)

## 🚀 Installation

## Install with curl

### Windows

```
iwr https://raw.githubusercontent.com/birukbelihu/run/main/install.ps1 -useb | iex
```

### Linux, macOS

```
curl -fsSL https://raw.githubusercontent.com/birukbelihu/run/main/install.sh | bash
```

## Prebuilt binaries

You can download prebuilt binaries from the [releases](https://github.com/birukbelihu/run/releases) page for your machine.

### Extensions 

You will be able to use ```run``` in your favorite dev environment like Visual Studio Code, Visual Studio & Jetbrains IDE's very soon

## 🧑‍💻 Usage

Run a source file

```
run main.go
run app.py
run index.js
run Main.java
```

Check a compiler / runtime installation

```
run check go  
run check py
run check js
run check java
```

## 📦 Supported Languages

run supports multiple languages out of the box (and more can be added easily)

| Language | Type | Run Check | Run File |
|----------|------|-----------|----------|
| Go | Compiler | `run check go` | `run main.go` |
| Java | Compiler | `run check java` | `run main.java` |
| Python | Interpreter | `run check py` | `run main.py` |
| C | Compiler | `run check c` | `run main.c` |
| C++ | Compiler | `run check c++` | `run main.cpp` |
| Rust | Compiler | `run check rs` | `run main.rs` |
| JavaScript (Node.js) | Interpreter | `run check javascript` | `run main.js` |
| Ruby | Interpreter | `run check rb` | `run main.rb` |
| PHP | Interpreter | `run check php` | `run main.php` |
| TypeScript | Compiler | `run check typescript` | `run main.ts` |
| Kotlin | Compiler | `run check kt` | `run main.kt` |
| C# | Compiler | `run check cs` | `run main.cs` |
| Swift | Compiler | `run check swift` | `run main.swift` |
| Lua | Interpreter | `run check lua` | `run main.lua` |
| R | Interpreter | `run check r` | `run main.r` |
| Julia | Interpreter | `run check jl` | `run main.jl` |
| Zig | Compiler | `run check zig` | `run main.zig` |
| Nim | Compiler | `run check nim` | `run main.nim` |
| D | Compiler | `run check d` | `run main.d` |
| Scala | Compiler | `run check scala` | `run main.scala` |
| Perl | Interpreter | `run check perl` | `run main.perl` |
| Haskell | Compiler | `run check haskell` | `run main.haskell` |
| Elixir | Interpreter | `run check elixir` | `run main.elixir` |
| Clojure | Interpreter | `run check clojure` | `run main.clojure` |
| Dart | Compiler | `run check dart` | `run main.dart` |
| Common Lisp | Interpreter | `run check lisp` | `run main.lisp` |
| Bash | Interpreter | `run check bash` | `run main.bash` |
| PowerShell | Interpreter | `run check powershell` | `run main.powershell` |
| Groovy | Interpreter | `run check groovy` | `run main.groovy` |
| OCaml | Compiler | `run check ocaml` | `run main.ocaml` |

## License

This project is licensed under the Apache License, Version 2.0. See the [LICENSE](https://github.com/birukbelihu/run/blob/main/LICENSE) file for more details.