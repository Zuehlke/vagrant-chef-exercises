
## Chef TDD: Scaffolding the MyApp Cookbook

Before for we step into TDD let's briefly revisit the structure of cookbooks
and how to scaffold / generate them.

### The MyApp Scenario

Our scenario for the remainder of this workshop is a sample web application called "myapp".
It's a super simple web application that will be set up using a Chef cookbook with the same
name and is just good enough to get to know the Chef TDD tools.

### Generating the MyApp Cookbook

The ChefDK includes a command called `chef`, which lets you very easily create
a new cookbook structure (**note:** you must place it into a directory named cookbooks!):
```
$ mkdir cookbooks
$ cd cookbooks
$ chef generate cookbook myapp
```

This scaffolds a cookbook structure with the basic skeleton files for
testing already included:
```
myapp/
├── Berksfile
├── CHANGELOG.md
├── chefignore
├── LICENSE
├── metadata.rb
├── README.md
├── recipes
│   └── default.rb
├── spec
│   ├── spec_helper.rb
│   └── unit
│       └── recipes
│           └── default_spec.rb
└── test
    └── integration
        └── default
            └── default_test.rb
```

*Feel free to inspect the generated files already. Many of them will not be needed for now, 
but we will revisited them in the next sections*

For more details you can also check:
```
$ chef generate cookbook --help
$ chef generate --help
$ chef --help
```
