
# "Let's Hack Some Infrastructure!"

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
 * [vagrant-with-windows](./vagrant-with-windows)
 * [vagrant-with-docker](./vagrant-with-docker)

## Chef + Vagrant Introduction

A very minimal introduction to Chef, just enough for showing the Chef DSL and Vagrant integration:

 * [vagrant-chef-introduction](./vagrant-chef-introduction)

## Test-Driven Cookbook Development with Chef

First let's briefly revisit the cookbook structure and how to create it:

 * [chef-creating-cookbooks](./chef-creating-cookbooks)

Infrastructure-as-code means infrastructure IS code, that means also want to treat it
with the same care and love as our application code, which means we also want to test it :-)

 * [chef-tdd-environment](./chef-tdd-environment)
 * [chef-tdd-rubocop](./chef-tdd-rubocop)
 * [chef-tdd-foodcritic](./chef-tdd-foodcritic)
 * [chef-tdd-chefspec](./chef-tdd-chefspec)
 * [chef-tdd-test-kitchen](./chef-tdd-test-kitchen)
