package utils

import (
	"strings"
)

func ReplacePlaceholders(command, sourceFile string) string {
	FileName := GetFileName(sourceFile)
	command = strings.ReplaceAll(command, "{{file}}", sourceFile)
	command = strings.ReplaceAll(command, "{{class_name}}", FileName)
	if IsWindows() {
		command = strings.ReplaceAll(command, "./{{out}}", FileName)
	}
	command = strings.ReplaceAll(command, "{{out}}", FileName)
	return command
}

func capitalizeFirstLetter(str string) string {
	if str == "" {
		return ""
	}

	firstLetterCap := strings.ToUpper(string(str[0]))
	rest := str[1:]
	return firstLetterCap + rest
}

func GenerateExample(file, examples string) string {
	generatedExample := strings.ReplaceAll(examples, "{{File}}", capitalizeFirstLetter(file))
	generatedExample = strings.ReplaceAll(generatedExample, "{{file}}", file)
	return generatedExample
}
