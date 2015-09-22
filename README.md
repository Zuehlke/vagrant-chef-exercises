
# "Let's Hack Some Infrastructure!"

Demo repository for my ZDays 2015 talk "Let's Hack Some Infrastructure!"

It contains all the code snippets to be shown (more or less likely in that order...)

## Development Environment: on Windows

I will probably start with the development environment for Windows:

 * [Bill's Kitchen](https://github.com/tknerr/bills-kitchen) - a "DevPack" with all you need for cooking with Chef, Vagrant and Docker on Windows


## Vagrant Introduction

A short introduction to Vagrant, covering the essential concepts:

 * [vagrant-basics](./vagrant-basics)
 * [vagrant-shell-provisioner](./vagrant-shell-provisioner)
 * [vagrant-multivm-and-networking](./vagrant-multivm-and-networking)

## Re: Development Environment: Linux! :-)

Windows is really sloooooooooow. Before we continue, let's switch to a Linux-based environment:

 * [Linus' Kitchen](https://github.com/tknerr/linus-kitchen) - a developer VM with Chef, Vagrant and Docker for cooking on Linux

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
