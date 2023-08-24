package example

import (
	"company.com/k8s"
)

// Use the company-defined tools template
k8s.tools

// Unfortunately because of the way that 'cue cmd' works today, we need to
// explicitly list the tools we want to expose, even though the use of the
// template should make this redundant.
command: ls: _
