package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var checkCmd = &cobra.Command{
	Use:   "check",
	Short: CheckCmdShortDescription,
	Long:  CheckCmdLongDescription,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("check called")
		fmt.Println(len(args))
	},
}

func init() {
	rootCmd.AddCommand(checkCmd)
}
