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
	Args:  cobra.RangeArgs(1, 10),
	Run:   runCheck,
}

func init() {
	rootCmd.AddCommand(checkCmd)
}

func runCheck(cmd *cobra.Command, args []string) {
	checkedLangs := map[string]bool{}
	for _, arg := range args {
		lang, ok := simpleNamesIndex[arg]
		if !ok {
			pterm.Warning.Printf("Unknown language %q\n", arg)
			continue
		}

		if checkedLangs[lang.Name] {
			pterm.Warning.Printf("%s is specified multiple times, skipping duplicate\n", lang.Name)
			continue
		}

		checkedLangs[lang.Name] = true

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
