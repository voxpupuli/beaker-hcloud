# beaker-hcloud

[![License](https://img.shields.io/github/license/voxpupuli/beaker-hcloud.svg)](https://github.com/voxpupuli/beaker-hcloud/blob/master/LICENSE)
[![Test](https://github.com/voxpupuli/beaker-hcloud/actions/workflows/ci.yml/badge.svg)](https://github.com/voxpupuli/beaker-hcloud/actions/workflows/ci.yml)
[![Release](https://github.com/voxpupuli/beaker-hcloud/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/beaker-hcloud/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/beaker-hcloud.svg)](https://rubygems.org/gems/beaker-hcloud)
[![RubyGem Downloads](https://img.shields.io/gem/dt/beaker-hcloud.svg)](https://rubygems.org/gems/beaker-hcloud)

A [beaker](https://github.com/voxpupuli/beaker) extension for provision Hetzner Cloud instances.

## Installation

Include this gem alongside Beaker in your Gemfile or project.gemspec. E.g.

```ruby
# Gemfile
gem 'beaker', '~> 5.0'
gem 'beaker-hcloud'

# project.gemspec
s.add_runtime_dependency 'beaker', '~> 5.0'
s.add_runtime_dependency 'beaker-hcloud'
```

## Authentication

You need to create an API token using Hetzner's cloud console. Make
sure to create the token in the correct project.

`beaker-hcloud` expects the token to be in the `BEAKER_HCLOUD_TOKEN`
environment variable.

## Configuration

Some options can be set to influence how and where server instances
are being created:


| configuration option | required | default | description |
| -------------------- | -------- | ------- | ----------- |
| `image`              | true     |         | The name of one of Hetzner's provided images, e.g. `ubuntu-20.04`, or a custom one, i.e. a snapshot in your account. |
| `server_type`        | false    | `cx11`  | Hetzner cloud server type |
| `location`           | false    | `nbg1`  | One of Hetzner's datacenter locations |

# Cleanup

In cases where the beaker process is killed before finishing, it may leave resources in Hetzner cloud. These will need to be manually deleted.
Look for servers in your project named exactly as the ones in your beaker host configuration and SSH keys with names beginning with `Beaker-`.

The gem will try to automatically delete old virtual machines. Every created
cloud instance gets a label `delete_vm_after: 'Fri, 22 Sep 2023 15:39:17 +0200'`.
By default this is the DateTime during VM creation + an hour. During each beaker
run, beaker-hcloud will check for existing VMs with a `delete_vm_after` label in
the past and delete them.

To work properly, beaker needs to run on a regular basis. You can modify the
default of an hour by setting the `BEAKER_HCLOUD_DELETE_VM_AFTER` environment
variable to any positive integer. It will be interpreted as hours.

# Contributing

Please refer to voxpupuli/beaker's [contributing](https://github.com/voxpupuli/beaker/blob/master/CONTRIBUTING.md) guide.
