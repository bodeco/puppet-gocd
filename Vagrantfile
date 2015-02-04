require_relative 'spec/fixtures/modules/helper/lib/bodeco_module_helper/vagrant'

vm(
  :hostname => 'gocd-lin',
  :module   => 'gocd',
  :memory   => 2048,
  :type  => :linux,
  :box      => 'oracle65-pe3.2.3'
)
vm(
  :hostname => 'gocd-win',
  :type  => :windows,
  :module   => 'gocd',
  :memory   => 4096,
  :cpu      => 2,
  :gui      => true,
  :box      => 'windows2008r2'
)