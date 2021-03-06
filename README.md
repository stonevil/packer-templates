# Packer templates for Windows

### Overview

This repository contains templates for Windows that can create
Vagrant boxes using Packer.


# Windows host with Hyper-V

## Requirements

* HashiCorp Packer [https://www.packer.io](https://www.packer.io)
* Packer Hyper-V plugin [https://github.com/pbolduc/packer-hyperv](https://github.com/pbolduc/packer-hyperv)
* HashiCorp Vagrant [https://www.vagrantup.com](https://www.vagrantup.com)
* Git command line [http://www.git-scm.com](http://www.git-scm.com)
* Wget [https://www.gnu.org/software/wget/](https://www.gnu.org/software/wget/)
* 7zip [http://www.7-zip.org](http://www.7-zip.org)
* ChefDK (optional) [https://downloads.chef.io/chef-dk/](https://downloads.chef.io/chef-dk/)
* Windows 8.1/2008r2/2012r2 host machine with enabled Hyper-V service.

Virtual Machines requires internet access for auto-update, packages download and install. Please configure Hyper-V Virtual Switch properly.

[Chocolatey](https://chocolatey.org) is preferable to install required software

    PS:\> iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))        
    PS:\> choco install sysinternals 7zip vim git git.commandline git.install git-credential-winstore wget packer chfdk
    PS:\> dism /online /enable-feature /featurename:Microsoft-Hyper-V /Al    restart`

## Building the Vagrant boxes

To build any of the boxes, you will need installed and enabled Hyper-V.

A packer command must be executed with Administration privileges for Hyper-V cmdlets.

    packer build -only=hyper-iso template.json -var update=true -var cm=nocm

Example: for building Windows 2012 R2 Server Standard Edition with OS updates with integrated Chef client execute

    packer build -only=hyper-iso win2012r2-standard.json -var update=true -var cm=chef

# OS X and Linux host with VMware (Fusion or Workstation), VirtualBox, Parallels

## Requirements

* HashiCorp Packer [https://www.packer.io](https://www.packer.io)
* HashiCorp Vagrant [https://www.vagrantup.com](https://www.vagrantup.com)
* Git command line [http://www.git-scm.com](http://www.git-scm.com)
* Wget [https://www.gnu.org/software/wget/](https://www.gnu.org/software/wget/)
* ChefDK (optional) [https://downloads.chef.io/chef-dk/](https://downloads.chef.io/chef-dk/)
* OS X or Linux host machine with VirtualBox/VMware Fusion/VMware Workstation/Parallels Desktop
* VirtualBox [https://www.virtualbox.org](https://www.virtualbox.org)
* VMware Fusion / VMware Workstation [http://www.vmware.com](http://www.vmware.com)
* Parallels Desktop [http://www.parallels.com](http://www.parallels.com)
* Packer and vagrant plugins for chosen virtualisation
* GNU Make

## OS X

[Homebrew](http://brew.sh) is preferable to install required software for OS X. Xcode command line tools must be installed at OS X.

    user:~> xcode-select --install
    user:~> ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    user:~> brew tap homebrew/binary
    user:~> brew install wget packer

## Linux

Native packages is preferable to install required software

## Building the Vagrant boxes

To build all the boxes, you will need both VirtualBox and VMware Fusion or Workstation installed.

A GNU Make `Makefile` drives the process via the following targets:

    make        # Build all the box types (VirtualBox & VMware)
    make test   # Run tests against all the boxes
    make list   # Print out individual targets
    make clean  # Clean up build detritus

Example: for building Windows 2012 R2 Server Standard Edition with OS updates for VMware execute

    user:~> export UPDATE=true && make vmware/win2012r2-standard

### Tests

The tests are written in [Serverspec](http://serverspec.org) and require the
`vagrant-serverspec` plugin to be installed with:

    vagrant plugin install vagrant-serverspec

The `Makefile` has individual targets for each box type with the prefix
`test-*` should you wish to run tests individually for each box.

Similarly there are targets with the prefix `ssh-*` for registering a
newly-built box with vagrant and for logging in using just one command to
do exploratory testing.  For example, to do exploratory testing
on the VirtualBox training environmnet, run the following command:

    make ssh-box/virtualbox/win2008r2-standard-nocm.box

Upon logout `make ssh-*` will automatically de-register the box as well.

### Makefile.local override

You can create a `Makefile.local` file alongside the `Makefile` to override
some of the default settings.  It is most commonly used to override the
default configuration management tool, for example with Chef:

    # Makefile.local
    CM := chef

Changing the value of the `CM` variable changes the target suffixes for
the output of `make list` accordingly.

Possible values for the CM variable are:

* `nocm` - No configuration management tool
* `chef` - Install Chef
* `puppet` - Install Puppet
* `salt`  - Install Salt

You can also specify a variable `CM_VERSION`, if supported by the
configuration management tool, to override the default of `latest`.
The value of `CM_VERSION` should have the form `x.y` or `x.y.z`,
such as `CM_VERSION := 11.12.4`

Another use for `Makefile.local` is to override the default locations
for the Windows install ISO files.

For Windows, the ISO path variables are:

* `EVAL_WIN10_X64`
* `EVAL_WIN10_X86`
* `EVAL_WIN2008R2_X64`
* `EVAL_WIN2012R2_X64`
* `EVAL_WIN7_X64`
* `EVAL_WIN7_X86`
* `EVAL_WIN81_X64`
* `EVAL_WIN81_X86`
* `EVAL_WIN8_X64`
* `WIN2008R2_X64`
* `WIN2012_X64`
* `WIN2012R2_X64`
* `WIN7_X64_ENTERPRISE`
* `WIN7_X64_PRO`
* `WIN7_X86_ENTERPRISE`
* `WIN7_X86_PRO`
* `WIN81_X64_ENTERPRISE`
* `WIN81_X64_PRO`
* `WIN81_X86_ENTERPRISE`
* `WIN81_X86_PRO`
* `WIN8_X64_ENTERPRISE`
* `WIN8_X64_PRO`
* `WIN8_X86_ENTERPRISE`
* `WIN8_X86_PRO`

You can also override these setting, such as with
`WIN81_X64_PRO := file:///Volumes/MSDN/en_windows_8.1_professional_vl_with_update_x64_dvd_4065194.iso
