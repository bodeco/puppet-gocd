require 'hiera-puppet-helper'

shared_context :hiera do
  # example only,
  let(:hiera_data) do
    { some_key: 'some_value' }
  end

end
