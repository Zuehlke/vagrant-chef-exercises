
# Infrastructure-as-Code with Vagrant, Chef & Co

Demo repository for the 2019 "Infrastructure-as-Code with Vagrant, Chef & Co" workshop,
based on the earlier examples from tknerr/zdays2015-demo-repo

It contains all the code snippets to be shown (more or less likely in that order...)

## The Development Environment: Linus Kitchen

Since we want to start off immediately without any installation hassle, simply grab a copy of the latest Linus' Kitchen developer VM. Pre-built .ova VMware images are available in the "releases" section:

 * [Linus' Kitchen](https://github.com/tknerr/linus-kitchen/releases) - a developer VM with Chef, Vagrant and Docker for cooking on Linux

*Note: make sure to give it enough RAM (8GB should be fine) and also enable VT-x when importing the pre-built .ova VMware image!*

## Vagrant Introduction

A short introduction to Vagrant, covering the essential concepts:

 * [vagrant-basics](./vagrant-basics)
 * [vagrant-shell-provisioner](./vagrant-shell-provisioner)
 * [vagrant-multivm-and-networking](./vagrant-multivm-and-networking)

Bonus topics:

 * [vagrant-with-docker](./vagrant-with-docker)
 * [vagrant-with-windows-boxes](./vagrant-with-windows-boxes)

## Chef Introduction

A brief introduction to Chef, just enough for showing the Chef DSL, getting to know the cookbook structure
and learning how to run Chef either locally or in Vagrant VMs:

 * [chef-basics-with-chef-apply](./chef-basics-with-chef-apply)
 * [chef-basics-intro-to-cookbooks](./chef-basics-intro-to-cookbooks)
 * [chef-basics-berkshelf](./chef-basics-berkshelf)

## Test-Driven Cookbook Development with Chef

First let's setup the "myapp" scenario by scaffolding the application cookbook:

* [chef-tdd-scaffolding-myapp](./chef-tdd-scaffolding-myapp)

Infrastructure-as-code means infrastructure IS code, that means also want to treat it
with the same care and love as our application code, which means we also want to test it :-)

 * [chef-tdd-environment](./chef-tdd-environment)
 * [chef-tdd-cookstyle](./chef-tdd-cookstyle)
 * [chef-tdd-foodcritic](./chef-tdd-foodcritic)
 * [chef-tdd-chefspec](./chef-tdd-chefspec)
 * [chef-tdd-test-kitchen](./chef-tdd-test-kitchen)
