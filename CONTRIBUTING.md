# Contributing to run

First of all, thank you for considering contributing to **run** 🙌  
Your help makes this project better for everyone.

This document provides guidelines and steps for contributing to the project. Please read it carefully before submitting issues or pull requests.

---

## 📋 Table of Contents

- [Code of Conduct](#-code-of-conduct)
- [Ways to Contribute](#-ways-to-contribute)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Adding a New Language](#-adding-a-new-language)
- [Reporting Bugs](#-reporting-bugs)
- [Suggesting Features](#-suggesting-features)
- [Pull Request Guidelines](#-pull-request-guidelines)
- [Commit Message Style](#-commit-message-style)
- [Development Tips](#-development-tips)

---

## 📜 Code of Conduct

By participating in this project, you agree to:

- Be respectful and inclusive
- Accept constructive feedback
- Focus on what is best for the community

Harassment, discrimination, or abusive behavior will not be tolerated.

---

## 🤝 Ways to Contribute

You can contribute in many ways:

- 🐞 Reporting bugs
- ✨ Suggesting or implementing new features
- 🌍 Adding support for new languages
- 📝 Improving documentation
- 🧪 Writing tests
- ♻️ Refactoring or improving code quality

All contributions—big or small—are welcome.

---

## 🚀 Getting Started

### 1. Fork the Repository

Click the **Fork** button on GitHub to create your own copy of the repository.

### 2. Clone Your Fork

```bash
git clone https://github.com/<your-username>/run.git
cd run
```

### 3. Create a Branch

Use a descriptive branch name:

```bash
git checkout -b feature/add-kotlin-support
```

---

## 🗂 Project Structure

> The structure may evolve, but conceptually the project is organized as follows:

```
run/
├── cmd/              # CLI entry point
├── internal/         # Core logic (language detection, execution, checks)
├── configs/          # Language configuration JSON files
├── docs/             # Documentation (supported languages, guides)
├── tests/            # Tests
└── README.md
```

Understanding this layout will help you navigate and contribute effectively.

---

## 🌐 Adding a New Language

Adding a new language is one of the easiest and most impactful ways to contribute.

### Steps

1. Open the language configuration file (JSON)
2. Add a new entry following the existing pattern

Example:

```json
"kt": {
  "name": "Kotlin",
  "download": "https://kotlinlang.org/",
  "check": "kotlinc -version",
  "compile": "kotlinc {{file}} -include-runtime -d {{base}}.jar",
  "run": "java -jar {{base}}.jar",
  "type": "compiler"
}
```

3. Test it locally with:

```bash
run check kt
run main.kt
```

4. Update documentation if necessary (`docs/supported_languages.md`)

---

## 🐛 Reporting Bugs

Before opening an issue:

- Check existing issues to avoid duplicates
- Make sure you are using the latest version

When reporting a bug, include:

- OS and version
- `run` version
- Language and file type used
- Exact command executed
- Error output or logs

Clear and detailed reports help fix issues faster.

---

## 💡 Suggesting Features

Feature ideas are welcome!

When suggesting a feature, please describe:

- The problem it solves
- How it fits the philosophy of **run** (simple, single-command, language-agnostic)
- Possible implementation ideas (optional but helpful)

---

## 🔁 Pull Request Guidelines

Before submitting a PR:

- Ensure your code builds and runs correctly
- Keep PRs focused (one feature or fix per PR)
- Write clear and concise commit messages
- Update documentation if behavior changes

### Pull Request Checklist

- [ ] Code follows project style
- [ ] Feature or fix is tested
- [ ] Documentation updated (if applicable)
- [ ] No breaking changes without discussion

---

## 📝 Commit Message Style

Use clear, meaningful commit messages:

```
feat: add kotlin language support
fix: handle missing compiler gracefully
docs: update supported languages list
refactor: simplify language detection logic
```

---

## 🛠 Development Tips

- Keep the CLI fast and predictable
- Prefer configuration-driven solutions over hardcoding
- Cross-platform compatibility matters (Windows, Linux, macOS)
- Simplicity is a core goal—avoid unnecessary complexity

---

## 🙏 Thank You

Thank you for taking the time to contribute to **run**.  
Your effort helps make development simpler for everyone 🚀
