# Thoughtworks Go puppet module

This module installs Thoughtworks' go agents.

## Usage

The agent installation can automatically register the system with a specific environment and list of resources:
```puppet
class { '::gocd::agent':
  server            => 'go.lab',
  resources         => ['puppet', 'linux'],
  auto_register_key => '0f18ade829104829148f',
}
```
See [Thoughtworks documentation](http://www.thoughtworks.com/products/docs/go/current/help/agent_auto_register.html) regarding auto_register_key.
