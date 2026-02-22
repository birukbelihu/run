package cmd

import (
	"encoding/json"
	"os"
	"run/cmd/utils"

	"github.com/pterm/pterm"
	"github.com/spf13/cobra"
)

type RunConfig struct {
	Run string `json:"run"`
}

var initCmd = &cobra.Command{
	Use:   "init",
	Short: InitCmdDescription,
	Long:  InitCmdDescription,
	Run: func(cmd *cobra.Command, args []string) {
		if utils.IsFileExist(RunConfigFileName) {
			force, err := cmd.Flags().GetBool("force")
			if err != nil {
				panic(err)
			}

			if force {
				overWriteRunConfig()
				return
			}
			pterm.Warning.Println("Run config file already exists. Use -f flag to overwrite.")
		} else {
			createRunConfig()
		}
	},
}

func overWriteRunConfig() {
	os.Remove(RunConfigFileName)
	createRunConfig()
}

func createRunConfig() {
	runConfig := RunConfig{
		Run: "run --version",
	}

	config, err := json.Marshal(runConfig)
	if err != nil {
		panic(err)
	}

	os.WriteFile(RunConfigFileName, config, 0644)

	pterm.Success.Println("Run config created successfully!")
}

func init() {
	rootCmd.AddCommand(initCmd)
	initCmd.Flags().BoolP("force", "f", false, "Overwrite an existing run config file")
}
