package cmd

import (
	"encoding/json"
	"fmt"
	"os"
	"strings"

	"run/cmd/utils"

	"github.com/pterm/pterm"
	"github.com/spf13/cobra"
)

type Language struct {
	Name     string   `json:"name"`
	Simple   []string `json:"simple"`
	Download string   `json:"download"`
	Check    string   `json:"check"`
	Run      string   `json:"run"`
	Type     string   `json:"type"`
}

type Config struct {
	Run string `json:"run"`
}

var languages = loadLanguagesConfig()

var rootCmd = &cobra.Command{
	Use:   Name,
	Short: ShortDescription,
	Long:  LongDescription,
	Args:  cobra.MaximumNArgs(1),
	Run:   runFile,
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.Version = Version
}

func runFile(cmd *cobra.Command, args []string) {
	if len(args) == 0 {
		if utils.IsFileExist(RunConfigFileName) {
			config := loadRunConfig()
			if err := utils.Run(config.Run); err != nil {
				pterm.Error.Printf("Execution failed: %v\n", err)
			}
		} else {
			pterm.Error.Println("No run config file found. Use run init to create one")
		}
		return
	}

	file := args[0]

	lang, err := validateAndGetLanguage(file)
	if err != nil {
		pterm.Error.Println(err)
		return
	}

	checkCmd := normalizeCommand(lang.Check)

	if !utils.IsInstalled(checkCmd) {
		printInstallHint(lang)
		return
	}

	runCmd := utils.ReplacePlaceholders(lang.Run, file)
	runCmd = normalizeCommand(runCmd)

	if err := utils.Run(runCmd); err != nil {
		pterm.Error.Printf("Execution failed: %v\n", err)
	}
}

func loadLanguagesConfig() map[string]Language {
	var langs map[string]Language

	if err := json.Unmarshal([]byte(utils.RunConfig), &langs); err != nil {
		panic(fmt.Sprintf("Failed to load languages config: %v", err))
	}

	return langs
}

func loadRunConfig() Config {
	var config Config

	data, err := os.ReadFile(RunConfigFileName)
	if err != nil {
		pterm.Error.Println(err)
		return Config{}
	}

	if err := json.Unmarshal(data, &config); err != nil {
		pterm.Error.Printf("Failed to parse run config: %v\n", err)
		return Config{}
	}

	return config
}

func validateAndGetLanguage(file string) (Language, error) {
	if !utils.IsFileExist(file) {
		return Language{}, fmt.Errorf("Source file %q doesn't exist", file)
	}

	ext := strings.ToLower(utils.GetFileExtension(file))
	if ext == "" {
		return Language{}, fmt.Errorf(
			"Source file %q must have an extension (%s)",
			file,
			utils.GenerateExample(file, Examples),
		)
	}

	lang, ok := languages[ext]
	if !ok {
		return Language{}, fmt.Errorf("File extension %q is not supported", ext)
	}

	return lang, nil
}

func normalizeCommand(cmd string) string {
	if utils.IsUnixLike() {
		return strings.ReplaceAll(cmd, "python", "python3")
	}
	return cmd
}

func printInstallHint(lang Language) {
	pterm.Error.Printf(
		"Oops. %s %s is not installed on your machine\n"+
			"You can download it here for your %s machine:\n",
		lang.Name,
		lang.Type,
		utils.CurrentOS(),
	)
	pterm.FgCyan.Println(lang.Download)
}

func IndexSimpleNames(langs map[string]Language) map[string]Language {
	index := make(map[string]Language)

	for _, lang := range langs {
		for _, alias := range lang.Simple {
			index[alias] = lang
		}
	}

	return index
}
