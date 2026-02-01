package utils

import (
	"errors"
	"os"
	"path/filepath"
	"strings"
)

func ReplacePlaceholders(command, sourceFile, out string) string {
	if strings.Contains(command, "{{file}}") {
		command = strings.ReplaceAll(command, "{{file}}", sourceFile)
	}

	if strings.Contains(command, "{{class_name}}") {
		command = strings.ReplaceAll(command, "{{class_name}}", strings.TrimSuffix(sourceFile, filepath.Ext(sourceFile)))
	}

	if strings.Contains(command, "{{out}}") {
		command = strings.ReplaceAll(command, "{{out}}", strings.TrimSuffix(sourceFile, filepath.Ext(sourceFile)))
	}

	if strings.Contains(command, "./{{out}}") {
		command = strings.ReplaceAll(command, "./{{out}}", strings.TrimSuffix(sourceFile, filepath.Ext(sourceFile)))
	}

	return command
}

func CapitalizeName(name string) string {
	r := []rune(name)
	capitalizedFirstLetter := strings.ToUpper(string(r[0]))
	capitalizedName := capitalizedFirstLetter + name[1:]
	return capitalizedName
}

func GetFileExtension(fileName string) string {
	FileExtension := strings.TrimPrefix(filepath.Ext(fileName), ".")
	return FileExtension
}

func GetFileName(fileName string) string {
	fileNameWithoutExt := strings.TrimSuffix(fileName, filepath.Ext(fileName))
	return fileNameWithoutExt
}

func IsFileExist(filePath string) bool {
	_, err := os.Stat(filePath)

	if err == nil {
		return true
	}

	if errors.Is(err, os.ErrNotExist) {
		return false
	}

	return false
}
