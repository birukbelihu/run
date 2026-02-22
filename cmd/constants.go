package cmd

import "fmt"

var (
	Name     = "run"
	Version  = "0.0.2"
	RunASCII = `
 _ __   _   _   _ __
| '__| | | | | | '_ \
| |    | |_| | | | | |
|_|     \__,_| |_| |_|
`

	ShortDescription = "compile & run source file of any language with just one command"
	LongDescription  = fmt.Sprintf("%s \n%s.\ne.g. run main.go, run app.py run Main.java, run index.js", RunASCII, ShortDescription)
	VersionString    = fmt.Sprintf("%s Version %s", Name, Version)
	Examples         = "e.g. {{file}}.go, {{file}}.py, {{File}}.java, {{file}}.js etc."

	CheckCmdShortDescription = "Check the availability of a compiler or toolchain installation"
	CheckCmdLongDescription  = fmt.Sprintf("%s.\n e.g. run check go, run check java, run check python", CheckCmdShortDescription)

	RunConfigFileName  = "run-config.json"
	InitCmdDescription = fmt.Sprintf("Create %s file to run any kind of project", RunConfigFileName)
)
