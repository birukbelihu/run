package cmd

import (
	"encoding/json"
	"fmt"
	"os"
	"run/cmd/utils"
	"strings"

	"github.com/pterm/pterm"
	"github.com/spf13/cobra"
)

type Language struct {
	Name     string `json:"name"`
	Download string `json:"download"`
	Check    string `json:"check"`
	Run      string `json:"run"`
	Type     string `json:"type"`
}

var languages = loadLanguagesConfig()

var rootCmd = &cobra.Command{
	Use:   Name,
	Short: ShortDescription,
	Long:  LongDescription,
	Args:  cobra.MaximumNArgs(1),
	Run: func(cmd *cobra.Command, args []string) {

		if len(args) == 0 {
			cmd.Help()
			os.Exit(0)
		}

		file := args[0]

		if err := validSourceFile(file); err != nil {
			pterm.DefaultBasicText.Print(pterm.Red(err))
			return
		} else {
			fileExtension := utils.GetFileExtension(file)
			checkCommand := getCheckCommand(fileExtension)

			if utils.IsUnixLike() {
				checkCommand = strings.ReplaceAll(checkCommand, "python", "python3")
			}

			if utils.IsInstalled(checkCommand) {
				preprocessedCommand := utils.ReplacePlaceholders(getRunCommand(fileExtension), file)

				if utils.IsUnixLike() {
					preprocessedCommand = strings.ReplaceAll(preprocessedCommand, "python", "python3")
				}
				err := utils.Run(preprocessedCommand)
				if err != nil {
					fmt.Printf("An error occurred: %s\n", err)
				}
			} else {
				fmt.Printf("Oops. %s %s is not installed on your machine\n", getName(fileExtension), getType(fileExtension))
				fmt.Printf("However You can download it from here for your %s machine:\n%s\n", utils.CurrentOS(), getDownload(fileExtension))
			}
		}

	},
}

func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.Version = Version
}

func loadLanguagesConfig() map[string]Language {
	config := utils.RunConfig

	var languages map[string]Language

	if err := json.Unmarshal([]byte(config), &languages); err != nil {
		panic(fmt.Sprintf("Unable to load languages config file due to: %s", err))
	}

	return languages
}

func validSourceFile(file string) error {
	extension := utils.GetFileExtension(file)

	if !utils.IsFileExist(file) {
		return fmt.Errorf(
			"source file %q doesn't exist\n",
			file,
		)
	}

	if extension == "" {
		return fmt.Errorf(
			"source file %q It must have an extension (%s)",
			file,
			Examples,
		)
	}

	_, ok := languages[strings.ToLower(extension)]
	if !ok {
		return fmt.Errorf("%q file extension is not supported", extension)
	}

	return nil
}

func get(fileExtension, kind string) (string, bool) {
	kind = strings.ToLower(kind)
	lang, ok := languages[strings.ToLower(fileExtension)]

	if !ok {
		return fmt.Sprintf("%s file is not supported", fileExtension), false
	}

	switch kind {
	case "name":
		return lang.Name, true

	case "download":
		return lang.Download, true

	case "check":
		return lang.Check, true

	case "run":
		return lang.Run, true

	case "type":
		return lang.Type, true
	default:
		return fmt.Sprintf("Unknown type %q", kind), false
	}
}

func getName(fileExtension string) string {
	lang, ok := get(fileExtension, "name")

	if !ok {
		return fmt.Sprintf("%s file is not supported", fileExtension)
	}

	return lang
}

func getCheckCommand(fileExtension string) string {
	lang, ok := get(fileExtension, "check")

	if !ok {
		return fmt.Sprintf("%s file is not supported", fileExtension)
	}

	return lang
}

func getRunCommand(fileExtension string) string {
	lang, ok := get(fileExtension, "run")

	if !ok {
		return fmt.Sprintf("%s file is not supported", fileExtension)
	}

	return lang
}

func getDownload(fileExtension string) string {
	lang, ok := get(fileExtension, "download")

	if !ok {
		return fmt.Sprintf("%s file is not supported", fileExtension)
	}

	return lang
}

func getType(fileExtension string) string {
	lang, ok := get(fileExtension, "type")

	if !ok {
		return fmt.Sprintf("%s file is not supported", fileExtension)
	}

	return lang
}
