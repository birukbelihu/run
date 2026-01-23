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
