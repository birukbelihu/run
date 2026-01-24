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
		_ = cmd.Help()
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
		panic(fmt.Sprintf("failed to load languages config: %v", err))
	}

	return langs
}

func validateAndGetLanguage(file string) (Language, error) {
	if !utils.IsFileExist(file) {
		return Language{}, fmt.Errorf("source file %q doesn't exist", file)
	}

	ext := strings.ToLower(utils.GetFileExtension(file))
	if ext == "" {
		return Language{}, fmt.Errorf(
			"source file %q must have an extension (%s)",
			file,
			Examples,
		)
	}

	lang, ok := languages[ext]
	if !ok {
		return Language{}, fmt.Errorf("file extension %q is not supported", ext)
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
	fmt.Printf(
		"Oops. %s %s is not installed on your machine\n"+
			"You can download it for your %s machine here:\n%s\n",
		lang.Name,
		lang.Type,
		utils.CurrentOS(),
		lang.Download,
	)
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
