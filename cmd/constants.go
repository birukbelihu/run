package cmd

import "fmt"

var (
	Name             = "run"
	Version          = "0.0.1"
	ShortDescription = "compile & run source file of any language with just one command"
	LongDescription  = fmt.Sprintf("run is a tool used to %s.\ne.g. run main.go, run app.py run Main.java, run index.js", ShortDescription)
	VersionString    = fmt.Sprintf("%s Version %s", Name, Version)
	Examples         = "e.g. {{file}}.go, app.py, Main.java, index.js etc."

	CheckCmdShortDescription = "Check the availability of a compiler or toolchain installation"
	CheckCmdLongDescription  = fmt.Sprintf("%s.\n e.g. run check go, run check java, run check python", CheckCmdShortDescription)
)