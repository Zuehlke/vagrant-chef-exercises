
## Creating Cookbooks

Before for we step into TDD let's briefly revisit the structure of cookbooks
and how to generate them.

### Scenario

Let's consider a sample web application called "myapp" for the remainder of
the demo.

### Generating a new Cookbook

The ChefDK includes a command called `chef`, which lets you very easily create
a new cookbook structure:
```
$ chef generate cookbook myapp
```

This scaffolds a cookbook structure with the basic skeleton files for
testing already included:
```
myapp/
├── Berksfile
├── chefignore
├── metadata.rb
├── README.md
├── recipes
│   └── default.rb
├── spec
│   ├── spec_helper.rb
│   └── unit
│       └── recipes
│           └── default_spec.rb
└── test
    └── integration
        ├── default
        │   └── serverspec
        │       └── default_spec.rb
        └── helpers
            └── serverspec
                └── spec_helper.rb
```

For more details you can also check:
```
$ chef generate cookbook --help
$ chef generate --help
$ chef --help
```
