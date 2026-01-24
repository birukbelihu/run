package cmd

import (
	"run/cmd/utils"

	"github.com/pterm/pterm"
	"github.com/spf13/cobra"
)

var simpleNamesIndex = IndexSimpleNames(languages)

var checkCmd = &cobra.Command{
	Use:   "check [language...]",
	Short: CheckCmdShortDescription,
	Long:  CheckCmdLongDescription,
	Args:  cobra.MinimumNArgs(1),
	Run:   runCheck,
}

func init() {
	rootCmd.AddCommand(checkCmd)
}

func runCheck(cmd *cobra.Command, args []string) {
	for _, arg := range args {
		lang, ok := simpleNamesIndex[arg]
		if !ok {
			pterm.Warning.Printf("Unknown language %q\n", arg)
			continue
		}

		pterm.Info.Printf("Checking %s...\n", lang.Name)

		checkCmd := normalizeCommand(lang.Check)

		if utils.IsInstalled(checkCmd) {
			pterm.Success.Printf("%s is installed\n", lang.Name)
			continue
		}

		pterm.Error.Printf(
			"%s %s is not installed\nDownload for %s:\n%s\n",
			lang.Name,
			lang.Type,
			utils.CurrentOS(),
			lang.Download,
		)
	}
}
