require_relative 'spec/fixtures/modules/helper/lib/bodeco_module_helper/vagrant'

vm(
  :hostname => 'gocd-lin',
  :module   => 'gocd',
  :memory   => 2048,
  :os_type  => :linux,
  :box      => 'oracle65-pe3.2.3'
)
vm(
  :hostname => 'gocd-win',
  :os_type  => :windows,
  :module   => 'gocd',
  :memory   => 2048,
  :box      => 'windows2008r2'
)