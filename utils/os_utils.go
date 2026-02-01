package utils

import "runtime"

var currentOS = runtime.GOOS

const (
	Windows = "windows"
	Linux   = "linux"
	Darwin  = "darwin"
	FreeBSD = "freebsd"
	NetBSD  = "netbsd"
	OpenBSD = "openbsd"
	Aix     = "aix"
	Solaris = "solaris"
)

func CurrentOS() string {
	return currentOS
}

func IsWindows() bool {
	return CurrentOS() == Windows
}

func IsLinux() bool {
	return CurrentOS() == Linux
}

func IsMacOS() bool {
	return CurrentOS() == Darwin
}

func IsBSD() bool {
	switch CurrentOS() {
	case FreeBSD, OpenBSD, NetBSD:
		return true
	default:
		return false
	}
}

func IsUnixLike() bool {
	switch CurrentOS() {
	case Linux, Darwin, FreeBSD, OpenBSD, NetBSD, Aix, Solaris:
		return true
	default:
		return false
	}
}
