package utils

import (
	"errors"
	"os"
	"path/filepath"
	"strings"
)

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
