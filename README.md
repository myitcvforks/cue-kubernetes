## Structure

I have renamed the module in this repo `company.com/config`. Because we are
currently in the directory (repo) that defines that module, we refer to
`company.com/config` as the main module.

Imagine I work for company.com, and this repo (and the module at the root of it)
holds our actual configurations. Not the templates or schemas (although these
can also co-exist) but the actual configurations, configurations that get used
by tools, services etc. The shape of these configurations is therefore driven by
the tools/services etc that consume them. Packages within this module are used
to sub-divide that configuration namespace, but this is just a pattern used here
there are other approaches.

```
├── cue.mod
│   └── pkg              # vendored dependencies live below here
│       ├── company.com  # vendored company code
│       └── k8s.io       # a dependency on k8s schemas
└── example              # an example configuration for a real service
```

Note the use of `cue.mod/pkg`. This is different from `cue.mod/gen` in that the
former are straightforward dependencies, whereas the latter is the result of
running `cue get go` (amongst other things). I've therefore imagined that
someone else has taken on the task of running `cue get go` on the k8s types and
has published those as various `k8s.io/...` modules. This ties in quite closely
with the idea of a schema store or curated schemas that has been discussed
before.

The code under `cue.mod/pkg/company.com` is reusable modules of CUE code written
by me or others in our company, that we use in various places. The module in
this situation is being used as the unit of reuse (and versioning).

The contents of `cue.mod/pkg` need to be populated by hand (or some tool) as of
today. `cmd/cue` does not know how to do that. The current work on modules is
focussing on exactly that, so that in the near future you will be able to run
commands like `cue mod get k8s.io/pkg` to add a dependency.

The `example` package in the main module is a real configuration that will be
consumed by a service the company runs. Follow the comments in that package and
imports to see how it ties together.

```
$ cue export ./example
{
    "service": {
        "my-service": {
            "kind": "Service",
            "metadata": {
                "name": "my-service"
            }
        }
    },
    "deployment": {
        "my-deployment": {
            "kind": "Deployment",
            "metadata": {
                "name": "my-deployment"
            }
        }
    }
}
$ cue cmd ls ./example
Service      my-service
Deployment   my-deployment

```
