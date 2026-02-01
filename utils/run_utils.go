package utils

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func IsInstalled(command string) bool {
	parts := strings.Fields(command)

	if len(parts) == 0 {
		return false
	}

	_, err := exec.LookPath(parts[0])
	return err == nil
}

func Compile(command string) error {
	if strings.TrimSpace(command) == "" {
		return fmt.Errorf("empty compile command")
	}

	cmd := ShellCommand(command)
	cmd.Stdout = os.Stdout
	cmd.Stderr = nil

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("compilation failed: %w", err)
	}

	return nil
}

func Run(command string) error {

	if strings.TrimSpace(command) == "" {
		return fmt.Errorf("empty run command")
	}

	cmd := ShellCommand(command)
	cmd.Stdout = os.Stdout
	cmd.Stderr = nil
	cmd.Stdin = os.Stdin

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("execution failed: %w", err)
	}

	return nil
}

func ShellCommand(command string) *exec.Cmd {
	if IsWindows() {
		return exec.Command("cmd", "/C", command)
	}
	return exec.Command("sh", "-c", command)
}
