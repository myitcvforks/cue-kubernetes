package k8s

import (
	"tool/cli"
	"text/tabwriter"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

config: {
	service?: [n=string]: corev1.#Service & {
		kind: "Service"
		metadata: name: *n | _
	}

	deployment?: [n=string]: appsv1.#Deployment & {
		kind: "Deployment"
		metadata: name: *n | _
	}
}

tools: t={
	config

	let objects = [ for v in objectSets for x in v {x}]

	let objectSets = [
		if t.service != _|_ {t.service},
		if t.deployment != _|_ {t.deployment},
	]

	command: ls: {
		task: print: cli.Print & {
			text: tabwriter.Write([
				for x in objects {
					"\(x.kind)  \t\(x.metadata.name)"
				},
			])
		}
	}
}
